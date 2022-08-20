
import XCTest
@testable import CronSwiftCore

class HourCronPartTests: XCTestCase {
    
    func test_init_returnNilWhenNotValid() {
        
        let sut = HourCronPart("any")
        
        XCTAssertNil(sut)
    }
    
    func test_init_returnInstanceWhenValid() {
        
        XCTAssertNotNil(HourCronPart("23"))
        XCTAssertNotNil(HourCronPart("0"))
        XCTAssertNotNil(HourCronPart("*"))
    }
    
    func test_validUnits_deliverAllTheRangeWhenValueIsEqualToStar() {
        let sut = HourCronPart("*")!
        
        let values = sut.validUnits()
        
        XCTAssertEqual(Array(0...23), values)
    }
    
    func test_validUnits_deliverExactValue() {
        let sut = HourCronPart("3")!
        
        let values = sut.validUnits()
        
        XCTAssertEqual([3], values)
    }
}
