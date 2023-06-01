//
//  NotificationHelper.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import Foundation
import SwiftUI
import UserNotifications

let notificationManager: NotificationManager  = NotificationManager()

class NotificationHelper {
    static func getTriggerDate(date: Date) -> DateComponents? {
        let triggerDate = date
        //Date().addingTimeInterval(5)
        return Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: triggerDate)
    }
}
