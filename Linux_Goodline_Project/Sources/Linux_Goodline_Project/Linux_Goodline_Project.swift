import Foundation
import ColorizeSwift
//./.build/debug/Linux_Goodline_Project

public func main()
{
    let container = Container()
    let parser = container.argumentsParserProtocol
    guard let arguments = parser.argumentsParser(nil) else {
        return
    }
    
    let repository = RepositoryContainer()
    let repositoryValueProtocol = repository.repoitoryProtocol
    
    let write = WriteContainer()
    let writeValueProtocol = write.writeProtocol
    
    if case .search(let key, let language) = arguments {
        let repositoryResult = repositoryValueProtocol.repositoryValueForSearch(key: key, language: language) 
       
        if case .success(let value) = repositoryResult {
            if case .search(let keywords, let word, let dictionary) = value {
                switch keywords {
                    case .keysKL: 
                        print(word!.white())
                    case .keyK, .keysNil: 
                        writeValueProtocol.PrintResult(dictionary: dictionary!)
                    case .keyL:
                        writeValueProtocol.PrintResultKeyL(dictionary: dictionary!) 
                }
            }
        }

        if case .failure(let value) = repositoryResult {
            writeValueProtocol.DisplayAnError(keywords: value)  
        }
    }
    
    if case .update(let word, let key, let language) = arguments {
        let repositoryResult = repositoryValueProtocol.repositoryValueForUpdate(word: word, key: key, language: language)
        
        if case .success(let value) = repositoryResult {
            if case .updateSuccess = value {
                print("Данные успешно обновлены/добавлены".lightCyan())
            }
        }

        if case .failure(let value) = repositoryResult {
            writeValueProtocol.DisplayAnError(keywords: value)
        }
    }

    if case .delete(let key, let language) = arguments {
        let repositoryResult = repositoryValueProtocol.repositoryValueForDelete(key: key, language: language) 
        
        if case .success(let value) = repositoryResult {
            if case .deleteSuccess = value {
                print("Данные успешно удалены".lightCyan())
            }
        }
        
        if case .failure(let value) = repositoryResult {
            writeValueProtocol.DisplayAnError(keywords: value)
        }
    }
}
//main()

//считывание аргументов из командой строки ---------------------
/*let argumentsLine  = CommandLineArguments()
let (argumentCount, key, language) = argumentsLine.commandArgs()
if argumentCount < 0 {exit(0)}*/
//-------------------------------------------------------------