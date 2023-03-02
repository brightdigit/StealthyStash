import Foundation
import Combine
import FloxBxAuth

class CredentialPropertyListObject : ObservableObject {
  internal init(repository: SecretsRepository, internetPasswords: [AnySecretProperty]? = nil) {
    self.repository = repository
    self.credentialProperties = internetPasswords
    
    let queryPublisher = self.querySubject      
      .tryMap(self.repository.query(_:))
      .share()
    
    
    queryPublisher
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
    queryPublisher
      .map(Optional<[AnySecretProperty]>.some)
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$credentialProperties)
  }
  
  let repository : SecretsRepository
  @Published var credentialProperties: [AnySecretProperty]?
  let querySubject  = PassthroughSubject<Query, Never> ()
  @Published var lastError : KeychainError?
  

  func query (_ query: Query) {
    self.querySubject.send(query)
  }
}
