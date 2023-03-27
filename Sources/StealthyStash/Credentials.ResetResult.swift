// import Foundation
//
//// swiftlint:disable:next file_types_order
// extension Credentials {
//  struct ResetResult: OptionSet {
//    init(rawValue: Int) {
//      self.rawValue = rawValue
//    }
//
//    var rawValue: Int
//
//    // swiftlint:disable:next nesting
//    typealias RawValue = Int
//
//    static let password: Self = .init(rawValue: 1)
//    static let token: Self = .init(rawValue: 2)
//  }
// }
//
// extension Credentials.ResetResult {
//  init(didDeletePassword: Bool, didDeleteToken: Bool) {
//    let didDeleteToken: Self? = didDeleteToken ? .token : nil
//    let didDeletePassword: Self? = didDeletePassword ? .password : nil
//    self = .init([didDeleteToken, didDeletePassword].compactMap { $0 })
//  }
// }
