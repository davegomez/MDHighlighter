//
//  TokenizerTests.swift
//
//  Copyright (c) 2017 David Gomez (http://github.com/davegomez/MDHighlighter)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import MDHighlighter

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.type == rhs.type && lhs.value == rhs.value
    }
}

class TokenizerTests: XCTestCase {
    
    private let text = "text"
    private let lineBreak = "line-break"
    private let heading = "heading"
    private let emphasis = "emphasis"
    private let strong = "strong"
    private let openingBracket = "opening-bracket"
    private let closingBracket = "closing-bracket"
    private let openingParen = "opening-paren"
    private let closingParen = "closing-paren"
    
    var tokens: [Token] = []
    
    override func setUp() {
        super.setUp()
        tokens = []
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        tokens = []
    }
    
    func testMarkdown() {
        // tests...
    }
    
    func testLineBreak() {
        tokens = tokenize(input: "\n")
        XCTAssertEqual(tokens.first, Token(type: lineBreak, value: "\n"))
        
        tokens = tokenize(input: "\n\n")
        XCTAssertEqual(tokens.first, Token(type: lineBreak, value: "\n"))
        XCTAssertEqual(tokens.last, Token(type: lineBreak, value: "\n"))
        
        tokens = tokenize(input: " \n\n ")
        XCTAssertEqual(tokens[1], Token(type: lineBreak, value: "\n"))
        XCTAssertEqual(tokens[2], Token(type: lineBreak, value: "\n"))
        
        tokens = tokenize(input: "\n \n")
        XCTAssertEqual(tokens.first, Token(type: lineBreak, value: "\n"))
        XCTAssertEqual(tokens.last, Token(type: lineBreak, value: "\n"))
        
        tokens = tokenize(input: " \n \n ")
        XCTAssertEqual(tokens[1], Token(type: lineBreak, value: "\n"))
        XCTAssertEqual(tokens[3], Token(type: lineBreak, value: "\n"))
    }
    
    func testHeading() {
        tokens = tokenize(input: "#")
        XCTAssertEqual(tokens.first, Token(type: heading, value: "#"))

        tokens = tokenize(input: "# ")
        XCTAssertEqual(tokens.first, Token(type: heading, value: "#"))

        tokens = tokenize(input: "# foo")
        XCTAssertEqual(tokens.first, Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n#")
        XCTAssertEqual(tokens.last, Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n# ")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n# bar")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n# bar\n")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n##")
        XCTAssertEqual(tokens.last, Token(type: heading, value: "##"))

        tokens = tokenize(input: "foo\n## ")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "##"))

        tokens = tokenize(input: "foo\n## bar")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "##"))

        tokens = tokenize(input: "foo\n## bar\n")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "##"))

        tokens = tokenize(input: "foo\n###")
        XCTAssertEqual(tokens.last, Token(type: heading, value: "###"))

        tokens = tokenize(input: "foo\n### ")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "###"))

        tokens = tokenize(input: "foo\n### bar")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "###"))

        tokens = tokenize(input: "foo\n### bar\n")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "###"))

        tokens = tokenize(input: "foo\n####")
        XCTAssertEqual(tokens.last, Token(type: heading, value: "####"))

        tokens = tokenize(input: "foo\n#### ")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "####"))

        tokens = tokenize(input: "foo\n#### bar")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "####"))

        tokens = tokenize(input: "foo\n#### bar\n")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "####"))

        tokens = tokenize(input: "foo\n#####")
        XCTAssertEqual(tokens.last, Token(type: heading, value: "#####"))

        tokens = tokenize(input: "foo\n##### ")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "#####"))

        tokens = tokenize(input: "foo\n##### bar")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "#####"))

        tokens = tokenize(input: "foo\n##### bar\n")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "#####"))

        tokens = tokenize(input: "foo\n######")
        XCTAssertEqual(tokens.last, Token(type: heading, value: "######"))

        tokens = tokenize(input: "foo\n###### ")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "######"))

        tokens = tokenize(input: "foo\n###### bar")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "######"))

        tokens = tokenize(input: "foo\n###### bar\n")
        XCTAssertEqual(tokens[2], Token(type: heading, value: "######"))

        tokens = tokenize(input: "foo\n#######")
        XCTAssertEqual(tokens.last, Token(type: text, value: "#######"))

        tokens = tokenize(input: "foo\n####### ")
        XCTAssertEqual(tokens[2], Token(type: text, value: "####### "))

        tokens = tokenize(input: "foo\n####### bar")
        XCTAssertEqual(tokens[2], Token(type: text, value: "####### bar"))

        tokens = tokenize(input: "foo\n####### bar\n")
        XCTAssertEqual(tokens[2], Token(type: text, value: "####### bar"))

        tokens = tokenize(input: "foo\n # bar")
        XCTAssertEqual(tokens[3], Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n  # bar")
        XCTAssertEqual(tokens[3], Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n   # bar")
        XCTAssertEqual(tokens[3], Token(type: heading, value: "#"))

        tokens = tokenize(input: "foo\n    # bar")
        XCTAssertEqual(tokens.last, Token(type: text, value: "    # bar"))

        tokens = tokenize(input: "foo # bar")
        XCTAssertEqual(tokens.first, Token(type: text, value: "foo # bar"))

        tokens = tokenize(input: "foo # \n bar")
        XCTAssertEqual(tokens.first, Token(type: text, value: "foo # "))
    }
    
    func testEmphasis() {
        tokens = tokenize(input: "*")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "_")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: "*foo*")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: " *foo* ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[3], Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "_foo_")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: " _foo_ ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[3], Token(type: emphasis, value: "_"))
    }
    
    func testStrong() {
        tokens = tokenize(input: "**")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "**"))
        
        tokens = tokenize(input: "__")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "__"))
        
        tokens = tokenize(input: "**foo**")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "**"))
        XCTAssertEqual(tokens.last, Token(type: strong, value: "**"))
        
        tokens = tokenize(input: " **foo** ")
        XCTAssertEqual(tokens[1], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "**"))
        
        tokens = tokenize(input: "__foo__")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "__"))
        XCTAssertEqual(tokens.last, Token(type: strong, value: "__"))
        
        tokens = tokenize(input: " __foo__ ")
        XCTAssertEqual(tokens[1], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "__"))
    }
    
    func testStrongEmphasis() {
        tokens = tokenize(input: "***")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "**"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "___")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "__"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: "**_")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "**"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: "__*")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "__"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "***foo***")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[1], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "***foo*** ***bar***")
        print(tokens)
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[1], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[4], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[6], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[7], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[9], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: " ***foo*** ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[2], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[4], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[5], Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: " ***foo*** ***bar*** ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[2], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[4], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[5], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[7], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[8], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[10], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[11], Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "___foo___")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[1], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: "___foo___ ___bar___")
        print(tokens)
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[1], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[4], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[6], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[7], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[9], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: " ___foo___ ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[2], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[4], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[5], Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: " ___foo___ ___bar___ ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[2], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[4], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[5], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[7], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[8], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[10], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[11], Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: "_**foo**_")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[1], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: "**_foo_**")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[3], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens.last, Token(type: strong, value: "**"))
        
        tokens = tokenize(input: " _**foo**_ ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[2], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[4], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[5], Token(type: emphasis, value: "_"))
        
        tokens = tokenize(input: " **_foo_** ")
        XCTAssertEqual(tokens[1], Token(type: strong, value: "**"))
        XCTAssertEqual(tokens[2], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[4], Token(type: emphasis, value: "_"))
        XCTAssertEqual(tokens[5], Token(type: strong, value: "**"))
        
        tokens = tokenize(input: "*__foo__*")
        XCTAssertEqual(tokens.first, Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[1], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[3], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens.last, Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: "__*foo*__")
        XCTAssertEqual(tokens.first, Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[3], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens.last, Token(type: strong, value: "__"))
        
        tokens = tokenize(input: " *__foo__* ")
        XCTAssertEqual(tokens[1], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[2], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[4], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[5], Token(type: emphasis, value: "*"))
        
        tokens = tokenize(input: " __*foo*__ ")
        XCTAssertEqual(tokens[1], Token(type: strong, value: "__"))
        XCTAssertEqual(tokens[2], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[4], Token(type: emphasis, value: "*"))
        XCTAssertEqual(tokens[5], Token(type: strong, value: "__"))
    }
    
    func testBrackets() {
        tokens = tokenize(input: "foo [bar] baz")
        XCTAssertEqual(tokens[1], Token(type: openingBracket, value: "["))
        XCTAssertEqual(tokens[3], Token(type: closingBracket, value: "]"))
    }
    
    func testParens() {
        tokens = tokenize(input: "foo (bar) baz")
        XCTAssertEqual(tokens[1], Token(type: openingParen, value: "("))
        XCTAssertEqual(tokens[3], Token(type: closingParen, value: ")"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
