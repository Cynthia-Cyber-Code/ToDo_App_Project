//
//  DetailNote.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI
import CoreData

struct DetailNote: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(entity: ListCheckMark.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ListCheckMark.id_message, ascending: true), NSSortDescriptor(keyPath: \ListCheckMark.order, ascending: true)], animation: .default)
    var lists: FetchedResults<ListCheckMark>
    
    @State var isAddPresented = false
    @State var note: Note
    @State private var content: String = ""
    
    @State var showGreeting: Bool
    
    @State var showFinish: Bool
    
    @ObservedObject var noteVM = TaskViewModel()
    @ObservedObject var stepVM = StepViewModel()
    
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 20).frame(minHeight: 50, maxHeight: 200).foregroundColor(.orange.opacity(0.5))
                VStack {
                    Toggle("Finish", isOn: $showFinish)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: showFinish) { value in
                            print("showfinish \(value)")
                            if (showFinish == false) {
                                note.idNotif = noteVM.scheduleNotification(title: note.title!, date: note.date!)
                            } else {
                                noteVM.removePendingNotification(id: note.idNotif!)
                            }
                            noteVM.autoBoolsave(note: note, showFinish: showFinish, showGreeting: false, viewContext: viewContext)
                            print(note.favoris)
                        }.padding()
                        .font(.title)
                    
                    
                    Text("Notification will appear in \((note.date!).formatted(date: .abbreviated, time: .shortened))")
                    if (note.date! < Date.now || note.favoris == true) {
                        
                    } else {
                        Toggle("Schedule notification", isOn: $showGreeting).toggleStyle(SwitchToggleStyle(tint: .orange))
                            .onChange(of: showGreeting) { value in
                                if (showGreeting == true ) {
                                    note.idNotif = noteVM.scheduleNotification(title: note.title!, date: note.date!)
                                    print(value)
                                } else {
                                    noteVM.removePendingNotification(id: note.idNotif!)
                                    print(value)
                                }
                                print(value)
                                noteVM.autoBoolsave(note: note, showFinish: showFinish, showGreeting: showGreeting, viewContext: viewContext)
                            }.padding()
                    }
                    
                }
            }
            HStack {
                Text(note.title!)
                Spacer()
                Button {
                    isAddPresented.toggle()
                } label: {
                    ZStack {
                        Circle().foregroundColor(.orange).frame(width: 50, height: 50)
                        Image(systemName: "rectangle.and.pencil.and.ellipsis").font(.body).foregroundColor(.white)
                    }
                }.sheet(isPresented: $isAddPresented) {
                    ModifyView(isAddPresented: $isAddPresented, title: note.title!, description: note.descriptif!, date: note.date!, order: note.order, status: Status(rawValue: note.status!) ?? .normal, note: note)
                }
            }.padding()
            Text(note.descriptif!)
            Spacer()
            HStack {
                TextField("Add a step", text: $content)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(colorScheme == .dark ? .white : .black).opacity(0.1))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.1).foregroundColor(colorScheme == .dark ? .white : .black))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                Button {
                    stepVM.step = stepVM.addStep(content: content, lists: lists, note: note, viewContext: viewContext)
                } label: {
                    Image(systemName: "square.and.arrow.down.fill")
                        .padding()
                        .background(Color(.orange).opacity(0.9).cornerRadius(15))
                        .foregroundColor(Color.white)
                }
            }
            if (lists.last != nil) {
                List {
                    ForEach(lists, id: \.self) {
                        checkMark in
                        if note.idNote == checkMark.idTask {
                            HStack {
                                Image(systemName: checkMark.activeCheckMark ? "checkmark.square.fill" : "square").font(.title)
                                    .foregroundColor(checkMark.activeCheckMark ? Color(.orange) : Color.secondary)
                                    .onTapGesture {
                                        checkMark.activeCheckMark.toggle()
                                    }
                                Text(checkMark.message!)
                            }
                        }
                    }.onMove(perform: { indexSet,arg  in
                        stepVM.moveNotes(for: indexSet, destination: arg, lists: lists, viewContext: viewContext)
                    })
                    .onDelete(perform: { indexSet in
                        stepVM.deleteSteps(for: indexSet, lists: lists, viewContext: viewContext)
                    })
                }
            } else {
                Text("No Step Add").font(.title).foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left.circle")
                            Text("Tasks")
                        }.foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Spacer()
                    Text(note.title!)
                    Spacer()
                    Spacer()
                    ShareLink(item: note.title!, preview: SharePreview(Text("\(note.title!) \(note.date!.formatted(date: .abbreviated, time: .shortened)) "))) {
                        Text("Share").foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
        }
    }
}

//struct DetailNote_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailNote(note: Note(), showGreeting: false, showFinish: false).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
//    }
//}
