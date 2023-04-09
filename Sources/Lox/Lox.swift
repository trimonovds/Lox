import Foundation

@main
public enum Lox {
    private static let errorReporter = ErrorReporter.live

    public static func main() {
        let args = CommandLine.arguments
        if args.count > 2 {
            print("Usage: jlox [script]")
            exit(64)
        } else if args.count == 2 {
            do {
                try runFile(args[1])
            } catch {
                print("Error: \(error)")
                exit(74)
            }
        } else {
            runPrompt()
        }
    }

    private static func runFile(_ path: String) throws {
        let url = URL(fileURLWithPath: path)
        let content = try String(contentsOf: url)
        let errors = run(source: content)
        errorReporter.report(errors: errors)
        if !errors.isEmpty {
            exit(65)
        }
    }

    private static func runPrompt() {
        while true {
            print("> ", terminator: "")
            guard let line = readLine() else {
                break
            }
            if line == "exit" {
                exit(0)
            } else {
                let errors = run(source: line)
                errorReporter.report(errors: errors)
            }
        }
    }

    private static func run(source: String) -> [Err] {
        let scannerResult = Scanner.live.scanTokens(source)
        print("Tokens:\n")
        for token in scannerResult.tokens {
            print(token)
        }
        return scannerResult.errors
    }
}

struct Err {
    var line: Int
    var position: String = ""
    var message: String
}

enum Res<TSuccess, TError> {
    case success(TSuccess)
    case failure(TError)
}

struct ErrorReporter {
    var report: (Err) -> Void
}

extension ErrorReporter {
    func report(errors: [Err]) {
        for err in errors {
            report(err)
        }
    }

    static var live: ErrorReporter {
        return ErrorReporter(report: { err in
            print("[line " + "\(err.line)" + "] Error" + err.position + ": " + err.message)
        })
    }
}
