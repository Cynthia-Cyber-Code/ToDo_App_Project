//
//  AddNoteView.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import SwiftUI
import CoreData

struct AddNoteView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>
//    @StateObject var noteVm: NoteVM = NoteVM()
    @Binding var isAddPresented: Bool
    
    @State var title: String = "Title"
    @State var description: String = "description"
    @State var date: Date = Date.now
    @State var status: Status = .encours
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("To-Do")
                    TextField(text: $title) {
                        Text("Titre")
                    }
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                }
                VStack {
                    Text("Description")
                    TextEditor(text: $description)
                        .lineLimit(2)
                        .frame(width: 300, height: 150)
                        .padding(.horizontal)
                        .border(.gray.opacity(0.5))
                }
                
                VStack {
                    DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute]) {
                        Text("Select a date")
                    }
                    Spacer()
                    
                    Text("finish the \(date.formatted(date: .abbreviated, time: .standard))")
                    
                    Spacer()
                }
            }
            
            Button {
                addNote()
//                noteVm.addItem(title: title, status: status.rawValue, date: date, description: description)
                isAddPresented.toggle()
            } label: {
                HStack{
                    Spacer()
                    Text("Ajouter")
                        .padding()
                        .frame(width: 300)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                }
            }
            .listStyle(.plain)
        }
    }
    func addNote() {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date.now
            newNote.title = title
            newNote.status = status.rawValue
            newNote.date = date
            newNote.descriptif = description
            newNote.favoris = false
            newNote.noteUser = String()
            newNote.updateName = String()
            newNote.updateTime = Date.now
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(isAddPresented: .constant(true))
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
