extension Int {
  /// Returns `nil` if the integer is zero, otherwise returns the integer itself.
  /// - Returns: An optional integer.
  internal func trimZero() -> Int? {
    self == 0 ? nil : self
  }
}
