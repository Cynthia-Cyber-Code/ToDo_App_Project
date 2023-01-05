//
//  NoteModel.swift
//  ToDo-list
//
//  Created by Cynthia on 04/01/2023.
//

import Foundation
import CoreData

struct NoteModel: Identifiable {
    
    private var task: Note
    
    init(task: Note) {
        self.task = task
    }
    var id: NSManagedObjectID {
        task.objectID
    }
    var status: Status {
        Status(rawValue: task.status!) ?? .normal
    }
    var title: String {
        task.title!
    }
}

extension NoteModel {
    init?(taskID: NSManagedObjectID, context: NSManagedObjectContext) {
        do {
            guard let task = try context.existingObject(with: taskID) as? Note else { return nil }
            self.task = task
        } catch {
            return nil
        }
    }
}
