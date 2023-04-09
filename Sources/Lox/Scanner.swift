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
    var scanTokens: (String) -> Res<[Token], Err> 
}

extension Scanner {
    static var live: Scanner {
        return Scanner(scanTokens: { source in
            var start = source.startIndex 
            var current = source.startIndex
            var line = 1
            var tokens: [Token] = []

            func isAtEnd() -> Bool {
                return current == source.endIndex 
            }

            func advance() -> Character {
                let char = source[current]
                current = source.index(after: current)
                return char 
            }

            func makeToken(_ type: TokenType, literal: Any? = nil) -> Token {
                let text = String(source[start ..< current])
                return Token(type: type, lexeme: text, literal: literal, line: line)
            }

            func makeToken(_ type: TokenType) -> Token {
                makeToken(type, literal: nil)
            }

            func scanToken() -> Res<Token, Err> {
                let c = advance()
                switch c {
                case "(":
                    return .success(makeToken(.leftParen))
                case ")":
                    return .success(makeToken(.rightParen))
                case "{":
                    return .success(makeToken(.leftBrace))
                case "}":
                    return .success(makeToken(.rightBrace))
                case ",":
                    return .success(makeToken(.comma))
                case ".":
                    return .success(makeToken(.dot))
                case "-":
                    return .success(makeToken(.minus))
                case "+":
                    return .success(makeToken(.plus))
                case ";":
                    return .success(makeToken(.semicolon))
                case "*":
                    return .success(makeToken(.star))
                default:
                    return .failure(Err(line: line, message: "Unexpected character '\(c)'"))
                }
            }
            while !isAtEnd() {
                // We are at the beginning of the next lexeme.
                start = current
                switch scanToken() {
                case .success(let token):
                    tokens.append(token)
                case let .failure(err):
                    return .failure(err)
                }
            }
            tokens.append(Token(type: .eof, lexeme: "", literal: nil, line: line))
            return .success(tokens)
        })
    }
}
