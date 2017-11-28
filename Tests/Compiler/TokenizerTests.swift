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
    let spaceToken = Token(type: Category.space, value: " ")
    let lineFeedToken = Token(type: Category.lineFeed, value: "\n")
    let asteriskToken = Token(type: Category.asterisk, value: "*")
    let underscoreToken = Token(type: Category.underscore, value: "_")
    let poundToken = Token(type: Category.pound, value: "#")
    let equalToken = Token(type: Category.equal, value: "=")
    let dashToken = Token(type: Category.dash, value: "-")
    let exclamationToken = Token(type: Category.exclamation, value: "!")
    let squareBracketOpenToken = Token(type: Category.squareBracket, value: "[")
    let squareBracketCloseToken = Token(type: Category.squareBracket, value: "]")
    let parenthesisOpenToken = Token(type: Category.parenthesis, value: "(")
    let parenthesisCloseToken = Token(type: Category.parenthesis, value: ")")
    let angleBracketToken = Token(type: Category.angleBracket, value: ">")
    let backtickToken = Token(type: Category.backtick, value: "`")
    
    var tokens: [Token] = []
    
    override func setUp() {
        super.setUp()
        tokens = []
    }
    
    func testText() {
        tokens = tokenize(input: "foo")
        XCTAssertEqual(tokens.last, Token(type: Category.text, value: "foo"))
        
        tokens = tokenize(input: "foo bar")
        XCTAssertEqual(tokens.first, Token(type: Category.text, value: "foo"))
        XCTAssertEqual(tokens.last, Token(type: Category.text, value: "bar"))
    }
    
    func testSpace() {
        tokens = tokenize(input: " ")
        XCTAssertEqual(tokens.first, spaceToken)
        
        tokens = tokenize(input: "foo bar")
        XCTAssertEqual(tokens[1], spaceToken)
        
        tokens = tokenize(input: " foo bar ")
        XCTAssertEqual(tokens.first, spaceToken)
        XCTAssertEqual(tokens[2], spaceToken)
        XCTAssertEqual(tokens.last, spaceToken)
    }
    
    func testLineFeed() {
        tokens = tokenize(input: "\n")
        XCTAssertEqual(tokens.first, lineFeedToken)
        
        tokens = tokenize(input: "foo\nbar")
        XCTAssertEqual(tokens[1], lineFeedToken)
        
        tokens = tokenize(input: "\nfoo\nbar\n")
        XCTAssertEqual(tokens.first, lineFeedToken)
        XCTAssertEqual(tokens[2], lineFeedToken)
        XCTAssertEqual(tokens.last, lineFeedToken)
    }
    
    func testAsterisk() {
        tokens = tokenize(input: "*")
        XCTAssertEqual(tokens.first, asteriskToken)
        
        tokens = tokenize(input: "foo *bar* ")
        XCTAssertEqual(tokens[2], asteriskToken)
        XCTAssertEqual(tokens[4], asteriskToken)
        
        tokens = tokenize(input: "*foo* bar")
        XCTAssertEqual(tokens.first, asteriskToken)
        XCTAssertEqual(tokens[2], asteriskToken)
        
        tokens = tokenize(input: "foo **bar** bazz")
        XCTAssertEqual(tokens[2], asteriskToken)
        XCTAssertEqual(tokens[3], asteriskToken)
        XCTAssertEqual(tokens[5], asteriskToken)
        XCTAssertEqual(tokens[6], asteriskToken)
        
        tokens = tokenize(input: "foo *_*bar*_* bazz")
        XCTAssertEqual(tokens[2], asteriskToken)
        XCTAssertEqual(tokens[4], asteriskToken)
        XCTAssertEqual(tokens[6], asteriskToken)
        XCTAssertEqual(tokens[8], asteriskToken)
    }
    
    func testUnderscore() {
        tokens = tokenize(input: "_")
        XCTAssertEqual(tokens.first, underscoreToken)
        
        tokens = tokenize(input: "foo _bar_ ")
        XCTAssertEqual(tokens[2], underscoreToken)
        XCTAssertEqual(tokens[4], underscoreToken)
        
        tokens = tokenize(input: "_foo_ bar")
        XCTAssertEqual(tokens.first, underscoreToken)
        XCTAssertEqual(tokens[2], underscoreToken)
        
        tokens = tokenize(input: "foo __bar__ bazz")
        XCTAssertEqual(tokens[2], underscoreToken)
        XCTAssertEqual(tokens[3], underscoreToken)
        XCTAssertEqual(tokens[5], underscoreToken)
        XCTAssertEqual(tokens[6], underscoreToken)
        
        tokens = tokenize(input: "foo _*_bar_*_ bazz")
        XCTAssertEqual(tokens[2], underscoreToken)
        XCTAssertEqual(tokens[4], underscoreToken)
        XCTAssertEqual(tokens[6], underscoreToken)
        XCTAssertEqual(tokens[8], underscoreToken)
    }
    
    func testPound() {
        tokens = tokenize(input: "#")
        XCTAssertEqual(tokens.first, poundToken)
        
        tokens = tokenize(input: "## foo")
        XCTAssertEqual(tokens.first, poundToken)
        XCTAssertEqual(tokens[1], poundToken)
        
        tokens = tokenize(input: "foo\n## bar")
        XCTAssertEqual(tokens[2], poundToken)
        XCTAssertEqual(tokens[3], poundToken)
        
        tokens = tokenize(input: "foo\n  ## bar")
        XCTAssertEqual(tokens[4], poundToken)
        XCTAssertEqual(tokens[5], poundToken)
    }
    
    func testEqual() {
        tokens = tokenize(input: "=")
        XCTAssertEqual(tokens.first, equalToken)
        
        tokens = tokenize(input: "foo = bar = ")
        XCTAssertEqual(tokens[2], equalToken)
        XCTAssertEqual(tokens[6], equalToken)
        
        tokens = tokenize(input: "foo\n===")
        XCTAssertEqual(tokens[2], equalToken)
        XCTAssertEqual(tokens[3], equalToken)
        XCTAssertEqual(tokens.last, equalToken)
    }
    
    func testDash() {
        tokens = tokenize(input: "-")
        XCTAssertEqual(tokens.first, dashToken)
        
        tokens = tokenize(input: "foo - bar - ")
        XCTAssertEqual(tokens[2], dashToken)
        XCTAssertEqual(tokens[6], dashToken)
        
        tokens = tokenize(input: "foo\n---")
        XCTAssertEqual(tokens[2], dashToken)
        XCTAssertEqual(tokens[3], dashToken)
        XCTAssertEqual(tokens.last, dashToken)
    }
    
    func testExclamation() {
        tokens = tokenize(input: "!")
        XCTAssertEqual(tokens.first, exclamationToken)
        
        tokens = tokenize(input: "foo!")
        XCTAssertEqual(tokens.last, exclamationToken)
        
        tokens = tokenize(input: "![foo](bar)")
        XCTAssertEqual(tokens.first, exclamationToken)
        
        tokens = tokenize(input: "foo ![bar](bazz)")
        XCTAssertEqual(tokens[2], exclamationToken)
    }
    
    func testSquareBracket() {
        tokens = tokenize(input: "[")
        XCTAssertEqual(tokens.first, squareBracketOpenToken)
        
        tokens = tokenize(input: "]")
        XCTAssertEqual(tokens.first, squareBracketCloseToken)
        
        tokens = tokenize(input: "[foo](bar)")
        XCTAssertEqual(tokens.first, squareBracketOpenToken)
        XCTAssertEqual(tokens[2], squareBracketCloseToken)
        
        tokens = tokenize(input: "foo ![bar](bazz)")
        XCTAssertEqual(tokens[3], squareBracketOpenToken)
        XCTAssertEqual(tokens[5], squareBracketCloseToken)
    }
    
    func testParenthesis() {
        tokens = tokenize(input: "(")
        XCTAssertEqual(tokens.first, parenthesisOpenToken)
        
        tokens = tokenize(input: ")")
        XCTAssertEqual(tokens.first, parenthesisCloseToken)
        
        tokens = tokenize(input: "[foo](bar)")
        XCTAssertEqual(tokens[3], parenthesisOpenToken)
        XCTAssertEqual(tokens.last, parenthesisCloseToken)
        
        tokens = tokenize(input: "foo ![bar](bazz)")
        XCTAssertEqual(tokens[6], parenthesisOpenToken)
        XCTAssertEqual(tokens.last, parenthesisCloseToken)
    }
    
    func testAngleBracket() {
        tokens = tokenize(input: ">")
        XCTAssertEqual(tokens.first, angleBracketToken)
        
        tokens = tokenize(input: "foo > bar > ")
        XCTAssertEqual(tokens[2], angleBracketToken)
        XCTAssertEqual(tokens[6], angleBracketToken)
        
        tokens = tokenize(input: "foo\n > >")
        XCTAssertEqual(tokens[3], angleBracketToken)
        XCTAssertEqual(tokens.last, angleBracketToken)
    }
    
    func testBacktick() {
        tokens = tokenize(input: "`")
        XCTAssertEqual(tokens.first, backtickToken)
        
        tokens = tokenize(input: "foo `bar` ")
        XCTAssertEqual(tokens[2], backtickToken)
        XCTAssertEqual(tokens[4], backtickToken)
        
        tokens = tokenize(input: "foo\n```\nbar\n```")
        XCTAssertEqual(tokens[2], backtickToken)
        XCTAssertEqual(tokens[3], backtickToken)
        XCTAssertEqual(tokens[4], backtickToken)
        XCTAssertEqual(tokens[8], backtickToken)
        XCTAssertEqual(tokens[9], backtickToken)
        XCTAssertEqual(tokens.last, backtickToken)
        
        tokens = tokenize(input: "foo\n```bar\n    //bazz\n```")
        XCTAssertEqual(tokens[2], backtickToken)
        XCTAssertEqual(tokens[3], backtickToken)
        XCTAssertEqual(tokens[4], backtickToken)
        XCTAssertEqual(tokens[13], backtickToken)
        XCTAssertEqual(tokens[14], backtickToken)
        XCTAssertEqual(tokens.last, backtickToken)
    }
}
