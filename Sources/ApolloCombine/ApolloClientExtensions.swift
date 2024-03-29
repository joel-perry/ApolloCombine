import Apollo
import Combine
import Foundation

#if canImport(ApolloAPI)
import ApolloAPI
#endif

public extension ApolloClientProtocol {
  
  /// Fetches a query from the server or from the local cache, depending on the current contents of the cache and the specified cache policy.
  ///
  /// - Parameters:
  ///   - query: The query to fetch.
  ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server and when data should be loaded from the local cache. Defaults to ``.default`.
  ///   - contextIdentifier: [optional] A unique identifier for this request, to help with deduping cache hits for watchers. Should default to `nil`.
  ///   - context: [optional] A context that is being passed through the request chain. Defaults to `nil`.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the fetch operation.
  func fetchPublisher<Query: GraphQLQuery>(query: Query,
                                           cachePolicy: CachePolicy = .default,
                                           contextIdentifier: UUID? = nil,
                                           context: RequestContext? = nil,
                                           queue: DispatchQueue = .main) -> Publishers.ApolloFetch<Query> {
    let config = Publishers.ApolloFetchConfiguration(client: self, 
                                                     query: query,
                                                     cachePolicy: cachePolicy,
                                                     contextIdentifier: contextIdentifier,
                                                     context: context,
                                                     queue: queue)
    return Publishers.ApolloFetch(with: config)
  }
  
  /// Performs a mutation by sending it to the server.
  ///
  /// - Parameters:
  ///   - mutation: The mutation to perform.
  ///   - publishResultToStore: If `true`, this will publish the result returned from the operation to the cache store. Defaults to `true`.
  ///   - contextIdentifier: [optional] A unique identifier for this request, to help with deduping cache hits for watchers. Should default to `nil`.
  ///   - context: [optional] A context that is being passed through the request chain. Defaults to `nil`.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the perform operation.
  func performPublisher<Mutation: GraphQLMutation>(mutation: Mutation,
                                                   publishResultToStore: Bool = true,
                                                   contextIdentifier: UUID? = nil,
                                                   context: RequestContext? = nil,
                                                   queue: DispatchQueue = .main) -> Publishers.ApolloPerform<Mutation> {
    let config = Publishers.ApolloPerformConfiguration(client: self, 
                                                       mutation: mutation,
                                                       publishResultToStore: publishResultToStore,
                                                       contextIdentifier: contextIdentifier,
                                                       context: context,
                                                       queue: queue)
    return Publishers.ApolloPerform(with: config)
  }
  
  /// Uploads the given files with the given operation.
  ///
  /// - Parameters:
  ///   - operation: The operation to send
  ///   - files: An array of `GraphQLFile` objects to send.
  ///   - context: [optional] A context that is being passed through the request chain. Defaults to `nil`.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the upload operation.
  func uploadPublisher<Operation: GraphQLOperation>(operation: Operation,
                                                    files: [GraphQLFile],
                                                    context: RequestContext? = nil,
                                                    queue: DispatchQueue = .main) -> Publishers.ApolloUpload<Operation> {
    let config = Publishers.ApolloUploadConfiguration(client: self, 
                                                      operation: operation,
                                                      files: files,
                                                      context: context,
                                                      queue: queue)
    return Publishers.ApolloUpload(with: config)
  }
  
  /// Watches a query by first fetching an initial result from the server or from the local cache, depending on the current contents of the cache and the specified cache policy. After the initial fetch, the returned publisher will get notified whenever any of the data the query result depends on changes in the local cache, and delivers the new result.
  ///
  /// - Parameters:
  ///   - query: The query to watch.
  ///   - cachePolicy: A cache policy that specifies when results should be fetched from the server or from the local cache. Defaults to ``.default`
  ///   - context: [optional] A context that is being passed through the request chain. Defaults to `nil`.
  ///   - callbackQueue: A dispatch queue on which the result handler will be called. Defaults to the main queue..
  /// - Returns: A publisher that delivers results from the watch operation.
  func watchPublisher<Query: GraphQLQuery>(query: Query,
                                           cachePolicy: CachePolicy = .default,
                                           context: RequestContext? = nil,
                                           callbackQueue: DispatchQueue = .main) -> Publishers.ApolloWatch<Query> {
    let config = Publishers.ApolloWatchConfiguration(client: self, 
                                                     query: query,
                                                     cachePolicy: cachePolicy,
                                                     context: context,
                                                     callbackQueue: callbackQueue)
    return Publishers.ApolloWatch(with: config)
  }
  
  /// Subscribe to a subscription
  ///
  /// - Parameters:
  ///   - subscription: The subscription to subscribe to.
  ///   - context: [optional] A context that is being passed through the request chain. Defaults to `nil`.
  ///   - queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
  /// - Returns: A publisher that delivers results from the subscribe operation.
  func subscribePublisher<Subscription: GraphQLSubscription>(subscription: Subscription,
                                                             context: RequestContext? = nil,
                                                             queue: DispatchQueue = .main) -> Publishers.ApolloSubscribe<Subscription> {
    let config = Publishers.ApolloSubscribeConfiguration(client: self, 
                                                         subscription: subscription,
                                                         context: context,
                                                         queue: queue)
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

