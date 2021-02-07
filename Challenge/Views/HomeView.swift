//
//  HomeView.swift
//  Challenge
//
//  Created by Andreas on 1/29/21.
//

import SwiftUI

struct HomeView: View {
    @State var battleNodes = [BattleNodeData]()
    @State var battleNodes2 = [BattleNodeData]()
    @State var battleNodes3 = [BattleNodeData]()
    @State var battleNodes4 = [BattleNodeData]()
    @State var heightsFoe = [Int]()
    @State var heightsSelf = [Int]()
    @State var capturedNodes = [Int]()
  
    
    
    @State var prep = false
    @State var ready = false
    @EnvironmentObject var userData: UserData
    var body: some View {
        GeometryReader { geo in
        ZStack {
            Color("background")
                .ignoresSafeArea()
                .onAppear() {
                    
                 capturedNodes = userData.completedLvls
                  print(userData.completedLvls)
                   
                    
                  //  for i in 0...4 {
                   //     heightsSelf.append(Int(geo.size.height/3))
                  //  }
                   // for i in 0...4 {
                   //     heightsFoe.append(Int(geo.size.height/3))
                   // }
                    for i in 0...18 {
                        let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4.5))
                        if !heightsFoe.contains(number) {
                            heightsFoe.append(number)
                        } else {
                            let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4.5))
                            
                            if !heightsFoe.contains(number) {
                                heightsFoe.append(number)
                                
                            } else {
                                let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4.5))
                                if !heightsFoe.contains(number) {
                                    heightsFoe.append(number)
                                } else {
                                    let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4.5))
                                    heightsFoe.append(number)
                                }
                            }
                        }
                }
                   
                   
                        
                        
                    for i in heightsFoe.indices {
                        if i > 0 && i < 6 {
                            if capturedNodes.contains(i) {
                        battleNodes.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heightsFoe[i], isMyGroup: true))
                            } else {
                                battleNodes.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heightsFoe[i], isMyGroup: false))
                            }
                    }
                        if i > 6 && i < 12 {
                            if capturedNodes.contains(i) {
                        battleNodes2.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heightsFoe[i], isMyGroup: true))
                            } else {
                                battleNodes2.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heightsFoe[i], isMyGroup: false))
                            }
                    }
                        if i > 12 && i < 18 {
                            if capturedNodes.contains(i) {
                        battleNodes3.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heightsFoe[i], isMyGroup: true))
                            } else {
                                battleNodes3.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heightsFoe[i], isMyGroup: false))
                            }
                    }
                    }
                    ready = true
                }
            if ready {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { sp in
                HStack {
        VStack {
           
            ForEach(battleNodes.indices, id: \.self) { i in
                VStack {
                   
                    HomeNode(node: battleNodes[i], count: i, capturedNodes: $capturedNodes, prep: $prep)
                        .environmentObject(UserData.shared)
                    
                    .padding(2)
                    .onAppear() {
                        //sp.scrollTo(battleNodes.last!, anchor: .bottom)
                    }
                   
                }
            }
        }
                VStack {
                   
                    ForEach(battleNodes2.indices, id: \.self) { i in
                        VStack {
                           
                            HomeNode(node: battleNodes2[i], count: i + battleNodes.count , capturedNodes: $capturedNodes, prep: $prep)
                                    .id(UUID())
                            .padding(2)
                           
                        }
                    }
                }
                    VStack {
                       
                        ForEach(battleNodes3.indices, id: \.self) { i in
                            VStack {
                               
                            HomeNode(node: battleNodes3[i], count: i + battleNodes2.count*2 , capturedNodes: $capturedNodes, prep: $prep)
                                        .id(UUID())
                                .padding(2)
                                
                            }
                        }
                    }
                  
                }
                }
            }
        .ignoresSafeArea()
                .padding(.horizontal, geo.size.width/6)
        
       
            
               
            }
         
        }
}  .statusBar(hidden: true)
}
}
