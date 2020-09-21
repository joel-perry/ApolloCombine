// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ApolloCombine",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(name: "ApolloCombine",targets: ["ApolloCombine"]),
  ],
  dependencies: [
    .package(name: "Apollo",
             url: "https://github.com/apollographql/apollo-ios.git", "0.28.0"..<"0.34.0")
  ],
  targets: [
    .target(name: "ApolloCombine", dependencies: [.product(name: "Apollo", package: "Apollo")])
  ]
)
