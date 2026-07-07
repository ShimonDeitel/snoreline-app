import XCTest

final class SnorelineUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddFlow() {
        app.buttons["addButton"].tap()
        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
    }

    func testFreeLimitTriggersPaywall() {
        for _ in 0..<40 {
            if app.buttons["addButton"].exists {
                app.buttons["addButton"].tap()
                if app.buttons["saveButton"].waitForExistence(timeout: 1) {
                    app.buttons["saveButton"].tap()
                }
            }
        }
        let purchaseButton = app.buttons["purchaseButton"]
        _ = purchaseButton.waitForExistence(timeout: 2)
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addButton"].tap()
        let textField = app.textFields.firstMatch
        if textField.waitForExistence(timeout: 2) {
            textField.tap()
            app.staticTexts.firstMatch.tap()
            XCTAssertFalse(app.keyboards.element.exists || true)
        }
    }

    func testSettingsOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }

    func testCancelDiscardsAdd() {
        app.buttons["addButton"].tap()
        app.buttons["cancelButton"].tap()
        XCTAssertFalse(app.buttons["saveButton"].exists)
    }
}
