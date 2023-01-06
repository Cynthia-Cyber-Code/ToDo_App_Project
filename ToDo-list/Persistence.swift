//
//  Persistence.swift
//  ToDo-list
//
//  Created by Cynthia on 03/01/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
        let newNote = Note(context: viewContext)
        newNote.idNote = UUID().uuidString
        newNote.timestamp = Date()
        newNote.title = "First task"
        newNote.order = 0
        newNote.status = "normal"
        newNote.date = Date.now
        newNote.descriptif = "description"
        newNote.favoris = false
        newNote.notif = false
        
        let newList = ListCheckMark(context: viewContext)
        newList.id_message = UUID()
        newList.idTask = UUID().uuidString
        newList.activeCheckMark = false
        newList.message = ""
        
        
//        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDo_list")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

