//
//  Item.swift
//  EventCounter
//
//  Created by Guy Shindel on 21/09/2023.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Event {
    var title: String
    var location: String?
    var catagory: String?
    var summary: String?
    var timestamp: Date
    var eventColorRgb: [Double]? = [1,1,1,1]
    

    init(title: String,timestamp: Date, eventCol: [Double],eventLocation: String,eventCatagory: String,eventDescription: String) {
        self.title = title
        self.timestamp = timestamp
        self.eventColorRgb = eventCol
        self.location = eventLocation
        self.catagory = eventCatagory
        self.summary = eventDescription
    }
    
    func countDays()-> Int{
        let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: self.timestamp)

        let days = dateComponents.day!
        
        return days
    }
    
    public func eventColor()-> Color{
        return Color(red: eventColorRgb?[0] ?? 1, green: eventColorRgb?[1] ?? 1, blue: eventColorRgb?[2] ?? 1)
    }
    
    public func setTitle(newTitle:String){
        self.title = newTitle
    }
}
