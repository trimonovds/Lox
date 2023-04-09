import Foundation

enum TokenType {
    // Single-character tokens.
    case leftParen
    case rightParen
    case leftBrace
    case rightBrace
    case comma
    case dot
    case minus
    case plus
    case semicolon
    case slash
    case star

    // One or two character tokens.
    case bang
    case bangEqual
    case equal
    case equalEqual
    case greater
    case greaterEqual
    case less
    case lessEqual

    // Literals
    case identifier
    case string
    case number

    // Keywords
    case and
    case `class`
    case `else`
    case `false`
    case fun
    case `for`
    case `if`
    case `nil`
    case or
    case print
    case `return`
    case `super`
    case this
    case `true`
    case `var`
    case `while`

    case eof
}

struct Token {
    var type: TokenType
    var lexeme: String
    var literal: Any?
    var line: Int
}

struct Scanner {
    struct Result {
        var tokens: [Token]
        var errors: [Err]
    }
    var scanTokens: (String) -> Result
}

extension Scanner {
    static var live: Scanner {
        return Scanner(scanTokens: { source in
            var start = source.startIndex 
            var current = source.startIndex
            var line = 1
            var tokens = [Token]()
            var errors = [Err]()

            func isAtEnd() -> Bool {
                return current == source.endIndex 
            }

            func advance() -> Character {
                let char = source[current]
                current = source.index(after: current)
                return char 
            }

            func addToken(_ type: TokenType, literal: Any? = nil) {
                let text = String(source[start ..< current])
                tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
            }

            func addToken(_ type: TokenType) {
                addToken(type, literal: nil)
            }

            func scanToken() {
                let c = advance()
                switch c {
                case "(":
                    addToken(.leftParen)
                case ")":
                    addToken(.rightParen)
                case "{":
                    addToken(.leftBrace)
                case "}":
                    addToken(.rightBrace)
                case ",":
                    addToken(.comma)
                case ".":
                    addToken(.dot)
                case "-":
                    addToken(.minus)
                case "+":
                    addToken(.plus)
                case ";":
                    addToken(.semicolon)
                case "*":
                    addToken(.star)
                default:
                    errors.append(Err(line: line, message: "Unexpected character '\(c)'"))
                }
            }
            while !isAtEnd() {
                // We are at the beginning of the next lexeme.
                start = current
                scanToken()
            }
            tokens.append(Token(type: .eof, lexeme: "", literal: nil, line: line))
            return Result(tokens: tokens, errors: errors) 
        })
    }
}
