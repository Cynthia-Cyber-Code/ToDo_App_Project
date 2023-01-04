//
//  ContentView.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) private var  viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
  var notes: FetchedResults<Note>
    
    @State var isAddPresented = false

    var body: some View {
        NavigationView {
            List {
                ForEach(notes, id: \.self) { note in
                    NavigationLink {
                        DetailNote(title: note.title!)
                    } label: {
                        VStack{
                            Text(note.title ?? "error")
                            Text(note.descriptif ?? "error")
                        }
                    }
                }
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
