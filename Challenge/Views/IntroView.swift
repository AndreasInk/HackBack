//
//  IntroView.swift
//  Challenge
//
//  Created by Andreas on 2/6/21.
//

import SwiftUI

struct IntroView: View {
    
    @State var add: Bool = false
    @State var settings: Bool = false
   

        
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
               
                IntroPage(titleText: "\"Creativity is just connecting things.\"", bodyText: "Steve Jobs", image: "iTunesArtwork")
                    
                
                
               
                   
                
            
            
            .transition(.opacity)
            .animation(.easeInOut(duration: 1.5))
            .ignoresSafeArea()

       
        }
    }
}

struct IntroPages_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}

