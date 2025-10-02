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
swift test
```

### Documentation
The library includes DocC documentation in `Sources/StealthyStash/Documentation.docc/`.

## Swift Configuration

This project uses Swift 6.0 with extensive upcoming and experimental features enabled, including:
- Strict concurrency checking (`-strict-concurrency=complete`)
- Actor data race checks
- Long function/expression warnings (>100 lines/ms)
- Various Swift 6.1+ and experimental features

When adding new code, ensure it follows the strict concurrency model and Swift 6 requirements.

## Platform Support

- **Apple Platforms**: iOS 14+, macOS 12+, watchOS 7+, tvOS 14+
- **Linux**: Ubuntu 18.04+
- **Swift**: 5.8+ (Swift 6.0+ for development)

## Sample Code

The `Samples/Demo/App/` directory contains example implementations showing how to use `StealthyModel` and `ModelQueryBuilder` for composite credential objects.