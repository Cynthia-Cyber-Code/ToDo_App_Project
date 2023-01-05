//
//  ModifyView.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import SwiftUI

struct ModifyView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.id, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>

    @Binding var isAddPresented: Bool
    
    @State var title: String
    @State var description: String
    @State var date: Date
    @State var order: Int64
    @State var status: Status = .normal
    @State var id: UUID
    
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
    private func addNote() {
        withAnimation {
            let note = Note(context: viewContext)
            note.id = id
            note.timestamp = Date.now
            note.title = title
            note.order = order
            note.status = status.rawValue
            note.date = date
            note.descriptif = description
            note.favoris = false
            note.noteUser = String()
            note.updateName = String()
            note.updateTime = Date.now
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ModifyView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyView(isAddPresented: .constant(true), title: "", description: "", date: Date.now, order: 0, id: UUID())
    }
}
