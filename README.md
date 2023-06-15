<h1 align="center">🤐 StealthyStash </h1>

A Swifty database interface into the Keychain Services.

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
* [Usage](#usage)
* [References](#references)
* [License](#license)

# Introduction

**StealthyState** provides an pluggable easy abstract layer for accessing Keychain data as well as an API for encoding and decoding complex data in the Keychain. 

## Requirements 

**Apple Platforms**

- Xcode 14.3.1 or later
- Swift 5.8 or later
- iOS 14 / watchOS 7 / tvOS 14 / macOS 12 or later deployment targets

**Linux**

- Ubuntu 18.04 or later
- Swift 5.8 or later

## Installation

Use the Swift Package Manager to install this library via the repository url:

```
https://github.com/brightdigit/StealthyStash.git
```

Use version up to `1.0`.

# Usage

## Accessing the Keychain like a Database

**StealthyState** supports the adding, updating, and querying for both generic and internet passwords. To do this you need to create a ``KeychainRepository`` to access the database to.

```
let repository = KeychainRepository(
  defaultServiceName: "com.brightdigit.KeychainSyncDemo",
  defaultServerName: "com.brightdigit.KeychainSyncDemo",
  defaultAccessGroup: "MLT7M394S7.com.brightdigit.KeychainSyncDemo"
)
```

To call ``KeychainRepository.init(defaultServiceName:defaultServerName:defaultAccessGroup:defaultSynchronizable:logger:)`` you need to supply a the default ``InternetPasswordItem/server`` and ``GenericPasswordItem/service`` which is required by both types to query and create.

> You can also supply a `logger` to use for logging as well as an ``InternetPasswordItem.accessGroup`` for your ``InternetPasswordItem`` and ``GenericPasswordItem.accessGroup`` for your ``GenericPasswordItem``

To query, update, or add a new password, check out the documentation under ``StealthyRepository``.

## Using `StealthyModel` for Composite Objects

In many cases, you may want to use multiple items to store a single object such as the user's password with ``InternetPasswordItem`` as well as their token via ``GenericPasswordItem``. In this case, you'll want to use a ``StealthyModel``:

```swift
struct CompositeCredentials: StealthyModel {
  typealias QueryBuilder = CompositeCredentialsQueryBuilder

  internal init(userName: String, password: String?, token: String?) {
    self.userName = userName
    self.password = password
    self.token = token
  }

  let userName: String

  let password: String?

  let token: String?
}
```

This is the perfect use case for ``StealthyModel`` and it only requires the implementation of a ``ModelQueryBuilder`` which defines how to build the queries for creating, updating, and deleting ``StealthyModel`` objects from the keychain:

* ``ModelQueryBuilder.updates(from:to:)`` require you to build an array of ``StealthyPropertyUpdate`` object which define the previous and new properties for the Keychain. Both the previous and new are optional in case you are only adding a new item as part of the update or only removing an old item.

* ``ModelQueryBuilder.properties(from:for:)`` is for creating a new model and requires the individual ``AnyStealthyProperty`` for each item to add to the keychain.

* ``ModelQueryBuilder.model(from:)`` builds the ``StealthyModel`` based on the ``AnyStealthyProperty`` items

* ``ModelQueryBuilder.queries(from:)`` builds a query dictionary depending the ``ModelQueryBuilder.QueryType`` passed. The keys to the query dictionary will be used by ``ModelQueryBuilder.model(from:)`` to define the keys of their resulting ``AnyStealthyProperty``. If there's only one object in your app, you can define ``ModelQueryBuilder.QueryType`` as `Void`:

```
static func queries(from _: Void) -> [String: Query] {
  [
    "password": TypeQuery(type: .internet),
    "token": TypeQuery(type: .generic)
  ]
}
```

For more help, take a look at the `Sample` project located in the Swift Package.

# References

* [Using the Keychain to Manage User Secret](https://developer.apple.com/documentation/security/keychain_services/keychain_items/using_the_keychain_to_manage_user_secrets)

# License 

This code is distributed under the MIT license. See the [LICENSE](https://github.com/brightdigit/StealthyStash/LICENSE) file for more info.
