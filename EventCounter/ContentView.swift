//
//  ContentView.swift
//  EventCounter
//
//  Created by Guy Shindel on 21/09/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Event]
    
    @State private var showAddEventView: Bool = false
    @State private var multiSelection = Set<UUID>()
    @State private var isSorted:Bool = false
    @State private var showDate:Bool = false
    
    var body: some View {
        NavigationSplitView {
            
            HStack{
                Text("EventCounter")
                    .font(.title)
                    .bold()
                
                Image(systemName: "calendar.circle")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                
            }
            EventList()
        } detail: {Text("Select an item")
        }
        //.ignoresSafeArea(.all)
        .sheet(isPresented: $showAddEventView){
            addEventView(isPresented: $showAddEventView)
                .environment(\.modelContext, modelContext)
                .presentationDetents([.large])
        }
        .onAppear(perform: {
            //AddDefaultEvents()
        })
    }
    
    private func EventList()->some View{
        var events:[Event]
        
        if(isSorted){
            events = sortByDate()
        }else{
            events = items
        }
        
        return List{
            ForEach(events, id: \.self) { item in
                NavigationLink{
                    eventDetailsView(event: item, showAllDate: $showDate)
                    .environment(\.modelContext, modelContext)}
            label: {
                HStack{
                    Circle()
                        .fill(item.eventColor())
                        .frame(width: 30,height: 30)
                        .shadow(radius: 10)
                        .padding(10)
                    
                    Text(item.title)
                    
                    Spacer()
                    Text("in \(item.countDays()) days")
                        .multilineTextAlignment(.trailing)
                        .bold()
                }
            }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    let itemToDelete = items[index]
                    modelContext.delete(itemToDelete)
                }
            })
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: {
                    showAddEventView = true
                }, label: {
                    Label("Add Item", systemImage: "plus")
                })
            }
            ToolbarItem(placement: .navigationBarLeading){
                NavigationLink(destination: settingsView(isSorted: $isSorted, showDate: $showDate), label: {Image(systemName: "gear")})
            }
        }
    }
    
    private func AddDefaultEvents() {
        // Initialize arrays for epic event details
        let eventTitles: [String] = ["Epic Birthday Bash", "Hackathon Showdown", "SpaceX Rocket Launch Viewing", "VR Gaming Night"]
        let eventLocations: [String] = ["Skydiving Arena", "Silicon Valley HQ", "NASA Space Center", "Virtual Reality Arcade"]
        let eventCategories: [String] = ["Adventure", "Tech", "Science", "Gaming"]
        let eventSummaries: [String] = [
            "It's not just a birthday; it's an adrenaline-pumping skydiving experience with close friends. We'll be diving from 15,000 feet, capturing the moment with GoPros. Cake and champagne await us upon landing.",
            "Get ready for a 48-hour coding marathon at the heart of Silicon Valley. We're building the next big thing in AI, and you're invited. There will be guest speakers, mentors, and, of course, tons of coffee and snacks.",
            "Witness history in the making as SpaceX launches its next mission to Mars. We've got VIP passes to the NASA Space Center for an up-close experience. Elon Musk might even make an appearance!",
            "Step into a new reality with a night of VR gaming. We've booked the entire arcade, so it's just us and the virtual world. From racing to shooting zombies, the night is young, and the games are endless."
        ]
        
        
        // Initialize an array with future dates
        let eventDates: [Date] = [
            Date(timeIntervalSinceNow: 86400),  // 1 day = 86400 seconds
            Date(timeIntervalSinceNow: 172800), // 2 days = 172800 seconds
            Date(timeIntervalSinceNow: 259200), // 3 days = 259200 seconds
            Date(timeIntervalSinceNow: 345600)  // 4 days = 345600 seconds
        ]
        
        // Initialize an array with RGB and Opacity values for event colors
        let eventColors: [[Double]] = [
            [1.0, 0.0, 0.0, 1.0],  // Red
            [0.0, 1.0, 0.0, 1.0],  // Green
            [0.0, 0.0, 1.0, 1.0],  // Blue
            [0.5, 0.5, 0.5, 1.0]   // Gray
        ]
        
        
        for k in 0...3{
            let toAdd = Event(title: eventTitles[k], timestamp: eventDates[k],eventCol: eventColors[k],eventLocation: eventLocations[k],eventCatagory: eventCategories[k],eventDescription: eventSummaries[k])
            modelContext.insert(toAdd)
        }
    }
    
    func sortByDate()->[Event]{
        var events:[Event] = []
        if !items.isEmpty{
            var min = items[0].countDays()
            var minEvent:Event = items[0]
            
            for _ in items{
                for j in items{
                    if !events.contains(j){
                        min = j.countDays()
                    }
                }
                for j in items{
                    if j.countDays() <= min && !events.contains(j){
                        minEvent = j
                        min = minEvent.countDays()
                    }
                }
                events.append(minEvent)
            }
        }
        return events
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Event.self, inMemory: true)
}
