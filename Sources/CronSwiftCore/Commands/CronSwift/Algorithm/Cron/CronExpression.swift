import Foundation

struct CronExpression: Equatable {
    
    static let CRON_ACCEPT_ALL_VALUES = "*"
    
    let minute: MinuteCronPart
    let hour: HourCronPart
    
    init(_ minute: MinuteCronPart, _ hour: HourCronPart) {
        self.minute = minute
        self.hour = hour
    }
}
