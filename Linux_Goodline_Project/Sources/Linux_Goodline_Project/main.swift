import Foundation
import ColorizeSwift
//./.build/debug/Linux_Goodline_Project 

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

    let write = WriteContainer()
    let writeValueProtocol = write.writeProtocol
    
    if case .search(let key, let language) = arguments {
        guard let repositoryResult = repositoryValueProtocol.repositoryValue(subcommand: "search", word: nil, key: key, language: language) else {
            return
        }
        
        if case .search(let status, let keywords, let wordForWrite, let dictionary) = repositoryResult {
            
            guard status else {
               writeValueProtocol.DisplayAnError(subcommand: "search", keywords: keywords)
               return
            } 
            
            writeValueProtocol.WriteDiactionary(keywords: keywords, wordForWrite: wordForWrite, dictionary: dictionary)
        }
    }
    
    if case .update(let word, let key, let language) = arguments {
        guard let repositoryResult = repositoryValueProtocol.repositoryValue(subcommand: "update", word: word, key: key, language: language) else {
            return
        }
        
        if case .update(let status) = repositoryResult {
            guard status else {
                writeValueProtocol.DisplayAnError(subcommand: "update", keywords: nil)
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
                writeValueProtocol.DisplayAnError(subcommand: "delete", keywords: nil)
                return
            }
            print("Данные успешно удалены")
        }
    }
}
main()

//считывание аргументов из командой строки ---------------------
/*let argumentsLine  = CommandLineArguments()
let (argumentCount, key, language) = argumentsLine.commandArgs()
if argumentCount < 0 {exit(0)}*/
//-------------------------------------------------------------