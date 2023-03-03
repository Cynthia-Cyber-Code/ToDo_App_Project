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
    
    @ObservedObject var noteVM = TaskViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.order, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>

    @Binding var isAddPresented: Bool
    
    @State var title: String = ""
    @State var description: String = ""
    @State private var content: String = ""
    @State var date: Date = Date.now
    @State var color: Color = .gray
    @State var status: Status = .normal
    @State var agreedToTerms = false
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("To-Do")
                    TextField(text: $title) {
                        Text("Titre")
                    }.padding()
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
                    }.accessibilityIdentifier("DatePicker")
                    Spacer()
                    
                    Text("finish the \(date.formatted(date: .abbreviated, time: .standard))")
                    
                    Spacer()
                }
                VStack(alignment: .center) {
                    Text("select order priority ").padding()
                    Spacer()
                    Picker("Priority", selection: $status) {
                        ForEach(Status.allCases, id: \.self) { status in
                            Image(systemName: status.rawValue)
                        }
                    }
                    .padding()
                    .frame(width: 200, height: 60)
                    .pickerStyle(SegmentedPickerStyle())
                    .scaledToFit()
                    .scaleEffect(CGSize(width: 2, height: 2))
                    if (status.rawValue == "clock.badge.exclamationmark.fill") {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Priority").fontWeight(.semibold)
                            Spacer()
                        }.padding()
                    } else {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Normal").fontWeight(.semibold)
                            Spacer()
                        }.padding()
                    }
                }.padding()
                
//                HStack {
//                    TextField("Add a step", text: $content)
//                        .padding()
//                        .frame(width: 270, height: 50)
//                        .background(Color(.black).opacity(0.05))
//                        .cornerRadius(15)
//                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).foregroundColor(Color.black.opacity(0.3)))
//                        .textInputAutocapitalization(.never)
//                        .disableAutocorrection(true)
//                    Button {
//                        addList()
//                    } label: {
//                        Image(systemName: "square.and.arrow.down.fill")
//                            .padding()
//                            .background(Color(.orange).opacity(0.9).cornerRadius(15))
//                            .foregroundColor(Color.white)
//                    }
//                }
//                if (lists.last != nil) {
//                    List {
//                        ForEach(lists, id: \.self) {
//                            checkMark in
//                            if Note(context: viewContext).idNote == checkMark.idTask {
//                                HStack {
//                                    Image(systemName: checkMark.activeCheckMark ? "checkmark.square.fill" : "square").font(.title)
//                                        .foregroundColor(checkMark.activeCheckMark ? Color(.orange) : Color.secondary)
//                                        .onTapGesture {
//                                            checkMark.activeCheckMark.toggle()
//                                        }
//                                    Text(checkMark.message!)
//                                }
//                            }
//                        }.onMove(perform: moveNotes)
//                        .onDelete(perform: deleteNotes)
//                    }
//                } else {
//                    Text("No Step Add").font(.title).foregroundColor(.gray)
//                }
            }
            Button {
                if (title == "" || description == "" || date == Date() || status.rawValue == ""){
//                    color = .gray
                } else {
//                    color = .orange
                    noteVM.note = noteVM.addTask(title: title, notes: notes, status: status, date: date, description: description, vc: viewContext)
                    isAddPresented.toggle()
                }
            } label: {
                HStack{
                    Spacer()
                    Text("Ajout")
                        .bold()
                        .padding()
                        .frame(width: 300)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(titleIsValid ? Color.orange : Color.gray))
                    Spacer()
                }.disabled(!titleIsValid).padding()
            }
            .listStyle(.plain)
        }
    }
    var titleIsValid: Bool {
            return !title.isEmpty
    }

    var buttonColor: Color {
        return titleIsValid ? .accentColor : .gray
    }

    func sendMessage() {
        title = ""
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(isAddPresented: .constant(true))
    }
}
