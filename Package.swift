// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MarkdownifyHTML",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "MarkdownifyHTML",
      targets: ["MarkdownifyHTML"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "MarkdownifyHTML",
      dependencies: ["html2md"],
      swiftSettings: [.interoperabilityMode(.Cxx)]
    ),
    .target(name: "html2md", dependencies: [], cxxSettings: []),
    .testTarget(
      name: "MarkdownifyHTMLTests",
      dependencies: ["MarkdownifyHTML"],
      swiftSettings: [.interoperabilityMode(.Cxx), .unsafeFlags([
        "-cxx-interoperability-mode=default",
      ])]
    ),
    .executableTarget(
      name: "MarkdownifyHTMLCmd",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "MarkdownifyHTML",
      ],
      swiftSettings: [.interoperabilityMode(.Cxx), .unsafeFlags([
        "-cxx-interoperability-mode=default",
      ])]
    ),
  ],
  cxxLanguageStandard: .cxx11
)
