
import XCTest
@testable import CronSwiftCore

class CronParserTests: XCTestCase {

    func test_parse_deliverFailureWhenContentsIsEmpty() throws {
        let result = CronParser.parse(contents: [])
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .configFileIsEmpty)
        default:
            XCTFail("Expected to fail and instead got \(result)")
        }
    }
    
    func test_parse_deliverFailureWhenEntryHasInvalidFormat() throws {
        let result = CronParser.parse(contents: ["Any"])
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .invalidFormat(row: "Any", line: 1))
        default:
            XCTFail("Expected to fail and instead got \(result)")
        }
    }
    
    func test_parse_deliverSuccessfulFileItems() throws {
        let result = CronParser.parse(contents: ["3 * any-command"])
        switch result {
        case .success(let items):
            XCTAssertEqual(items, [.init(minute: "3", hour: "*", command: "any-command")])
        default:
            XCTFail("Expected to succeed and instead got \(result)")
        }
    }
}
