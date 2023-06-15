@testable import StealthyStash
import XCTest

// swiftlint:disable line_length
final class KeychainSyncDemoUITests: XCTestCase {
  fileprivate func genericPassword(
    _ genericPassword: GenericPasswordItem,
    testApp app: XCUIApplication,
    atCount currentCount: Int
  ) {
    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Generic"].tap()
    let collectionViewsQuery = app.collectionViews
    XCTAssertEqual(
      collectionViewsQuery.buttons.matching(identifier: "propertyList").count,
      currentCount
    )

    app.navigationBars["Generic Passwords"]/*@START_MENU_TOKEN@*/ .buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    let accountField = collectionViewsQuery.textFields["account"]
    accountField.tap()
    accountField.typeText(genericPassword.account)

    let passwordField = app.collectionViews.textViews["data"]
    passwordField.tap()
    passwordField.typeText(genericPassword.dataString)

    app.navigationBars["New Generic Passwords"]/*@START_MENU_TOKEN@*/ .buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    let propertyListQuery = collectionViewsQuery.buttons.matching(identifier: "propertyList")

    XCTAssertEqual(propertyListQuery.count, currentCount + 1)
    let propertyList = propertyListQuery.element(boundBy: currentCount)

    XCTAssertEqual(propertyList.staticTexts["accountProperty"].label, genericPassword.account)
    XCTAssertEqual(propertyList.staticTexts["dataProperty"].label, genericPassword.dataString)
    propertyList.tap()
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/ .textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .value as? String, genericPassword.account)
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/ .textViews["data"]/*[[".cells.textViews[\"data\"]",".textViews[\"data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .value as? String, genericPassword.dataString)

    app.navigationBars[genericPassword.account]/*@START_MENU_TOKEN@*/ .buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
  }

  fileprivate func internetPassword(_ internetPassword: InternetPasswordItem, testApp app: XCUIApplication, atCount currentCount: Int) {
    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Internet"].tap()
    let collectionViewsQuery = app.collectionViews
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count, currentCount)

    app.navigationBars["Internet Passwords"]/*@START_MENU_TOKEN@*/ .buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    let accountField = collectionViewsQuery.textFields["account"]
    accountField.tap()
    accountField.typeText(internetPassword.account)

    let passwordField = app.collectionViews.textViews["data"]
    passwordField.tap()
    passwordField.typeText(internetPassword.dataString)

    app.navigationBars["New Internet Passwords"]/*@START_MENU_TOKEN@*/ .buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    let propertyListQuery = collectionViewsQuery.buttons.matching(identifier: "propertyList")

    XCTAssertEqual(propertyListQuery.count, currentCount + 1)
    let propertyList = propertyListQuery.element(boundBy: currentCount)

    XCTAssertEqual(propertyList.staticTexts["accountProperty"].label, internetPassword.account)
    XCTAssertEqual(propertyList.staticTexts["dataProperty"].label, internetPassword.dataString)
    propertyList.tap()
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/ .textFields["account"]/*[[".cells.textFields[\"account\"]",".textFields[\"account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .value as? String, internetPassword.account)
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/ .textViews["data"]/*[[".cells.textViews[\"data\"]",".textViews[\"data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .value as? String, internetPassword.dataString)

    app.navigationBars[internetPassword.account]/*@START_MENU_TOKEN@*/ .buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
  }

  fileprivate func clearAll(_ app: XCUIApplication) {
    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Settings"].tap()

    let collectionViewsQuery = app.collectionViews
    collectionViewsQuery/*@START_MENU_TOKEN@*/ .buttons["Erase All Keychain Items"]/*[[".cells.buttons[\"Erase All Keychain Items\"]",".buttons[\"Erase All Keychain Items\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    app.alerts["Are you sure you want to delete all keychain items?"].scrollViews.otherElements.buttons["Yes"].tap()
    app.alerts["All Keychain Items Deleted"].scrollViews.otherElements.buttons["Ok"].tap()

    tabBar.buttons["Person"].tap()
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count, 0)

    tabBar.buttons["Generic"].tap()
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count, 0)

    tabBar.buttons["Internet"].tap()
    XCTAssertEqual(collectionViewsQuery.buttons.matching(identifier: "propertyList").count, 0)
  }

  func testCompsite() {
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
  fileprivate func internetPasswordTests(_ totalCount: Int, _ app: XCUIApplication) -> [InternetPasswordItem] {
    (0 ..< totalCount).map { count in
      let password: InternetPasswordItem = .random()
      self.internetPassword(password, testApp: app, atCount: count)
      return password
    }
  }

  @discardableResult
  fileprivate func genericPasswordTests(_ totalCount: Int, _ app: XCUIApplication, withUserName userName: String? = nil, atIndex userNameIndex: Int? = nil) -> [GenericPasswordItem] {
    (0 ..< totalCount).map { count in
      let password: GenericPasswordItem = .random(withAccountName: count == userNameIndex ? userName : nil)
      self.genericPassword(password, testApp: app, atCount: count)
      return password
    }
  }

  func testRunThrough() {
    let app = XCUIApplication()
    app.launch()
    clearAll(app)

    let internetPasswords = internetPasswordTests(3, app)

    let tokenIndex: Int = .random(in: 0 ... 2)
    let genericPasswords = genericPasswordTests(3, app, withUserName: internetPasswords.first?.account, atIndex: tokenIndex)

    app.tabBars["Tab Bar"].buttons["Person"].tap()

    let collectionViewsQuery = app.collectionViews
    XCTAssertEqual(collectionViewsQuery/*@START_MENU_TOKEN@*/ .textFields["User name"]/*[[".cells.textFields[\"User name\"]",".textFields[\"User name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .value as? String, internetPasswords.first?.account)
    // .tap()
    XCTAssertEqual(collectionViewsQuery.textFields["Password"].value as? String, internetPasswords.first?.dataString)
    XCTAssertEqual(collectionViewsQuery.textFields["Token"].value as? String, genericPasswords[tokenIndex].dataString)

    let tabBar = app.tabBars["Tab Bar"]
    tabBar.buttons["Internet"].tap()

    let intenetItem = collectionViewsQuery.buttons.matching(identifier: "propertyList").element(boundBy: 0)

    XCTAssertEqual(intenetItem.staticTexts["accountProperty"].label, internetPasswords.first?.account)
    XCTAssertEqual(intenetItem.staticTexts["dataProperty"].label, internetPasswords.first?.dataString)

    tabBar.buttons["Generic"].tap()
    let genericItem = collectionViewsQuery.buttons.matching(identifier: "propertyList").element(boundBy: tokenIndex)

    XCTAssertEqual(genericItem.staticTexts["accountProperty"].label, genericPasswords[tokenIndex].account)
    XCTAssertEqual(genericItem.staticTexts["dataProperty"].label, genericPasswords[tokenIndex].dataString)
  }
}
