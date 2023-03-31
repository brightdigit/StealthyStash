import Combine
import SwiftUI

extension Int {
  internal func trimZero() -> Int? {
    self == 0 ? nil : self
  }
}
