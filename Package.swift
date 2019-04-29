// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "app-content-service",
    dependencies: [
        .package(url: "https://github.com/HedvigInsurance/SwiftGraphQLServer.git", from: "2.0.0"),
        .package(url: "https://github.com/HedvigInsurance/Graphiti.git", from: "0.9.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "app-content-service",
            dependencies: [
                "Graphiti",
                "SwiftGraphQLServer",
                "Vapor"
            ]),
        .testTarget(
            name: "app-content-serviceTests",
            dependencies: ["app-content-service"]),
    ]
)
