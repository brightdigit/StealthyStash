import Combine
import Foundation
import StealthyStash

class CredentialPropertyObject: ObservableObject {
  internal init(repository: StealthyRepository, triggerSet: TriggerSet, item: StealthyPropertyBuilder, original: AnyStealthyProperty?) {
    self.item = item
    self.repository = repository
    originalItem = original

    
    let savePublisher = saveTriggerSubject
      .map { self.item }
      .tryMap(AnyStealthyProperty.init)
      .tryMap { item in
        try self.repository.upsert(from: self.originalItem, to: item.property)
      }
      .share()

    let successSavePublisher = savePublisher
      .map(Void?.some)
      .replaceError(with: Void?.none)
      .compactMap { $0 }
      .share()

    successSavePublisher
      .tryMap { try self.item.saved() }
      .assertNoFailure()
      .receive(on: DispatchQueue.main)
      .assign(to: &$item)

    savePublisher
      .map { Error?.none }
      .catch { Just(Optional.some($0)) }
      .compactMap{$0}
      .print()
      .compactMap { $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &$lastError)

    clearErrorSubject
      .filter { $0 == self.lastError }
      .map { _ in KeychainError?.none }
      .receive(on: DispatchQueue.main)
      .assign(to: &$lastError)

    let deletePublisher = deleteTriggerSubject
      .map { self.item }
      .tryMap(AnyStealthyProperty.init)
      .tryMap { item in
        try self.repository.delete(item)
      }
      .share()
    let successDeletePublisher = deletePublisher
      .map(Void?.some)
      .replaceError(with: Void?.none)
      .compactMap { $0 }
      .share()

    deletePublisher
      .map { Error?.none }
      .catch { Just(Optional.some($0)) }
      .compactMap { $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &$lastError)

    updateCompletedCancellable = Publishers.Merge(successSavePublisher, successDeletePublisher)
      .subscribe(updateCompletedSubject)

    saveCompletedCancellable = updateCompleted.subscribe(triggerSet.saveCompletedTrigger)
  }

  func save() {
    saveTriggerSubject.send()
  }

  func clearError(_ error: KeychainError) {
    clearErrorSubject.send(error)
  }

  func delete() {
    deleteTriggerSubject.send()
  }

  @Published var lastError: KeychainError?
  @Published var item: StealthyPropertyBuilder
  let saveTriggerSubject = PassthroughSubject<Void, Never>()
  let deleteTriggerSubject = PassthroughSubject<Void, Never>()
  let clearErrorSubject = PassthroughSubject<KeychainError, Never>()
  let updateCompletedSubject = PassthroughSubject<Void, Never>()
  let repository: StealthyRepository
  let originalItem: AnyStealthyProperty?
  var saveCompletedCancellable: AnyCancellable!
  var updateCompletedCancellable: AnyCancellable!

  var updateCompleted: AnyPublisher<Void, Never> {
    updateCompletedSubject.eraseToAnyPublisher()
  }
}

extension CredentialPropertyObject {
  convenience init(repository: StealthyRepository, item: AnyStealthyProperty) {
    self.init(repository: repository, triggerSet: .init(), item: .init(item: item), original: item)
  }

  convenience init(repository: StealthyRepository, type: StealthyPropertyType) {
    self.init(repository: repository, triggerSet: .init(), item: .init(secClass: type), original: nil)
  }
}
