//
//  CodeDefenseView.swift
//  Challenge
//
//  Created by Andreas on 2/5/21.
//

import SwiftUI
import HighlightedTextEditor
struct CodeDefenseView: View {
    
    @State private var text: String = "import Ai \n data = "
       
    @State private var rules: [HighlightRule] = [HighlightRule]()
    
       
    var body: some View {
        Color.clear
            .onAppear() {
                do {
                    let betweenUnderscores = try! NSRegularExpression(pattern: "struct[^_]+:", options: [])
                rules =  try [HighlightRule(pattern:NSRegularExpression(pattern: "import", options: .caseInsensitive), formattingRules: [
                    
                       TextFormattingRule(key: .foregroundColor, value: UIColor.systemPurple),
                      
                ])]
                    
                } catch {
                }
            }
        HighlightedTextEditor(text: $text, highlightRules: rules)
            .onChange(of: text) { newValue in
                let array = text.components(separatedBy: "\n")
                for a in array {
                    if a.contains("import") {
                        print(a)
                    }
                }
            }
        
        Spacer()
    }
}

struct CodeDefenseView_Previews: PreviewProvider {
    static var previews: some View {
        CodeDefenseView()
    }
}
