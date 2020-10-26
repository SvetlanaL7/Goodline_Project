import Foundation
import ColorizeSwift

//class DictionaryMain {
//объявляем путь к файлу с данными из словаря    
let url = Bundle.module.url(forResource:"dictionary", withExtension: "json")!
let dictionaryarr: [String: [String: String]]

//считывание данных (словаря) из файла -------------------------
let fileManager = FileManager.default
if let dataFile = fileManager.contents(atPath: url.path){
    dictionaryarr = (try? JSONDecoder().decode([String: [String: String]].self, from: dataFile)) ?? [:]
} else {
    dictionaryarr = [:]
}
//--------------------------------------------------------------

//считывание аргументов из командой строки ---------------------
/*let argumentsLine  = CommandLineArguments()
let (argumentCount, key, language) = argumentsLine.commandArgs()
if argumentCount < 0 {exit(0)}*/
//--------------------------------------------------------------

//считывание аргументов с помощью Argument Parser --------------
let argumentsLine  = ArgumentParserKey()
let (key, language) = argumentsLine.argumentsParse()
//--------------------------------------------------------------

if key != nil || language != nil {
    if key != nil && language != nil {
        Calculation3(key: key!, language: language!)
    } else {
        Calculation2(key: key, language: language)
    }
} else {
    Calculation1()
}

//if CommandLine.arguments.count == 1 
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
    if keytrue < 2 {print("Not found".lightRed())}    
}