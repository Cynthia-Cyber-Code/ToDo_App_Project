//
//  NoteVM.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import Foundation
import SwiftUI
import CoreData

enum Status: String, CaseIterable {
    case priority = "clock.badge.exclamationmark.fill"
    case normal = "clock.badge.checkmark.fill"
}

class NoteVM: ObservableObject {
    @Environment(\.managedObjectContext) var  viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.id, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>
    func addItem(title: String, status: String, date: Date, description: String) {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date.now
            newNote.title = title
            newNote.status = status
            newNote.date = date
            newNote.descriptif = description
            newNote.favoris = false
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print(nsError.localizedDescription)
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
 
            configuration.label
 
            Spacer()
 
            Image(systemName: configuration.isOn ? "checkmark.square" : "circle")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(configuration.isOn ? .orange : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
 
    }
}
