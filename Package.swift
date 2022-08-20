// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cron-swift",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "cronswift", targets: ["CronSwift"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CronSwiftCore",
               dependencies: []),
        .executableTarget(
            name: "CronSwift",
            dependencies: [
                "CronSwiftCore"
            ]),
        .testTarget(
            name: "CronSwiftCoreUnitTests",
            dependencies: ["CronSwiftCore"]),
    ]
)
