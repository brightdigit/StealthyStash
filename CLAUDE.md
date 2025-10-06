# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

StealthyStash is a Swift Package Manager library that provides a Swifty database interface into macOS/iOS Keychain Services. It supports storing and retrieving both generic and internet passwords with an abstraction layer for complex composite objects.

## Key Architecture

The library is built around several core protocols and types:

- **StealthyRepository**: Main protocol for storing/retrieving keychain items. Implemented by `KeychainRepository`.
- **StealthyProperty**: Protocol for individual keychain items (`GenericPasswordItem`, `InternetPasswordItem`).
- **StealthyModel**: Protocol for composite objects that span multiple keychain items.
- **ModelQueryBuilder**: Defines how to build queries for creating, updating, and deleting `StealthyModel` objects.
- **Query**: Protocol for querying the keychain (TypeQuery, etc.).

The codebase uses conditional compilation (`#if canImport(Security)`) to support both Apple platforms (using Keychain Services) and Linux (using swift-log).

## Development Commands

### Building
```bash
swift build
```

### Testing
```bash
# Run all tests
swift test

# Run specific test
swift test --filter <test-name>
```

### Documentation
The library includes DocC documentation in `Sources/StealthyStash/Documentation.docc/`.

## Swift Configuration

This project has two package manifests:
- `Package.swift`: Uses Swift 5.8 tools version with basic upcoming features
- `Package@swift-6.0.swift`: Uses Swift 6.0 with extensive experimental features

Key compiler settings (especially in Swift 6.0 manifest):
- Strict concurrency checking (`-strict-concurrency=complete`)
- Actor data race checks
- Long function/expression warnings (>100 lines/ms)
- Experimental features: `BitwiseCopyable`, `NoncopyableGenerics`, `MoveOnlyClasses`, `VariadicGenerics`, and many more

When adding new code:
- Ensure it follows the strict concurrency model (all types must be `Sendable` where appropriate)
- Avoid long functions or expressions (>100 lines)
- Use `#if swift(>=6.0)` for Swift version-specific code
- Use `#if canImport(Security)` for platform-specific code (Apple platforms vs Linux)

## Platform Support

- **Apple Platforms**: iOS 14+, macOS 12+, watchOS 7+, tvOS 14+
- **Linux**: Ubuntu 18.04+
- **Swift**: 5.8+ (Swift 6.0+ for development)

## Working with StealthyModel and ModelQueryBuilder

`StealthyModel` allows composite objects spanning multiple keychain items. A `ModelQueryBuilder` implementation must provide:

1. **`queries(from:)`**: Returns dictionary of Query objects keyed by property names
2. **`model(from:)`**: Builds model from dictionary of `[String: [AnyStealthyProperty]]`
3. **`properties(from:for:)`**: Extracts `AnyStealthyProperty` array from model for create/delete operations
4. **`updates(from:to:)`**: Creates `StealthyPropertyUpdate` array for model updates

Example implementations in `Samples/Demo/App/Keychain/`:
- `CompositeCredentials.swift`: Simple model with username, password, and token
- `CompositeCredentialsQueryBuilder.swift`: Full `ModelQueryBuilder` implementation pattern