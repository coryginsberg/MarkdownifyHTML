// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import MarkdownifyHTML

@available(iOS 16, macOS 13, *)
@main
struct MarkdownifyHTMLCmd: ParsableCommand {
  @Option(
    help: "File to be parsed.",
    transform: URL.init(fileURLWithPath:)
  )
  var file: URL?
  @Option(help: "Text to convert directly.")
  var text: String?

  mutating func run() throws {
    if let file {
      guard let input = try? String(contentsOf: file) else {
        throw RuntimeError("Couldn't read from '\(file)'!")
      }
      var markdownify = ""
      let clock = ContinuousClock()
      let measurement = clock.measure {
        markdownify = MarkdownifyHTML(input).text
      }
      print(markdownify)
      print(measurement)
    } else if let text { // assume text is filled out
      let markdownify = MarkdownifyHTML(text).text
      print(markdownify)
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
