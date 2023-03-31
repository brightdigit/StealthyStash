import Combine
import Foundation
import StealthyStash

class TriggerSet {
  let saveCompletedTrigger = PassthroughSubject<Void, Never>()
  // private let receivedUpdate = PassthroughSubject<Void, Never>()

  var receiveUpdatePublisher: AnyPublisher<Void, Never> {
    saveCompletedTrigger.share().eraseToAnyPublisher()
  }
}

class CompositeStealthyObject: ObservableObject {
  internal init(
    repository: StealthyRepository,
    triggerSet: TriggerSet,
    secret: CompositeStealthyBuilder = CompositeStealthyBuilder()
  ) {
    self.repository = repository
    self.secret = secret

    let resetSourcePublisher = resetPassthrough
      .map { self.source }

    Publishers.Merge(resetSourcePublisher, $source)
      .map(CompositeStealthyBuilder.init)
      .receive(on: DispatchQueue.main)
      .assign(to: &$secret)

    let loadResult = Publishers.Merge(loadPassthrough, triggerSet.receiveUpdatePublisher)
      .map {
        Future<CompositeCredentials?, Error> { completed in
          Task {
            do {
              let secret: CompositeCredentials? = try await self.repository.fetch()
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
      .map { _ in true }
      .replaceError(with: true)
      .receive(on: DispatchQueue.main)
      .assign(to: &$isLoaded)

    loadResult
      .map { _ in Error?.none }
      .catch { Just(Error?.some($0)) }
      .compactMap { $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &$lastError)

    loadResult
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .assign(to: &$source)

    let saveResult = savePassthrough
      .map { self.secret }
      .compactMap(CompositeCredentials.init(builder:))
      .tryMap { model in
        if let source = self.source {
          try self.repository.update(from: source, to: model)
        } else {
          try self.repository.create(model)
        }
        return model
      }
      .share()

    saveResult
      .map { _ in Error?.none }
      .catch { Just(Error?.some($0)) }
      .compactMap { $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &$lastError)

    let saveSuccess = saveResult
      .map { $0 as CompositeCredentials? }
      .catch { _ in Just(CompositeCredentials?.none) }
      .compactMap { $0 }
      .share()

    saveSuccess
      .map { $0 as CompositeCredentials? }
      .receive(on: DispatchQueue.main)
      .assign(to: &$source)

    saveSuccessCancellable = saveSuccess
      .breakpoint()
      .map { _ in () }
      .subscribe(triggerSet.saveCompletedTrigger)
  }

  let repository: StealthyRepository

  let resetPassthrough = PassthroughSubject<Void, Never>()
  let savePassthrough = PassthroughSubject<Void, Never>()
  let loadPassthrough = PassthroughSubject<Void, Never>()

  @Published var lastError: KeychainError?
  @Published var source: CompositeCredentials?
  @Published var secret = CompositeStealthyBuilder()
  @Published var isLoaded = false

  var saveSuccessCancellable: AnyCancellable!

  func save() {
    savePassthrough.send()
  }

  func reset() {
    resetPassthrough.send()
  }

  func load() {
    loadPassthrough.send()
  }
}
