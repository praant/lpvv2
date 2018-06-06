//
//  SessionConfigurationExtension.swift
//  Lumina
//
//  Created by David Okun on 11/20/17.
//  Copyright © 2017 David Okun. All rights reserved.
//

import Foundation
import AVFoundation

extension LuminaCamera {
    func requestVideoPermissions() {
        self.sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                Log.verbose("successfully enabled video permissions")
                self.sessionQueue.resume()
                self.delegate?.cameraSetupCompleted(camera: self, result: .requiresUpdate)
            } else {
                Log.warning("video permissions were not allowed - video feed will not show")
                self.delegate?.cameraSetupCompleted(camera: self, result: .videoPermissionDenied)
            }
        }
    }

    func requestAudioPermissions() {
        self.sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { success in
            if success {
                Log.verbose("successfully enabled audio permissions")
                self.sessionQueue.resume()
                self.delegate?.cameraSetupCompleted(camera: self, result: .requiresUpdate)
            } else {
                Log.warning("audio permissions were not allowed - audio feed will not be present")
                self.delegate?.cameraSetupCompleted(camera: self, result: .audioPermissionDenied)
            }
        }
    }

    func updateOutputVideoOrientation(_ orientation: AVCaptureVideoOrientation) {
        self.videoBufferQueue.async {
            for output in self.session.outputs {
                guard let connection = output.connection(with: AVMediaType.video) else {
                    continue
                }
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = orientation
                }
            }
        }
    }

    func restartVideo() {
        Log.verbose("restarting video feed")
        if self.session.isRunning {
            self.session.stopRunning()
            updateVideo({ result in
                if result == .videoSuccess {
                    self.start()
                } else {
                    self.delegate?.cameraSetupCompleted(camera: self, result: result)
                }
            })
        }
    }

    func updateAudio(_ completion: @escaping (_ result: CameraSetupResult) -> Void) {
        self.sessionQueue.async {
            self.purgeAudioDevices()
            switch AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) {
            case .authorized:
                guard let audioInput = self.getNewAudioInputDevice() else {
                    completion(CameraSetupResult.invalidAudioInput)
                    return
                }
                guard self.session.canAddInput(audioInput) else {
                    completion(CameraSetupResult.invalidAudioInput)
                    return
                }
                self.audioInput = audioInput
                self.session.addInput(audioInput)
                completion(CameraSetupResult.audioSuccess)
                return
            case .denied:
                completion(CameraSetupResult.audioPermissionDenied)
                return
            case .notDetermined:
                completion(CameraSetupResult.audioRequiresAuthorization)
                return
            case .restricted:
                completion(CameraSetupResult.audioPermissionRestricted)
                return
            }
        }
    }

    func updateVideo(_ completion: @escaping (_ result: CameraSetupResult) -> Void) {
        self.sessionQueue.async {
            self.purgeVideoDevices()
            switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            case .authorized:
                completion(self.videoSetupApproved())
            case .denied:
                completion(CameraSetupResult.videoPermissionDenied)
                return
            case .notDetermined:
                completion(CameraSetupResult.videoRequiresAuthorization)
                return
            case .restricted:
                completion(CameraSetupResult.videoPermissionRestricted)
                return
            }
        }
    }

    private func videoSetupApproved() -> CameraSetupResult {
        self.torchState = .off
        self.session.sessionPreset = .high // set to high here so that device input can be added to session. resolution can be checked for update later
        guard let videoInput = self.getNewVideoInputDevice() else {
            return .invalidVideoInput
        }
        if let failureResult = checkSessionValidity(for: videoInput) {
            return failureResult
        }
        self.videoInput = videoInput
        self.session.addInput(videoInput)
        if self.streamFrames {
            Log.verbose("adding video data output to session")
            self.session.addOutput(self.videoDataOutput)
        }
        self.session.addOutput(self.photoOutput)
        self.session.commitConfiguration()
        if self.session.canSetSessionPreset(self.resolution.foundationPreset()) {
            Log.verbose("creating video session with resolution: \(self.resolution.rawValue)")
            self.session.sessionPreset = self.resolution.foundationPreset()
        }
        configureVideoRecordingOutput(for: self.session)
        configureMetadataOutput(for: self.session)
        configureHiResPhotoOutput(for: self.session)
        configureLivePhotoOutput(for: self.session)
        configureDepthDataOutput(for: self.session)
        configureFrameRate()
        return .videoSuccess
    }

    private func checkSessionValidity(for input: AVCaptureDeviceInput) -> CameraSetupResult? {
        guard self.session.canAddInput(input) else {
            Log.error("cannot add video input")
            return .invalidVideoInput
        }
        guard self.session.canAddOutput(self.videoDataOutput) else {
            Log.error("cannot add video data output")
            return .invalidVideoDataOutput
        }
        guard self.session.canAddOutput(self.photoOutput) else {
            Log.error("cannot add photo output")
            return .invalidPhotoOutput
        }
        guard self.session.canAddOutput(self.metadataOutput) else {
            Log.error("cannot add video metadata output")
            return .invalidVideoMetadataOutput
        }
        if self.recordsVideo == true {
            guard self.session.canAddOutput(self.videoFileOutput) else {
                Log.error("cannot add video file output for recording video")
                return .invalidVideoFileOutput
            }
        }
        if #available(iOS 11.0, *), let depthDataOutput = self.depthDataOutput {
            guard self.session.canAddOutput(depthDataOutput) else {
                Log.error("cannot add depth data output with this settings map")
                return .invalidDepthDataOutput
            }
        }
        return nil
    }

    private func configureVideoRecordingOutput(for session: AVCaptureSession) {
        if self.recordsVideo {
            // adding this invalidates the video data output
            Log.verbose("adding video file output")
            self.session.addOutput(self.videoFileOutput)
            if let connection = self.videoFileOutput.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
        }
    }

    private func configureHiResPhotoOutput(for session: AVCaptureSession) {
        if self.captureHighResolutionImages && self.photoOutput.isHighResolutionCaptureEnabled {
            Log.verbose("enabling high resolution photo capture")
            self.photoOutput.isHighResolutionCaptureEnabled = true
        } else if self.captureHighResolutionImages {
            Log.error("cannot capture high resolution images with current settings")
            self.captureHighResolutionImages = false
        }
    }

    private func configureLivePhotoOutput(for session: AVCaptureSession) {
        if self.captureLivePhotos && self.photoOutput.isLivePhotoCaptureSupported {
            Log.verbose("enabling live photo capture")
            self.photoOutput.isLivePhotoCaptureEnabled = true
        } else if self.captureLivePhotos {
            Log.error("cannot capture live photos with current settings")
            self.captureLivePhotos = false
        }
    }

    private func configureMetadataOutput(for session: AVCaptureSession) {
        if self.trackMetadata {
            Log.verbose("adding video metadata output")
            session.addOutput(self.metadataOutput)
            self.metadataOutput.metadataObjectTypes = self.metadataOutput.availableMetadataObjectTypes
        }
    }

    private func configureDepthDataOutput(for session: AVCaptureSession) {
        if #available(iOS 11.0, *) {
            if self.captureDepthData && self.photoOutput.isDepthDataDeliverySupported {
                Log.verbose("enabling depth data delivery")
                self.photoOutput.isDepthDataDeliveryEnabled = true
            } else if self.captureDepthData {
                Log.error("cannot capture depth data with these settings")
                self.captureDepthData = false
            }
        } else {
            Log.error("cannot capture depth data - must use iOS 11.0 or higher")
            self.captureDepthData = false
        }
        if #available(iOS 11.0, *) {
            if self.streamDepthData, let depthDataOutput = self.depthDataOutput {
                Log.verbose("adding streaming depth data output to capture session")
                session.addOutput(depthDataOutput)
                session.commitConfiguration()
            }
        }
    }
}
