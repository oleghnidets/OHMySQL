// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OHMySQL",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OHMySQL",
            targets: ["OHMySQL"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OHMySQL",
            dependencies: ["MySQL", "OpenSSL"],
            path: "OHMySQL/Sources",
            resources: [.process("PrivacyInfo.xcprivacy")],
            publicHeadersPath: "",
            cSettings: [
                .define("SWIFT_PACKAGE")
            ]
        ),
        .binaryTarget(
            name: "MySQL",
            path: "OHMySQL/lib/MySQL.xcframework"
        ),
        .binaryTarget(
            name: "OpenSSL",
            path: "OHMySQL/lib/OpenSSL.xcframework"
        ),
        .testTarget(
            name: "OHMySQLTests",
            dependencies: ["OHMySQL"],
            path: "OHMySQL/Tests",
            
        ),
    ]
)