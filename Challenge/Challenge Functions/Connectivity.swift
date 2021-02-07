//
//  Connectivity.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct Connectivity  {
    @State var batteryState = 0
    func battery() {

UIDevice.current.isBatteryMonitoringEnabled = true

        if UIDevice.current.batteryState == .charging {
            batteryState = 1
        } else {
            batteryState = 0
        }
}
    }
