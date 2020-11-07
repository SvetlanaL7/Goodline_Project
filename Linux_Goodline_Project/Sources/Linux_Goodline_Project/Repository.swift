import Foundation
   
class RepositoryGetValue: RepositoryProtocol  {
    private var dictionaryarr: [String: [String: String]] = [:]
    private var status = false   
    
    init() {    
        //объявляем путь к файлу с данными из словаря    
        let url = Bundle.module.url(forResource:"dictionary", withExtension: "json")!
        //let dictionaryarr: [String: [String: String]]
        //let pathurl = Bundle.module.path(forResource:"dictionary_test", ofType: "json") ?? "dictionary_test.json"
        //считывание данных (словаря) из файла -------------------------
        let fileManager = FileManager.default
        if let dataFile = fileManager.contents(atPath: url.path){
            dictionaryarr = (try? JSONDecoder().decode([String: [String: String]].self, from: dataFile)) ?? [:]
        } else {
            dictionaryarr = [:]
        }
    }

    func repositoryValue(subcommand: String, word: String?, key: String?, language: String?) -> RepositoryResult? {
        switch subcommand {
            case "search":
                repositoryValueForSearch(key: key, language: language)
                return .search(status: status, dictionary: dictionaryarr)
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

    func repositoryValueForSearch(key: String?, language: String?) { //-> DictionaryWords? {
        
        //DictionaryGet()

        if key != nil || language != nil {
            if key != nil && language != nil {
                Calculation3(key: key!, language: language!)
            } else {
                Calculation2(key: key, language: language)
            }
        } else {
            Calculation1()
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
      
        WriteDictionaryToDB()
    }

    func repositoryValueForDelete(key: String?, language: String?) {
        if key != nil && language != nil {
            //key + language +
            dictionaryarr[language!]!.removeValue(forKey:key!)
            status = true //задача выполнена
        } 
        else {
            if key != nil {
                //key + language -
                for dictionary in dictionaryarr {
                    print(dictionary)
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
        
        WriteDictionaryToDB()
    }

    func WriteDictionaryToDB() {
        let pathurl = Bundle.module.path(forResource:"dictionary", ofType: "json") ?? "dictionary.json"
        JSONEncoder().outputFormatting = .prettyPrinted
        let json = try! JSONEncoder().encode(dictionaryarr.self)
        try! json.write(to: URL(fileURLWithPath: pathurl))
    }
    
    func Calculation1() {
        var keylanguage: [String] = []
    
        for dictionary in dictionaryarr {  //ищет значение словаря среди значений словарей в массиве словарей и выводит язык (ru/en/pt)
            for dictionaryValue in dictionary.value {
                keylanguage.append(String(dictionaryValue.key))
            }
        }

        keylanguage = Array(Set(keylanguage))
    
        for i in 0...keylanguage.count-1 {
            print(keylanguage[i].lightMagenta())
            
            for dictionary in dictionaryarr {
                if let dictstr = dictionary.value[keylanguage[i]] {
                    print(dictionary.key.lightCyan(),": ",dictstr.white())
                }
            }
        }
    }

    //if CommandLine.arguments.count == 3 
    func Calculation2 (key: String?, language: String?) {
        if key != nil {
            Calculation2_Key_K(key: key!)
        }
        
        if language != nil {
            Calculation2_Key_L(language: language!) 
        }
    }

    func Calculation2_Key_K (key: String) {
        print(key.lightMagenta())
        var presencearg = false

        for dictionary in dictionaryarr {
            if let dictstr = dictionary.value[key] {
                presencearg = true
                print(dictionary.key.lightCyan(),": ",dictstr.white())
            }
        }
        if !presencearg {print("Такого слова в словаре нет".lightRed())}
    }

    func Calculation2_Key_L (language: String) {
        var presencearg = false
        for dictionary in dictionaryarr {
            if dictionary.key == language {
                for dictElement in dictionary.value {
                    presencearg = true
                    print(dictElement.key.lightMagenta()," = ",dictElement.value.white())
                }
            }
        }
        if !presencearg {print("Такого языка для перевода в словаре нет".lightRed())}
    }

    //if CommandLine.arguments.count == 5
    func Calculation3(key: String, language: String) {  
        var keytrue = 0
        
        for dictionary in dictionaryarr {
            if dictionary.key == language {
                keytrue += 1
                for dictElement in dictionary.value {
                    if dictElement.key == key {
                        keytrue += 1
                        print(dictElement.value.white())
                    }
                }
            }
        }
        if keytrue < 2 {
            print("Not found".lightRed())}       
    }
}    