import Foundation
import Combine
import FloxBxAuth

class InternetPasswordListObject : ObservableObject {
  internal init(repository: CredentialsRepository, internetPasswords: [InternetPasswordItem]? = nil) {
    self.repository = repository
    self.internetPasswords = internetPasswords
    
    let queryPublisher = self.querySubject
      .map(Query.init)
      .tryMap(self.repository.query)
      .share()
    
    
    queryPublisher
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
    queryPublisher
      .map(Optional<[InternetPasswordItem]>.some)
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$internetPasswords)
  }
  
  let repository : CredentialsRepository
  @Published var internetPasswords: [InternetPasswordItem]?
  let querySubject  = PassthroughSubject<String?, Never> ()
  @Published var lastError : KeychainError?
  

  func query (_ string: String?) {
    self.querySubject.send(string)
  }
}
