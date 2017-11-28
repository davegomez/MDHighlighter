//
//  Tokenizer.swift
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

enum MarkdownGlyph: Character {
    case space              = "\u{20}"
    case lineFeed           = "\u{a}"
    case asterisk           = "\u{2a}"
    case underscore         = "\u{5f}"
    case pound              = "\u{23}"
    case equal              = "\u{3d}"
    case dash               = "\u{2d}"
    case exclamation        = "\u{21}"
    case squareBracketOpen  = "\u{5b}"
    case squareBracketClose = "\u{5d}"
    case parenthesisOpen    = "\u{28}"
    case parenthesisClose   = "\u{29}"
    case angleBracketClose  = "\u{3e}"
    case backtick           = "\u{60}"
}

enum Category {
    case text
    case space
    case lineFeed
    case asterisk
    case underscore
    case pound
    case equal
    case dash
    case exclamation
    case squareBracket
    case parenthesis
    case angleBracket
    case backtick
    
    /// Returns the correct category based on the provided glyph
    init(for markdownGlyph: MarkdownGlyph) {
        switch markdownGlyph {
        case .space:              self = .space
        case .lineFeed:           self = .lineFeed
        case .asterisk:           self = .asterisk
        case .underscore:         self = .underscore
        case .pound:              self = .pound
        case .equal:              self = .equal
        case .dash:               self = .dash
        case .exclamation:        self = .exclamation
        case .squareBracketOpen:  self = .squareBracket
        case .squareBracketClose: self = .squareBracket
        case .parenthesisOpen:    self = .parenthesis
        case .parenthesisClose:   self = .parenthesis
        case .angleBracketClose:  self = .angleBracket
        case .backtick:           self = .backtick
        }
    }
}

struct Token {
    var type: Category
    var value: String
}


// MARK: - Utilities

/// Merge similar tokens if their type matches the passed category
///
/// - parameter forType: The category used to compare the provided tokens
/// - parameter first: First token to merge
/// - parameter second: Second token to merge
/// - returns: An array containing the merged token or the passed tokens in case theyr type doesn't match
private func mergeTokens(forType category: Category, _ first: Token, _ second: Token) -> [Token] {
    if first.type == category && second.type == category {
        return [Token(type: category, value: "\(first.value)\(second.value)")]
    }
    
    return [first, second]
}


// MARK: - Handlers

/// Creates a token using the character passed in the params
///
/// - parameter char: Character to handle
/// - returns: An array containing the token created for the character
private func handleCharacter(char: Character) -> [Token] {
    if let glyph = MarkdownGlyph(rawValue: char) {
        return [Token(type: Category(for: glyph), value: String(char))]
    }
    
    return [Token(type: Category.text, value: String(char))]
}


// MARK: - Tokenizer

/// Splits the incomming string into tokens using the Commonmark Specification to detect the
/// markdown code (http://spec.commonmark.org/).
///
/// - parameter input: The raw string coming from the `TextView`.
/// - returns: An array of tokens.
func tokenize(input: String) -> [Token] {
    var tokens: [Token] = []
    
    for char in input {
        var token = handleCharacter(char: char)
        if let lastToken = tokens.popLast() {
            token = mergeTokens(forType: Category.text, lastToken, token.removeLast())
        }
        
        tokens += token
    }
    
    return tokens
}

