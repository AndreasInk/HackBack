//
//  IfView.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct IfView: View {
   @State var basics =  Basics()
    @State var light = 0.0
    
    @State var vision =  Vision()
    @State var prediction = "hi"
    @State  var ciColor2 = CIColor(color: .white)
    var body: some View {
        ZStack {
            CustomCameraRepresentable()
            Text(ciColor2.stringRepresentation)
            .onAppear() {
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
               
                    prediction = predictions
                    
                    ciColor2 = ciColor
                }
            }
    }
    }
}

