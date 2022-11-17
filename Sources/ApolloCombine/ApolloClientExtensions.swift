import Apollo
import ApolloAPI
import Combine
import Foundation

public extension ApolloClientProtocol {
  
  /// Fetches a query from the server or from the local cache, depending on the current contents of the cache and the specified cache policy.
  ///
  /// - Parameters:
  ///   - query: The query to fetch.
  ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server and when data should be loaded from the local cache. Defaults to ``.default`.
  ///   - contextIdentifier: [optional] A unique identifier for this request, to help with deduping cache hits for watchers. Defaults to `nil`.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the fetch operation.
  func fetchPublisher<Query: GraphQLQuery>(query: Query,
                                           cachePolicy: CachePolicy = .default,
                                           contextIdentifier: UUID? = nil,
                                           queue: DispatchQueue = .main) -> Publishers.ApolloFetch<Query> {
    let config = Publishers.ApolloFetchConfiguration(client: self, query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue)
    return Publishers.ApolloFetch(with: config)
  }
  
  /// Performs a mutation by sending it to the server.
  ///
  /// - Parameters:
  ///   - mutation: The mutation to perform.
  ///   - publishResultToStore: If `true`, this will publish the result returned from the operation to the cache store. Defaults to `true`.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the perform operation.
  func performPublisher<Mutation: GraphQLMutation>(mutation: Mutation,
                                                   publishResultToStore: Bool = true,
                                                   queue: DispatchQueue = .main) -> Publishers.ApolloPerform<Mutation> {
    let config = Publishers.ApolloPerformConfiguration(client: self, mutation: mutation, publishResultToStore: publishResultToStore, queue: queue)
    return Publishers.ApolloPerform(with: config)
  }
  
  /// Uploads the given files with the given operation.
  ///
  /// - Parameters:
  ///   - operation: The operation to send
  ///   - files: An array of `GraphQLFile` objects to send.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the upload operation.
  func uploadPublisher<Operation: GraphQLOperation>(operation: Operation,
                                                    files: [GraphQLFile],
                                                    queue: DispatchQueue = .main) -> Publishers.ApolloUpload<Operation> {
    let config = Publishers.ApolloUploadConfiguration(client: self, operation: operation, files: files, queue: queue)
    return Publishers.ApolloUpload(with: config)
  }
  
  /// Watches a query by first fetching an initial result from the server or from the local cache, depending on the current contents of the cache and the specified cache policy. After the initial fetch, the returned publisher will get notified whenever any of the data the query result depends on changes in the local cache, and delivers the new result.
  ///
  /// - Parameters:
  ///   - query: The query to watch.
  ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server or from the local cache. Defaults to ``.default`
  ///   - callbackQueue: A dispatch queue on which the result handler will be called. Defaults to the main queue..
  /// - Returns: A publisher that delivers results from the watch operation.
  func watchPublisher<Query: GraphQLQuery>(query: Query,
                                           cachePolicy: CachePolicy = .default,
                                           callbackQueue: DispatchQueue = .main) -> Publishers.ApolloWatch<Query> {
    let config = Publishers.ApolloWatchConfiguration(client: self, query: query, cachePolicy: cachePolicy, callbackQueue: callbackQueue)
    return Publishers.ApolloWatch(with: config)
  }
  
  /// Subscribe to a subscription
  ///
  /// - Parameters:
  ///   - subscription: The subscription to subscribe to.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the subscribe operation.
  func subscribePublisher<Subscription: GraphQLSubscription>(subscription: Subscription,
                                                             queue: DispatchQueue = .main) -> Publishers.ApolloSubscribe<Subscription> {
    let config = Publishers.ApolloSubscribeConfiguration(client: self, subscription: subscription, queue: queue)
    return Publishers.ApolloSubscribe(with: config)
  }
  
  /// Request to clear the cache
  ///
  /// - Parameters:
  ///   - callbackQueue: The queue to call back on. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the clear operaion.
  func clearCachePublisher(queue: DispatchQueue = .main) -> Publishers.ApolloClearCache {
    let config = Publishers.ApolloClearCacheConfiguration(client: self,
                                                          queue: queue)
    return Publishers.ApolloClearCache(with: config)
  }
}

