import Foundation
import ColorizeSwift

public func main() -> Int {

    let container = Container()
    let parser = container.argumentsParserProtocol
    guard let arguments = parser.argumentsParser(nil) else {
        return 100
    }
    
    let repository = RepositoryContainer()
    let repositoryValueProtocol = repository.repoitoryProtocol
    
    let write = WriteContainer()
    let writeValueProtocol = write.writeProtocol
    
    switch arguments {
        case .search(let key, let language):
            let repositoryResult = repositoryValueProtocol.repositoryValueForSearch(key: key, language: language) 
            
            switch repositoryResult {
                case .success(let value):
                    if case .search(let keywords, let word, let dictionary) = value {
                        switch keywords {
                            case .keysKL: 
                                print(word!.white())
                            case .keyK, .keysNil: 
                                writeValueProtocol.PrintResult(dictionary: dictionary!)
                            case .keyL:
                                writeValueProtocol.PrintResultKeyL(dictionary: dictionary!) 
                        }

                        return 0
                    }
                    else {
                        return 200 //пришел результат не из того класса (выполнилась не та подкоманда)
                    }

                case .failure(let value):
                    let errorCode = writeValueProtocol.DisplayAnError(keywords: value)  
                    return errorCode
            }
            
        case .update(let word, let key, let language):
            let repositoryResult = repositoryValueProtocol.repositoryValueForUpdate(word: word, key: key, language: language)
            
            switch repositoryResult {
                case .success(let value):
                    if case .updateSuccess = value {
                        print("Данные успешно обновлены/добавлены".lightCyan())
                        return 0
                    }
                    else {
                        return 200 //пришел результат не из того класса (выполнилась не та подкоманда)
                    }

                case .failure(let value):
                    let errorCode = writeValueProtocol.DisplayAnError(keywords: value)
                    return errorCode
            }
            
        case .delete(let key, let language):
            let repositoryResult = repositoryValueProtocol.repositoryValueForDelete(key: key, language: language) 
            
            switch repositoryResult {
                case .success(let value):
                    if case .deleteSuccess = value {
                        print("Данные успешно удалены".lightCyan())
                        return 0
                    }
                    else {
                        return 200 //пришел результат не из того класса (выполнилась не та подкоманда)
                    }

                case .failure(let value):
                    let errorCode = writeValueProtocol.DisplayAnError(keywords: value)
                    return errorCode
            }
    }    
}