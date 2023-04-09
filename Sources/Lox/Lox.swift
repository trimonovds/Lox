import Foundation

@main
public enum Lox {
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
        run(source: content)
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
                run(source: line)
            }
        }
    }

    private static func run(source: String) {
        print("Evaluating: \(source)")
    }
}
