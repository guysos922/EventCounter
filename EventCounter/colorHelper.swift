//
//  colorHelper.swift
//  EventCounter
//
//  Created by Guy Shindel on 26/09/2023.
//

import Foundation
import SwiftUI


extension Color {

    var components: (r: Double, g: Double, b: Double, o: Double)? {
        let uiColor: UIColor
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        if self.description.contains("NamedColor") {
            let lowerBound = self.description.range(of: "name: \"")!.upperBound
            let upperBound = self.description.range(of: "\", bundle")!.lowerBound
            let assetsName = String(self.description[lowerBound..<upperBound])
            
            uiColor = UIColor(named: assetsName)!
        } else {
            uiColor = UIColor(self)
        }

        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &o) else { return nil }
        
        return (Double(r), Double(g), Double(b), Double(o))
    }
}
