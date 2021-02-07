//
//  BattleNodeData.swift
//  Challenge
//
//  Created by Andreas on 1/29/21.
//

import SwiftUI

struct BattleNodeData: Identifiable, Codable, Hashable {
    var id: UUID
    var num: Int
    var groupID: String
    var height: Int
    var isMyGroup: Bool?
}
