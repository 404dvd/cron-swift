import Foundation

protocol CronSchedulerProtocol {
    // Command name
    var command: String { get }
    
    /// Get the next run `Date`
    func nextRunDate() -> Date?
}
