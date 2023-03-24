//
//  CompositeSecretObject.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/22/23.
//

import Foundation
import Combine
import StealthyStash

class TriggerSet {
  let saveCompletedTrigger = PassthroughSubject<Void, Never>()
  //private let receivedUpdate = PassthroughSubject<Void, Never>()
  
  var receiveUpdatePublisher : AnyPublisher<Void, Never> {
    return saveCompletedTrigger.share().eraseToAnyPublisher()
  }
}
class CompositeSecretObject : ObservableObject {
  internal init(
    repository: SecretsRepository,
    triggerSet : TriggerSet,
    secret: CompositeSecretBuilder = CompositeSecretBuilder()
  ) {
    self.repository = repository
    self.secret = secret
    
    let resetSourcePublisher = self.resetPassthrough
      .map{self.source}
    
    Publishers.Merge(resetSourcePublisher, self.$source)
      .map(CompositeSecretBuilder.init)
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$secret)
    
    let loadResult = Publishers.Merge(self.loadPassthrough, triggerSet.receiveUpdatePublisher)
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
        if let source = self.source {
          try self.repository.update(from: source, to: model)
        } else {
          try self.repository.create(model)
        }
        return model
      }
      .share()
      
  
    saveResult
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
      
    let saveSuccess = saveResult
      .map{$0 as CompositeCredentials?}
      .catch{_ in Just(Optional<CompositeCredentials>.none)}
      .compactMap{$0}
      .share()
    
    saveSuccess
      .map{$0 as CompositeCredentials?}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$source)
    
    saveSuccessCancellable = saveSuccess
      .breakpoint()
      .map{_ in ()}
      .subscribe(triggerSet.saveCompletedTrigger)
  }
  
  let repository : SecretsRepository
  
  let resetPassthrough = PassthroughSubject<Void, Never>()
  let savePassthrough = PassthroughSubject<Void, Never>()
  let loadPassthrough = PassthroughSubject<Void, Never>()
  
  @Published var lastError : KeychainError?
  @Published var source : CompositeCredentials?
  @Published var secret = CompositeSecretBuilder()
  @Published var isLoaded = false
  
  var saveSuccessCancellable : AnyCancellable!
  
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
