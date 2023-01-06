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
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.order, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>

    @Binding var isAddPresented: Bool
    
    @State var title: String = "Title"
    @State var description: String = "description"
    @State var date: Date = Date.now
    @State var status: Status = .normal
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
                    DatePicker(selection: $date, in: Date.now..., displayedComponents: [.date, .hourAndMinute]) {
                        Text("Select a date")
                    }
                    Spacer()
                    
                    Text("finish the \(date.formatted(date: .abbreviated, time: .standard))")
                    
                    Spacer()
                }
                VStack(alignment: .center) {
                    Text("select order priority ").padding(.leading, 60)
                    Spacer()
                    Picker("Priority", selection: $status) {
                        ForEach(Status.allCases, id: \.self) { status in
                            Image(systemName: status.rawValue)
                        }
                    }
                    .padding(.leading, 35)
                    .frame(width: 200, height: 60)
                    .pickerStyle(SegmentedPickerStyle())
                    .scaledToFit()
                    .scaleEffect(CGSize(width: 2, height: 2))
                }.padding()
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
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date.now
            newNote.title = title
            if (notes.last == nil)
            {
                newNote.order = 0
            } else {
                newNote.order = notes.last!.order + 1
            }
            newNote.status = status.rawValue
            newNote.date = date
            newNote.descriptif = description
            newNote.favoris = false
            newNote.notif = false
            newNote.idNote = UUID().uuidString
            
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

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(isAddPresented: .constant(true))
    }
}
