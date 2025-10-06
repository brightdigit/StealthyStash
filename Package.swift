// swift-tools-version: 5.8

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let swiftSettings: [SwiftSetting] = [
 .enableUpcomingFeature("BareSlashRegexLiterals"),
 .enableUpcomingFeature("ConciseMagicFile"),
 .enableUpcomingFeature("ExistentialAny"),
 .enableUpcomingFeature("ForwardTrailingClosures"),
 .enableUpcomingFeature("ImplicitOpenExistentials"),
 .enableUpcomingFeature("StrictConcurrency"),
 .enableExperimentalFeature("AccessLevelOnImport"),
 .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks",
    // Warn about functions with >100 lines
    "-Xfrontend", "-warn-long-function-bodies=100",
    // Warn about slow type checking expressions
    "-Xfrontend", "-warn-long-expression-type-checking=100"])
]

let package = Package(
  name: "StealthyStash",
  platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v7), .tvOS(.v14)],
  products: [
    .library(
      name: "StealthyStash",
      targets: ["StealthyStash"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "StealthyStash",
      dependencies: [],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "StealthyStashTests",
      dependencies: ["StealthyStash"],
      swiftSettings: swiftSettings
    )
  ]
)
