import Foundation

struct HourCronPart: CronPart, Equatable {
    static let CRON_HOUR_ALLOWED_VALUES = 0...23
    
    let value: String
    
    init?(_ value: String) {
        self.value = value
        guard self.isValid() else { return nil }
    }
    
    func validUnits() -> [Int] {
        guard value != CronExpression.CRON_ACCEPT_ALL_VALUES else {
            return HourCronPart.CRON_HOUR_ALLOWED_VALUES.sorted()
        }
        guard let value = Int(value) else { return [] }
        return [value]
    }
}

extension HourCronPart: Validatable {
    func isValid() -> Bool {
        guard value != CronExpression.CRON_ACCEPT_ALL_VALUES else { return true}
        guard let value = Int(value) else {
            return false
        }
        switch value {
        case HourCronPart.CRON_HOUR_ALLOWED_VALUES:
            return true
        default:
            return false
        }
    }
}
