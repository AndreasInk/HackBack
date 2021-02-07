//
//  CreatePuzzleThenView.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct CreatePuzzleThenView: View {
    var body: some View {
        GeometryReader { geo in
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color(.darkText))
                .opacity(0.5)
                
            HStack {
            Text("Then")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                Spacer()
                Button(action: {
                    
                }) {
                    
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25.0)
                                        .foregroundColor(Color("green1")))
                } .padding()

        } .padding()
        } .padding()
    }
    }
}

