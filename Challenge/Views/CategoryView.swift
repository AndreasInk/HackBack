//
//  CategoryView.swift
//  Challenge
//
//  Created by Andreas on 1/29/21.
//

import SwiftUI

struct CategoryView: View {
    @State var text: String
   
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(.darkText))
            VStack {
                Image("cam")
                    .resizable()
                    .scaledToFit()
                    .padding()
            Text(text)
                .foregroundColor(Color("green1"))
            }
        } .padding()
    }
}

