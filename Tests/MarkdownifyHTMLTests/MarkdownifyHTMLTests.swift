//
// Copyright (c) 2023 - Present Cory Ginsberg
// Licensed under Apache License 2.0
//
// swiftlint:disable force_unwrapping

import MarkdownifyHTML
import OSLog
import XCTest

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
final class MarkdownifyHTMLTests: XCTestCase {
  var testFilePath: Resource?
  var solutionFile: Resource?

  override func setUpWithError() throws {
    try super.setUpWithError()
    testFilePath = try Resource(name: "formattedComment", type: "html")
    solutionFile = try Resource(name: "formattedComment", type: "md")
    continueAfterFailure = false
  }

  func testEmptyString() {
    let expectedResult = ""
    let startingValue = ""
    let markdownify = MarkdownifyHTML(startingValue).text
    XCTAssert(expectedResult == markdownify, "Test")
  }

  func testComplexString() {
    guard let testFile = try? String(contentsOf: testFilePath!.url) else {
      XCTFail("Failed to load test file: \(testFilePath!.name)")
      return
    }
    guard let solutionFile = try? String(contentsOf: solutionFile!.url) else {
      XCTFail("Failed to load solution file: \(solutionFile!.name)")
      return
    }
    let conversion = MarkdownifyHTML(testFile)

    XCTAssertEqual(conversion.text, solutionFile, "Test File not equal to expected result")
  }

  func testAttributedConversionPerf() throws {
    guard let testFile = try? String(contentsOf: testFilePath!.url) else {
      XCTFail("Failed to load test file: \(testFilePath!.name)")
      return
    }

    measure {
      guard try? MarkdownifyHTML(testFile).attributedText != nil else {
        XCTFail("Failed to render")
        return
      }
    }
  }
}

enum TestError: Error {
  case testFolderNotFoundError
}

struct Resource {
  let name: String
  let type: String
  let url: URL

  init(name: String, type: String, sourceFile: StaticString = #file) throws {
    self.name = name
    self.type = type

    // The following assumes that your test source files are all in the same directory, and the resources are one
    // directory down and over
    // <Some folder>
    //  - Resources
    //      - <resource files>
    //  - <Some test source folder>
    //      - <test case files>
    let testCaseURL = URL(fileURLWithPath: "\(sourceFile)", isDirectory: false)
    let testsFolderURL = testCaseURL.deletingLastPathComponent()
    let resourcesFolderURL = testsFolderURL.deletingLastPathComponent().appendingPathComponent("Resources",
                                                                                               isDirectory: true)
    self.url = resourcesFolderURL.appendingPathComponent("\(name).\(type)", isDirectory: false)
  }
}

// swiftlint:enable force_unwrapping
