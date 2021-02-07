//
//  IntroPagw.swift
//  Challenge
//
//  Created by Andreas on 2/6/21.
//

import SwiftUI

struct IntroPage: View {
    var titleText:String
    var bodyText:String
    var image:String
    let screenSize = UIScreen.main.bounds
   
    @State var animate1 = true
    @State var animate2 = true
    @State var animate3 = true
    @State var animate4 = true
    @State var animate5 = true
    @State var animate6 = true
    @EnvironmentObject var userData: UserData
    @State var home = false
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animate1 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        animate2 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate3 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate4 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate5 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate6 = true
                    }
                }
            VStack {
                HStack {
                    if animate1 {
                    Text(titleText)
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Montserrat-Bold", size: 25, relativeTo: .headline))
                        .foregroundColor(Color("green1"))
                        .padding(.vertical, 20)
                        .padding(.horizontal)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.5))
                        .offset(y: screenSize.height/4)
                        .frame(minHeight: screenSize.height/6)
                }
                }
                if animate2 {
                Spacer()
                }
                if animate3 {
                Text(bodyText)
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Montserrat-Light", size: 15, relativeTo: .headline))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color("green2"))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
                    .offset(y: screenSize.height/4)
                    
                }
                if animate4 {
                Spacer()
                }
                if animate5 {
                Image(decorative: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width, height:screenSize.height)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
                    .offset(y: screenSize.height/5)
                    .onTapGesture {
                        userData.isOnboardingCompleted = true
                        home = true
                    }
                    if animate6 {
                Spacer()
                    }
                }
               // Text("Skip for now")
                  //  .font(.custom("Montserrat-Regular", size: 17))
                   // .foregroundColor(Color.black.opacity(0.5))
                    //.padding(.bottom, 10)

                
            }
            
        } .fullScreenCover(isPresented: $home) {
            HomeView()
        }
    }
}

struct IntroPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage(titleText: "Customization", bodyText: "Select your classes and learning topics and we'll recommend groups where you can find help.", image: "studying_drawing")
    }
}
