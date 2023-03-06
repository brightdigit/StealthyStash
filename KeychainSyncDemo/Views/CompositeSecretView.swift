//
//  CompositeSecretView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/4/23.
//

import SwiftUI
import Combine
import FloxBxAuth

struct CompositeSecretBuilder {

  
  var userName = ""
  var password = ""
  var token = ""
}

extension CompositeSecretBuilder {
  init(secret : CompositeCredentials?) {
    self.init(
      userName: secret?.userName ?? "",
      password: secret?.password ?? "",
      token: secret?.token ?? ""
    )
  }
}

extension CompositeCredentials {
  init?(builder : CompositeSecretBuilder) {
    guard let userName = builder.userName.nilTrimmed() else {
      return nil
    }
    
    guard let password = builder.password.nilTrimmed() else {
      return nil
    }
    
    guard let token = builder.token.nilTrimmed() else {
      return nil
    }
    
    self.init(
      userName: userName,
      password: password,
      token: token
    )
  }
}

class CompositeSecretObject : ObservableObject {
  internal init(repository: SecretsRepository, secret: CompositeSecretBuilder = CompositeSecretBuilder()) {
    self.repository = repository
    self.secret = secret
    
    let resetSourcePublisher = self.resetPassthrough
      .map{self.source}
    
    Publishers.Merge(resetSourcePublisher, self.$source)
      .map(CompositeSecretBuilder.init)
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$secret)
    
    let loadResult = self.loadPassthrough
      .map {
        Future<CompositeCredentials?, Error> { completed in
          Task {
            do {
              let secret : CompositeCredentials? = try await self.repository.fetch()
              completed(.success(secret))
            } catch {
              completed(.failure(error))
            }
          }
        }
      }
      .switchToLatest()
      .share()
    
    loadResult
      .map{_ in true}
      .replaceError(with: true)
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$isLoaded)
    
    
    loadResult
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
      
    loadResult
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$source)
    
    
    let saveResult = savePassthrough
      .map{ self.secret }
      .compactMap(CompositeCredentials.init(builder:))
      .tryMap{ model in
        try self.repository.update(model)
        return model
      }
      .share()
      
  
    saveResult
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
      
    saveResult
      .map{$0 as CompositeCredentials?}
      .catch{_ in Just(Optional<CompositeCredentials>.none)}
      .compactMap{$0}
      .map{$0 as CompositeCredentials?}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$source)
  }
  
  let repository : SecretsRepository
  
  let resetPassthrough = PassthroughSubject<Void, Never>()
  let savePassthrough = PassthroughSubject<Void, Never>()
  let loadPassthrough = PassthroughSubject<Void, Never>()
  
  @Published var lastError : KeychainError?
  @Published var source : CompositeCredentials?
  @Published var secret = CompositeSecretBuilder()
  @Published var isLoaded = false
  
  func save() {
    self.savePassthrough.send()
  }
  
  func reset () {
    self.resetPassthrough.send()
  }
  
  func load () {
    self.loadPassthrough.send()
  }
}

struct CompositeSecretView: View {
  internal init(object: CompositeSecretObject) {
    self._object = .init(wrappedValue: object)
  }
  
  internal init(repository: SecretsRepository, secret: CompositeSecretBuilder = .init()) {
    self.init(object: .init(repository: repository, secret: secret))
  }
  
  @StateObject var object : CompositeSecretObject
  
    var body: some View {
      Group{
        if object.isLoaded {
          Form{
            Section("User Name") {
              TextField("User name", text: self.$object.secret.userName)
            }
            
            Section("Password") {
              TextField("Password", text: self.$object.secret.password)
            }
            
            Section("Token") {
              TextField("Token", text: self.$object.secret.token)
            }
            
            Section{
              Button("Save") {
                self.object.save()
              }
              
              Button("Reset", role: .destructive) {
                self.object.reset()
              }
            }
            
            if let lastError = object.lastError {
              Section("Error") {
                Text(lastError.localizedDescription)
              }
            }
          }
        } else {
          ProgressView()
        }
      }.onAppear{
        self.object.load()
      }
    }
}

struct CompositeSecretView_Previews: PreviewProvider {
    static var previews: some View {
      CompositeSecretView(repository: PreviewRepository(items: []), secret: .init(userName: "username", password: "password", token: "token"))
    }
}
