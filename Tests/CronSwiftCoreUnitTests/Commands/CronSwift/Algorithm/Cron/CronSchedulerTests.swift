import XCTest
import Foundation
@testable import CronSwiftCore

class CronSchedulerTests: XCTestCase {
    
    func test_nextRunDate_DeliversDateWhenCronEveryMinuteEveryHour() {
        let (sut, dateNow) = makeSUT("*", "*", "Any command", makeDate(2022, 8, 20, 15, 30)!)
        
        let nextRunDate = sut.nextRunDate()
        
        XCTAssertEqual(dateNow, nextRunDate)
    }
    
    func test_nextRunDate_DeliversDateWhenCronExactMinuteEveryHour() {
        let (sut, _) = makeSUT("2", "*", "Any command", makeDate(2022, 8, 20, 15, 30)!)
        
        let nextRunDate = sut.nextRunDate()
        
        XCTAssertEqual(nextRunDate, makeDate(2022, 8, 20, 16, 2))
    }
    
    func test_nextRunDate_DeliversDateWhenCronEveryMinuteExactHour() {
        let (sut, _) = makeSUT("*", "3", "Any command", makeDate(2022, 8, 20, 15, 30)!)
        
        let nextRunDate = sut.nextRunDate()
        
        XCTAssertEqual(nextRunDate, makeDate(2022, 8, 21, 3, 0))
    }
    
    func test_nextRunDate_DeliversDateWhenCronExactMinuteExactHour() {
        let (sut, _) = makeSUT("0", "0", "Any command", makeDate(2022, 12, 31, 15, 30)!)
        
        let nextRunDate = sut.nextRunDate()
        
        XCTAssertEqual(nextRunDate, makeDate(2023, 1, 1, 0, 0))
    }
    
    // MARK: - Helpers
    
    func makeSUT(_ minute: String,_ hour: String, _ command: String, _ dateNow: Date = Date.now, calendar: Calendar = .current) -> (CronScheduler, Date) {
        guard let minute = MinuteCronPart(minute),
              let hour = HourCronPart(hour) else {
            fatalError("Failing instantiating the SUT got \(minute) \(hour)")
        }
        let sut = CronScheduler(cronExpr: CronExpression(minute, hour), command: command, dateNow: dateNow, calendar: calendar)
        return (sut, dateNow)
    }
    
    
    private func makeDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int,_ second: Int = 0, calendar: Calendar = .current) -> Date? {
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        year: year,
                                        month: month,
                                        day: day,
                                        hour: hour,
                                        minute: minute,
                                        second: second)
        return components.date
    }
}
