// swift-tools-version: 5.9

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription
import CompilerPluginSupport

// let swiftSettings: [SwiftSetting] = [
//  .enableUpcomingFeature("BareSlashRegexLiterals"),
//  .enableUpcomingFeature("ConciseMagicFile"),
//  .enableUpcomingFeature("ExistentialAny"),
//  .enableUpcomingFeature("ForwardTrailingClosures"),
//  .enableUpcomingFeature("ImplicitOpenExistentials"),
//  .enableUpcomingFeature("StrictConcurrency"),
//  .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"])
// ]

let package = Package(
  name: "StealthyStash",
  platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v7), .tvOS(.v14), .macCatalyst(.v14), .visionOS(.v1)],
  products: [
    .library(
      name: "StealthyStash",
      targets: ["StealthyStash"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-syntax", from: "510.0.0")
  ],
  targets: [
    .macro(
        name: "StealthyStashMacros",
        dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
        ]
    ),
    .target(
      name: "StealthyStash",
      dependencies: [
        .product(
          name: "Logging",
          package: "swift-log",
          condition: .when(platforms: [.linux, .android, .windows, .wasi])
        )
      ]
    ),
    .testTarget(
      name: "StealthyStashTests",
      dependencies: ["StealthyStash"]
    )
  ]
)
