import Foundation
import ArgumentParser
import ColorizeSwift

class ArgumentParserKey {
    public var argumentCount: Int = -1

    func argumentsParse() -> (String?, String?) {
        guard let arguments = try? ArgumentParserGetValue.parse() else {
            print("Ошибка ввода!".lightRed())
            print(ArgumentParserGetValue.helpMessage().onRed())
            exit(0)
        }

        return (
        valueKey: arguments.key,
        valueLanguage: arguments.language
        )
    }
}

struct ArgumentParserGetValue: ParsableCommand{
    //static let configuration = CommandConfiguration(abstract: "Localisation helper terminal aplication.")
    @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary key", valueName:"key"))
    var key: String?
    @Option (name: .shortAndLong, help: ArgumentHelp("Dictionary language", valueName:"language"))
    var language: String?
}
//DictionaryWorld.main()