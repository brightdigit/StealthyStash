<p align="center">
    <img alt="StealthyStash" title="StealthyStash" src="Assets/logo.svg" height="200">
</p>
<h1 align="center"> StealthyStash </h1>

A Swifty interface into the Keychain Services.

[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@brightdigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
![GitHub](https://img.shields.io/github/license/brightdigit/StealthyStash)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/StealthyStash)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/brightdigit/StealthyStash/StealthyStash.yml?label=actions&logo=github&?branch=main)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FStealthyStash%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brightdigit/StealthyStash)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FStealthyStash%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brightdigit/StealthyStash)


[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/StealthyStash)](https://codecov.io/gh/brightdigit/StealthyStash)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/brightdigit/StealthyStash)](https://www.codefactor.io/repository/github/brightdigit/StealthyStash)
[![codebeat badge](https://codebeat.co/badges/54695d4b-98c8-4f0f-855e-215500163094)](https://codebeat.co/projects/github-com-brightdigit-StealthyStash-main)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/brightdigit/StealthyStash)](https://codeclimate.com/github/brightdigit/StealthyStash)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/brightdigit/StealthyStash?label=debt)](https://codeclimate.com/github/brightdigit/StealthyStash)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/brightdigit/StealthyStash)](https://codeclimate.com/github/brightdigit/StealthyStash)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

# Table of Contents

* [Introduction](#introduction)
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [Why use Base32Crockford](#why-use-base32crockford)
* [Usage](#usage)
   * [Encoding and Decoding Data](#encoding-and-decoding-data)
      * [How Checksum Works](#how-checksum-works)
      * [Using Group Separators](#using-group-separators)
   * [Creating an Identifier](#creating-an-identifier)
      * [What is ULID?](#what-is-ulid)
* [References](#references)
* [License](#license)

# Introduction

**StealthyStash** provides a way to encode data and create identifiers which is both efficient and human-readable. While Base64 is more efficient it is not very human-readable with both both upper case and lower case letters as well as punctuation.

## Requirements 

**Apple Platforms**

- Xcode 13.3 or later
- Swift 5.5.2 or later
- iOS 14 / watchOS 6 / tvOS 14 / macOS 12 or later deployment targets

**Linux**

- Ubuntu 18.04 or later
- Swift 5.5.2 or later

## Installation

Use the Swift Package Manager to install this library via the repository url:

```
https://github.com/brightdigit/StealthyStash.git
```

Use version up to `1.0`.

## Why use Base32Crockford

Base32Crockford offers the most reasonable compromise when it comes to encoding data. Being a super set of Base16, it uses all ten digits and 22 of the 26 Latin upper case characters.

| Symbol Value   | Decode Symbol   | Encode Symbol   |
|:------------:  |:-------------:  |:-------------:  |
| 0              | 0 O o           | 0               |
| 1              | 1 I i L l       | 1               |
| 2              | 2               | 2               |
| 3              | 3               | 3               |
| 4              | 4               | 4               |
| 5              | 5               | 5               |
| 6              | 6               | 6               |
| 7              | 7               | 7               |
| 8              | 8               | 8               |
| 9              | 9               | 9               |
| 10             | A a             | A               |
| 11             | B b             | B               |
| 12             | C c             | C               |
| 13             | D d             | D               |
| 14             | E e             | E               |
| 15             | F f             | F               |
| 16             | G g             | G               |
| 17             | H h             | H               |
| 18             | J j             | J               |
| 19             | K k             | K               |
| 20             | M m             | M               |
| 21             | N n             | N               |
| 22             | P p             | P               |
| 23             | Q q             | Q               |
| 24             | R r             | R               |
| 25             | S s             | S               |
| 26             | T t             | T               |
| 27             | V v             | V               |
| 28             | W w             | W               |
| 29             | X x             | X               |
| 30             | Y y             | Y               |
| 31             | Z z             | Z               |

# Usage

**StealthyStash** enables the encoding and decoding data in _Base32Crockford_ as well as creation of unique identifiers. There are a variety of options available for encoding and decoding.

## Encoding and Decoding Data

All encoding and decoding is done through the `Base32CrockfordEncoding.encoding` object. This provides an interface into encoding and decoding data as well standardizing. 

To encode any data call:

```swift
public func encode(
    data: Data,
    options: Base32CrockfordEncodingOptions = .none
  ) -> String
```

Therefore to encode a `Data` object, simply call via:

```swift
let data : Data // 0x00b003786a8d4aa28411f4e268c43629 
let base32String = Base32CrockfordEncoding.encoding.encode(data: data)
print(base32String) // P01QGTMD9AH884FMW9MC8DH9
```

If you wish to decode the string you can call `Base32CrockfordEncoding.decode`:

```swift
let data = try Base32CrockfordEncoding.encoding.decode(
    base32Encoded: "P01QGTMD9AH884FMW9MC8DH9"
) // 0x00b003786a8d4aa28411f4e268c43629
```

The `Base32CrockfordEncoding.encode` object provides the ability to specify options on formatting and a checksum.

### How Checksum Works

You can optionally provide a checksum character at the end which allows for detecting transmission and entry errors early and inexpensively.

According to the specification:

> The check symbol encodes the number modulo 37, 37 being the least prime number greater than 32. We introduce 5 additional symbols that are used only for encoding or decoding the check symbol.

The additional 5 symbols are:

| Symbol Value   | Decode Symbol   | Encode Symbol   |
|----  |-----  |---  |
| 32   | *     | *   |
| 33   | ~     | ~   |
| 34   | $     | $   |
| 35   | =     | =   |
| 36   | U u   | U   |

If you wish to include the checksum, pass true for the `withChecksum` property on the `Base32CrockfordEncodingOptions` object:

```swift
let data : Data // 0xb63d798c4329401684d1d41d3becc95c
let base32String = Base32CrockfordEncoding.encoding.encode(
    data: data,
    options: .init(withChecksum: true)
)
print(base32String) // 5P7NWRRGS980B89MEM3MXYSJAW5
```

When decoding a string wtih a checksum, you must specify true for the `withChecksum` property on `Base32CrockfordDecodingOptions`:

```swift
let data = try Base32CrockfordEncoding.encoding.decode(
    base32Encoded: "5P7NWRRGS980B89MEM3MXYSJAW5"a,
    options: .init(withChecksum: true)
) // 0xb63d798c4329401684d1d41d3becc95c
```

Besides adding a checksum, `Base32CrockfordEncodingOptions` also provides the ability to add a grouping separator.

### Using Group Separators

According to the Base32Crockford specification:

> Hyphens (-) can be inserted into symbol strings. This can partition a string into manageable pieces, improving readability by helping to prevent confusion. Hyphens are ignored during decoding.

To insert hyphens to the encoded string, provide the `GroupingOptions` object to `Base32CrockfordEncodingOptions`:

```swift
let data : Data // 00c9c37484b85a42e8b3e7fbf806f2661b
let base32StringGroupedBy3 = Base32CrockfordEncoding.encoding.encode(
    data: data,
    options: .init(groupingBy: .init(maxLength: 3))
)
let base32StringGroupedBy9 = Base32CrockfordEncoding.encoding.encode(
    data: data,
    options: .init(groupingBy: .init(maxLength: 9))
)
print(base32StringGroupedBy3) // 69R-DT8-9E2-T8B-MB7-SZV-Z03-F4S-GV2
print(base32StringGroupedBy9) // 69RDT89E2-T8BMB7SZV-Z03F4SGV2
```

When decoding, hyphens are ignored:

```swift
let dataNoHyphens = try Base32CrockfordEncoding.encoding.decode(
    base32Encoded: "69RDT89E2T8BMB7SZVZ03F4SGV2"
) // 00c9c37484b85a42e8b3e7fbf806f2661b

let dataGroupedBy3 = try Base32CrockfordEncoding.encoding.decode(
    base32Encoded: "69R-DT8-9E2-T8B-MB7-SZV-Z03-F4S-GV2"
) // 00c9c37484b85a42e8b3e7fbf806f2661b

let dataGroupedBy9 = try Base32CrockfordEncoding.encoding.decode(
    base32Encoded: "69RDT89E2-T8BMB7SZV-Z03F4SGV2"
) // 00c9c37484b85a42e8b3e7fbf806f2661b

assert(dataNoHyphens == dataGroupedBy3) // true
assert(dataNoHyphens == dataGroupedBy9) // true
assert(dataGroupedBy3 == dataGroupedBy9) // true
```

## Creating an Identifier


**StealthyStash** offers the ability to create identifiers of different types in a universal factory. 
While `UUID` has been available to developers, this library provides a interface for creating two other types. To do this you can call `IdentifierFactory/createIdentifier(with:)` on the `Identifier/factory` to create any of the three types provided:

- `UUID` - standard universal identifier
- `ULID` - [Universally Unique Lexicographically Sortable Identifier](https://github.com/ulid)
- `UDID` - dynamicly sized random identifier

Each type has corresponding `ComposableIdentifier/Specifications`:

- `UUID` takes no specifications and be created with `IdentifierFactory.createIdentifier(_:)`
- `ULID` takes `ULID/Specifications`
- `UDID` takes `AnyIdentifierSpecifications`

Here's an example with `UDID`:

```
// create an identifier for 1 million unique IDs that is a factor of 5.
let specs = AnyIdentifierSpecifications(
  size: .minimumCount(1_000_000, factorOf: 5)
)
let identifier: UDID = Identifier.factory.createIdentifier(with: specs)
```

### What is ULID?

`ULID` serves the purpose of solving several issues with `UUID` while being compatible:

- 1.21e+24 unique ULIDs per millisecond
- Lexicographically sortable!
- Monotonic sort order (correctly detects and handles the same millisecond)

Most importantly it Uses Base32Crockford for better efficiency and readability.

To create a ULID you can either use `IdentifierFactory.createIdentifier(with:)` on `Identifier.factory`:

```
let ulid : ULID = Identifier.factory.createIdentifier(with: .parts(nil, .random(nil)))
```

or a constructor:

```
let ulid = ULID(specifications: .parts(nil, .random(nil)))
```

For most cases the default `ULID.Specifications.default` specification is sufficient. The follows the canonical spec which uses the first 6 bytes for a the timestamp and the last 10 bytes are random. Otherwise you can specify all 16 bytes with `ULID.Specifications.data(_:)` or specify which `Date` to use for the timestamp and the `RandomDataGenerator` to use for the `ULID.randomPart` of the data. 

# References

* [Base32 Specifications from crockford.com](https://www.crockford.com/base32.html)
* [ULID Specifications](https://github.com/ulid/spec)

# License 

This code is distributed under the MIT license. See the [LICENSE](https://github.com/brightdigit/StealthyStash/LICENSE) file for more info.
