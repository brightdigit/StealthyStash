// swift-tools-version: 6.0

// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription
// swiftlint:disable:next explicit_top_level_acl explicit_acl
let swiftSettings: [SwiftSetting] = [
  // Swift 6.2 Upcoming Features (not yet enabled by default)
  // SE-0335: Introduce existential `any`
  .enableUpcomingFeature("ExistentialAny"),
  // SE-0409: Access-level modifiers on import declarations
  .enableUpcomingFeature("InternalImportsByDefault"),
  // SE-0444: Member import visibility (Swift 6.1+)
  .enableUpcomingFeature("MemberImportVisibility"),
  // SE-0413: Typed throws
  .enableUpcomingFeature("FullTypedThrows"),

  // Experimental Features (stable enough for use)
  // SE-0426: BitwiseCopyable protocol
  .enableExperimentalFeature("BitwiseCopyable"),
  // SE-0432: Borrowing and consuming pattern matching for noncopyable types
  .enableExperimentalFeature("BorrowingSwitch"),
  // Extension macros
  .enableExperimentalFeature("ExtensionMacros"),
  // Freestanding expression macros
  .enableExperimentalFeature("FreestandingExpressionMacros"),
  // Init accessors
  .enableExperimentalFeature("InitAccessors"),
  // Isolated any types
  .enableExperimentalFeature("IsolatedAny"),
  // Move-only classes
  .enableExperimentalFeature("MoveOnlyClasses"),
  // Move-only enum deinits
  .enableExperimentalFeature("MoveOnlyEnumDeinits"),
  // SE-0429: Partial consumption of noncopyable values
  .enableExperimentalFeature("MoveOnlyPartialConsumption"),
  // Move-only resilient types
  .enableExperimentalFeature("MoveOnlyResilientTypes"),
  // Move-only tuples
  .enableExperimentalFeature("MoveOnlyTuples"),
  // SE-0427: Noncopyable generics
  .enableExperimentalFeature("NoncopyableGenerics"),
  // One-way closure parameters
  // .enableExperimentalFeature("OneWayClosureParameters"),
  // Raw layout types
  .enableExperimentalFeature("RawLayout"),
  // Reference bindings
  .enableExperimentalFeature("ReferenceBindings"),
  // SE-0430: sending parameter and result values
  .enableExperimentalFeature("SendingArgsAndResults"),
  // Symbol linkage markers
  .enableExperimentalFeature("SymbolLinkageMarkers"),
  // Transferring args and results
  .enableExperimentalFeature("TransferringArgsAndResults"),
  // SE-0393: Value and Type Parameter Packs
  .enableExperimentalFeature("VariadicGenerics"),
  // Warn unsafe reflection
  .enableExperimentalFeature("WarnUnsafeReflection"),

  // Enhanced compiler checking
  .unsafeFlags([
    // Enable concurrency warnings
    "-warn-concurrency",
    // Enable actor data race checks
    "-enable-actor-data-race-checks",
    // Complete strict concurrency checking
    "-strict-concurrency=complete",
    // Enable testing support
    "-enable-testing",
    // Warn about functions with >100 lines
    "-Xfrontend", "-warn-long-function-bodies=100",
    // Warn about slow type checking expressions
    "-Xfrontend", "-warn-long-expression-type-checking=100"
  ])
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
  dependencies: [
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
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "StealthyStashTests",
      dependencies: ["StealthyStash"],
      swiftSettings: swiftSettings
    )
  ]
)
