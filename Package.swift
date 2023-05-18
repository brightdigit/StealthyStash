// swift-tools-version: 5.7

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let package = Package(
  name: "StealthyStash",
  platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v7)],
  products: [
    .library(
      name: "StealthyStash",
      targets: ["StealthyStash"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
  ],
  targets: [
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
