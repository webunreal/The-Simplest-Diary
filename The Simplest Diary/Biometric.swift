//
//  Biometric.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 25.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import Foundation
import LocalAuthentication

public enum Biometric {
    
    public enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    public static let biometricType: BiometricType = {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .none
            }
        } else {
            return .none
        }
    }()
    
    public static let biometricImageName: String = {
        if biometricType == .touchID {
            return "touchid"
        } else if biometricType == .faceID {
            return "faceid"
        } else {
            return ""
        }
    }()
    
    public static let biometricTypeName: String = {
        if biometricType == .touchID {
            return "Touch ID"
        } else if biometricType == .faceID {
            return "Face ID"
        } else {
            return ""
        }
    }()
}
