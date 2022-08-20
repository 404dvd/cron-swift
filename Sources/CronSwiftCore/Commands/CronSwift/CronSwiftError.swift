import Foundation

public enum CronSwiftError: Swift.Error, Equatable {
    /// It was not possible to read the file
    case impossibleReadFile
    /// The config file was empty
    case configFileIsEmpty
    /// An error that occurs when was not possible parse that particular file line because of not being well formatted
    case invalidFormat(row: String, line: Int)
    /// It was not possible parse the input time string
    case invalidInputTimeString
    /// The file was not valid
    case invalidFileLine(minute: String, hour: String, command: String)
}
