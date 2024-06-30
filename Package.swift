// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "MarkdownifyHTML",
  platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)],
  products: [
    .library(
      name: "MarkdownifyHTML",
      targets: ["MarkdownifyHTML"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
  ],
  targets: [
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
