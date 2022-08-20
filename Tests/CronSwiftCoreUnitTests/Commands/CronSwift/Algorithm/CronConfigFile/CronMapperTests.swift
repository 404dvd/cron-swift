
import XCTest
@testable import CronSwiftCore

class CronMapperTests: XCTestCase {

    func test_cron_doesNotDeliverCronSchedulerWhenInvalidItem() {
        XCTAssertNil(CronMapper.cron(CronFileItem(minute: "any", hour: "any", command: "any")))
        XCTAssertNil(CronMapper.cron(CronFileItem(minute: "3", hour: "any", command: "any")))
        XCTAssertNil(CronMapper.cron(CronFileItem(minute: "3", hour: "", command: "any")))
        XCTAssertNil(CronMapper.cron(CronFileItem(minute: "any", hour: "3", command: "any")))
        XCTAssertNil(CronMapper.cron(CronFileItem(minute: "", hour: "3", command: "any")))
    }
    
    func test_cron_deliverCronSchedulerWhenValidItem() {
        XCTAssertNotNil(CronMapper.cron(CronFileItem(minute: "3", hour: "3", command: "any")))
        XCTAssertNotNil(CronMapper.cron(CronFileItem(minute: "3", hour: "*", command: "any")))
        XCTAssertNotNil(CronMapper.cron(CronFileItem(minute: "*", hour: "*", command: "any")))
    }
}
