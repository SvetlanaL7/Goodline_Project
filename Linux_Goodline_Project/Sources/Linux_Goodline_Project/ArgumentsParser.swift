import Foundation
import ArgumentParser
//import ColorizeSwift


class ArgumentParserKey: ArgumentsParserProtocol {
    func argumentsParser() -> Arguments? {
        do {
            let command = try Commands.parseAsRoot()
           
            switch command {
                case let command as Commands.Search:
                    return .search(key: command.key, language: command.language)
                
                case let command as Commands.Update:
                    return .update(word: command.word, key: command.key, language: command.language)
                
                case let command as Commands.Delete:
                    return .delete(key: command.key, language: command.language)
                default:
                    //print("Switch out")
                    print(Commands.helpMessage().onRed())
                    return nil
                   
            }
        }
        catch {
            print(Commands.helpMessage().onRed())
            //print("Catch out")
            return nil
           
        }
    }
}

private struct Commands: ParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [Search.self, Update.self, Delete.self]
    )
}

extension Commands {
    struct Search: ParsableCommand {
        @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary key", valueName:"key"))
        var key: String?

        @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary language", valueName:"language"))
        var language: String?
    }

    struct Update: ParsableCommand {
        @Argument
        var word: String

        @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary key", valueName:"key"))
        var key: String

        @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary language", valueName:"language"))
        var language: String
    }

    struct Delete: ParsableCommand {
        @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary key", valueName:"key"))
        var key: String?

        @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary language", valueName:"language"))
        var language: String?
    }
}