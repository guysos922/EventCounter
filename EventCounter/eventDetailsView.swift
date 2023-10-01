//
//  eventDetailsView.swift
//  EventCounter
//
//  Created by Guy Shindel on 26/09/2023.
//

import Foundation
import SwiftUI
import SwiftData

enum ActiveSheet: Identifiable {
    case title, catagory, location, summary, color, date
    
    var id: Int {
        hashValue
    }
}


struct eventDetailsView: View{
    @State var event:Event
    @Binding var showAllDate:Bool
    
    @State private var activeSheet: ActiveSheet?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var eventName = ""
    @State private var eventLocation = ""
    @State private var eventDescription = ""
    @State private var eventCatagory = ""
    @State private var eventDate = Date()
    @State private var eventColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View{
        VStack{
            HStack {
                Text(event.title)
                    .font(.custom(
                        "AmericanTypewriter",
                        fixedSize: 30))
                    .foregroundColor(.white)
                    .bold()
                    .padding(30)
                    .shadow(radius: 10)
                Spacer()
            }
            .frame(width: 400, height: 120)
            .background(event.eventColor())
        }
        .shadow(color: event.eventColor(), radius: 20)
        NavigationView(content: {
            VStack{
                List{
                    Section("event catagory", content: {
                        Text(event.catagory ?? "")
                    })
                    Section("days until event", content: {
                        if showAllDate{
                            Text(event.timestamp.formatted())
                        }
                        Text("in \(event.countDays()) days")
                    })
                    Section("event details", content: {
                        Text(event.location ?? "")
                    })
                    Section("event description", content:{
                        Text(event.summary ?? "")
                    })
                }
                HStack{
                    
                    Menu("edit") {
                        Button("title", action: {
                            activeSheet = .title
                        })
                        
                        Button("catagory", action: {
                            activeSheet = .catagory
                        })
                        Button("date", action: {
                            activeSheet = .date
                        })
                        Button("description", action: {
                            activeSheet = .summary
                        })
                        Button("location", action: {
                            activeSheet = .location
                        })
                        Button("color", action: {
                            activeSheet = .color
                        })
                    }
                    .sheet(item: $activeSheet) { item in
                        switch item {
                        case .title:
                            editTitle()
                        case .location:
                            editLocation()
                        case .summary:
                            editDescription()
                        case .date:
                            editDate()
                        case .color:
                            editColor()
                        case .catagory:
                            editCatagory()
                        }
                    }
                    
                    .buttonStyle(.bordered)
                    Button(action: {delete()}, label:{ Text("delete")})
                        .buttonStyle(.bordered)
                }
            }
        })
    }
    
    func delete(){
        modelContext.delete(event)
        presentationMode.wrappedValue.dismiss()
    }
    
    func editTitle()->some View{
        return VStack{
            TextField("Event Title", text: $eventName)
                .padding(10)
                .textFieldStyle(.roundedBorder)
                .presentationDetents([.height(100)])
            
            HStack{
                Button(action: {
                    event.title = eventName
                    activeSheet = .none
                }, label: {Text("Done")})
                .buttonStyle(.bordered)
                Button(action: {
                    activeSheet = .none
                }, label: {Text("Cancel")})
                .buttonStyle(.bordered)
            }
        }
    }
    
    func editCatagory()->some View{
        return VStack{
            TextField("Event Category", text: $eventCatagory)
                .padding(10)
                .textFieldStyle(.roundedBorder)
                .presentationDetents([.height(100)])
            
            HStack{
                Button(action: {
                    event.catagory = eventCatagory
                    activeSheet = .none
                }, label: {Text("Done")})
                .buttonStyle(.bordered)
                Button(action: {
                    activeSheet = .none
                }, label: {Text("Cancel")})
                .buttonStyle(.bordered)
            }
        }
    }
    
    func editDate()->some View{
        return VStack{
            DatePicker(selection: $eventDate, displayedComponents: .date, label: { Text("Date") })
                .datePickerStyle(.graphical)
                .presentationDetents([.height(500)])
            
            HStack{
                Button(action: {
                    event.timestamp = eventDate
                    activeSheet = .none
                }, label: {Text("Done")})
                .buttonStyle(.bordered)
                Button(action: {
                    activeSheet = .none
                }, label: {Text("Cancel")})
                .buttonStyle(.bordered)
            }
        }
    }
    
    func editDescription()->some View{
        return VStack{
            TextField("Event Title", text: $eventDescription)
                .padding(10)
                .textFieldStyle(.roundedBorder)
                .presentationDetents([.height(100)])
            
            HStack{
                Button(action: {
                    event.summary = eventDescription
                    activeSheet = .none
                }, label: {Text("Done")})
                .buttonStyle(.bordered)
                Button(action: {
                    activeSheet = .none
                }, label: {Text("Cancel")})
                .buttonStyle(.bordered)
            }
        }
    }
    
    func editLocation()->some View{
        return VStack{
            TextField("Event Location", text: $eventLocation)
                .padding(10)
                .textFieldStyle(.roundedBorder)
                .presentationDetents([.height(100)])
            
            HStack{
                Button(action: {
                    event.location = eventLocation
                    activeSheet = .none
                }, label: {Text("Done")})
                .buttonStyle(.bordered)
                Button(action: {
                    activeSheet = .none
                }, label: {Text("Cancel")})
                .buttonStyle(.bordered)
            }
        }
    }
    
    func editColor()->some View{
        return VStack{
            ColorPicker("color", selection: $eventColor)
                .presentationDetents([.height(100)])
                .padding(20)
            
            HStack{
                Button(action: {
                    event.eventColorRgb = setToArray(colorTuple: eventColor.components ?? (1,1,1,1))
                    activeSheet = .none
                }, label: {Text("Done")})
                .buttonStyle(.bordered)
                Button(action: {
                    activeSheet = .none
                }, label: {Text("Cancel")})
                .buttonStyle(.bordered)
            }
        }
    }
    
    
    func setToArray(colorTuple:(r: Double, g: Double, b: Double, o: Double))->[Double]{
        let colorArray: [Double] = [colorTuple.r, colorTuple.g, colorTuple.b, colorTuple.o]
        return colorArray
    }
}


#Preview {
    eventDetailsView(event: Event(title: "simple event", timestamp: Date(), eventCol: [1,0.5,0.5,1], eventLocation: "simple event", eventCatagory: "simple event", eventDescription: "simple event"),showAllDate: .constant(true))
}

