# ApolloCombine
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/joel-perry/ApolloCombine)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
![Cocoapods](https://img.shields.io/cocoapods/v/ApolloCombine)
![GitHub](https://img.shields.io/github/license/joel-perry/ApolloCombine)

A collection of Combine publishers for the [Apollo iOS client](https://github.com/apollographql/apollo-ios).

## Usage
The extension to ApolloClientProtocol (in the aptly named `ApolloClientExtensions`) includes methods whose inputs mirror the existing ApolloClientProtocol operation methods. Instead of including a result handler, though, these methods return Combine publishers that deliver the results of the operation to subscribers.

When `cancel()` is invoked on a subscription, the underlying Apollo operation is also cancelled.

`fetchPublisher`, `performPublisher`, `uploadPublisher`, and `clearCachePublisher` will send a completion when the operation has completed.

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

`watchPublisher` and `subscribePublisher` will not send a completion, instead delivering data and errors as the value of the subscription. This allows these operations to remain open after an error has been encountered. As such, it is important to explicitly cancel these subscriptions when you are done with them to avoid memory leaks.

```swift
import ApolloCombine

let client = ApolloClient(...)

let watchSubscription = client.watchPublisher(query: MyQuery())
  .sink(receiveValue: { operationResult in
    switch operationResult {
    case .success(let graphQLResult):
      // handle returned data
    	
    case .failure(let error): 
      // handle error     
  })

// Don't forget to cancel when you're done
watchSubscription.cancel()

```


## Installation
### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Use Xcode’s Swift Packages option, which is located within the File menu.

### CocoaPods
ApolloCombine is available through [CocoaPods](https://cocoapods.org/). To install it, simply add the following line in your `Podfile`

```
pod 'ApolloCombine'
```

## License
ApolloCombine is released under the MIT license. [See LICENSE](LICENSE) for details.
