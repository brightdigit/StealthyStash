// swift-tools-version: 5.7

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
  ],
  targets: [
    .target(
      name: "StealthyStash",
      dependencies: []
    ),
    .testTarget(
      name: "StealthyStashTests",
      dependencies: ["StealthyStash"]
    )
  ]
)
