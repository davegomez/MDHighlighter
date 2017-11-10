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

struct Token {
    var type: String
    var value: String
}

// MARK: - Constants

/// Unicode strings used to detect and handle the characters in the input string.
private let asterisk: Character = "\u{2a}"
private let underscore: Character = "\u{5f}"
private let pound: Character = "\u{23}"
private let backtick: Character = "\u{60}"
private let space: Character = "\u{20}"
private let lineFeed: Character = "\u{a}"
private let squareBracketOpen: Character = "\u{5b}"
private let squareBracketClose: Character = "\u{5d}"
private let parenOpen: Character = "\u{28}"
private let parenClose: Character = "\u{29}"

/// Constants used to defined the Token's type.
private let text = "text"
private let lineBreak = "line-break"
private let heading = "heading"
private let emphasis = "emphasis"
private let strong = "strong"
private let openingBracket = "opening-bracket"
private let closingBracket = "closing-bracket"
private let openingParen = "opening-paren"
private let closingParen = "closing-paren"

/// Functions to fix the strong emphasis cases.
///
/// - parameter tokens: The tokens array.
/// - parameter char: The character to check for the strong emphasis intent.
/// - returns: The fixed token.
private let fixStrongEmphasisAsterisk = fixStrongEmphasis()
private let fixStrongEmphasisUnderscore = fixStrongEmphasis()

// MARK: - Utilities

/// Fixes the current strong token when detects the appereance of a possible strong emphasis
/// changing the current token to emphasis and creating a new one as a strong.
///
/// Returns a new function that accepts two parameters (see above) and uses the `isStrongEmphasisOpen`
/// flag to know if the opening strong emphasis token exists.
private func fixStrongEmphasis() -> (_ tokens: inout [Token], _ char: Character) -> Token {
    var isStrongEmphasisOpen = false
    
    return { (tokens: inout [Token], char: Character) in
        if isStrongEmphasisOpen {
            tokens[tokens.count - 1] = Token(type: emphasis, value: String(char))
            isStrongEmphasisOpen = false
            return Token(type: strong, value: "\(char)\(char)")
        }
        
        isStrongEmphasisOpen = true
        return Token(type: emphasis, value: String(char))
    }
}

/// Detects if the appearance of a tripple set of asterisk or underscore characters might be
/// considered as a strong emphasis intent.
///
/// - parameter tokens: The tokens array.
/// - parameter char: The character to check for the strong emphasis intent.
///
/// - returns: `true` if is strong emphasis intent, `false` otherwise.
private func isStrongEmphasis(tokens: [Token], char: Character) -> Bool {
    return !tokens.isEmpty && tokens.last?.type == strong && tokens.last?.value == "\(char)\(char)"
}

/// Determines if the token is a valid heading.
///
/// - parameter token: The heading token to validate.
/// - returns: `true` if the token is a valid heading token, `false` otherwise.
private func isValidHeading(token: Token) -> Bool {
    return token.type == heading && token.value.count < 6
}

/// According to the Commonmark Specification the headings only allow the existence of maximum
/// three spaces before the first pound sign, this function validates if this existing space
/// is valid.
///
/// - parameter value: The text token with spaces in its value.
/// - returns: `true` if the spaces in the string are three or less, `false` if the spaces are more
///            than three or there is any other type of character in the string
private func isValidSpaceBeforeHeading(value: String) -> Bool {
    return value.count < 4 && value.reduce(true, { x, y in
        x && y == space
    })
}

/// Checks if the token before the current heading is not valid. This is used to determine if the
/// heading token must be transformed to a text token instead.
///
/// - parameter tokens: The tokens array.
/// - returns: `true` if the token is not valid, `false` otherwise.
private func isNotValidTokenBeforeHeading(tokens: [Token]) -> Bool {
    return !tokens.isEmpty && (
        !(isValidSpaceBeforeHeading(value: tokens.last!.value) || tokens.last!.type == lineBreak)
    )
}

/// If the last token matches the condition the current character is merged into this token.
///
/// - parameter tokens: The tokens array.
/// - parameter type: The type to check.
/// - parameter value: An optional character in case we want to check for a more detailed match.
/// - returns: `true` if the token matches the provided type and value, `false` otherwise.
private func isMatchingLastToken(tokens: [Token], type: String, value: Character?) -> Bool {
    if !tokens.isEmpty {
        let lastToken = tokens.last!
        
        if let value = value {
            return lastToken.type == type && lastToken.value == String(value)
        } else {
            return lastToken.type == type
        }
    }
    
    return false
}

// MARK: - Handlers

/// Handles the non-markdown syntax characters considered by Markdown as content.
///
/// - parameter char: The character to handle.
/// - parameter tokens: The tokens array.
/// - returns: The modified array of tokens.
private func handleCharacter(char: Character, tokens: inout [Token]) -> [Token] {
    var token: Token = Token(type: text, value: String(char))
    
    if isMatchingLastToken(tokens: tokens, type: text, value: nil) {
        token = Token(type: text, value: tokens.last!.value + String(char))
        tokens.removeLast()
    }
    
    tokens.append(token)
    return tokens
}

/// Handles several key single characters used by Markdown for several cases.
///
/// - parameter char: The character to handle.
/// - parameter type: The Token type that matches the key character.
/// - parameter tokens: The tokens array.
/// - returns: The modified array of tokens.
private func handleSingleKeyCharacter(char: Character, type: String, tokens: inout [Token]) -> [Token] {
    tokens.append(Token(type: type, value: String(char)))
    return tokens
}

/// Handles the asterisk characters used by Markdown to display text as headings.
///
/// The rules to apply are:
///     * The maximum heading level must be six.
///     * The heading must be preceded only by maximum four spaces or a line break.
///
/// - parameter char: The character to handle.
/// - parameter tokens: The tokens array.
/// - returns: The modified array of tokens.
private func handlePound(char: Character, tokens: inout [Token]) -> [Token] {
    var token: Token = Token(type: heading, value: String(char))
    
    if isMatchingLastToken(tokens: tokens, type: heading, value: nil) {
        let type = isValidHeading(token: tokens.last!) ? heading : text
        let value = "\(tokens.last!.value)\(char)"
        token = Token(type: type, value: value)
        tokens.removeLast()
    }
    
    if !tokens.isEmpty && isNotValidTokenBeforeHeading(tokens: tokens) {
        token = Token(type: text, value: "\(tokens.last!.value)\(char)")
        tokens.removeLast()
    }
    
    tokens.append(token)
    return tokens
}

/// Handles the asterisk characters used by Markdown to denote strong or emphasis.
///
/// The rules to apply are:
///     * If there is one appearance of the character this is marked as emphasis.
///     * If there is two appearances of the character these are marked as strong.
///     * If there is three appearances of the character these are marked as emphasis > strong.
///     * More than three appearances of the character are marked as text.
///
/// - parameter char: The character to handle.
/// - parameter tokens: The tokens array.
/// - returns: The modified array of tokens.
private func handleAsterisk(char: Character, tokens: inout [Token]) -> [Token] {
    var token: Token = Token(type: emphasis, value: String(char))
    
    if isStrongEmphasis(tokens: tokens, char: char) {
        token = fixStrongEmphasisAsterisk(_: &tokens, _: char)
    } else if isMatchingLastToken(tokens: tokens, type: emphasis, value: asterisk) {
        token = Token(type: strong, value: "\(tokens.last!.value)\(char)")
        tokens.removeLast()
    }
    
    tokens.append(token)
    return tokens
}

/// Handles the underscore characters used by Markdown to denote strong or emphasis.
///
/// The rules to apply are:
///     * If there is one appearance of the character this is marked as emphasis.
///     * If there is two appearances of the character these are marked as strong.
///     * If there is three appearances of the character these are marked as emphasis > strong.
///     * More than three appearances of the character are marked as text.
///
/// - parameter char: The character to handle.
/// - parameter tokens: The tokens array.
/// - returns: The modified array of tokens.
private func handleUnderscore(char: Character, tokens: inout [Token]) -> [Token] {
    var token: Token = Token(type: emphasis, value: String(char))
    
    if isStrongEmphasis(tokens: tokens, char: char) {
        token = fixStrongEmphasisUnderscore(_: &tokens, _: char)
    } else if isMatchingLastToken(tokens: tokens, type: emphasis, value: underscore) {
        token = Token(type: strong, value: tokens.last!.value + String(char))
        tokens.removeLast()
    }
    
    tokens.append(token)
    return tokens
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
        switch char {
        case lineFeed:
            tokens = handleSingleKeyCharacter(char: char, type: lineBreak, tokens: &tokens)
        case pound:
            tokens = handlePound(char: char, tokens: &tokens)
        case asterisk:
            tokens = handleAsterisk(char: char, tokens: &tokens)
        case underscore:
            tokens = handleUnderscore(char: char, tokens: &tokens)
        case squareBracketOpen:
            tokens = handleSingleKeyCharacter(char: char, type: openingBracket, tokens: &tokens)
        case squareBracketClose:
            tokens = handleSingleKeyCharacter(char: char, type: closingBracket, tokens: &tokens)
        case parenOpen:
            tokens = handleSingleKeyCharacter(char: char, type: openingParen, tokens: &tokens)
        case parenClose:
            tokens = handleSingleKeyCharacter(char: char, type: closingParen, tokens: &tokens)
        default:
            tokens = handleCharacter(char: char, tokens: &tokens)
        }
    }
    
    return tokens
}

