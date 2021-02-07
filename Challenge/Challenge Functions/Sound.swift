//
//  Sound.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI
import AVKit
struct Sound  {
    func volume() -> Double {
        let audioSession = AVAudioSession.sharedInstance()
        let volume : Double = Double(audioSession.outputVolume)
        return volume
    }

    func otherAudioPlaying() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        let isOtherAudioPlaying : Bool = (audioSession.isOtherAudioPlaying)
        return isOtherAudioPlaying
    }
    
    func portName() -> String {
        let audioSession = AVAudioSession.sharedInstance()
        let port : String = (audioSession.currentRoute.outputs[0].portName)
        return port
    }
}
import SwiftUI
import MediaPlayer

struct UIVolumeView: UIViewRepresentable {

    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.tintColor = UIColor(named: "green1")
        volumeView.showsRouteButton = false
        return volumeView
    }

    func updateUIView(_ view: MPVolumeView, context: Context) {
        
    }
}
