import Foundation
import Combine
import FloxBxAuth

class InternetPasswordListObject : ObservableObject {
  internal init(repository: CredentialsRepository, internetPasswords: [AnyCredentialProperty]? = nil) {
    self.repository = repository
    self.internetPasswords = internetPasswords
    
    let queryPublisher = self.querySubject
      .map(Query.init)
      .tryMap(self.repository.query(_:))
      .share()
    
    
    queryPublisher
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
    queryPublisher
      .map(Optional<[AnyCredentialProperty]>.some)
      .replaceError(with: nil)
      .print()
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$internetPasswords)
  }
  
  let repository : CredentialsRepository
  @Published var internetPasswords: [AnyCredentialProperty]?
  let querySubject  = PassthroughSubject<String?, Never> ()
  @Published var lastError : KeychainError?
  

  func query (_ string: String?) {
    self.querySubject.send(string)
  }
}
