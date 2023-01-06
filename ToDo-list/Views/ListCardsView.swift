//
//  ContentView.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI
import CoreData


struct ListCardsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: Note.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Note.order, ascending: true)], animation: .default)
    
    var notes: FetchedResults<Note>
    @State var selectedTab: Tab = .all
    @Namespace var namespace
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        ForEach(Tab.allCases) { tab in
                            SelectButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                        }
                    }
                    .padding(.top, 150.0)
                    
                    if selectedTab == .all {
                        ForEach(notes, id: \.self) { note in
                            ListView(note: note)
                        }
                        .onMove(perform: moveNotes)
                        .onDelete(perform: deleteNotes)
                    } else if selectedTab == .end {
                        ForEach(notes) { note in
                            if note.favoris == true {
                                ListView(note: note)
                            }
                        }.onMove(perform: moveNotes)
                            .onDelete(perform: deleteNotes)
                    } else if selectedTab == .wait {
                        ForEach(notes) { note in
                            if (note.date! <= Date.now && note.favoris == false) {
                                ListView(note: note)
                            }
                        }.onMove(perform: moveNotes)
                            .onDelete(perform: deleteNotes)
                    } else if selectedTab == .late {
                        ForEach(notes) { note in
                            if note.date! > Date.now {
                                ListView( note: note)
                            }
                        }.onMove(perform: moveNotes)
                        .onDelete(perform: deleteNotes)
                    } else {
                        EmptyView()
                    }
                }.id(UUID()).padding()
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                           BarTitleView()
                    }
                }
                ButtonAdd()
                .navigationBarTitle("Tasks")
            }.ignoresSafeArea()
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
                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ListCardsView_Previews: PreviewProvider {

    static var previews: some View {
        ListCardsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ListCardsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
    }
}
