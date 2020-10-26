import Foundation
import ColorizeSwift

class CommandLineArguments {
    public var valueKey: String? = nil
    public var valueLanguage: String? = nil
    public var argumentCount: Int = -1
    
    func commandArgs() -> (Int, String?, String?) {
        switch CommandLine.arguments.count {
            case 1:
                argumentCount = 0
                break
            case 3:
                argumentCount = 1
                ReadArguments2()
            case 5:
                argumentCount = 2
                ReadArguments3()
            default:
                print("не удалось распознать введенное значение".lightRed())
        }

        //кортеж
        return (
        argumentCount: argumentCount,    
        valueKey: valueKey,
        valueLanguage: valueLanguage
        )
    }

    func ReadArguments2() {
        guard CommandLine.arguments[1] == "-k" || CommandLine.arguments[1] == "-l" else {
            print("Ошибка ввода ключа!".lightRed())
            exit(0)
        }

        if CommandLine.arguments[1] == "-k" {
            valueKey = CommandLine.arguments[2]
        }
        
        if CommandLine.arguments[1] == "-l" {
            valueLanguage = CommandLine.arguments[2]
        }
    }

    func ReadArguments3() {
        if CommandLine.arguments[1] == "-k" && CommandLine.arguments[3] == "-l" {
            valueKey = CommandLine.arguments[2]
            valueLanguage = CommandLine.arguments[4]
        }
        if CommandLine.arguments[1] == "-l" && CommandLine.arguments[3] == "-k" {
            valueKey = CommandLine.arguments[4]
            valueLanguage = CommandLine.arguments[2]
        }

        guard valueKey != nil && valueLanguage != nil else {
            print("Ошибка ввода данных!".lightRed())
            exit(0)
        }

        guard valueKey != "" && valueLanguage != "" else {
            print("Ошибка ввода данных!".lightRed())
            exit(0)
        }
    }
}



















/*import Foundation

class CommandLineArgumentsw//: DictionaryMain
{
    var valuekeyK = ""
    var valuekeyL = ""

    func commandArgs() -> Args {
        switch CommandLine.arguments.count {
        case 1:
            ReadArguments1()
        case 3:
            ReadArguments2()
        case 5:
            ReadArguments3()
        default:
            print("не удалось распознать введенное значение")
        }

        return Args(
            valuekeyK: valuekeyK,
            valuekeyL: valuekeyL
        )
    }

    func ReadArguments1(){
        valuekeyK = ""
        valuekeyL = "" 
    }

    func ReadArguments2(){
        guard CommandLine.arguments[1] == "-k" || CommandLine.arguments[1] == "-l"
        else {print("Ошибка ввода ключа!");exit(0)}

        if CommandLine.arguments[1] == "-k"
        {
            valuekeyK = CommandLine.arguments[2]
        }
        
        if CommandLine.arguments[1] == "-l"
        {
            valuekeyL = CommandLine.arguments[2]
        }
    }



    func ReadArguments3()
    {
        var valuekeyK = ""
        var valuekeyL = ""

        if CommandLine.arguments[1] == "-k" && CommandLine.arguments[3] == "-l"
        {
            valuekeyK = CommandLine.arguments[2]
            valuekeyL = CommandLine.arguments[4]
        }
        if CommandLine.arguments[1] == "-l" && CommandLine.arguments[3] == "-k"
        {
            valuekeyK = CommandLine.arguments[4]
            valuekeyL = CommandLine.arguments[2]
        }
        guard valuekeyK != "" && valuekeyL != ""
        else {print("Ошибка ввода данных!");exit(0)}
    }
}
*/