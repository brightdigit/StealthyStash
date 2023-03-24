import Combine
import SwiftUI

extension Int {
  func trimZero() -> Int? {
    self == 0 ? nil : self
  }
}
