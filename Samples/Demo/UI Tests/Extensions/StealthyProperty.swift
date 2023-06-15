import StealthyStash
extension StealthyProperty {
  var dataString: String {
    String(data: data, encoding: .utf8) ?? ""
  }
}
