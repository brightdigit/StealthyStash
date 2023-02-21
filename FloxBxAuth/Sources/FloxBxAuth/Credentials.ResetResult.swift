import Foundation

// swiftlint:disable:next file_types_order
extension Credentials {
  public struct ResetResult: OptionSet {
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    public var rawValue: Int

    // swiftlint:disable:next nesting
    public typealias RawValue = Int

    public static let password: Self = .init(rawValue: 1)
    public static let token: Self = .init(rawValue: 2)
  }
}

extension Credentials.ResetResult {
  public init(didDeletePassword: Bool, didDeleteToken: Bool) {
    let didDeleteToken: Self? = didDeleteToken ? .token : nil
    let didDeletePassword: Self? = didDeletePassword ? .password : nil
    self = .init([didDeleteToken, didDeletePassword].compactMap { $0 })
  }
}
