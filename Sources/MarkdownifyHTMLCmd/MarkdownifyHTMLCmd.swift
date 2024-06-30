// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import MarkdownifyHTML

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
@main
struct MarkdownifyHTMLCmd: ParsableCommand {
  @Option(
    help: "File to be parsed.",
    transform: URL.init(fileURLWithPath:)
  )
  var file: URL? = nil
  @Option(help: "Text to convert directly.")
  var text: String? = nil

  mutating func run() throws {
    if let file = file {
      guard let input = try? String(contentsOf: file) else {
        throw RuntimeError("Couldn't read from '\(file)'!")
      }
      print(MarkdownifyHTML(input).text)
    } else if let text = text { // assume text is filled out
      print(MarkdownifyHTML(text).text)
    } else {
      print("Error: you must select either `--file` or `--text`")
    }
  }
}

struct RuntimeError: Error, CustomStringConvertible {
  var description: String

  init(_ description: String) {
    self.description = description
  }
}
