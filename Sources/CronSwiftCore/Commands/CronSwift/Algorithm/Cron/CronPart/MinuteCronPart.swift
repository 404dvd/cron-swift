import Foundation

struct MinuteCronPart: CronPart, Equatable {
    static let CRON_MINUTE_ALLOWED_VALUES = 0...59
    
    let value: String
    
    init?(_ value: String) {
        self.value = value
        guard self.isValid() else { return nil }
    }
    
    func validUnits() -> [Int] {
        guard value != CronExpression.CRON_ACCEPT_ALL_VALUES else {
            return MinuteCronPart.CRON_MINUTE_ALLOWED_VALUES.sorted()
        }
        guard let value = Int(value) else { return [] }
        return [value]
    }
}

extension MinuteCronPart: Validatable {
    func isValid() -> Bool {
        guard value != CronExpression.CRON_ACCEPT_ALL_VALUES else { return true}
        guard let value = Int(value) else {
            return false
        }
        switch value {
        case MinuteCronPart.CRON_MINUTE_ALLOWED_VALUES:
            return true
        default:
            return false
        }
    }
}
