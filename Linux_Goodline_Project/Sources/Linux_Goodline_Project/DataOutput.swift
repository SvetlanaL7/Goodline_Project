import Foundation
   
class DataOutput: WriteProtocol  {
    
    func DisplayAnError(subcommand: String, keywords: String?)
    {
        switch subcommand {
            case "search":
                switch keywords {
                    case "KeysNil":
                        print("Не удалось получить данные из словаря!".lightRed())
                    case "KeyK":
                        print("Такого слова в словаре нет".lightRed())
                    case "KeyL":
                        print("Такого языка для перевода в словаре нет".lightRed())
                    case "KeysKL":
                        print("Not found".lightRed())
                    default:
                        return
                }
            case "update":
                print("Ошибка! Команда 'update' не выполнена!".red())
                //print(Commands.helpMessage().onRed())
            case "delete":
                print("Ошибка! Команда 'delete' не выполнена!".red())
                //print(Commands.helpMessage().onRed())
            default:
                print("Ошибка!")
                return
        }
    }

    func WriteDiactionary(keywords: String?, wordForWrite: String?, dictionary: [String: [String: String]]?)
    {
        guard dictionary != [:] || wordForWrite != nil else {
            print("Словарь пуст!")
            return
        } 

        switch keywords {
            case "KeyL":
                for dict in dictionary! {  
                    for dictionaryValue in dict.value {
                        print(dictionaryValue.key.lightCyan(),"=",dictionaryValue.value.white())
                    }
                }
            case "KeyK", "KeysNil":
                PrintResult(dictionary: dictionary!)
            case "KeysKL":
                print(wordForWrite!.white())
            default:
                print("Ошибка обработки запроса!")
                return     
        }
    }

    func PrintResult(dictionary: [String: [String: String]])
    {
        var keyLanguage: [String] = []
            
        for dict in dictionary {  //ищет значение словаря среди значений словарей в массиве словарей и выводит язык (ru/en/pt)
            for dictionaryValue in dict.value {
                 keyLanguage.append(String(dictionaryValue.key))
            }
        }

        keyLanguage = Array(Set(keyLanguage))
        
        for i in 0...keyLanguage.count-1 {
            print(keyLanguage[i].lightMagenta())
                            
            for dict in dictionary {
                if let dictStr = dict.value[keyLanguage[i]] {
                    print(dict.key.lightCyan(),": ",dictStr.white())
                }
            }
        }
    }

}