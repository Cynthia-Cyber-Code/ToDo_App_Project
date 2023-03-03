//
//  ToDo_listUITests.swift
//  ToDo-listUITests
//
//  Created by Cynthia on 01/03/2023.
//

import XCTest

final class ToDo_listUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testInitialPage() throws {
        let app = XCUIApplication()
        // 1 - Define UI Elements
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        let navBarFirstTitle = tasksNavigationBar/*@START_MENU_TOKEN@*/.staticTexts[" To-Do list"]/*[[".staticTexts.matching(identifier: \"Tasks\")",".staticTexts[\" To-Do list\"]",".staticTexts[\"elementAtester \"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/
        let navBarEditButton = tasksNavigationBar/*@START_MENU_TOKEN@*/.buttons["Edit"]/*[[".staticTexts.matching(identifier: \"Tasks\")",".buttons[\"Edit\"]",".buttons[\"elementAtester \"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/
        let allButton = app.buttons["ALL"]
        let backButton = app.buttons["Revenir En Arrière"]
        let selectButtons = app.buttons["Supprimer Du Calendrier"]
        
        let list = app.collectionViews.element
        app.launch()
        
        let initialListRows = list.cells.count
        
        // 2 - Check if UI exits
        XCTAssert(tasksNavigationBar.exists)
        XCTAssert(navBarFirstTitle.exists)
        XCTAssert(navBarEditButton.exists)
        XCTAssert(allButton.exists)
        XCTAssert(backButton.exists)
        XCTAssert(selectButtons.exists)

        XCTAssert(list.exists)
        print("count: \(initialListRows)")
//        XCTAssert(initialListRows == 0)
        
        // 3 - Check if UI label is correct
        navBarEditButton.tap()
        allButton.tap()
        backButton.tap()
        selectButtons.tap()
        
        
    }
    
    func testAddButton() throws {
        
        let app = XCUIApplication()
        let addButtonModal = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 3)
        
        app.launch()
        
        XCTAssert(addButtonModal.exists)
        
        addButtonModal.tap()
        
        let formAddNote = app.collectionViews
        let toDo = formAddNote/*@START_MENU_TOKEN@*/.staticTexts["To-Do"]/*[[".cells.staticTexts[\"To-Do\"]",".staticTexts[\"To-Do\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let placeholderTitle = formAddNote/*@START_MENU_TOKEN@*/.textFields["Titre"]/*[[".cells.textFields[\"Titre\"]",".textFields[\"Titre\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let description = formAddNote/*@START_MENU_TOKEN@*/.staticTexts["Description"]/*[[".cells.staticTexts[\"Description\"]",".staticTexts[\"Description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let placeholderDescription = formAddNote.children(matching: .cell).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        let date = app.collectionViews/*@START_MENU_TOKEN@*/.cells.staticTexts["Select a date"]/*[[".cells.staticTexts[\"Select a date\"]",".staticTexts[\"Select a date\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        
        let changeDate = app.datePickers["DatePicker"]
         
        XCTAssert(toDo.exists)
        XCTAssert(placeholderTitle.exists)
        XCTAssert(description.exists)
        XCTAssert(placeholderDescription.exists)
        XCTAssert(date.exists)
//        XCTAssert(changeDate.exists)
        
        placeholderTitle.tap()
        placeholderTitle.typeText("First Task")
        XCTAssert(placeholderTitle.waitForExistence(timeout: 5))
        XCTAssert(placeholderTitle.exists)
        
        app.keyboards.buttons["retour"].tap()
        
        placeholderDescription.tap()
        placeholderDescription.typeText("Detail Description")
        XCTAssert(placeholderDescription.waitForExistence(timeout: 5))
        XCTAssert(placeholderDescription.exists)
        
        app.keyboards.buttons["retour"].tap()
        
        let element = formAddNote.children(matching: .cell).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .other).element
        element.swipeUp()
        
        changeDate.forceTap()
        
        let exitDate = formAddNote.children(matching: .cell).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .other).element
        exitDate.tap()
                
        let AddButton = app.buttons["Ajout"]
        XCTAssert(AddButton.exists)
        
        AddButton.tap()
        
        let list = app.collectionViews.element
        let initialListRows = list.cells.count
        
        XCTAssert(list.exists)
        XCTAssert(initialListRows == 1)
    }
    
    func testDetailNote() throws {
        
        let app = XCUIApplication()
        let collection = app.collectionViews
        let date = collection.cells.element(boundBy: 0)
        let share = app.navigationBars.buttons["Share"]
        let dismissShare = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.button, identifier:"XCElementSnapshotPrivilegedValuePlaceholder").element/*[[".otherElements[\"ActivityListView\"].collectionViews.containing(.button, identifier:\"XCElementSnapshotPrivilegedValuePlaceholder\").element",".collectionViews.containing(.button, identifier:\"XCElementSnapshotPrivilegedValuePlaceholder\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let modify = app.buttons["Remplissage Automatique"]
        let title = app.staticTexts["First Task"]
        let description = app.staticTexts["Detail Description\n"]
        
        let swipeModify = collection.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element
        
//       let textFieldStep = app.textFields["Add a step"]
        
        app.launch()
        XCTAssert(date.exists)
        date.tap()
        
        XCTAssert(share.exists)
        share.tap()
        XCTAssert(dismissShare.exists)
        dismissShare.swipeDown()
        
        XCTAssert(title.exists)
        XCTAssert(description.exists)
        
        XCTAssert(modify.exists)
        modify.swipeDown()
        
        XCTAssert(swipeModify.exists)
        swipeModify.swipeDown()
        
        app.textFields["Add a step"].firstMatch.tap()
    }
    
    func testMoveAndDeleteNote() throws {
        
        let app = XCUIApplication()
        let tasksNavigationBar = app.navigationBars["Tasks"]
        
        app.launch()
        
        tasksNavigationBar/*@START_MENU_TOKEN@*/.buttons["Edit"]/*[[".staticTexts.matching(identifier: \"Tasks\")",".buttons[\"Edit\"]",".buttons[\"elementAtester \"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        let collection = app.collectionViews
        let reorderButton = collection/*@START_MENU_TOKEN@*/.buttons["Reorder"]/*[[".cells.buttons[\"Reorder\"]",".buttons[\"Reorder\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        reorderButton.swipeDown()
        reorderButton.swipeUp()
        collection.cells.otherElements.containing(.image, identifier:"remove").element.tap()
        collection.buttons["Delete"].tap()
        tasksNavigationBar/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".staticTexts.matching(identifier: \"Tasks\")",".buttons[\"Done\"]",".buttons[\"elementAtester \"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    func forceTap() {
        if (isHittable) {
            tap()
        } else {
            coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()
        }
    }
}
