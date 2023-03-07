import Foundation
import FloxBxAuth
import Combine

class CredentialPropertyObject : ObservableObject {
  internal init( repository: SecretsRepository, item: SecretPropertyBuilder, original: AnySecretProperty?) {
    self.item = item
    self.repository = repository
    self.originalItem = original
    
    let savePublisher = saveTriggerSubject
      .map{self.item}
      .tryMap(AnySecretProperty.init)
      .tryMap { item in
        try self.repository.upsert(from: self.originalItem, to: item.property)
       
      }
      .share()
    
    let successPublisher = savePublisher
      .map(Optional<Void>.some)
      .replaceError(with: Optional<Void>.none)
      .compactMap{$0}
      .share()
    
    successPublisher
      .tryMap{try self.item.saved()}
      .assertNoFailure()
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$item)
    
    saveCompletedCancellable = successPublisher
      .subscribe(self.saveCompletedSubject)
    
    savePublisher
      .map{Optional<Error>.none}
      .catch{Just(Optional.some($0))}
      .compactMap{$0 as? KeychainError}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
   
    clearErrorSubject
      .filter{$0 == self.lastError}
      .map{_ in Optional<KeychainError>.none}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
  }
  
  func save () {
    self.saveTriggerSubject.send()
  }
  
  func clearError (_ error: KeychainError) {
    self.clearErrorSubject.send(error)
  }
  
  
  @Published var lastError: KeychainError?
  @Published var item : SecretPropertyBuilder
  let saveTriggerSubject = PassthroughSubject<Void, Never>()
  let clearErrorSubject = PassthroughSubject<KeychainError, Never>()
  let saveCompletedSubject = PassthroughSubject<Void, Never>()
  let repository : SecretsRepository
  let originalItem : AnySecretProperty?
  var saveCompletedCancellable : AnyCancellable!
  
  var saveCompleted : AnyPublisher<Void, Never> {
    return self.saveCompletedSubject.eraseToAnyPublisher()
  }
}

extension CredentialPropertyObject {
  convenience init(repository: SecretsRepository, item: AnySecretProperty) {
    self.init(repository: repository, item: .init(item: item), original: item)
  }
  
  convenience init(repository: SecretsRepository, type:  SecretPropertyType) {
    self.init(repository: repository, item: .init(secClass: type), original: nil)
  }
}
