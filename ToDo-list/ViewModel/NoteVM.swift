//
//  NoteVM.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import Foundation
import SwiftUI
import CoreData

let notificationManager: NotificationManager  = NotificationManager()

enum Status: String, CaseIterable {
    case priority = "clock.badge.exclamationmark.fill"
    case normal = "clock.badge.checkmark.fill"
}

class NoteVM: ObservableObject {
    @Environment(\.managedObjectContext) var  viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true), NSSortDescriptor(keyPath: \Note.title, ascending: true), NSSortDescriptor(keyPath: \Note.descriptif, ascending: true), NSSortDescriptor(keyPath: \Note.status, ascending: true), NSSortDescriptor(keyPath: \Note.favoris, ascending: true)],
        animation: .default)
    
    var notes: FetchedResults<Note>
    func addItem(title: String, status: String, date: Date, description: String) {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date.now
            newNote.title = title
            newNote.status = status
            newNote.date = date
            newNote.descriptif = description
            newNote.favoris = false
            newNote.noteUser = String()
            newNote.updateName = String()
            newNote.updateTime = Date.now
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
