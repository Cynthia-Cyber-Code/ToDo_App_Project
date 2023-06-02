//
//  ToDo_listTestsUnits.swift
//  ToDo-listTestsUnits
//
//  Created by Cynthia on 01/03/2023.
//

import XCTest
import CoreData
import SwiftUI
@testable import ToDo_list

final class ToDo_listTestsUnits: XCTestCase {
    let viewContext = PersistenceController(inMemory: true).container.viewContext
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Note.order, ascending: true)], animation: .default)
    
    var notes: FetchedResults<Note>
    @ObservedObject var viewModel = TaskViewModel()

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testAddNotesCoreData() throws {
        let title = "Title"
        let date = Date.now
        let content = "Test description 1"

        let task = viewModel.addTask(title: title, notes: notes, status: Status.priority, date: date, description: content, vc: viewContext)

        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.status, Status.priority.rawValue)
        XCTAssertEqual(task.date, date)
        XCTAssertEqual(task.descriptif, content)

        print("success task: \(task) \(notes.count)")
    }

    func testMoveNotesCoreData() throws {
        
    }
    
    func testDeleteNotesCoreData() throws {
        
    }
    
    func testModifyNotesCoreData() throws {
        let title = "Title"
        let date = Date.now
        let content = "Test description 1"

        let task = viewModel.addTask(title: title, notes: notes, status: Status.priority, date: date, description: content, vc: viewContext)

        XCTAssertEqual(task.title, title)
        XCTAssertEqual(task.status, Status.priority.rawValue)
        XCTAssertEqual(task.date, date)
        XCTAssertEqual(task.descriptif, content)

        print("success task: \(task)")

        let newTitle = "Title 2"
        let newDate = Date.now
        let newContent = "Test description 2"

        viewModel.autosave(note: task, title: newTitle, status: Status.priority, date: newDate, description: newContent, viewContext: viewContext)

        XCTAssertEqual(task.title, newTitle)
        XCTAssertEqual(task.status, Status.priority.rawValue)
        XCTAssertEqual(task.date, newDate)
        XCTAssertEqual(task.descriptif, newContent)

        print("success task: \(task)")
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            let task = viewModel.addTask(title: "Title", notes: notes, status: Status.priority, date: Date.now, description: "Content", vc: viewContext)
            
            let newTitle = "Title 2"
            let newDate = Date.now
            let newContent = "Test description 2"

            viewModel.autosave(note: task, title: newTitle, status: Status.priority, date: newDate, description: newContent, viewContext: viewContext)
        }
    }

}
