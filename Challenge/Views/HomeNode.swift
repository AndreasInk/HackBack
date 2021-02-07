//
//  HomeNode.swift
//  Challenge
//
//  Created by Andreas on 1/29/21.
//

import SwiftUI

struct HomeNode: View {
    @State var node: BattleNodeData
    @State var count: Int
    @State var toggle = false
    @Binding var capturedNodes: [Int]
    @Binding var prep: Bool
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
       
        Button(action: {
            if !node.isMyGroup! {
                
                        
            toggle = true
                        
                    
                    
                
            } else {
                toggle = true
            }
        }) {
           
     RoundedRectangle(cornerRadius: 35)
        .foregroundColor(Color(node.isMyGroup ?? false ? "green1" : "green2"))
        .frame(height: CGFloat(node.height))
        .frame(maxWidth: 65)
        //.offset(y: node.isMyGroup! ? 20 : -20)
      // .padding(.top, count > 25 ? 10 : 0)
        .onAppear() {
            if node.isMyGroup! {
            
            }
            for c in capturedNodes {
            if c == count {
                    //node.isMyGroup = true
            }
            }
            print(capturedNodes)
        }
        .onChange(of: node.isMyGroup, perform: { value in
            
            capturedNodes.append(node.num)
                let defaults = UserDefaults.standard
               
            defaults.set(capturedNodes, forKey: "completedLvls")
        })
       
        }  .fullScreenCover(isPresented: $toggle) {
            if !node.isMyGroup! {
                ZStack {
                    Color("background")
                        .ignoresSafeArea()
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                VStack {
                    
                    HStack {
                        Button(action: {
                            toggle = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                            
                        }
                        
                        Spacer()
                    
                    } .padding()
                    SolveView(capturedNodes: $capturedNodes, node: $node, count: count, motion: MotionManager())
                        
                }
                }  .ignoresSafeArea()
            } else {
                ZStack {
                    Color("background")
                        .ignoresSafeArea()
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                VStack {
                    
                    HStack {
                        Button(action: {
                            toggle = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                            
                        }
                        
                        Spacer()
                    
                    } .padding()
                    SolveView(capturedNodes: $capturedNodes, node: $node, count: count, motion: MotionManager())
                        
                }
                }  .ignoresSafeArea()
            }
                }
    }

}

