// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "app-content-service",
    dependencies: [
        .package(url: "https://github.com/HedvigInsurance/SwiftGraphQLServer.git", from: "4.2.0"),
        .package(url: "https://github.com/HedvigInsurance/Graphiti.git", from: "0.17.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha"),
        .package(url: "https://github.com/ianpartridge/swift-backtrace.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "app-content-service",
            dependencies: [
                "Graphiti",
                "SwiftGraphQLServer",
                "Vapor",
                "Backtrace"
            ]),
        .testTarget(
            name: "app-content-serviceTests",
            dependencies: ["app-content-service"]),
    ]
)
