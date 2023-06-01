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


@MainActor class TaskViewModel: ObservableObject {
    let notificationManager = NotificationManager()
    
    @Published var note : Note = Note()
    
    init() {}
    
    func addTask(title: String, notes: FetchedResults<Note>, status: Status, date: Date, description: String, vc: NSManagedObjectContext) -> Note {
        withAnimation {
            let newNote = Note(context: vc)
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
                try vc.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return newNote
        }
    }
    
    func autosave(note: Note, title: String, status: Status, date: Date, description: String, viewContext: NSManagedObjectContext) {
        withAnimation {
            let updateTitle = title
            let updateDesciption = description
            let updateStatus = status
            let updateDateModified = date
            viewContext.performAndWait {
                note.title = updateTitle
                note.descriptif = updateDesciption
                note.status = updateStatus.rawValue
                note.date = updateDateModified
                do {
                    try viewContext.save()
                    print("Note saved!")
                } catch {
                    print(error.localizedDescription)
                }
            }
            return
        }
    }
    
    func autoBoolsave(note: Note, showFinish: Bool, showGreeting: Bool, viewContext: NSManagedObjectContext) {
        withAnimation {
        let updateFinsh = showFinish
        let updateNotif = showGreeting
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
    
    func deleteNotes(for offsets: IndexSet, notes: FetchedResults<Note>, viewContext: NSManagedObjectContext) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
            }
        }
    }
    
    func moveNotes(for offsets: IndexSet, destination: Int, notes: FetchedResults<Note>, viewContext: NSManagedObjectContext) {
        
        let itemToMove = offsets.first!
        withAnimation {
            if itemToMove < destination {
                var startIndex = itemToMove + 1
                let endIndex = destination - 1
                var startOrder = notes[itemToMove].order
                
                while startIndex <= endIndex {
                    notes[startIndex].order = startOrder
                    startOrder = startOrder + 1
                    startIndex = startIndex + 1
                }
                notes[itemToMove].order = startOrder
            } else if destination < itemToMove {
                var startIndex = destination
                let endIndex = itemToMove - 1
                var startOrder = notes[destination].order + 1
                let newOrder = notes[destination].order
                
                while startIndex <= endIndex {
                    notes[startIndex].order = startOrder
                    startOrder = startOrder + 1
                    startIndex = startIndex + 1
                }
                notes[itemToMove].order = newOrder
                
            }
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func scheduleNotification(title: String, date: Date) {
        let notificationId = UUID()
        let content = UNMutableNotificationContent()
        content.body = "\(title) at \(date.formatted(date: .abbreviated, time: .standard))"
        content.sound = UNNotificationSound.default
        content.userInfo = [
            "notificationId": "\(notificationId)"
        ]

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: NotificationHelper.getTriggerDate(date: date)!,
                repeats: false
        )

        notificationManager.scheduleNotification(
                id: "\(notificationId)",
                content: content,
                trigger: trigger)
    }
    func removePendingNotification(id: String) {
        let notificationId = id
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [notificationId])
        center.removePendingNotificationRequests(withIdentifiers: [notificationId])

        notificationManager.removePendingNotification(id: notificationId)
    }
}




//    // MARK: Notification func
//    func scheduleNotification(triggerDate: Date, taskContent: String, taskPriority: String) {
//        let notificationId = UUID()
//        let content = UNMutableNotificationContent()
//        if taskPriority == "exclamationmark.3" {
//            content.body = "‼️🧨 Priorité maximale: \n \(taskContent)"
//            content.sound = UNNotificationSound.defaultCritical
//        } else if taskPriority == "exclamationmark.2"  {
//            content.body = "‼️ Haute priorité: \n \(taskContent)"
//            content.sound = UNNotificationSound.defaultRingtone
//        } else if taskPriority == "exclamationmark"  {
//            content.body = "❗️ Attention: \(taskContent)"
//            content.sound = UNNotificationSound.default
//        } else if taskPriority == ""  {
//            content.body = "Rappel: \(taskContent)"
//            content.sound = UNNotificationSound.default
//        }
//
//        content.userInfo = [
//            "notificationId": "\(notificationId)" // additional info to parse if need
//        ]
//
//        let trigger = UNCalendarNotificationTrigger(
//            dateMatching: NotificationHelper.getTriggerDate(triggerDate: triggerDate)!,
//            repeats: false
//        )
//
//        notificationManager.scheduleNotification(
//            id: "\(notificationId)",
//            content: content,
//            trigger: trigger)
//
//    }


//class NoteVM: ObservableObject {
//    @Environment(\.managedObjectContext) var  viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Note.id, ascending: true)],
//        animation: .default)
//
//    var notes: FetchedResults<Note>
//    func addItem(title: String, status: String, date: Date, description: String) {
//        withAnimation {
//            let newNote = Note(context: viewContext)
//            newNote.timestamp = Date.now
//            newNote.title = title
//            newNote.status = status
//            newNote.date = date
//            newNote.descriptif = description
//            newNote.favoris = false
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    func deleteNotes(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { notes[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                print(nsError.localizedDescription)
//            }
//        }
//    }
//}


//    func autosave(note: Note) {
//        withAnimation {
//            let updateTitle = self.title
//            let updateDesciption = self.description
//            let updateStatus = self.status.rawValue
//            let updateDateModified = self.date
//            viewContext.performAndWait {
//                note.title = updateTitle
//                note.descriptif = updateDesciption
//                note.status = updateStatus
//                note.date = updateDateModified
//                do {
//                    try viewContext.save()
//                    print("Note saved!")
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }

//    func autosave(note: Note) {
//        withAnimation {
//        let updateFinsh = self.showFinish
//        let updateNotif = self.showGreeting
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


//    func deleteNotes(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { notes[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                print("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
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
//                var startOrder = notes[itemToMove].order
//
//                while startIndex <= endIndex {
//                    notes[startIndex].order = startOrder
//                    startOrder = startOrder + 1
//                    startIndex = startIndex + 1
//                }
//                notes[itemToMove].order = startOrder
//            } else if destination < itemToMove {
//                var startIndex = destination
//                let endIndex = itemToMove - 1
//                var startOrder = notes[destination].order + 1
//                let newOrder = notes[destination].order
//
//                while startIndex <= endIndex {
//                    notes[startIndex].order = startOrder
//                    startOrder = startOrder + 1
//                    startIndex = startIndex + 1
//                }
//                notes[itemToMove].order = newOrder
//
//            }
//            do {
//                try viewContext.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
