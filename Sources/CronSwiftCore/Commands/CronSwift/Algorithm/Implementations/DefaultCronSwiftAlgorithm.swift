import Foundation

public struct DefaultCronSwiftAlgorithm: CronSwiftAlgorithm {
    
    // MARK: - Setup
    
    public init(fileLines: [String],
                simulatedCurrentTime: String,
                calendar: Calendar = .current) {
        self.fileLines = fileLines
        self.inputTime = simulatedCurrentTime
        self.calendar = calendar
        self.printFunc = DefaultCronSwiftAlgorithm.print
    }
    
    init(fileLines: [String],
         simulatedCurrentTime: String,
         calendar: Calendar = .current,
         printFunc: @escaping (String) -> Void) {
        self.fileLines = fileLines
        self.inputTime = simulatedCurrentTime
        self.calendar = calendar
        self.printFunc = printFunc
    }
    
    // MARK: - Public
    
    /// Process the algorithm return the result of success or failure
    public func process(_ completion: @escaping (Result<Void, CronSwiftError>) -> ()) {
        completion(
            parse(contents: fileLines, time: inputTime)  // parse input
                .flatMap({ map($0) })                    // map into cron scheduler
                .flatMap({ calculateNextRunDates($0)})   // calculate the next run dates
                .flatMap({ printResults($0)})            // print the cron schedules
        )
    }
    
    // MARK: - Private
    
    /// The path from where to read the file with the cron schedules
    private let fileLines: [String]
    
    /// Input simulated time string
    private let inputTime: String
    
    /// Calendar
    private let calendar: Calendar
    
    /// The print function
    private let printFunc: (String) -> Void
    
    private static func print(string: String) -> Void {
        Swift.print(string)
    }
}

extension DefaultCronSwiftAlgorithm {
    
    typealias FileLines = [String]
    typealias PrintObj = (Date, String)
    typealias Input = (fileItems: [CronFileItem], dateSimulated: Date)
    
    func parse(contents: FileLines, time: String) -> Result<Input, CronSwiftError> {
        guard let date = parse(time) else { return .failure(.invalidInputTimeString) }
        return CronParser.parse(contents: contents).flatMap({ .success(($0, date)) })
    }
    
    func parse(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let simulatedTime = formatter.date(from: time) else { return nil }
        let simulatedComponents = calendar.dateComponents([.hour, .minute], from: simulatedTime)
        return calendar.date(bySettingHour: simulatedComponents.hour!, minute: simulatedComponents.minute!, second: 0, of: Date())
    }
    
    func map(_ input: Input) -> Result<[CronScheduler], CronSwiftError> {
        var cronItems = [CronScheduler]()
        for item in input.fileItems {
            let cron = CronMapper.cron(item, date: input.dateSimulated, calendar: calendar)
            if let cron = cron {
                cronItems.append(cron)
                continue
            }
            let error = CronSwiftError.invalidFileLine(minute: item.minute, hour: item.hour, command: item.command)
            return .failure(error)
        }
        return .success(cronItems)
    }
    
    func calculateNextRunDates(_ schedulers: [CronSchedulerProtocol]) -> Result<[PrintObj], CronSwiftError> {
        let printObjs: [PrintObj] = schedulers.compactMap { cron in
            guard let date = cron.nextRunDate() else { return nil }
            return (nextRunDate: date, command: cron.command)
        }
        return .success(printObjs)
    }
    
    func printResults(_ objects: [PrintObj]) -> Result<Void, CronSwiftError> {
        objects.forEach {
            let (nextRunDate, command) = $0
            let formatter = DateFormatter()
            formatter.dateFormat = "H:mm"
            let day = calendar.isDateInToday(nextRunDate) ? "today" : "tomorrow"
            let output = "\(formatter.string(from: nextRunDate)) \(day) - \(command)"
            printFunc(output)
        }
        return .success(())
    }
}
