// swift-tools-version:5.3

import PackageDescription

let productName: String = "Minimum"
let package: Package = .init(
    name: productName,
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6)
    ],
    products: [
        .library(name: productName, targets: [productName])
    ],
    targets: [
        .target(name: productName, path: "Sources"),
        .testTarget(name: productName + "Tests",
                    dependencies: [.target(name: productName)],
                    path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
