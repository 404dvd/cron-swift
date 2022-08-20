import Foundation

public protocol CronSwiftAlgorithm {
    func process(_ completion: @escaping (Result<Void, CronSwiftError>) -> ())
}
