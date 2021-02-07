//
//  SolveView.swift
//  Challenge
//
//  Created by Andreas on 1/29/21.
//

import SwiftUI
import DocumentClassifier
import AVKit
struct SolveView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var capturedNodes: [Int]
    @Binding var node: BattleNodeData
    @State var count: Int
    @State var basic = Basics()
    @State var sound = Sound()
    @State var clue = false
    @State var text = ""
    @State var volume = 0.0
    @State var c = 0
    @State var femaleCount = 0
    let classifier = DocumentClassifier()
    @ObservedObject
       var motion: MotionManager
    @State var y = 0.0
    @State var x = 0.0
    let data = (1...13).map { "Item \($0)" }

       let columns = [
           GridItem(.adaptive(minimum: 80))
       ]
    var body: some View {
        ZStack {
            Color.clear
               
            switch count {
            case 0:
               
            CustomCameraRepresentable()
                
                Image(systemName: "laptopcomputer")
                    .foregroundColor(Color("green1"))
                .onAppear() {
                   
                    let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        let array = predictions.components(separatedBy: ",")
                        for a in array {
                            print(a)
                        if a == "web site" || a == "website" || a == "internet site" || a == "phone" || a == "tv" || a == "tv" || a == "computer keyboard" || a == "keyboard" || a == "keypad" {
                            clue = true
                           
                        } else {
                          //  clue = false
                        }
                        
                    if a == "monitor" || a == "laptop" || a == "computer" {
                        
                       
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut) {
                                
                        node.isMyGroup = true
                               
                        }
                        }
                        presentationMode.wrappedValue.dismiss()
                        timer.invalidate()
                    }
                        }
                    }
                }
                
            case 1:
                ZStack {
                   Image("hand")
                   
                    .resizable()
                    .scaledToFit()
                    .padding()
                    
                    
                    
                    CustomCameraRepresentableHand()
                        
                   
                    .onAppear() {
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if isPinched {
                               
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut) {
                                    
                            node.isMyGroup = true
                                   
                            }
                            }
                            presentationMode.wrappedValue.dismiss()
                                timer.invalidate()
                        }
                        }
                    }
                    }
            case 2:
                SpeechView()
                Image("girl")
                  
                 .resizable()
                 .scaledToFit()
                    .padding()
                    .onAppear() {
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if isFemale {
                                femaleCount += 1
                                if femaleCount > 3 {
                                   
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut) {
                                   
                            node.isMyGroup = true
                                   
                            }
                            }
                            presentationMode.wrappedValue.dismiss()
                                    timer.invalidate()
                                } else {
                                    femaleCount = 0
                                }
                            } else {
                                femaleCount = 0
                            }
                        }
                    }
            case 3:
               
                
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    TextField("", text: $text)
                        .foregroundColor(Color("green1"))
                    Button(action: {
                        let model = IMDBReviewClassifier()
                        
                        
                        
                            do {
                                let prediction = try model.prediction(text: text)
                                if prediction.label == "Positive" {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation(.easeInOut) {
                                          
                                    node.isMyGroup = true
                                           
                                    }
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } else {
                                   
                                }
                            } catch {
                                print(error)
                            }
                        
                    }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("green1")))
                }
                } .padding()
                  
            case 4:
                CustomCameraRepresentable2()
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(Color("green1"))
                    .onAppear() {
                        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            
                            
                                do {
                                    let classification = classify(texting)
                                    print(classification)
                                    if classification == "Business" {
                                       
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation(.easeInOut) {
                                               
                                        node.isMyGroup = true
                                               
                                                
                                        }
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                        timer.invalidate()
                                    } else {
                                       
                                    }
                                } catch {
                                    print(error)
                                }
                        }
                    }
            case 5:
                
                CustomCameraRepresentable3()
                VStack {
                Text("\(14)")
                 .foregroundColor(Color("green1"))
                   Text("\(c)")
                    .foregroundColor(Color("green2"))
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                                  ForEach(data, id: \.self) { item in
                                    Circle()
                                        .foregroundColor(Color("green1"))
                                        .frame(width: 50, height: 50)
                                  }
                              }
                              .padding(.horizontal)
                }
                    .onAppear() {
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            c = countC
                            print(countC)
                            if countC > 10 && countC < 20 {
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.easeInOut) {
                                        
                                node.isMyGroup = true
                                       
                                }
                                }
                                presentationMode.wrappedValue.dismiss()
                                timer.invalidate()
                            }
                         
                        }
                    }
            case 6:
                Image(systemName: "bolt")
                    .foregroundColor((Color("green1")))
                    .onAppear() {
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                           
                           
                            UIDevice.current.isBatteryMonitoringEnabled = true
                            
                                    if UIDevice.current.batteryState == .charging {
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation(.easeInOut) {
                                               
                                        node.isMyGroup = true
                                               
                                        }
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                        timer.invalidate()
                                    } else {
                                       
                                    }
                           
                        }
                        }
            case 7:
                Image(systemName: "music.note")
                    .foregroundColor((Color("green1")))
                    .onAppear() {
                       
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                           
                           
                            let audioSession = AVAudioSession.sharedInstance()
                            let isOtherAudioPlaying : Bool = (audioSession.isOtherAudioPlaying)

                                    if isOtherAudioPlaying {
                                     
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation(.easeInOut) {
                                               
                                        node.isMyGroup = true
                                               
                                        }
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                        timer.invalidate()
                                    } else {
                                       
                                    }
                           
                        }
                    }
            case 8:
                GeometryReader { geo in
                ZStack {
                    Color("green1")
                        .ignoresSafeArea()
                   
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(.black)
                        .offset(y: -geo.size.height/3)
                    
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 50)
                        .offset(x: CGFloat(x), y: CGFloat(y))
                        .onAppear() {
                           
                            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                               
                                withAnimation(.easeOut) {
                                x = motion.z*1000
                                y = -motion.y*1000
                                  
                                    if y < -220 {
                                        if y > -250 {
                                            if x < 0 {
                                                if x > -3 {
                                                   
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        withAnimation(.easeInOut) {
                                                          
                                                    node.isMyGroup = true
                                                           
                                                    }
                                                    }
                                                    presentationMode.wrappedValue.dismiss()
                                                    timer.invalidate()
                                                }
                                            }
                                           
                                        }
                                    }
                                }
                        }
                }
            }
                }
            case 9:
                Rectangle()
                    .foregroundColor(Color("background"))
                    .onTapGesture(count:2) {
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut) {
                               
                        node.isMyGroup = true
                               
                                
                              
                        }
                        }
                        presentationMode.wrappedValue.dismiss()
                       
                    }
                Text("2")
                    .foregroundColor((Color("green1")))
                    .padding()
               
            case 10:
                facesView()
                
                    .onAppear() {
                       
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                           
                           
                          

                                    if smile == "yes" {
                                       
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation(.easeInOut) {
                                             
                                        node.isMyGroup = true
                                                
                                        }
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                        timer.invalidate()
                                    } else {
                                       
                                    }
                           
                        }
                    }
            case 11:
                Image(systemName: "headphones")
                    .foregroundColor((Color("green1")))
                    .onAppear() {
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        let audioSession = AVAudioSession.sharedInstance()
                        let port : String = (audioSession.currentRoute.outputs[0].portType).rawValue
                        if port == "BluetoothA2DPOutput" {
                          
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut) {
                                  
                            node.isMyGroup = true
                                   
                            }
                            }
                            presentationMode.wrappedValue.dismiss()
                            timer.invalidate()
                        }
                        }
                    }
            case 12:
                
                CustomCameraRepresentable()
                    
                    
                Text("2020")
                    .font(.title)
                    .foregroundColor((Color("green1")))
                    .onAppear() {
                       
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            let array = predictions.components(separatedBy: ",")
                            for a in array {
                                print(a)
                           
                            
                        if a == "toilet" || a == "toilet paper" || a == "toilet tissue" {
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut) {
                                    
                            node.isMyGroup = true
                                  
                            }
                            }
                            presentationMode.wrappedValue.dismiss()
                            timer.invalidate()
                        }
                            }
                        }
                    }
            case 13:
                ZStack {
                GreenCustomCameraRepresentable()
                    Color("green1")
                        .ignoresSafeArea()
                        .onAppear() {
                           
                            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                if avgColor == "green" {
                                   
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation(.easeInOut) {
                                           
                                    node.isMyGroup = true
                                           
                                    }
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                    timer.invalidate()
                                }
                                
                            }
                        }
            }
            case 14:
                DogView()
                Text("🐶")
                    .onAppear() {
                       
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if isDog {
                                
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.easeInOut) {
                                       
                                node.isMyGroup = true
                                       
                                        timer.invalidate()
                                }
                                }
                                presentationMode.wrappedValue.dismiss()
                                timer.invalidate()
                            }
                        }
                    
        }
            default:
                EmptyView()
            }
           
            
           
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                   // Image(systemName: "xmark")
                     //   .foregroundColor(.white)
                       // .font(.title)
                        //.padding()
                    EmptyView()
                }
                Spacer()
                    
            }
            Spacer()
        }
            
        }
    }
    func classify(_ text: String) -> String {
            guard let classification = classifier.classify(text) else { return ""}
            let prediction = classification.prediction
        return prediction.category.rawValue
           // updateInterface(for: prediction)
        }
}

