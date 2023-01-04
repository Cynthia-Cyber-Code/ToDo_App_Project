//
//  ContentView.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI
import CoreData
import MobileCoreServices

struct Item: Identifiable {
    let id = UUID()
    let title: String
}
struct ListView: View {
    @State var url_selection: Set<UUID> = []
    @State private var items: [Item] = []
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
                            DetailNote(notificationManager: NotificationManager(), title: note.title!, date: note.date!, description: note.descriptif!, order: note.order, id: note.id ?? UUID())
                        } label: {
                            VStack(alignment: .leading){
                                Text(note.title ?? "error")
                                Text("\(note.date!.formatted(date: .abbreviated, time: .standard))")
                            }
                        }
                    }
                    
                    .onMove(perform: moveNotes)
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
                }.navigationBarTitle("Tasks")
            }
        }
    }
    private func moveNotes(offsets: IndexSet, destination: Int) {
        
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
}

struct ListView_Previews: PreviewProvider {

    static var previews: some View {
        ListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
