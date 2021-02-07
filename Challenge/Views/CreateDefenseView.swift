//
//  CreatePuzzleView.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct CreateDefenseView: View {
    @State var node: BattleNodeData
    @Environment(\.presentationMode) var presentationMode
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
       
        ]
    
    @State var categories = ["Basics", "Sound", "Speech", "Camera", "Draw", "Location", "Motion"]
    @ObservedObject
       var motion: MotionManager
    @State var basics = Basics()
    @State var prediction = "hi"
    @State  var ciColor2 = CIColor(color: .white)
    @State var brightness = [Double]()
    @State var torch = [Double]()
    @State var isFlat = [Bool]()
    @State var isMirroring = [Bool]()
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
                .onAppear() {
                    let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if brightness.last ?? basics.light()  != basics.light() {
                            presentationMode.wrappedValue.dismiss()
                        }
                        if torch.last ?? Double(basics.torch())  != Double(basics.torch()) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        if isFlat.last ?? basics.isFlat()  != basics.isFlat() {
                            presentationMode.wrappedValue.dismiss()
                        }
                        if isMirroring.last ?? basics.isMirroring()  != basics.isMirroring() {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        prediction = predictions
                        
                        ciColor2 = ciColor
                        
                        brightness.append(basics.light())
                        
                       // torch.append(Double(basics.torch()))
                        
                       // isFlat.append(basics.isFlat())
                        
                        //isMirroring.append(basics.isMirroring())
                       
                    }
                }
        GeometryReader { geo in
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                    
                }
                Spacer()
                Text("Create your defense")
                    
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color("green1"))
            } .padding()
            Spacer()
            Text("Interact with your device to configure its defense")
                
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.white))
                .opacity(0.6)
                .padding()
            Text("For Example: If you turn your flashlight on then that becomes your defense for this node")
                
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.white))
                .opacity(0.4)
                .padding()
            Spacer()
            
            HStack {
                Spacer()
            Button(action: {
                
            }) {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 75, height: 75, alignment: .center)
            }
                Button(action: {
                    
                }) {
                    Circle()
                        .foregroundColor(.white)
                        .opacity(0.4)
                        .frame(width: 75, height: 75, alignment: .center)
                }
            } .padding()
    }
           
        }
    }
}
}


