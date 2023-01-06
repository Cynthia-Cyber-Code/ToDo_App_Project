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
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.order, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>

    @Binding var isAddPresented: Bool
    
    @State var title: String
    @State var description: String
    @State var date: Date
    @State var order: Int64
    @State var status: Status
//    @State var id: UUID
    @State var note: Note
    
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
                autosave(note: note)
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
    func autosave(note: Note) {
        withAnimation {
            let updateTitle = self.title
            let updateDesciption = self.description
            let updateStatus = self.status.rawValue
            let updateDateModified = self.date
            viewContext.performAndWait {
                note.title = updateTitle
                note.descriptif = updateDesciption
                note.status = updateStatus
                note.date = updateDateModified
                do {
                    try viewContext.save()
                    print("Note saved!")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ModifyView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyView(isAddPresented: .constant(true), title: "", description: "", date: Date.now, order: 0, status: Status.normal, note: Note())
    }
}
