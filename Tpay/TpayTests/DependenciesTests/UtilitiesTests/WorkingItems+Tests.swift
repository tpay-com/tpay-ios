//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class WorkingItems_Tests: XCTestCase {

    // MARK: - Properties

    private let sut = WorkingItems()

    // MARK: - Tests

    func test_WorkingItemsRetainWorkingItem() throws {
        var workingItem: WorkingItem? = WorkingItem {}
        weak var item = workingItem

        sut.append(try XCTUnwrap(workingItem), for: UUID())

        workingItem = nil

        expect(item).toNot(beNil())

        sut.cancelAll()

        expect(item).to(beNil())
    }

    func test_RemovingItemFromBagCaseItemCancel() {
        waitUntil(timeout: .milliseconds(1)) { done in
            let item = WorkingItem { done() }

            let uuid = UUID()
            self.sut.append(item, for: uuid)
            self.sut.removeItem(with: uuid)
        }
    }
    
    func test_CancelAllCaseInvokeItemsCancel() {
        waitUntil(timeout: .milliseconds(1)) { done in
            let item = WorkingItem { done() }

            self.sut.append(item, for: UUID())
            self.sut.cancelAll()
        }
    }
    
    func test_ReleaseOfBagCaseCancelAllItems() {
        var sut: WorkingItems? = WorkingItems()
        waitUntil(timeout: .milliseconds(1)) { done in
            sut?.append(WorkingItem { done() }, for: UUID())
            sut = nil
        }
    }

}
