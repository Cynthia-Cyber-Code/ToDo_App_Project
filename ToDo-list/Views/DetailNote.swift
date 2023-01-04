//
//  DetailNote.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI

struct DetailNote: View {
    let notificationManager: NotificationManager
    @State var title: String
    @State var date: Date
    @State var description: String
    @State var order: Int64
    @State var id: UUID
    @State var isAddPresented = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                isAddPresented.toggle()
            } label: {
                Image(systemName: "pencil").font(.largeTitle).foregroundColor(.black)
            }.sheet(isPresented: $isAddPresented) {
                ModifyView(isAddPresented: $isAddPresented, title: title, description: description, date: date, order: order, id: id)
            }
            Text(title)
            ShareLink(item: title, preview: SharePreview(title))
            VStack {
                Text("Notification will appear in \(date.formatted(date: .abbreviated, time: .standard))")
                Button {
                    scheduleNotification(title: title, date: date)
                } label: {
                    Text("Schedule notification")
                }
                .padding()
            }
            
        }
        .padding(.horizontal)
        
    }
    private func scheduleNotification(title: String, date: Date) {
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
}

struct DetailNote_Previews: PreviewProvider {
    static var previews: some View {
        DetailNote(notificationManager: NotificationManager(), title: "", date: Date.now, description: "", order: 0, id: UUID())
    }
}
