//
//  Basics.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI
import AVKit
struct Basics  {
    func light() -> Double {
        let currentBrightness = UIScreen.main.brightness
        return currentBrightness.magnitudeSquared
    }
    
    func torch() -> Int {
        let device: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
        return device.torchMode.rawValue
    }
    func model() -> String {
        let device = UIDevice.current
        return device.model
    }
    
    func isFlat() -> Bool {
        let device = UIDevice.current
        return device.orientation.isFlat
    }
    func isLandscape() -> Bool {
        let device = UIDevice.current
        return device.orientation.isLandscape
    }
    func isMirroring() -> Bool {
        let device = UIScreen.main
        return (device.mirrored != nil)
    }
    func scale() -> CGFloat {
        let device = UIScreen.main
        return device.scale
    }
    func isCharging() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
               
               
               
               switch UIDevice.current.batteryState {
               case .unknown:
                 return false
               case .charging:
                return true
               case .full:
                return true
               case .unplugged:
                return false
               default:
                   return false
               
           }
        
    }
    func darkMode() -> Bool {
        if UITraitCollection.current.userInterfaceStyle == .dark {
                return true
            }
            else {
                return false
            }
    }
    func isCaptured() -> Bool {
        let device = UIScreen.main
        return device.isCaptured
    }
}

