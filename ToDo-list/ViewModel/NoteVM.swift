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
        removePendingNotification(id: note.idNotif ?? "")
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
                note.idNotif = scheduleNotification(title: title, date: date)
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
            let items = offsets.map{ notes[$0] }
                print(items.first?.idNotif ?? "")
            items.forEach { item in
                removePendingNotification(id: item.idNotif ?? "")
            }
            print(items.first?.idNotif ?? "")
            items.forEach(viewContext.delete)
            
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
    func scheduleNotification(title: String, date: Date) -> String{
        let notificationId = UUID().uuidString
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
        return notificationId
    }
    func removePendingNotification(id: String) {
        let notificationId = id
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [notificationId])
        center.removePendingNotificationRequests(withIdentifiers: [notificationId])

        notificationManager.removePendingNotification(id: notificationId)
    }
}
