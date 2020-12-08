import Foundation
import ColorizeSwift
   
class RepositoryGetValue: RepositoryProtocol  {
    private var dictionaryValue: [String: [String: String]] = [:]
    private lazy var dictionaryForWrite: [String: [String: String]] = [:]
    public var status = false   
    private var keywords: String? = nil
    private var wordForWrite: String = ""
    let dataProtocol: DbProtocol
    var dataFromDb: [String: [String: String]]? = nil
    private var dictKey: String = ""

    init(dictionaryProtocol: DbProtocol) {
        self.dataProtocol = dictionaryProtocol
        dataFromDb = dataProtocol.GetValueFromDb() 
       
        guard let db = dataFromDb else {
           return 
        }

        dictionaryValue = db 
    }

    func repositoryValueForSearch(key: String?, language: String?) -> Result<RepositoryResult, RepositoryResultError> { 
        guard dataFromDb != nil else {
            return .failure(.dbConectFailed)
        }
        
        if key != nil || language != nil {
            if let keyValue = key, let languageValue = language {
                Calculation3(key: keyValue, language: languageValue)
                
                guard status else {
                    return .failure(.notFound)
                }

                return .success(.search(.keysKL, wordForWrite:  wordForWrite, dictionary: nil))
            } 
            else {
                if let keyValue = key {
                    Calculation2_Key_K(keys: keyValue)
                    
                    guard status else {
                        return .failure(.notFoundKey)
                    }

                    return .success(.search(.keyK, wordForWrite:  nil, dictionary: dictionaryForWrite))
                }
                else {
                    if let languageValue = language {
                        Calculation2_Key_L(language: languageValue) 
                    }

                    guard status else {
                        return .failure(.notFoundLanguage)
                    }

                    return .success(.search(.keyL, wordForWrite:  nil, dictionary: dictionaryForWrite))
                }    
            }
        } 
        else {
            guard dictionaryValue != [:] else {
                return .failure(.emptyDictionary)
            }

            dictionaryForWrite = dictionaryValue
            return .success(.search(.keysNil, wordForWrite:  nil, dictionary: dictionaryForWrite))
        }  
    }

    func repositoryValueForUpdate(word: String, key: String, language: String) -> Result<RepositoryResult, RepositoryResultError> {
        var keyLanguage = false
        
        guard dataFromDb != nil else {
            return .failure(.dbConectFailed)
        }

        for dictionary in dictionaryValue {  //ищет значение словаря среди значений словарей в массиве словарей и выводит язык (ru/en/pt)
            if dictionary.key == language { //проверяем - есть ли в словаре уже такой язык, если есть - добавляем новое значение
                keyLanguage = true
            }   
        }

        if keyLanguage {
            dictionaryValue[language]!.updateValue(word,forKey:key)
            status = true //задача выполнена
        } 
        else {
            dictionaryValue.updateValue([key:word],forKey:language)
            status = true //задача выполнена
        }
      
        let write = dataProtocol.WriteDictionaryToDb(dictionaryValue: dictionaryValue)
        
        guard write else {
            return .failure(.updateFailed)
        }

        return .success(.updateSuccess)
    }

    func repositoryValueForDelete(key: String?, language: String?) -> Result<RepositoryResult, RepositoryResultError> {
        status = false

        guard dataFromDb != nil else {
            return .failure(.dbConectFailed)
        }

        guard key != nil || language != nil else {
            return .failure(.deleteArgumentsFailed)
        }

        if let keyValue = key, let languageValue = language {
            guard let deleteLanguage = dictionaryValue[languageValue], let deleteKey = dictionaryValue[languageValue]![keyValue] else {
                return .failure(.deleteNotFound)
            }
            
            dictionaryValue[languageValue]!.removeValue(forKey:keyValue)
        } 
        else {
            if let keyValue = key {
             //key + language -
                for dictionary in dictionaryValue {
                    for dictionaryData in dictionary.value {
                        if keyValue == dictionaryData.key {
                            dictionaryValue[dictionary.key]!.removeValue(forKey: keyValue)
                            status = true
                        }
                    }
                }

                guard status else {
                    return .failure(.deleteNotFoundKey)
                }
            } 
            
            if let languageValue = language {    
                //key - language +
                guard let deleteLanguage = dictionaryValue[languageValue] else {
                    return .failure(.deleteNotFoundLanguage)
                }

                dictionaryValue.removeValue(forKey: languageValue) //удаляем язык и все переводы на него
            }
        }
        
        let write = dataProtocol.WriteDictionaryToDb(dictionaryValue: dictionaryValue)
        
        guard write else {
            return .failure(.deleteFailed)
        }

        return .success(.deleteSuccess)
    }

    func Calculation2_Key_K (keys: String) {
        for dictionary in dictionaryValue {
            if let dictstr = dictionary.value[keys] {
                if dictionaryForWrite[dictionary.key] != nil {
                    dictionaryForWrite[dictionary.key]!.updateValue(dictstr,forKey:keys)
                } 
                else {
                    dictionaryForWrite.updateValue([keys:dictstr],forKey:dictionary.key)
                    status = true
                }
            }
        }
    }

    func Calculation2_Key_L (language: String) {
        for dictionary in dictionaryValue {
            if dictionary.key == language {
                dictionaryForWrite.updateValue(dictionary.value,forKey:language)
                status = true
            }
        }
    }

    func Calculation3(key: String, language: String) {  
        for dictionary in dictionaryValue {
            if dictionary.key == language {
                for dictElement in dictionary.value {
                    if dictElement.key == key {
                        wordForWrite = dictElement.value
                        status = true
                    }
                }
            }
        }
    }
}    