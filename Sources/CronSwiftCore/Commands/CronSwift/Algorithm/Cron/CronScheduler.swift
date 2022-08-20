import Foundation

struct CronScheduler: Equatable {
    
    // MARK: - Properties
    
    let cronExpr: CronExpression
    let command: String
    let dateNow: Date
    let calendar: Calendar
    
    var minutes: [Int] {
        return cronExpr.minute.validUnits()
    }
    
    var hours: [Int] {
        return cronExpr.hour.validUnits()
    }
    
    // MARK: - Setup
    
    init(cronExpr: CronExpression, command: String, dateNow: Date = Date.now, calendar: Calendar = .current) {
        self.cronExpr = cronExpr
        self.command = command
        self.dateNow = dateNow
        self.calendar = calendar
    }
}

extension CronScheduler: CronSchedulerProtocol {
    
    /// Get the next run date based on the cron expression
    func nextRunDate() -> Date? {  
        var nextCronDates = [Date]()
        for hour in hours {
            for minute in minutes {
                let dateNowComponents = calendar.dateComponents(in: calendar.timeZone, from: dateNow)
                guard let dateNowDate = dateNowComponents.date,
                      let datePossibleNext = makeDate(hour, minute, from: dateNowComponents) else {
                    continue
                }
                if  dateNowDate > datePossibleNext {
                    guard let nextDate = calendar.date(byAddingDay: 1, to: datePossibleNext) else {
                        continue
                    }
                    nextCronDates.append(nextDate)
                } else {
                    nextCronDates.append(datePossibleNext)
                }
            }
        }
        return nextCronDates.sorted().first
    }
    
    private func makeDate(_ hour: Int, _ minute: Int, from components: DateComponents) -> Date? {
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        year: components.year,
                                        month: components.month,
                                        day: components.day,
                                        hour: hour,
                                        minute: minute)
        return components.date
    }
}

private extension Calendar {
    func date(byAddingDay: Int, to date: Date) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        return self.date(byAdding: dayComponent, to: date)
    }
}
