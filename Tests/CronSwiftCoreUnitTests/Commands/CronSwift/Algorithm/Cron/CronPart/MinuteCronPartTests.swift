
import XCTest
@testable import CronSwiftCore

class MinuteCronPartTests: XCTestCase {

    func test_init_returnNilWhenNotValid() {
        
        let sut = MinuteCronPart("any")
        
        XCTAssertNil(sut)
    }
    
    func test_init_returnInstanceWhenValid() {
        
        XCTAssertNotNil(MinuteCronPart("59"))
        XCTAssertNotNil(MinuteCronPart("0"))
        XCTAssertNotNil(MinuteCronPart("*"))
    }
    
    func test_validUnits_deliverAllTheRangeWhenValueIsEqualToStar() {
        let sut = MinuteCronPart("*")!
        
        let values = sut.validUnits()
        
        XCTAssertEqual(Array(0...59), values)
    }
    
    func test_validUnits_deliverExactValue() {
        let sut = MinuteCronPart("3")!
        
        let values = sut.validUnits()
        
        XCTAssertEqual([3], values)
    }
}
