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
    @ObservedObject var noteVM = TaskViewModel()
    @State var selectedTab: Tab = .all
    @Namespace var namespace
    var body: some View {
        NavigationStack {
            VStack {
                    HStack {
                        ForEach(Tab.allCases) { tab in
                            SelectButton(tab: tab, selectedTab: $selectedTab, namespace: namespace).frame(height: 70)
                                .shadow(radius: 30)
                        }
                    }
                    .padding(.top, 150.0)
                List {
                    if selectedTab == .all {
                        ForEach(notes, id:\.self) { note in
                            ListView(note: note)
                        }
                        .onMove(perform: { indexSetMove,arg   in
                            noteVM.moveNotes(for: indexSetMove, destination: arg, notes: notes, viewContext: viewContext)
                        })
                        .onDelete(perform: { indexSet in
                            noteVM.deleteNotes(for: indexSet, notes: notes, viewContext: viewContext)
                        })
                    } else if selectedTab == .end {
                        ForEach(notes) { note in
                            if note.favoris == true {
                                ListView(note: note)
                            }
                        }.onMove(perform: { indexSetMove,arg  in
                            noteVM.moveNotes(for: indexSetMove, destination: arg, notes: notes, viewContext: viewContext)
                        })
                            .onDelete(perform: { indexSet in
                                noteVM.deleteNotes(for: indexSet, notes: notes, viewContext: viewContext)
                            })
                    } else if selectedTab == .wait {
                        ForEach(notes) { note in
                            if (note.favoris == false) {
                                ListView(note: note)
                            }
                        }.onMove(perform: { indexSet,arg  in
                            noteVM.moveNotes(for: indexSet, destination: arg, notes: notes, viewContext: viewContext)
                        })
                            .onDelete(perform: { indexSet in
                                noteVM.deleteNotes(for: indexSet, notes: notes, viewContext: viewContext)
                            })
                    }
                    
                }.id(UUID().uuidString).padding()
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        BarTitleView()
                    }
                }
                ButtonAdd()
            }
            .navigationBarTitle("Tasks")
            .ignoresSafeArea()
        }
    }
}

struct ListCardsView_Previews: PreviewProvider {

    static var previews: some View {
        ListCardsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ListCardsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
    }
}
