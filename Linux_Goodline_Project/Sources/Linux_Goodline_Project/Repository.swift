import Foundation
import ColorizeSwift
   
class RepositoryGetValue: RepositoryProtocol  {
    private var dictionaryValue: [String: [String: String]] = [:]
    private lazy var dictionaryForWrite: [String: [String: String]] = [:]
    public var status = false   
    private var keywords: String? = nil
    private var wordForWrite: String = ""
    let dataProtocol: DBProtocol
    var getData: [String: [String: String]]? = nil
    
    init(dictionaryProtocol: DBProtocol) {
        self.dataProtocol = dictionaryProtocol
        getData = dataProtocol.GetValueFromDB() 
       
        guard let db = getData else {
           return 
        }

        dictionaryValue = db 
    }

    func repositoryValueForSearch(key: String?, language: String?) -> Result<RepositoryResult, RepositoryResultError> { 
        guard getData != nil else {
            return .failure(.dbConectFailed)
        }

        if key != nil || language != nil {
            if key != nil && language != nil {
                Calculation3(key: key!, language: language!)
                guard status else {
                    return .failure(.notFound)
                }
                return .success(.search(.keysKL, wordForWrite:  wordForWrite, dictionary: nil))
            } 
            else {
                if key != nil {
                    Calculation2_Key_K(keys: key!)
                    guard status else {
                        return .failure(.notFoundKey)
                    }
                    return .success(.search(.keyK, wordForWrite:  nil, dictionary: dictionaryForWrite))
                }
                else {
                    Calculation2_Key_L(language: language!) 
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
        
        guard getData != nil else {
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
      
        let write = dataProtocol.WriteDictionaryToDB(dictionaryValue: dictionaryValue)
        guard write else {
            return .failure(.updateFailed)
        }

        return .success(.updateSuccess)
    }

    func repositoryValueForDelete(key: String?, language: String?) -> Result<RepositoryResult, RepositoryResultError> {
        guard getData != nil else {
            return .failure(.dbConectFailed)
        }

        guard key != nil || language != nil else {
            return .failure(.deleteArgumentsFailed)
        }

        if key != nil && language != nil {
            guard let deleteLanguage = dictionaryValue[language!], let deleteKey = dictionaryValue[language!]![key!] else {
                return .failure(.deleteNotFound)
            }
            dictionaryValue[language!]!.removeValue(forKey:key!)
        } 
        else {
            if key != nil {
                //key + language -
                for dictionary in dictionaryValue {
                    for dictionaryData in dictionary.value {
                        if key! == dictionaryData.key {
                            dictionaryValue[dictionary.key]!.removeValue(forKey: key!)
                        }
                    }
                }
            } 
            else {
                //key - language +
                dictionaryValue.removeValue(forKey: language!) //удаляем язык и все переводы на него
            }
        }
        
        let write = dataProtocol.WriteDictionaryToDB(dictionaryValue: dictionaryValue)
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
