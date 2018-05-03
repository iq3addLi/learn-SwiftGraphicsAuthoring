// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "learn-SwiftGraphicsAuthoring",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/vapor.git", from: "2.4.4"),
        .package(url: "https://github.com/twostraws/SwiftGD.git", from: "2.1.1"),
        .package(url: "https://github.com/PureSwift/Cairo.git", from: "1.2.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "learn-SwiftGraphicsAuthoring",
            dependencies: [ "Vapor", "Cairo", "SwiftGD" ]),
    ]
)
