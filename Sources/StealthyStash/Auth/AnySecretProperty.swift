import Foundation

public struct AnySecretProperty: Identifiable, Hashable {
  public init(property: any SecretProperty) {
    self.property = property
  }

  public static func == (lhs: AnySecretProperty, rhs: AnySecretProperty) -> Bool {
    Swift.type(of: lhs.property).propertyType == Swift.type(of: rhs.property).propertyType
      && lhs.id == rhs.id
  }

  public var id: String {
    property.id
  }

  public let property: any SecretProperty

  public func hash(into hasher: inout Hasher) {
    hasher.combine(property)
  }
}

extension AnySecretProperty {
  public var account: String {
    property.account
  }

  public var data: Data {
    property.data
  }

  public var dataString: String {
    property.dataString
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

  public var isSynchronizable: Bool? {
    property.isSynchronizable
  }

  public var server: String? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.server
  }

  public var service: String? {
    guard let property = self.property as? GenericPasswordItem else {
      return nil
    }
    return property.service
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

  public init(builder: SecretPropertyBuilder) throws {
    let property = try builder.secClass.propertyType.init(builder: builder)
    self.init(property: property)
  }
}

extension AnySecretProperty {
  init(propertyType: SecretPropertyType, dictionary: [String: Any]) throws {
    let property = try propertyType.propertyType.init(dictionary: dictionary)
    self.init(property: property)
  }
}

extension AnySecretProperty {
  public var propertyType: SecretPropertyType {
    Swift.type(of: property).propertyType
  }
}
