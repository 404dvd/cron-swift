import Foundation

/// Fetch all the lines in stdin
func fetchLines(_ lines: [String] = []) -> [String] {
    guard let line = readLine() else { return lines }
    return fetchLines(lines + [line])
}
