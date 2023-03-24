import Foundation

extension Data {
  func string(encoding: String.Encoding = .utf8) -> String? {
    String(data: self, encoding: encoding)
  }
}
