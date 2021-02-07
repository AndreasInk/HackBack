//
//  ContentView.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        if userData.isOnboardingCompleted {
            HomeView()
        } else {
            IntroView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
