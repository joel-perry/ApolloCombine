# ApolloCombine
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/joel-perry/ApolloCombine)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
![GitHub](https://img.shields.io/github/license/joel-perry/ApolloCombine)

A collection of Combine publishers for the [Apollo iOS client](https://github.com/apollographql/apollo-ios).

## Usage
The extension to ApolloClient (in the aptly named `ApolloClientExtensions`) includes methods whose inputs mirror the existing ApolloClient operation methods. Instead of including a result handler, though, these methods return Combine publishers that deliver the results of the operation to subscribers.

When `cancel()` is invoked on a subscription, the underlying Apollo operation is also cancelled.

`fetchPublisher`, `performPublisher`, and `uploadPublisher` subscriptions will send `.finished` completions whey they are done.

```swift
import ApolloCombine

let client = ApolloClient(...)

let fetchSubscription = client.fetchPublisher(query: MyQuery(), cachePolicy: .fetchIgnoringCacheData)
  .sink(receiveCompletion: { completion in
    // handle .finished or .failure 
    }, receiveValue: { graphQLResult in
      // handle returned fetch data      
  })

// Cancelling the Combine subscription will also cancel the underlying Apollo operation
fetchSubscription.cancel()

```
## Installation
### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Use Xcode’s Swift Packages option, which is located within the File menu.

## License
ApolloCombine is released under the MIT license. [See LICENSE](LICENSE) for details.
