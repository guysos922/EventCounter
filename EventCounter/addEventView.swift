//
//  addEventView.swift
//  countev
//
//  Created by Guy Shindel on 18/09/2023.
//

import SwiftUI
import SwiftData

struct addEventView: View{
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    @State private var eventName = ""
    @State private var eventLocation = ""
    @State private var eventDescription = ""
    @State private var eventCatagory = ""
    @State private var eventDate = Date()
    @State private var eventColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    @State private var isEditing = false
    
    var body: some View{
        VStack{
            List{
                Section("event title", content: {
                    TextField("requierd", text: $eventName)
                })
                Section("event location", content:{
                    TextField("optional", text: $eventLocation)
                })
                Section("event catagory", content: {
                    TextField("optional", text: $eventCatagory)
                })
                Section("event description", content:{
                    TextField("optional", text: $eventDescription, axis: .vertical)
                })
                Section("event date", content:{
                    DatePicker(selection: $eventDate, displayedComponents: .date, label: { Text("Date") })
                        .datePickerStyle(.graphical)
                })
                Section("event color", content:{
                    ColorPicker("color", selection: $eventColor)
                })
                
                Section{
                    HStack{
                        //Spacer()
                        //cancelButton()
                        Spacer()
                        saveButton()
                        Spacer()
                    }
                }
            }
        }
    }
    
    
    
    /*func cancelButton()->some View{
        Button(action: {
            isPresented = false
        }, label: {
            HStack{
                Text("Cancel")
                Image(systemName: "minus.square.fill")
            }
        })
        .foregroundStyle(.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
    }*/
    
    func saveButton()->some View{
        Button(action: {
            isPresented = false
         
            let toAdd = Event(title: eventName, timestamp: eventDate, eventCol: setToArray(colorTuple: eventColor.components ?? (1,1,1,1)),eventLocation: eventLocation,eventCatagory: eventCatagory,eventDescription: eventDescription)
            
            
            modelContext.insert(toAdd)
            
        }, label: {
            HStack{
                Text("Save")
                Image(systemName: "plus.rectangle.portrait.fill")
            }
        })
        
        .foregroundStyle(.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    func setToArray(colorTuple:(r: Double, g: Double, b: Double, o: Double))->[Double]{
        let colorArray: [Double] = [colorTuple.r, colorTuple.g, colorTuple.b, colorTuple.o]
        return colorArray
    }
    
    
}
