import Apollo
import Combine
import Foundation

#if canImport(ApolloAPI)
import ApolloAPI
#endif

// Each operation type has 3 elements:
//  1. A Publisher instance.
//  2. A Configuration struct that encapsulates the parameters for the operation and a reference to the client making the call.
//  3. A Subscription that wraps the underlying operation and returns results to subscribers.

public extension Publishers {
  
  // MARK: Fetch
  struct ApolloFetch<Query: GraphQLQuery>: Publisher {
    public typealias Output = GraphQLResult<Query.Data>
    public typealias Failure = Error
    
    private let configuration: ApolloFetchConfiguration<Query>
    
    public init(with configuration: ApolloFetchConfiguration<Query>) {
      self.configuration = configuration
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let subscription = ApolloFetchSubscription(subscriber: subscriber, configuration: configuration)
      subscriber.receive(subscription: subscription)
    }
  }
  
  struct ApolloFetchConfiguration<Query: GraphQLQuery> {
    let client: ApolloClientProtocol
    let query: Query
    let cachePolicy: CachePolicy
    let contextIdentifier: UUID?
    let context: RequestContext?
    let queue: DispatchQueue
  }
  
  private final class ApolloFetchSubscription<S: Subscriber, Query: GraphQLQuery>: Subscription
  where S.Failure == Error, S.Input == GraphQLResult<Query.Data> {
    private let configuration: ApolloFetchConfiguration<Query>
    var subscriber: S?
    private var task: Apollo.Cancellable?
    
    init(subscriber: S?, configuration: ApolloFetchConfiguration<Query>) {
      self.subscriber = subscriber
      self.configuration = configuration
    }
    
    func request(_ demand: Subscribers.Demand) {
      task = configuration.client.fetch(query: configuration.query,
                                        cachePolicy: configuration.cachePolicy,
                                        contextIdentifier: configuration.contextIdentifier,
                                        context: configuration.context,
                                        queue: configuration.queue)
      { [weak self] result in
        switch result {
        case .success(let data):
          _ = self?.subscriber?.receive(data)
          
          if self?.configuration.cachePolicy == .returnCacheDataAndFetch && data.source == .cache {
            return
          }
          self?.subscriber?.receive(completion: .finished)
          
        case .failure(let error):
          self?.subscriber?.receive(completion: .failure(error))
        }
      }
    }
    
    func cancel() {
      task?.cancel()
      task = nil
      subscriber = nil
    }
  }
  
  // MARK: - Perform
  struct ApolloPerform<Mutation: GraphQLMutation>: Publisher {
    public typealias Output = GraphQLResult<Mutation.Data>
    public typealias Failure = Error
    
    private let configuration: ApolloPerformConfiguration<Mutation>
    
    public init(with configuration: ApolloPerformConfiguration<Mutation>) {
      self.configuration = configuration
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let subscription = ApolloPerformSubscription(subscriber: subscriber, configuration: configuration)
      subscriber.receive(subscription: subscription)
    }
  }
  
  struct ApolloPerformConfiguration<Mutation: GraphQLMutation> {
    let client: ApolloClientProtocol
    let mutation: Mutation
    let publishResultToStore: Bool
    let context: RequestContext?
    let queue: DispatchQueue
  }
  
  private final class ApolloPerformSubscription<S: Subscriber, Mutation: GraphQLMutation>: Subscription
  where S.Failure == Error, S.Input == GraphQLResult<Mutation.Data> {
    private let configuration: ApolloPerformConfiguration<Mutation>
    private var subscriber: S?
    private var task: Apollo.Cancellable?
    
    init(subscriber: S, configuration: ApolloPerformConfiguration<Mutation>) {
      self.subscriber = subscriber
      self.configuration = configuration
    }
    
    func request(_ demand: Subscribers.Demand) {
      task = configuration.client.perform(mutation: configuration.mutation,
                                          publishResultToStore: configuration.publishResultToStore,
                                          context: configuration.context,
                                          queue: configuration.queue)
      { [weak self] result in
        switch result {
        case .success(let data):
          _ = self?.subscriber?.receive(data)
          self?.subscriber?.receive(completion: .finished)
          
        case .failure(let error):
          self?.subscriber?.receive(completion: .failure(error))
        }
      }
    }
    
    func cancel() {
      task?.cancel()
      task = nil
      subscriber = nil
    }
  }
  
  // MARK: - Upload
  struct ApolloUpload<Operation: GraphQLOperation>: Publisher {
    public typealias Output = GraphQLResult<Operation.Data>
    public typealias Failure = Error
    
    private let configuration: ApolloUploadConfiguration<Operation>
    
    public init(with configuration: ApolloUploadConfiguration<Operation>) {
      self.configuration = configuration
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let subscription = ApolloUploadSubscription(subscriber: subscriber, configuration: configuration)
      subscriber.receive(subscription: subscription)
    }
  }
  
  struct ApolloUploadConfiguration<Operation: GraphQLOperation> {
    let client: ApolloClientProtocol
    let operation: Operation
    let files: [GraphQLFile]
    let context: RequestContext?
    let queue: DispatchQueue
  }
  
  private final class ApolloUploadSubscription<S: Subscriber, Operation: GraphQLOperation>: Subscription
  where S.Failure == Error, S.Input == GraphQLResult<Operation.Data> {
    private let configuration: ApolloUploadConfiguration<Operation>
    private var subscriber: S?
    private var task: Apollo.Cancellable?
    
    init(subscriber: S, configuration: ApolloUploadConfiguration<Operation>) {
      self.subscriber = subscriber
      self.configuration = configuration
    }
    
    func request(_ demand: Subscribers.Demand) {
      task = configuration.client.upload(operation: configuration.operation,
                                         files: configuration.files,
                                         context: configuration.context,
                                         queue: configuration.queue)
      { [weak self] result in
        switch result {
        case .success(let data):
          _ = self?.subscriber?.receive(data)
          self?.subscriber?.receive(completion: .finished)
          
        case .failure(let error):
          self?.subscriber?.receive(completion: .failure(error))
        }
      }
    }
    
    func cancel() {
      task?.cancel()
      task = nil
      subscriber = nil
    }
  }
  
  // MARK: - Watch
  struct ApolloWatch<Query: GraphQLQuery>: Publisher {
    public typealias Output = Result<GraphQLResult<Query.Data>, Error>
    public typealias Failure = Never
    
    private let configuration: ApolloWatchConfiguration<Query>
    
    public init(with configuration: ApolloWatchConfiguration<Query>) {
      self.configuration = configuration
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let subscription = ApolloWatchSubscription(subscriber: subscriber, configuration: configuration)
      subscriber.receive(subscription: subscription)
    }
  }
  
  struct ApolloWatchConfiguration<Query: GraphQLQuery> {
    let client: ApolloClientProtocol
    let query: Query
    let cachePolicy: CachePolicy
    let context: RequestContext?
    let callbackQueue: DispatchQueue
  }
  
  private final class ApolloWatchSubscription<S: Subscriber, Query: GraphQLQuery>: Subscription
  where S.Failure == Never, S.Input == Result<GraphQLResult<Query.Data>, Error> {
    private let configuration: ApolloWatchConfiguration<Query>
    private var subscriber: S?
    private var task: GraphQLQueryWatcher<Query>?
    
    init(subscriber: S, configuration: ApolloWatchConfiguration<Query>) {
      self.subscriber = subscriber
      self.configuration = configuration
    }
    
    func request(_ demand: Subscribers.Demand) {
      task = configuration.client.watch(query: configuration.query,
                                        cachePolicy: configuration.cachePolicy,
                                        context: configuration.context,
                                        callbackQueue: configuration.callbackQueue)
      { [weak self] result in
        _ = self?.subscriber?.receive(result)
      }
    }
    
    func cancel() {
      task?.cancel()
      task = nil
      subscriber = nil
    }
  }
  
  // MARK: - Subscribe
  struct ApolloSubscribe<Subscription: GraphQLSubscription>: Publisher {
    public typealias Output = Result<GraphQLResult<Subscription.Data>, Error>
    public typealias Failure = Never
    
    private let configuration: ApolloSubscribeConfiguration<Subscription>
    
    public init(with configuration: ApolloSubscribeConfiguration<Subscription>) {
      self.configuration = configuration
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let subscription = ApolloSubscribeSubscription(subscriber: subscriber, configuration: configuration)
      subscriber.receive(subscription: subscription)
    }
  }
  
  struct ApolloSubscribeConfiguration<Subscription: GraphQLSubscription> {
    let client: ApolloClientProtocol
    let subscription: Subscription
    let context: RequestContext?
    let queue: DispatchQueue
  }
  
  private final class ApolloSubscribeSubscription<S: Subscriber, Sub: GraphQLSubscription>: Subscription
  where S.Failure == Never, S.Input == Result<GraphQLResult<Sub.Data>, Error> {
    private let configuration: ApolloSubscribeConfiguration<Sub>
    private var subscriber: S?
    private var task: Apollo.Cancellable?
    
    init(subscriber: S, configuration: ApolloSubscribeConfiguration<Sub>) {
      self.subscriber = subscriber
      self.configuration = configuration
    }
    
    func request(_ demand: Subscribers.Demand) {
      task = configuration.client.subscribe(subscription: configuration.subscription,
                                            context: configuration.context,
                                            queue: configuration.queue)
      { [weak self] result in
        _ = self?.subscriber?.receive(result)
      }
    }
    
    func cancel() {
      task?.cancel()
      task = nil
      subscriber = nil
    }
  }
  
  // MARK: - Clear Cache
  struct ApolloClearCache: Publisher {
    public typealias Output = Void
    public typealias Failure = Error
    
    private let configuration: ApolloClearCacheConfiguration
    
    public init(with configuration: ApolloClearCacheConfiguration) {
      self.configuration = configuration
    }
    
    public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      let subscription = ApolloClearCacheSubscription(subscriber: subscriber, configuration: configuration)
      subscriber.receive(subscription: subscription)
    }
  }
  
  struct ApolloClearCacheConfiguration {
    let client: ApolloClientProtocol
    let queue: DispatchQueue
  }
  
  private final class ApolloClearCacheSubscription<S: Subscriber> : Subscription
  where S.Failure == Error, S.Input == Void {
    
    private let configuration: ApolloClearCacheConfiguration
    var subscriber: S?
    
    init(subscriber: S?, configuration:ApolloClearCacheConfiguration) {
      self.subscriber = subscriber
      self.configuration = configuration
    }
    
    func request(_ demand: Subscribers.Demand) {
      configuration.client.clearCache(callbackQueue: configuration.queue)
      { [weak self] result in
        switch result {
        case .success():
          _ = self?.subscriber?.receive()
          self?.subscriber?.receive(completion: .finished)
          
        case .failure(let error):
          self?.subscriber?.receive(completion: .failure(error))
        }
      }
    }
    
    func cancel() {
      subscriber = nil
    }
  }
}
