//
//  settingsView.swift
//  EventCounter
//
//  Created by Guy Shindel on 26/09/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct settingsView: View{
    @Binding var isSorted: Bool
    @Binding var showDate: Bool
    
    var body: some View{
        List{
            Section("about app", content: {
                LabeledContent("version", value: "1.0")
                Text("support us")
                Text("terms of use")
            })
            Section{
                Text("time format")
                Text("widjet")
                Text("upgrade app")
                Toggle("sort by date", isOn: $isSorted)
                Toggle("show all date", isOn: $showDate)
                
            }
        }
        .listStyle(GroupedListStyle())
    }
}


#Preview {
    settingsView(isSorted: .constant(true), showDate: .constant(true))
}

