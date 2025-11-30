// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "securx",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "securx", targets: ["securx"])
    ],
    dependencies: [
        .package(url: "https://github.com/thii/DTTJailbreakDetection.git", from: "0.4.0"),
        .package(url: "https://github.com/prongbang/ScreenProtectorKit.git", from: "1.3.1")
    ],
    targets: [
        .target(
            name: "securx",
            dependencies: [
                "DTTJailbreakDetection",
                "ScreenProtectorKit"
            ],
            path: ".",
            sources: ["Classes"],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
