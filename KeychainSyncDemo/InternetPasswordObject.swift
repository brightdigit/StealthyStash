import Foundation
import FloxBxAuth
import Combine

class InternetPasswordObject : ObservableObject {
  internal init( repository: CredentialsRepository, item: InternetPasswordItemBuilder, isNew: Bool) {
    self.item = item
    self.repository = repository
    self.isNew = isNew
    
    let savePublisher = saveTriggerSubject
      .map{self.item}
      .map(InternetPasswordItem.init)
      .tryMap { item in
        if self.isNew {
          try self.repository.create(item)
        } else {
          try self.repository.update(item)
        }
      }
      .share()
    
    let successPublisher = savePublisher
      .map(Optional<Void>.some)
      .replaceError(with: Optional<Void>.none)
      .compactMap{$0}
      .share()
    
    successPublisher
      .map{self.item.saved()}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$item)
    
    saveCompletedCancellable = successPublisher
      .subscribe(self.saveCompletedSubject)
    
    savePublisher
      .map{Optional<Error>.none}
      .catch{Just(Optional.some($0))}
      .compactMap{$0 as? KeychainError}
      .receive(on: DispatchQueue.main)
      .print()
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
  @Published var item : InternetPasswordItemBuilder
  let saveTriggerSubject = PassthroughSubject<Void, Never>()
  let clearErrorSubject = PassthroughSubject<KeychainError, Never>()
  let saveCompletedSubject = PassthroughSubject<Void, Never>()
  let repository : CredentialsRepository
  let isNew : Bool
  var saveCompletedCancellable : AnyCancellable!
  
  var saveCompleted : AnyPublisher<Void, Never> {
    return self.saveCompletedSubject.eraseToAnyPublisher()
  }
}

extension InternetPasswordObject {
  convenience init(repository: CredentialsRepository, item: InternetPasswordItem? = nil) {
    self.init(repository: repository, item: .init(item: item), isNew: item == nil)
  }
}
