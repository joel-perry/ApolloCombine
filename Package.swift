// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ApolloCombine",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15)
  ],
  products: [
    .library(name: "ApolloCombine",targets: ["ApolloCombine"]),
  ],
  dependencies: [
    .package(name: "Apollo",
             url: "https://github.com/apollographql/apollo-ios.git", from: "0.28.0")
  ],
  targets: [
    .target(name: "ApolloCombine", dependencies: [.product(name: "Apollo", package: "Apollo")]),
    .testTarget(name: "ApolloCombineTests", dependencies: ["ApolloCombine"])
  ]
)
