import XCTest
@testable import CronSwiftCore

class DefaultCronSwiftAlgorithmTests: XCTestCase {
    
    func test_process_deliverFailureWhenContentsIsEmpty() throws {
        let sut = DefaultCronSwiftAlgorithm(fileLines: [], simulatedCurrentTime: "16:10")
        
        sut.process { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .configFileIsEmpty)
            default:
                XCTFail("Expected to fail and instead got \(result)")
            }
        }
    }
    
    func test_process_deliverFailureWhenEntryHasInvalidFormat() throws {
        let sut = DefaultCronSwiftAlgorithm(fileLines: ["Any"], simulatedCurrentTime: "16:10")

        sut.process { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidFormat(row: "Any", line: 1))
            default:
                XCTFail("Expected to fail and instead got \(result)")
            }
        }
    }
    
    func test_process_deliverErrorWhenInputTimeStringIsInvalid() throws {
        let sut = DefaultCronSwiftAlgorithm(fileLines: [], simulatedCurrentTime: "any")

        sut.process { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidInputTimeString)
            default:
                XCTFail("Expected failure and instead got \(result)")
            }
        }
    }
    
    func test_process_deliverErrorWhenInvalidFileLine() throws {
        let invalidLine = "90 10 any-command"
        let sut = DefaultCronSwiftAlgorithm(fileLines: [invalidLine], simulatedCurrentTime: "16:10")
        
        sut.process { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidFileLine(minute: "90", hour: "10", command: "any-command"))
            default:
                XCTFail("Expected failure and instead got \(result)")
            }
        }
    }

    func test_process_printSuccessfullySchedules() {
        let validLine1 = "30 1 /bin/run_me_daily"
        let validLine2 = "45 * /bin/run_me_hourly"
        let validLine3 = "* * /bin/run_me_every_minute"
        let validLine4 = "* 19 /bin/run_me_sixty_times"
        let fileLines = [validLine1, validLine2, validLine3, validLine4]
        
        var capturedOutput = [String]()
        func fakePrint(item: String) -> Void {
            capturedOutput.append(item)
        }
        let sut = DefaultCronSwiftAlgorithm(fileLines: fileLines, simulatedCurrentTime: "16:10", printFunc: fakePrint)
        
        let exp = expectation(description: "Expect the algo to be processed")
        sut.process { result in
            switch result {
            case .success():
                exp.fulfill()
            default:
                XCTFail("Expected to success but instead got \(result)")
            }
        }
        
        wait(for: [exp], timeout: 1.0)
        let expectLine1 = "1:30 tomorrow - /bin/run_me_daily"
        let expectLine2 = "16:45 today - /bin/run_me_hourly"
        let expectLine3 = "16:10 today - /bin/run_me_every_minute"
        let expectLine4 = "19:00 today - /bin/run_me_sixty_times"
        XCTAssertEqual(capturedOutput, [expectLine1, expectLine2, expectLine3, expectLine4])
    }
}
