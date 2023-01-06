//
//  DetailNote.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI

struct DetailNote: View {
    @Environment(\.managedObjectContext) var viewContext
       
    @FetchRequest(entity: ListCheckMark.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \ListCheckMark.id_message, ascending: true), NSSortDescriptor(keyPath: \ListCheckMark.order, ascending: true)], animation: .default)
    var lists: FetchedResults<ListCheckMark>
    
    @State var isAddPresented = false
//    @State var id : String
    @State var note: Note
    @State private var content: String = ""
    
    @State var showGreeting: Bool
    
    @State var showFinish: Bool
    
    
    var body: some View {
        VStack {
            List {
                Toggle("Finish", isOn: $showFinish)
                    .toggleStyle(CheckboxStyle())
                    .onChange(of: showFinish) { value in
                        print(value)
                        autosave(note: note)
                        print(note.favoris)
                    }.padding()
                    .font(.title)
                
                
                VStack {
                    Text("Notification will appear in \(note.date!.formatted(date: .abbreviated, time: .shortened))")
                    Toggle("Schedule notification", isOn: $showGreeting).toggleStyle(SwitchToggleStyle(tint: .orange))
                        .onChange(of: showGreeting) { value in
                            print(value)
                            scheduleNotification(title: note.title!, date: note.date!)
                            autosave(note: note)
                        }
                }
            }
            Spacer()
            HStack {
                TextField("Add a step", text: $content)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(.black).opacity(0.05))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).foregroundColor(Color.black.opacity(0.3)))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                Button {
                    addList()
                } label: {
                    Image(systemName: "square.and.arrow.down.fill")
                        .padding()
                        .background(Color(.orange).opacity(0.9).cornerRadius(15))
                        .foregroundColor(Color.white)
                }
            }
            HStack {
                Text(note.title!).font(.title)
                Spacer()
                Button {
                    isAddPresented.toggle()
                } label: {
                    ZStack {
                        Circle().foregroundColor(.orange).frame(width: 70, height: 70)
                        Image(systemName: "rectangle.and.pencil.and.ellipsis").font(.title).foregroundColor(.white)
                    }
                }.sheet(isPresented: $isAddPresented) {
                    ModifyView(isAddPresented: $isAddPresented, title: note.title!, description: note.descriptif!, date: note.date!, order: note.order, status: Status(rawValue: note.status!) ?? .normal, note: note)
                }
            }.padding()
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
                    }.onMove(perform: moveNotes)
                        .onDelete(perform: deleteNotes)
                }
            } else {
                Text("No Step Add").font(.title).foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ShareLink(item: note.title!, preview: SharePreview(note.title!))
                }
        }
    }
    private func autosave(note: Note) {
        withAnimation {
        let updateFinsh = self.showFinish
        let updateNotif = self.showGreeting
            viewContext.performAndWait {
                note.favoris = updateFinsh
                note.notif = updateNotif
                do {
                    guard viewContext.hasChanges else { return }
                    try viewContext.save()
                    print("Note saved!")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    private func moveNotes(offsets: IndexSet, destination: Int) {
        
        let itemToMove = offsets.first!
        withAnimation {
            if itemToMove < destination {
                var startIndex = itemToMove + 1
                let endIndex = destination - 1
                var startOrder = lists[itemToMove].order
                
                while startIndex <= endIndex {
                    lists[startIndex].order = startOrder
                    startOrder = startOrder + 1
                    startIndex = startIndex + 1
                }
                lists[itemToMove].order = startOrder
            } else if destination < itemToMove {
                var startIndex = destination
                let endIndex = itemToMove - 1
                var startOrder = lists[destination].order + 1
                let newOrder = lists[destination].order
                
                while startIndex <= endIndex {
                    lists[startIndex].order = startOrder
                    startOrder = startOrder + 1
                    startIndex = startIndex + 1
                }
                lists[itemToMove].order = newOrder
                
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
            offsets.map { lists[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func addList() {
          withAnimation {
              let newListCheckMark = ListCheckMark(context: viewContext)
              newListCheckMark.message = content
              if (lists.last == nil)
              {
                  newListCheckMark.order = 0
              } else {
                  newListCheckMark.order = lists.last!.order + 1
              }
              newListCheckMark.activeCheckMark = false
              newListCheckMark.idTask = note.idNote
              do {
                  try viewContext.save()
              } catch {
                  let nsError = error as NSError
                  print(nsError.localizedDescription)
//                  fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
              }
          }
      }
}

//struct DetailNote_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailNote(note: Note(), showGreeting: true, showFinish: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
//    }
//}
