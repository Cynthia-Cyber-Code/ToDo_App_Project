//
//  ContentView.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI
import CoreData

struct ListView: View {
    let notificationManager: NotificationManager
    @Environment(\.managedObjectContext) var viewContext
       
    @FetchRequest(entity: Note.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Note.order, ascending: true)], animation: .default)
    var notes: FetchedResults<Note>

    @State var isAddPresented = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notes, id: \.self) { note in
                        NavigationLink {
                            DetailNote(title: note.title!)
                        } label: {
                            VStack{
                                Text(note.title ?? "error")
                                Text("\(note.order)")
                                Text(note.descriptif ?? "error")
                            }
                        }
                    }
                    .onMove(perform: dragAndDropNotes)
                    .onDelete(perform: deleteNotes)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        
                        HStack {
                            Button {
                                isAddPresented.toggle()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .sheet(isPresented: $isAddPresented) {
                                AddNoteView( isAddPresented: $isAddPresented)
                            }
                            Spacer()
                            VStack {
                                Text("To-Do list").font(.title).fontWeight(.bold).foregroundColor(.black)
                            }
                            Spacer()
                            
                            EditButton().font(.title).fontWeight(.thin).foregroundColor(.black)
                        }
                        
                    }
                }
                VStack {
                    Text("Notification will appear in 10 sec")
                    Button(action: scheduleNotification) {
                        Text("Schedule notification")
                    }
                    .padding()
                    //                }
                    .padding()
                    
                }.navigationBarTitle("Tasks")
            }
        }
    }
    private func dragAndDropNotes(offsets: IndexSet, destination: Int) {
        
        let itemToMove = offsets.first!
        withAnimation {
            if itemToMove < destination {
                var startIndex = itemToMove + 1
                let endIndex = destination - 1
                var startOrder = notes[itemToMove].order
                
                while startIndex <= endIndex {
                    notes[startIndex].order = startOrder
                    startOrder = startOrder + 1
                    startIndex = startIndex + 1
                }
                notes[itemToMove].order = startOrder
            } else if destination < itemToMove {
                var startIndex = destination
                let endIndex = itemToMove - 1
                var startOrder = notes[destination].order + 1
                let newOrder = notes[destination].order
                
                while startIndex <= endIndex {
                    notes[startIndex].order = startOrder
                    startOrder = startOrder + 1
                    startIndex = startIndex + 1
                }
                notes[itemToMove].order = newOrder
                
            }
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func scheduleNotification() {
        let notificationId = UUID()
        let content = UNMutableNotificationContent()
        content.body = "New notification \(notificationId)"
        content.sound = UNNotificationSound.default
        content.userInfo = [
            "notificationId": "\(notificationId)" // additional info to parse if need
        ]

        let trigger = UNCalendarNotificationTrigger(
                dateMatching: NotificationHelper.getTriggerDate()!,
                repeats: false
        )

        notificationManager.scheduleNotification(
                id: "\(notificationId)",
                content: content,
                trigger: trigger)
    }
}

struct ListView_Previews: PreviewProvider {

    static var previews: some View {
        ListView(notificationManager: NotificationManager()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
