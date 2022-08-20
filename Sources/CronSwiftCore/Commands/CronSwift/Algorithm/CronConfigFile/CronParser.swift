import Foundation

enum CronParser {
    
    /// Parse the input contents in `CronFileItem`
    static func parse(contents: [String], separator: Character = " ") ->  Result<[CronFileItem], CronSwiftError>{
        guard !contents.isEmpty else {
            return .failure(CronSwiftError.configFileIsEmpty)
        }
        var items = [CronFileItem]()
        for (index, content)  in contents.enumerated(){
            let components = content.split(separator: separator)
            guard components.count == 3 else {
                return .failure(.invalidFormat(row: content, line: index + 1))
            }
            let minute = String(components[0])
            let hour = String(components[1])
            let command = String(components[2])
            let item = CronFileItem(minute: minute, hour: hour, command: command)
            items.append(item)
        }
        return .success(items)
    }
}
