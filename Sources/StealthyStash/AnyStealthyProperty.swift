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
  /// The account associated with the property.
  public var account: String {
    property.account
  }

  /// The data stored in the property.
  public var data: Data {
    property.data
  }

  /// The access group for the property.
  public var accessGroup: String? {
    property.accessGroup
  }

  /// The creation date of the property.
  public var createdAt: Date? {
    property.createdAt
  }

  /// The modification date of the property.
  public var modifiedAt: Date? {
    property.modifiedAt
  }

  /// A description of the property.
  public var description: String? {
    property.description
  }

  /// A comment associated with the property.
  public var comment: String? {
    property.comment
  }

  /// The type value of the property.
  public var type: Int? {
    property.type
  }

  /// The label of the property.
  public var label: String? {
    property.label
  }

  /// Whether the property is synchronizable.
  public var isSynchronizable: Synchronizable {
    property.isSynchronizable
  }

  /// The service associated with the property.
  public var service: String? {
    guard let property = self.property as? GenericPasswordItem else {
      return nil
    }
    return property.service
  }

  /// The server associated with the password item.
  public var server: String? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.server
  }

  /// The protocol used by the server.
  public var `protocol`: ServerProtocol? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.protocol
  }

  /// The port used by the server.
  public var port: Int? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.port
  }

  /// The path of the server.
  public var path: String? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.path
  }
}

extension AnyStealthyProperty {
  /// The property type which can be stored securely.
  public var propertyType: StealthyPropertyType {
    Swift.type(of: property).propertyType
  }
}
