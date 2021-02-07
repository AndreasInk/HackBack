//
//  BattleNode.swift
//  Challenge
//
//  Created by Andreas on 1/28/21.
//

import SwiftUI

struct BattleNode: View {
    @State var node: BattleNodeData
    @State var count: Int
    @State var toggle = false
    @Binding var capturedNodes: [Int]
    @Binding var prep: Bool
    var body: some View {
       
        Button(action: {
            if !node.isMyGroup! {
                for i in capturedNodes {
                    for i2 in i - 4...i + 4 {
                    if count == i2 {
                        if !prep {
            toggle = true
                        }
                    }
                    }
                }
            } else {
                toggle = true
            }
        }) {
           
     RoundedRectangle(cornerRadius: 35)
        .foregroundColor(Color(node.isMyGroup ?? true ? "green1" : "green2"))
        
        .frame(height: CGFloat(node.height))
        .frame(maxWidth: 65)
        //.offset(y: node.isMyGroup! ? 20 : -20)
      // .padding(.top, count > 25 ? 10 : 0)
        .onAppear() {
            if node.isMyGroup! {
            capturedNodes.append(count)
            }
        }
       
        .fullScreenCover(isPresented: $toggle) {
            if !node.isMyGroup! {
                SolveView(capturedNodes: $capturedNodes, node: $node, count: count, motion: MotionManager())
            } else {
                CodeDefenseView()
            }
                }
        }  

}
}
