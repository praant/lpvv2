//
//  CapturePhotoExtension.swift
//  Lumina
//
//  Created by David Okun on 11/20/17.
//  Copyright © 2017 David Okun. All rights reserved.
//

import Foundation
import AVFoundation

@available (iOS 11.0, *)
extension AVCapturePhoto {
    func normalizedImage(forCameraPosition position: CameraPosition) -> UIImage? {
        Log.verbose("normalizing image from AVCapturePhoto instance")
        guard let cgImage = self.cgImageRepresentation() else {
            return nil
        }
        return UIImage(cgImage: cgImage.takeUnretainedValue(), scale: 1.0, orientation: getImageOrientation(forCamera: position))
    }

    private func getImageOrientation(forCamera: CameraPosition) -> UIImageOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            return forCamera == .back ? .down : .upMirrored
        case .landscapeRight:
            return forCamera == .back ? .up : .downMirrored
        case .portraitUpsideDown:
            return forCamera == .back ? .left : .rightMirrored
        case .portrait:
            return forCamera == .back ? .right : .leftMirrored
        case .unknown:
            return forCamera == .back ? .right : .leftMirrored
        }
    }
}
