//
//  ListStepsCheckMark.swift
//  ToDo-list
//
//  Created by Cynthia on 02/03/2023.
//

import Foundation
import SwiftUI
import CoreData

@MainActor class StepViewModel: ObservableObject {
    let notificationManager = NotificationManager()
    
    @Published var step : ListCheckMark = ListCheckMark()
    
    init() {}
    
    func addStep(content: String, lists: FetchedResults<ListCheckMark>, note: Note, viewContext: NSManagedObjectContext) -> ListCheckMark {
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
                }
                return newListCheckMark
            }
        }
    
    func deleteSteps(for offsets: IndexSet, lists: FetchedResults<ListCheckMark>, viewContext: NSManagedObjectContext) {
        withAnimation {
            offsets.map { lists[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
            }
        }
    }
    
    func moveNotes(for offsets: IndexSet, destination: Int, lists: FetchedResults<ListCheckMark>, viewContext: NSManagedObjectContext) {
        
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
}


//    func addList() {
//          withAnimation {
//              let newListCheckMark = ListCheckMark(context: viewContext)
//              newListCheckMark.message = content
//              if (lists.last == nil)
//              {
//                  newListCheckMark.order = 0
//              } else {
//                  newListCheckMark.order = lists.last!.order + 1
//              }
//              newListCheckMark.activeCheckMark = false
//              newListCheckMark.idTask = note.idNote
//              do {
//                  try viewContext.save()
//              } catch {
//                  let nsError = error as NSError
//                  print(nsError.localizedDescription)
//              }
//          }
//      }
//    func autosave(note: Note, title: String, status: Status, date: Date, description: String, viewContext: NSManagedObjectContext) {
//        withAnimation {
//            let updateTitle = title
//            let updateDesciption = description
//            let updateStatus = status
//            let updateDateModified = date
//            viewContext.performAndWait {
//                note.title = updateTitle
//                note.descriptif = updateDesciption
//                note.status = updateStatus.rawValue
//                note.date = updateDateModified
//                do {
//                    try viewContext.save()
//                    print("Note saved!")
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//            return
//        }
//    }
    
//    func autoBoolsave(note: Note, showFinish: Bool, showGreeting: Bool, viewContext: NSManagedObjectContext) {
//        withAnimation {
//        let updateFinsh = showFinish
//        let updateNotif = showGreeting
//            viewContext.performAndWait {
//                note.favoris = updateFinsh
//                note.notif = updateNotif
//                do {
//                    guard viewContext.hasChanges else { return }
//                    try viewContext.save()
//                    print("Note saved!")
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//    private func moveNotes(offsets: IndexSet, destination: Int) {
//
//        let itemToMove = offsets.first!
//        withAnimation {
//            if itemToMove < destination {
//                var startIndex = itemToMove + 1
//                let endIndex = destination - 1
//                var startOrder = lists[itemToMove].order
//
//                while startIndex <= endIndex {
//                    lists[startIndex].order = startOrder
//                    startOrder = startOrder + 1
//                    startIndex = startIndex + 1
//                }
//                lists[itemToMove].order = startOrder
//            } else if destination < itemToMove {
//                var startIndex = destination
//                let endIndex = itemToMove - 1
//                var startOrder = lists[destination].order + 1
//                let newOrder = lists[destination].order
//
//                while startIndex <= endIndex {
//                    lists[startIndex].order = startOrder
//                    startOrder = startOrder + 1
//                    startIndex = startIndex + 1
//                }
//                lists[itemToMove].order = newOrder
//
//            }
//            do {
//                try viewContext.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    private func deleteNotes(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { lists[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
//            }
//        }
//    }
