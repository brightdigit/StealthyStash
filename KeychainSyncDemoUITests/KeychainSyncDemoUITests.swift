//
//  KeychainSyncDemoUITests.swift
//  KeychainSyncDemoUITests
//
//  Created by Leo Dion on 3/7/23.
//

import XCTest
import FloxBxAuth


extension InternetPasswordItem {
  
  static func random() -> InternetPasswordItem {
    return InternetPasswordItem(account: UUID().uuidString, data: UUID().uuidString.data(using: .utf8)!, url: .random(), type: .random(in: 1...12), label: UUID().uuidString)
  }
  
}



extension GenericPasswordItem {
  
  static func random(withAccountName accountName : String? = nil) -> GenericPasswordItem {
    return GenericPasswordItem(account: accountName ?? UUID().uuidString, data: UUID().uuidString.data(using: .utf8)!, type: .random(in: 1...12), label: UUID().uuidString)
  }
  
}
final class KeychainSyncDemoUITests: XCTestCase {
  
  fileprivate func genericPassword(_ genericPassword: GenericPasswordItem, testApp app: XCUIApplication, atCount currentCount: Int) {
    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Generic"].tap()
    let collectionViewsQuery = app.collectionViews
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count , currentCount)
    
    app.navigationBars["Generic Passwords"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    let accountField = collectionViewsQuery.textFields["account"]
    accountField.tap()
    accountField.typeText(genericPassword.account)
    
    let passwordField = app.collectionViews.textViews["data"]
    passwordField.tap()
    passwordField.typeText(genericPassword.dataString)
    
    //      let syncSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Is Syncronizable"]/*[[".cells.switches[\"Is Syncronizable\"]",".switches[\"Is Syncronizable\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //      syncSwitch.tap()
    //
    //      let setTypeSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Set Type"]/*[[".cells.switches[\"Set Type\"]",".switches[\"Set Type\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //      setTypeSwitch.tap()
    //
    //      let setTypeStepper = app.collectionViews.steppers["setTypeStepper"]
    //      setTypeStepper.buttons["Increment"].tap()
    //      setTypeStepper.buttons["Increment"].tap()
    //      setTypeStepper.buttons["Increment"].tap()
    //
    //      app.collectionViews/*@START_MENU_TOKEN@*/.switches["Set Label"]/*[[".cells.switches[\"Set Label\"]",".switches[\"Set Label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    //
    //      let labelTextField = app.collectionViews/*@START_MENU_TOKEN@*/.textFields["label"]/*[[".cells.textFields[\"label\"]",".textFields[\"label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //      labelTextField.tap()
    //      labelTextField.typeText("label")
    
    app.navigationBars["New Generic Passwords"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    let propertyListQuery = collectionViewsQuery.buttons.matching(identifier: "propertyList")
    
    XCTAssertEqual(propertyListQuery.count, currentCount+1)
    let propertyList = propertyListQuery.element(boundBy: currentCount)
    
    XCTAssertEqual(propertyList.staticTexts["accountProperty"].label, genericPassword.account)
    XCTAssertEqual(propertyList.staticTexts["dataProperty"].label, genericPassword.dataString)
    propertyList.tap()
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as? String, genericPassword.account)
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["data"]/*[[".cells.textViews[\"data\"]",".textViews[\"data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as? String, genericPassword.dataString)
    
    app.navigationBars[genericPassword.account]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
  }
  fileprivate func internetPassword(_ internetPassword: InternetPasswordItem, testApp app: XCUIApplication, atCount currentCount: Int) {
    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Internet"].tap()
    let collectionViewsQuery = app.collectionViews
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count , currentCount)
    
    app.navigationBars["Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    let accountField = collectionViewsQuery.textFields["account"]
    accountField.tap()
    accountField.typeText(internetPassword.account)
    
    let passwordField = app.collectionViews.textViews["data"]
    passwordField.tap()
    passwordField.typeText(internetPassword.dataString)
    
    //      let syncSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Is Syncronizable"]/*[[".cells.switches[\"Is Syncronizable\"]",".switches[\"Is Syncronizable\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //      syncSwitch.tap()
    //
    //      let setTypeSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Set Type"]/*[[".cells.switches[\"Set Type\"]",".switches[\"Set Type\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //      setTypeSwitch.tap()
    //
    //      let setTypeStepper = app.collectionViews.steppers["setTypeStepper"]
    //      setTypeStepper.buttons["Increment"].tap()
    //      setTypeStepper.buttons["Increment"].tap()
    //      setTypeStepper.buttons["Increment"].tap()
    //
    //      app.collectionViews/*@START_MENU_TOKEN@*/.switches["Set Label"]/*[[".cells.switches[\"Set Label\"]",".switches[\"Set Label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    //
    //      let labelTextField = app.collectionViews/*@START_MENU_TOKEN@*/.textFields["label"]/*[[".cells.textFields[\"label\"]",".textFields[\"label\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    //      labelTextField.tap()
    //      labelTextField.typeText("label")
    
    app.navigationBars["New Internet Passwords"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    let propertyListQuery = collectionViewsQuery.buttons.matching(identifier: "propertyList")
    
    XCTAssertEqual(propertyListQuery.count, currentCount+1)
    let propertyList = propertyListQuery.element(boundBy: currentCount)
    
    XCTAssertEqual(propertyList.staticTexts["accountProperty"].label, internetPassword.account)
    XCTAssertEqual(propertyList.staticTexts["dataProperty"].label, internetPassword.dataString)
    propertyList.tap()
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as? String, internetPassword.account)
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["data"]/*[[".cells.textViews[\"data\"]",".textViews[\"data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as? String, internetPassword.dataString)
    
    app.navigationBars[internetPassword.account]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
  }
  
  fileprivate func clearAll(_ app: XCUIApplication) {
    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Settings"].tap()
    
    let collectionViewsQuery = app.collectionViews
    collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Erase All Keychain Items"]/*[[".cells.buttons[\"Erase All Keychain Items\"]",".buttons[\"Erase All Keychain Items\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.alerts["Are you sure you want to delete all keychain items?"].scrollViews.otherElements.buttons["Yes"].tap()
    app.alerts["All Keychain Items Deleted"].scrollViews.otherElements.buttons["Ok"].tap()
    
    tabBar.buttons["Person"].tap()
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count , 0)
    
    tabBar.buttons["Generic"].tap()
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count , 0)
    
    tabBar.buttons["Internet"].tap()
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count , 0)
  }
  
  
  func testCompsite () {
    let app = XCUIApplication()
    app.launch()
    clearAll(app)
  
  }
  
  func testClear() {
    let app = XCUIApplication()
    app.launch()
    clearAll(app)
    
  }
  
  @discardableResult
  fileprivate func internetPasswordTests(_ totalCount: Int, _ app: XCUIApplication)  -> [InternetPasswordItem] {
    return (0..<totalCount).map { count in
      let password : InternetPasswordItem = .random()
      self.internetPassword(password, testApp: app, atCount: count)
      return password
    }
  }
  
  
  @discardableResult
  fileprivate func genericPasswordTests(_ totalCount: Int, _ app: XCUIApplication, withUserName userName : String? = nil, atIndex userNameIndex : Int? = nil) -> [GenericPasswordItem] {

      return (0..<totalCount).map { count in
        let password : GenericPasswordItem = .random(withAccountName: count == userNameIndex ? userName : nil)
        self.genericPassword(password, testApp: app, atCount: count)
        return password
      }
  }
  
  
  func testRunThrough() {
    let app = XCUIApplication()
    app.launch()
    clearAll(app)
  
    
    let internetPasswords = internetPasswordTests(3, app)
    
    let tokenIndex : Int = .random(in: 0...2)
    let genericPasswords = genericPasswordTests(3, app, withUserName: internetPasswords.first?.account, atIndex: tokenIndex)
    
    
    app.tabBars["Tab Bar"].buttons["Person"].tap()
    
    
    
    let collectionViewsQuery = app.collectionViews
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["User name"]/*[[".cells.textFields[\"User name\"]",".textFields[\"User name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as? String, internetPasswords.first?.account)
    //.tap()
    XCTAssertEqual(collectionViewsQuery.textFields["Password"].value as? String, internetPasswords.first?.dataString)
    //collectionViewsQuery.textFields["Password"]
    //.tap()
    XCTAssertEqual(collectionViewsQuery.textFields["Token"].value as? String, genericPasswords[tokenIndex].dataString)
    //.tap()
    //collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".cells.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    
//    let app = XCUIApplication()
//    let tabBar = app.tabBars["Tab Bar"]
//    let personButton = tabBar.buttons["Person"]
//    personButton.tap()
//
//    let collectionViewsQuery = app.collectionViews
//    let userNameTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["User name"]/*[[".cells.textFields[\"User name\"]",".textFields[\"User name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//    userNameTextField.tap()
//    userNameTextField.tap()
//    userNameTextField.tap()
//    userNameTextField.tap()
//
//    let passwordTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Password"]/*[[".cells.textFields[\"Password\"]",".textFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//    passwordTextField.tap()
//    passwordTextField.tap()
//    passwordTextField.tap()
//    collectionViewsQuery.children(matching: .cell).element(boundBy: 5).children(matching: .other).element(boundBy: 1).children(matching: .other).element.twoFingerTap()
//
//    let tokenTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Token"]/*[[".cells.textFields[\"Token\"]",".textFields[\"Token\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//    tokenTextField.twoFingerTap()
//    tokenTextField.tap()
//    tokenTextField.twoFingerTap()
//    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 0).twoFingerTap()
//    collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".cells.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.twoFingerTap()
//
//    let genericButton = tabBar.buttons["Generic"]
//    genericButton.twoFingerTap()
//    tabBar.buttons["Internet"].twoFingerTap()
//    genericButton.twoFingerTap()
//    personButton.twoFingerTap()
//    tokenTextField.tap()
    
    
    
  }
}
