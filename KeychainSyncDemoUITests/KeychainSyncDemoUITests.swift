//
//  KeychainSyncDemoUITests.swift
//  KeychainSyncDemoUITests
//
//  Created by Leo Dion on 3/7/23.
//

import XCTest

final class KeychainSyncDemoUITests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testExample() throws {
      let accountName = "AccountName"
      let password = "Password"
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
      app.navigationBars["Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let collectionViewsQuery = app.collectionViews
      let accountField = collectionViewsQuery.textFields["account"]
      accountField.tap()
      accountField.typeText(accountName)
      
      let passwordField = app.collectionViews.textViews["data"]
      passwordField.tap()
      passwordField.typeText(password)
      
      
      let syncSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Is Syncronizable"]/*[[".cells.switches[\"Is Syncronizable\"]",".switches[\"Is Syncronizable\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      syncSwitch.tap()
      
      let setTypeSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Set Type"]/*[[".cells.switches[\"Set Type\"]",".switches[\"Set Type\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      setTypeSwitch.tap()
      
      let setTypeStepper = app.collectionViews.steppers["setTypeStepper"]
      setTypeStepper.buttons["Increment"].tap()
      setTypeStepper.buttons["Increment"].tap()
      setTypeStepper.buttons["Increment"].tap()
      
      app.collectionViews/*@START_MENU_TOKEN@*/.switches["Set Label"]/*[[".cells.switches[\"Set Label\"]",".switches[\"Set Label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let labelTextField = app.collectionViews/*@START_MENU_TOKEN@*/.textFields["label"]/*[[".cells.textFields[\"label\"]",".textFields[\"label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      labelTextField.tap()
      labelTextField.typeText("label")
      
      app.navigationBars["New Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      print(app.tables["propertyList"].cells.count)
      
//      let app = XCUIApplication()
//      let verticalScrollBar1PageCollectionView = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//      verticalScrollBar1PageCollectionView.tap()
//
//      let collectionViewsQuery = app.collectionViews
//      collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Query"]/*[[".cells.buttons[\"Query\"]",".buttons[\"Query\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//      verticalScrollBar1PageCollectionView.tap()
//      app.navigationBars["Internet Passwords"].buttons["Add"].tap()
//      collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//      let dataTextView = collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["data"]/*[[".cells.textViews[\"data\"]",".textViews[\"data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//      dataTextView.tap()
//      dataTextView.tap()
//      app.navigationBars["New Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
      let testTestButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Test, Test"]/*[[".cells.buttons[\"Test, Test\"]",".buttons[\"Test, Test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//      testTestButton.tap()
//      
//      let backButton = app.navigationBars["Test"]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//      backButton.tap()
//      testTestButton.tap()
//      backButton.tap()
//      testTestButton.tap()
                                                                  
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
