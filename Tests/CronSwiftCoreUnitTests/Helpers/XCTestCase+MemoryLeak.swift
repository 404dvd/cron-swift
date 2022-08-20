import Foundation
import XCTest

extension XCTestCase {
    func addAssertMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance doesn't being allocated, possibly memory leak", file: file, line: line)
        }
    }
}
