
public struct UpdateQuerySet {
  public init(query: [String : Any?], attributes: [String : Any?], id: String) {
    self.query = query
    self.attributes = attributes
    self.id = id
  }
  
  public let query : [String : Any?]
  public let attributes : [String : Any?]
  public let id : String
}

extension UpdateQuerySet {
  fileprivate typealias DeepUnwrappable = _OptionalProtocol
  
  static func deepUnwrap(_ any: Any) -> Any? {
      if let optional = any as? _OptionalProtocol {
          return optional._deepUnwrapped
      }
      return any
  }
  
  func merging (with rhs: SecretDictionary, overwrite : Bool) -> Self {
    let rhs = rhs.mapValues(Self.deepUnwrap).compactMapValues{$0}
    let newQuery = query.mapValues(Self.deepUnwrap).compactMapValues{$0}.merging(with: rhs, overwrite: overwrite)
    //let attributes = attributes.merging(with: rhs, overwrite: overwrite)
    return .init(query: newQuery, attributes: attributes, id: id)
  }
}

private protocol _OptionalProtocol {
    var _deepUnwrapped: Any? { get }
}

extension Optional: UpdateQuerySet.DeepUnwrappable {
    fileprivate var _deepUnwrapped: Any? {
        if let wrapped = self { return UpdateQuerySet.deepUnwrap(wrapped) }
        return nil
    }
}
