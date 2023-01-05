//
//  ToDo_listApp.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import SwiftUI

@main
struct ToDo_listApp: App {
    private let notificationManager = NotificationManager()

    init() {

        setupNotifications()
    }
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListCardsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    private func setupNotifications() {
        notificationManager.notificationCenter.delegate = notificationManager
        notificationManager.handleNotification = handleNotification

        requestNotificationsPermission()
    }

    private func handleNotification(notification: UNNotification) {
        print("<<<DEV>>> Notification received: \(notification.request.content.userInfo)")
    }

    private func requestNotificationsPermission() {
        notificationManager.requestPermission(completionHandler: { isGranted, error in
            if isGranted {
                // handle granted success
            }

            if let _ = error {
                // handle error

                return
            }
        })
    }
}
