import Foundation
import Combine
import StealthyStash

class CredentialPropertyListObject : ObservableObject {
  internal init(repository: SecretsRepository, triggerSet: TriggerSet, internetPasswords: [AnySecretProperty] = [], isLoaded : Bool = false) {
    self.repository = repository
    self.credentialProperties = internetPasswords
    self.isLoaded = isLoaded
    
    let queryPublisher = self.querySubject
      .combineLatest(triggerSet.receiveUpdatePublisher.prepend(()) , {query,_  in query})
      .tryMap(self.repository.query(_:))
      .share()
    
    
    queryPublisher
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
    let loadedCompleted = queryPublisher
      .map(Optional<[AnySecretProperty]>.some)
      .replaceError(with: nil)
      .compactMap{$0}
      .share()
    
    loadedCompleted
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$credentialProperties)
    
    loadedCompleted
      .map{_ in true}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$isLoaded)
  }
  
  let repository : SecretsRepository
  @Published var credentialProperties: [AnySecretProperty]
  @Published var isLoaded = false
  let querySubject  = PassthroughSubject<Query, Never> ()
  @Published var lastError : KeychainError?
  

  func query (_ query: Query) {
    self.querySubject.send(query)
  }
}
