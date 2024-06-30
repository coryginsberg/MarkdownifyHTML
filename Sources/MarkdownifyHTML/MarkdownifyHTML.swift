// The Swift Programming Language
// https://docs.swift.org/swift-book

import CxxStdlib
import Foundation
import html2md

@available(macOS 12, *)
public struct MarkdownifyHTML {
  public private(set) var text: String
  public var attributedText: AttributedString {
    get throws {
      try AttributedString(markdown: text, options: attributedStringOptions)
    }
  }

  let attributedStringOptions: AttributedString.MarkdownParsingOptions

  public init(_ text: String, withMarkdownOptions options: AttributedString.MarkdownParsingOptions = .init()) {
    self.text = text
    self.attributedStringOptions = options
    markdownify(self.text)
  }

  mutating func markdownify(_ text2: String) {
    var stdStr = std.string(text2)
    var options = html2md.Options.self.init()
    options.splitLines = false
    options.includeTitle = false
    var converter = html2md.Converter(&stdStr, withUnsafeMutablePointer(to: &options) { _ in
      nil // Optional C++ value but pointer declaration is required in Swift
    })
    text = String(converter.convert())
  }
}
