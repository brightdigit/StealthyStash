import Foundation

public struct AnyStealthyProperty: Identifiable, Hashable {
  public let property: any StealthyProperty
  public var id: String {
    property.id
  }

  public init(property: any StealthyProperty) {
    self.property = property
  }

  public static func == (lhs: AnyStealthyProperty, rhs: AnyStealthyProperty) -> Bool {
    Swift.type(of: lhs.property).propertyType == Swift.type(of: rhs.property).propertyType
      && lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(property)
  }
}

extension AnyStealthyProperty {
  public var account: String {
    property.account
  }

  public var data: Data {
    property.data
  }

  public var accessGroup: String? {
    property.accessGroup
  }

  public var createdAt: Date? {
    property.createdAt
  }

  public var modifiedAt: Date? {
    property.modifiedAt
  }

  public var description: String? {
    property.description
  }

  public var comment: String? {
    property.comment
  }

  public var type: Int? {
    property.type
  }

  public var label: String? {
    property.label
  }

  public var isSynchronizable: Synchronizable {
    property.isSynchronizable
  }

  public var service: String? {
    guard let property = self.property as? GenericPasswordItem else {
      return nil
    }
    return property.service
  }

  public var server: String? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.server
  }

  public var `protocol`: ServerProtocol? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.protocol
  }

  public var port: Int? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.port
  }

  public var path: String? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.path
  }
}

extension AnyStealthyProperty {
  public var propertyType: StealthyPropertyType {
    Swift.type(of: property).propertyType
  }
}
