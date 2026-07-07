import XCTest
@testable import Snoreline

final class SnorelineTests: XCTestCase {
    var store: Store!

    @MainActor override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    @MainActor func testSeedDataBelowFreeLimit() {
        let seed = Store.seedData()
        XCTAssertLessThan(seed.count, Store.freeLimit)
    }

    @MainActor func testAddItem() {
        let item = SnoreEntry()
        let added = store.add(item, isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, 1)
    }

    @MainActor func testFreeLimitBlocksAdd() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(SnoreEntry(), isPro: false)
        }
        let blocked = store.add(SnoreEntry(), isPro: false)
        XCTAssertFalse(blocked)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    @MainActor func testProBypassesLimit() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(SnoreEntry(), isPro: true)
        }
        let added = store.add(SnoreEntry(), isPro: true)
        XCTAssertTrue(added)
    }

    @MainActor func testDeleteItem() {
        let item = SnoreEntry()
        _ = store.add(item, isPro: false)
        store.delete(id: item.id)
        XCTAssertTrue(store.items.isEmpty)
    }

    @MainActor func testUpdateItem() {
        var item = SnoreEntry()
        _ = store.add(item, isPro: false)
        item = store.items[0]
        store.update(item)
        XCTAssertEqual(store.items.count, 1)
    }

    @MainActor func testCanAddRespectsLimit() {
        XCTAssertTrue(store.canAdd(isPro: false))
    }

    @MainActor func testPersistenceRoundTrip() {
        let item = SnoreEntry()
        _ = store.add(item, isPro: false)
        store.save()
        store.load()
        XCTAssertEqual(store.items.first?.id, item.id)
    }
}
