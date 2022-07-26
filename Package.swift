// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "GUActomaton",
    platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "GUActomaton",
            targets: ["GUActomaton", "GUActomatonDebugging"]),
        .library(
            name: "GUActomatonUI",
            targets: ["GUActomatonUI"]),
        .library(
            name: "GUActomatonStore",
            targets: ["GUActomatonStore", "GUActomatonDebugging"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "GUActomaton",
            dependencies: [.product(name: "CasePaths", package: "swift-case-paths")],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .target(
            name: "GUActomatonStore",
            dependencies: [
                "GUActomaton"
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .target(
            name: "GUActomatonUI",
            dependencies: [
                "GUActomaton", "GUActomatonDebugging"
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .target(
            name: "GUActomatonDebugging",
            dependencies: [
                "GUActomaton",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]),
        .target(
            name: "TestFixtures",
            dependencies: ["GUActomaton"],
            path: "./Tests/TestFixtures",
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .testTarget(
            name: "GUActomatonTests",
            dependencies: ["GUActomaton", "TestFixtures"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .testTarget(
            name: "GUActomatonStoreTests",
            dependencies: ["GUActomatonStore", "TestFixtures"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .testTarget(
            name: "GUActomatonUITests",
            dependencies: ["GUActomatonUI", "TestFixtures"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        ),
        .testTarget(
            name: "ReadMeTests",
            dependencies: ["GUActomatonStore", "GUActomatonDebugging"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks",
                ])
            ]
        )
    ]
)
