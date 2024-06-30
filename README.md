SwiftPM support for converting HTML to Markdown using Tim Gromeyer's excellent [html2md](https://github.com/tim-gromeyer/html2md) package. Has options for converting to either a `String` or an `AttributedString` with `AttributedString.MarkdownParsingOptions` support.

## Why make this?
2 main reasons: customization and speed. I wanted to be able to customize the specific Markdown tags being converted which the `NSAttributedString.loadFromHTML` from `WebKit.framework` doesn't support. On top of that, the default implementation is slow as mollases for my use case.

## So how fast is it then? 
Extremely! It's an order of maginitude faster than the built in conversion. See the comparisons below where each function converts `Sources/Tests/Resources/formattedComment.html` 10 times\*:

<table>
  <tr>
    <th>
      <code>NSAttributedString.loadFromHTML</code>
    </th>
    <th>
      <code>html2md.Converter</code>
    </th>
  </tr>
  <tr>
    <td>
      <pre lang="swift">
NSAttributedString.loadFromHTML(string: text2, options: [:]) { [self] result, _, _ in
  if let result {
    self.attributedText = AttributedString(result)
  }
}      
</pre>
    </td>
    <td>
      <pre lang=swift>
html2md.Converter(&stdStr, withUnsafeMutablePointer(to: &options) { _ in
  nil // Optional C++ value but pointer declaration is required in Swift
}).convert()      
      </pre>
    </td>
  </tr>
  <tr>
    <td>
      0.0521 seconds average
    </td>
    <td>
      0.00289 seconds average
    </td>
  </tr>
</table>

\* All tests done using XCTest's `measure` function with default values. Ran on an M3 Pro Macbook Pro with 18 GB of memory and built for an iPhone SE (3rd Generation)
