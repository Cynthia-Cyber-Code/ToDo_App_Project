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
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notes, id: \.self) { note in
                        ListView(title: note.title!, date: note.date!, status: note.status!, description: note.description, id: note.id ?? UUID(), order: note.order)
                    }
                    .onMove(perform: moveNotes)
                    .onDelete(perform: deleteNotes)
                }
                .padding(.top, 150.0)
                .listStyle(.sidebar)
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
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ListCardsView_Previews: PreviewProvider {

    static var previews: some View {
        ListCardsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
