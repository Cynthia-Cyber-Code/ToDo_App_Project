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
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentCloudKitContainer
//    let options = NSPersistentCloudKitContainerSchemaInitializationOptions()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ToDo_list")
//        try? container.initializeCloudKitSchema(options: options)
//                container = NSPersistentCloudKitContainer(name: "ToDo_list")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}

