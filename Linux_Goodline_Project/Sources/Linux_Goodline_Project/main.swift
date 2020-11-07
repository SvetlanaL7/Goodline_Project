import Foundation
import ColorizeSwift

func main()
{
    let container = Container()
    let parser = container.argumentsParserProtocol
    guard let arguments = parser.argumentsParser() else {
        return
    }

    let repository = RepositoryContainer()
    let repositoryValueProtocol = repository.repoitoryProtocol
    //guard let arguments = parser.argumentsParser() else {
    //    return
    //}
    
    if case .search(let key, let language) = arguments {
        guard let repositoryResult = repositoryValueProtocol.repositoryValue(subcommand: "search", word: nil, key: key, language: language) else {
            return
        }
        
        if case .search(let status, let dictionary) = repositoryResult {
            guard status else {
                print("Ошибка! Команда не выполнена!".red)
                return
            }
        }
    }
    
    if case .update(let word, let key, let language) = arguments {
        guard let repositoryResult = repositoryValueProtocol.repositoryValue(subcommand: "update", word: word, key: key, language: language) else {
            return
        }
        
        if case .update(let status) = repositoryResult {
            guard status else {
                print("Ошибка! Команда не выполнена!".red)
                return
            }
            print("Данные успешно обновлены/добавлены")
        }
    }

    if case .delete(let key, let language) = arguments {
        guard let repositoryResult = repositoryValueProtocol.repositoryValue(subcommand: "delete", word: nil, key: key, language: language) else {
            return
        }
        
        if case .delete(let status) = repositoryResult {
            guard status else {
                print("Ошибка! Команда не выполнена!".red)
                return
            }
            print("Данные успешно удалены")
        }
    }
}
main()

class Container {
    var argumentsParserProtocol: ArgumentsParserProtocol {
        return ArgumentParserKey()
    }
}

class RepositoryContainer {
    var repoitoryProtocol: RepositoryProtocol {
        return RepositoryGetValue()
    }
}

//считывание аргументов из командой строки ---------------------
/*let argumentsLine  = CommandLineArguments()
let (argumentCount, key, language) = argumentsLine.commandArgs()
if argumentCount < 0 {exit(0)}*/
//-------------------------------------------------------------