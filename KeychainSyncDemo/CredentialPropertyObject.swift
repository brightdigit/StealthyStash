import Foundation
import FloxBxAuth
import Combine

class CredentialPropertyObject : ObservableObject {
  internal init( repository: SecretsRepository, triggerSet: TriggerSet, item: SecretPropertyBuilder, original: AnySecretProperty?) {
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
    
    let successSavePublisher = savePublisher
      .map(Optional<Void>.some)
      .replaceError(with: Optional<Void>.none)
      .compactMap{$0}
      .share()
    
    successSavePublisher
      .tryMap{try self.item.saved()}
      .assertNoFailure()
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$item)
    
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
    
    let deletePublisher = deleteTriggerSubject
      .map{self.item}
      .tryMap(AnySecretProperty.init)
      .tryMap { item in
        try self.repository.delete(item)
       
      }
      .share()
    let successDeletePublisher = deletePublisher
      .map(Optional<Void>.some)
      .replaceError(with: Optional<Void>.none)
      .compactMap{$0}
      .share()
    
    deletePublisher
      .map{Optional<Error>.none}
      .catch{Just(Optional.some($0))}
      .compactMap{$0 as? KeychainError}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
    
    updateCompletedCancellable = Publishers.Merge(successSavePublisher, successDeletePublisher)
      .subscribe(self.updateCompletedSubject)
    
    saveCompletedCancellable = self.updateCompleted.subscribe(triggerSet.saveCompletedTrigger)
  }
  
  func save () {
    self.saveTriggerSubject.send()
  }
  
  func clearError (_ error: KeychainError) {
    self.clearErrorSubject.send(error)
  }
  
  func delete () {
    self.deleteTriggerSubject.send()
  }
  
  
  @Published var lastError: KeychainError?
  @Published var item : SecretPropertyBuilder
  let saveTriggerSubject = PassthroughSubject<Void, Never>()
  let deleteTriggerSubject = PassthroughSubject<Void, Never>()
  let clearErrorSubject = PassthroughSubject<KeychainError, Never>()
  let updateCompletedSubject = PassthroughSubject<Void, Never>()
  let repository : SecretsRepository
  let originalItem : AnySecretProperty?
  var saveCompletedCancellable : AnyCancellable!
  var updateCompletedCancellable : AnyCancellable!
  
  var updateCompleted : AnyPublisher<Void, Never> {
    return self.updateCompletedSubject.eraseToAnyPublisher()
  }
}

extension CredentialPropertyObject {
  convenience init(repository: SecretsRepository, item: AnySecretProperty) {
    self.init(repository: repository, triggerSet: .init(), item: .init(item: item), original: item)
  }
  
  convenience init(repository: SecretsRepository, type:  SecretPropertyType) {
    self.init(repository: repository, triggerSet: .init(), item: .init(secClass: type), original: nil)
  }
}
