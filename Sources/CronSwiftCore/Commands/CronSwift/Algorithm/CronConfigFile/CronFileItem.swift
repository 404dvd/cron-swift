import Foundation

/// A type that represents how the data is parsed from the file.
struct CronFileItem: Equatable {
    let minute: String
    
    let hour: String
    
    let command: String
}
