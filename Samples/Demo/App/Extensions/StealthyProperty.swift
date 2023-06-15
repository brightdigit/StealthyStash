import StealthyStash

extension StealthyProperty {
  public var dataString: String {
    String(data: data, encoding: .utf8) ?? ""
  }

  init(builder: StealthyPropertyBuilder) throws {
    try self.init(rawDictionary: .init(builder: builder))
  }
}
