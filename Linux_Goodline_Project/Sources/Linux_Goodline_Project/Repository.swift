import Foundation
   
class RepositoryGetValue: RepositoryProtocol  {
    private var dictionaryarr: [String: [String: String]] = [:]
    private lazy var dictionaryForWrite: [String: [String: String]] = [:]
    public var status = false   
    private var keywords: String? = nil
    private var wordForWrite: String? = nil
    private let dataProtocol: DBProtocol

    init() {    
        dataProtocol = DBConnect()
        guard let db = dataProtocol.ConnectToDB() else {
            print("Ошибка соединения с базой данных!")
            return
        }
        dictionaryarr = db    
    }

    func repositoryValue(subcommand: String, word: String?, key: String?, language: String?) -> RepositoryResult? {
        switch subcommand {
            case "search":
                repositoryValueForSearch(key: key, language: language)
                return .search(status: status, keywords: keywords, wordForWrite: wordForWrite, dictionary: dictionaryForWrite)
            case "update":
                repositoryValueForUpdate(word: word!, key: key!, language: language!)
                return .update(status: status)
            case "delete":
                repositoryValueForDelete(key: key, language: language)
                return .delete(status: status)
            default:
                print("default")
                return nil
        }
    }

    func repositoryValueForSearch(key: String?, language: String?) { 
        
        if key != nil || language != nil {
            if key != nil && language != nil {
                Calculation3(key: key!, language: language!)
            } else {
                Calculation2(key: key, language: language)
            }
        } else {
            dictionaryForWrite = dictionaryarr
            status = true
            keywords = "KeysNil"
        }
    }

    func repositoryValueForUpdate(word: String, key: String, language: String) {
        var keyLanguage = false
        
        for dictionary in dictionaryarr {  //ищет значение словаря среди значений словарей в массиве словарей и выводит язык (ru/en/pt)
            if dictionary.key == language { //проверяем - есть ли в словаре уже такой язык, если есть - добавляем новое значение
                keyLanguage = true
            }   
        }
        if keyLanguage {
            dictionaryarr[language]!.updateValue(word,forKey:key)
            status = true //задача выполнена
        } 
        else {
            dictionaryarr.updateValue([key:word],forKey:language)
            status = true //задача выполнена
        }
      
        let write = dataProtocol.WriteDictionaryToDB(dictionaryarr: dictionaryarr)
        guard write else {
            print("Ошибка! Не удалось изменить данные в словаре!")
            status = false
            return
        }
    }

    func repositoryValueForDelete(key: String?, language: String?) {
        guard key != nil || language != nil else {
           print("Ошибка ввода аргументов!") 
           return
        }

        if key != nil && language != nil {
            //key + language +
            guard let deleteLanguage = dictionaryarr[language!], let deleteKey = dictionaryarr[language!]![key!] else {
                return
            }
            dictionaryarr[language!]!.removeValue(forKey:key!)
            status = true //задача выполнена
        } 
        else {
            if key != nil {
                //key + language -
                for dictionary in dictionaryarr {
                    for dictionaryValue in dictionary.value {
                        if key! == dictionaryValue.key {
                            dictionaryarr[dictionary.key]!.removeValue(forKey: key!)
                            status = true //задача выполнена
                        }
                    }
                }
            } 
            else {
                //key - language +
                dictionaryarr.removeValue(forKey: language!) //удаляем язык и все переводы на него
                status = true //задача выполнена
            }
        }
        
        let write = dataProtocol.WriteDictionaryToDB(dictionaryarr: dictionaryarr)
        guard write else {
            print("Ошибка! Не удалось изменить данные в словаре!")
            status = false
            return
        }
    }

    func Calculation2 (key: String?, language: String?) {
        if key != nil {
            Calculation2_Key_K(keys: key!)
        }
        
        if language != nil {
            Calculation2_Key_L(language: language!) 
        }
    }

    func Calculation2_Key_K (keys: String) {
        keywords = "KeyK"

        for dictionary in dictionaryarr {
            if let dictstr = dictionary.value[keys] {
                //if let dictKey = dictionaryForWrite[dictionary.key] {
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
        keywords = "KeyL"
        for dictionary in dictionaryarr {
            if dictionary.key == language {
                dictionaryForWrite.updateValue(dictionary.value,forKey:language)
                status = true
                }
        }
    }

    func Calculation3(key: String, language: String) {  
       keywords = "KeysKL"

        for dictionary in dictionaryarr {
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