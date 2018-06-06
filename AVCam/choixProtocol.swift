//
//  choixMatchProtocol.swift
//  AVCam
//
//  Created by Anthony Praud on 12/05/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

// Note: this protocol is used in "Passing Data Back With Delegation"
protocol choixDelegate
{   var name: String { get }
    var nickname: String? { get set }
    var sport : String? { get set }
    var matchchoix: String? { get set }
    func onSportReady(type: String)
    func onMatchReady(type: String)
    func onConnexionReady(type: String)
}

