//
//  BattleView.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct BattleView: View {
    @State var battleNodes = [BattleNodeData]()
    @State var battleNodes2 = [BattleNodeData]()
    @State var battleNodes3 = [BattleNodeData]()
    @State var battleNodes4 = [BattleNodeData]()
    @State var heights = [Int]()
    @State var heightsSelf = [Int]()
    @State var capturedNodes = [Int]()
   
    
    
    @State var prep = false
    @EnvironmentObject var userData: UserData
    var body: some View {
        GeometryReader { geo in
        ZStack {
            Color("background")
                .ignoresSafeArea()
                .onAppear() {
                    
                
                  
                   
                    
                  //  for i in 0...4 {
                   //     heightsSelf.append(Int(geo.size.height/3))
                  //  }
                   // for i in 0...4 {
                   //     heightsFoe.append(Int(geo.size.height/3))
                   // }
                    for i in 0...30 {
                    
                        let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4))
                        if !heights.contains(number) {
                            heights.append(number)
                        } else {
                            let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4))
                            
                            if !heights.contains(number) {
                                heights.append(number)
                                
                            } else {
                                let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4))
                                if !heights.contains(number) {
                                    heights.append(number)
                                } else {
                                    let number = Int.random(in: Int(geo.size.height/7)..<Int(geo.size.height/4))
                                    heights.append(number)
                                }
                            }
                        }
                
                   
                   
                        
                        
                       
                     
                        
                    }
                    for i in heights.indices {
                        if i > 0 && i < 3 {
                        battleNodes.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: false))
                        }
                        if i > 3 && i < 6 {
                            battleNodes.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: true))
                    
                    }
                        if i > 6 && i < 9 {
                            battleNodes2.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: false))
                    
                    }
                        if i > 9 && i < 12 {
                            battleNodes2.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: true))
                    
                    }
                        if i > 12 && i < 15 {
                            battleNodes3.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: false))
                    
                    }
                        if i > 15 && i < 18 {
                            battleNodes3.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: true))
                    
                    }
                        if i > 18 && i < 21 {
                            battleNodes4.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: false))
                    
                    }
                        if i > 21 && i < 24 {
                            battleNodes4.append(BattleNodeData(id: UUID(), num: i, groupID: "1", height: heights[i], isMyGroup: true))
                    
                    }
                        
                    }
                }
    
           // ScrollView(showsIndicators: false) {
            //    ScrollViewReader { sp in
                HStack {
        VStack {
           
            ForEach(battleNodes, id: \.self) { node in
                VStack {
                   
                    BattleNode(node: node, count: 0, capturedNodes: $capturedNodes, prep: $prep)
                           
                    
                    .padding(2)
                    .onAppear() {
                     //   sp.scrollTo(battleNodes.last!, anchor: .bottom)
                    }
                   
                }
            }
        }
                VStack {
                   
                    ForEach(battleNodes2.indices, id: \.self) { i in
                        VStack {
                           
                            BattleNode(node: battleNodes2[i], count: i, capturedNodes: $capturedNodes, prep: $prep)
                                    .id(UUID())
                            .padding(2)
                            
                        }
                    }
                }
                    VStack {
                       
                        ForEach(battleNodes3.indices, id: \.self) { i in
                            VStack {
                               
                                BattleNode(node: battleNodes3[i], count: i, capturedNodes: $capturedNodes, prep: $prep)
                                        .id(UUID())
                                .padding(2)
                                
                            }
                        }
                    }
                    VStack {
                       
                        ForEach(battleNodes4.indices, id: \.self) { i in
                            VStack {
                                
                                BattleNode(node: battleNodes4[i], count: i, capturedNodes: $capturedNodes, prep: $prep)
                                        .id(UUID())
                                .padding(2)
                               
                            }
                        }
                    }
                }
        .ignoresSafeArea()
                .padding(.horizontal, geo.size.width/6)
        
       
            
               
            }
         
        
}  .statusBar(hidden: true)
}
}
