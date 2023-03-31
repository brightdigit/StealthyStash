import Combine
import Foundation
import StealthyStash

class CredentialPropertyListObject: ObservableObject {
  internal init(repository: StealthyRepository, triggerSet: TriggerSet, internetPasswords: [AnyStealthyProperty] = [], isLoaded: Bool = false) {
    self.repository = repository
    credentialProperties = internetPasswords
    self.isLoaded = isLoaded

    let queryPublisher = querySubject
      .combineLatest(triggerSet.receiveUpdatePublisher.prepend(())) { query, _ in query }
      .tryMap(self.repository.query(_:))
      .share()

    queryPublisher
      .map { _ in Error?.none }
      .catch { Just(Error?.some($0)) }
      .compactMap { $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &$lastError)

    let loadedCompleted = queryPublisher
      .map([AnyStealthyProperty]?.some)
      .replaceError(with: nil)
      .compactMap { $0 }
      .share()

    loadedCompleted
      .receive(on: DispatchQueue.main)
      .assign(to: &$credentialProperties)

    loadedCompleted
      .map { _ in true }
      .receive(on: DispatchQueue.main)
      .assign(to: &$isLoaded)
  }

  let repository: StealthyRepository
  @Published var credentialProperties: [AnyStealthyProperty]
  @Published var isLoaded = false
  let querySubject = PassthroughSubject<Query, Never>()
  @Published var lastError: KeychainError?

  func query(_ query: Query) {
    querySubject.send(query)
  }
}
