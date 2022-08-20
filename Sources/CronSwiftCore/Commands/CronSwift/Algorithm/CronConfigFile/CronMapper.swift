import Foundation

struct CronMapper {
    
    static func cron(_ fileItem: CronFileItem, date: Date = Date.now, calendar: Calendar = .current) -> CronScheduler? {
        guard let minute = MinuteCronPart(fileItem.minute),
              let hour = HourCronPart(fileItem.hour) else { return nil }
        return CronScheduler(cronExpr: CronExpression(minute, hour),
                             command: fileItem.command,
                             dateNow: date,
                             calendar: calendar)
    }
}
