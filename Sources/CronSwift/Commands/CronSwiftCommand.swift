import Foundation
import CronSwiftCore

public final class CronSwiftCommand {
    
    // MARK: - Setup
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    // MARK: - Public
    
    /// Execute the command
    public func run() throws {
        if arguments.count == 1 {
            printHelp()
            return
        }
        guard arguments.count == 2 else {
            print("Too many arguments.")
            return
        }
        let time = arguments[1]
        let lines = fetchLines()
        algorithm(fileLines: lines, simulatedCurrentTime: time).process { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Command failed with error \(error)")
                break
            }
        }
    }
    
    // MARK: - Private
    
    /// Command arguments
    private let arguments: [String]
    
    /// Print an help message descriptive of how to use the command
    private func printHelp() {
        print("usage: cronswift <simulated-current-time>")
    }
}

extension CronSwiftCommand {
    func algorithm(fileLines: [String], simulatedCurrentTime: String) -> CronSwiftAlgorithm {
        return DefaultCronSwiftAlgorithm(fileLines: fileLines, simulatedCurrentTime: simulatedCurrentTime)
    }
}
