import Foundation
   
class DataOutput: WriteProtocol {
    
    func DisplayAnError(keywords:RepositoryResultError) {
        switch keywords {
            case .notFound:
                print("Not found".lightRed())
            case .notFoundKey:
                print("Такого слова в словаре нет".lightRed())
            case .notFoundLanguage:
                print("Такого языка для перевода в словаре нет".lightRed())
            case .emptyDictionary:
                print("Словарь пуст!".lightRed())
            case .updateFailed:
                print("Ошибка! Не удалось изменить данные в словаре! Команда 'update' не выполнена!".lightRed())
            case .deleteFailed:
                print("Ошибка! Не удалось изменить данные в словаре! Команда 'delete' не выполнена!".lightRed())
            case .deleteArgumentsFailed:
                print("Ошибка! Неверный ввод аргументов!".lightRed())
            case .dbConectFailed:
                print("Ошибка соединения с базой данных!".lightRed())
            case .deleteNotFound:
                print("Такого слова для удаления в словаре нет!".lightRed())    
        }    
    }    
          
    func PrintResultKeyL(dictionary: [String: [String: String]]) {
        for dict in dictionary {  
            for dictionaryValue in dict.value {
                print(dictionaryValue.key.lightCyan(),"=",dictionaryValue.value.white())
            }
        }

    }

    func PrintResult(dictionary: [String: [String: String]]) {
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
