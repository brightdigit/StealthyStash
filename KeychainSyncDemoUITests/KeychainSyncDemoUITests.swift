//
//  KeychainSyncDemoUITests.swift
//  KeychainSyncDemoUITests
//
//  Created by Leo Dion on 3/7/23.
//

import XCTest

final class KeychainSyncDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
      app.navigationBars["Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let collectionViewsQuery2 = app.collectionViews
      collectionViewsQuery2/*@START_MENU_TOKEN@*/.textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let textView = collectionViewsQuery2.children(matching: .cell).element(boundBy: 3).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
      textView.tap()
      textView.tap()
      collectionViewsQuery2.children(matching: .cell).element(boundBy: 8).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.swipeUp()
      
      let collectionViewsQuery = app.collectionViews
      collectionViewsQuery/*@START_MENU_TOKEN@*/.switches["Is Syncronizable"]/*[[".cells.switches[\"Is Syncronizable\"]",".switches[\"Is Syncronizable\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
      
      let setTypeSwitch = collectionViewsQuery/*@START_MENU_TOKEN@*/.switches["Set Type"]/*[[".cells.switches[\"Set Type\"]",".switches[\"Set Type\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      setTypeSwitch.tap()
      setTypeSwitch.tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.steppers["0"]/*[[".cells.steppers[\"0\"]",".steppers[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.steppers["1"]/*[[".cells.steppers[\"1\"]",".steppers[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.steppers["2"]/*[[".cells.steppers[\"2\"]",".steppers[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["LABEL"]/*[[".cells.staticTexts[\"LABEL\"]",".staticTexts[\"LABEL\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.switches["Set Label"]/*[[".cells.switches[\"Set Label\"]",".switches[\"Set Label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let labelTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["label"]/*[[".cells.textFields[\"label\"]",".textFields[\"label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      labelTextField.tap()
      labelTextField.tap()
      app.navigationBars["New Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let usernamePasswordButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["UserName, Password"]/*[[".cells.buttons[\"UserName, Password\"]",".buttons[\"UserName, Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      usernamePasswordButton.tap()
      collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
      app.navigationBars["UserName"]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      usernamePasswordButton.tap()
                  
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
