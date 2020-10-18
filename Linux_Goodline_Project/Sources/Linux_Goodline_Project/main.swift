import Foundation

var dictionaryarr = ["ru":["hello": "Привет", "day": "День", "sun": "Солнце","night":"Ночь","tree":"Дерево","grass":"Трава","house":"Дом","river":"Река","goodbye":"До свидания","road":"Дорога","bridge":"Мост","cave":"Пещера","snow":"Снег","rain":"Дождь","lake":"Озеро","sea":"Море","country":"Страна","world":"Мир"],
"en":["hello": "Hello", "day": "Day", "sun": "Sun","night":"Night","tree":"Tree","grass":"Grass","house":"House","river":"River","goodbye":"Goodbye","road":"Road","bridge":"Bridge","mountain":"Mountain","cave":"Cave","snow":"Snow","rain":"Rain","lake":"Lake","sea":"Sea","ocean":"Ocean","country":"Country","world":"World"],
"pt":["day": "Dia", "sun": "Sol","night":"Noite","tree":"Arvore","grass":"Grama","house":"Casa","river":"Rio","goodbye":"Tchau","bridge":"Ponte","mountain":"Montanha","cave":"Caverna","snow":"Neve","rain":"Chuva","lake":"Lago","sea":"Mar","ocean":"Oceano","country":"Pai","world":"Mundo"]]

//if CommandLine.arguments.count == 1 
func Calculation1()
{
    var keylanguage: [String] = []
  
    for dictionary in dictionaryarr  //ищет значение словаря среди значений словарей в массиве словарей и выводит язык (ru/en/pt)
    {
        for dictionaryValue in dictionary.value
        {
            keylanguage.append(String(dictionaryValue.key))
        }
    }

    keylanguage = Array(Set(keylanguage))
  
    for i in 0...keylanguage.count-1
    {
        print(keylanguage[i])
        
        for dictionary in dictionaryarr 
        {
            if let dictstr = dictionary.value[keylanguage[i]]
            {
                print(dictionary.key,": ",dictstr)
            }
        }
    }
}

//if CommandLine.arguments.count == 3 
func Calculation2()
{
    guard CommandLine.arguments[1] == "-k" || CommandLine.arguments[1] == "-l"
    else {print("Ошибка ввода ключа!");exit(0)}

    if CommandLine.arguments[1] == "-k"
    {
        Calculation2_Key_K()
    }
    
    if CommandLine.arguments[1] == "-l"
    {
        Calculation2_Key_L() 
    }
}

func Calculation2_Key_K()
{
    print(CommandLine.arguments[2])
    var presencearg = false

    for dictionary in dictionaryarr
    {
        if let dictstr = dictionary.value[CommandLine.arguments[2]]
        {
            presencearg = true
            print(dictionary.key,": ",dictstr)
        }
    }
    if !presencearg {print("Такого слова в словаре нет")}
}

func Calculation2_Key_L()
{
    var presencearg = false
    for dictionary in dictionaryarr 
    {
        if dictionary.key == CommandLine.arguments[2]
        {
            for dictElement in dictionary.value
            {
                presencearg = true
                print(dictElement.key," = ",dictElement.value)
            }
        }
    }
    if !presencearg {print("Такого языка для перевода в словаре нет")}
}

//if CommandLine.arguments.count == 5
func Calculation3()
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

    var keytrue = 0
    for dictionary in dictionaryarr 
    {
        if dictionary.key == valuekeyL //CommandLine.arguments[4]
        {
            keytrue += 1
            for dictElement in dictionary.value
            {
                if dictElement.key == valuekeyK //CommandLine.arguments[2]
                {
                    keytrue += 1
                    print(dictElement.value)
                }
            }
        }
    }

    if keytrue < 2 {print("Not found")}    
}


switch CommandLine.arguments.count {
case 1:
    Calculation1()
case 3:
    Calculation2()
case 5:
    Calculation3()
default:
    print("не удалось распознать введенное значение")
}



/* Calculation2() - Если после -k идет слово на любом языке, а не ключ-указатель
    var key = "" */
/*
        let word = CommandLine.arguments[2]
        
        //Если после -k идет слово на любом языке, а не ключ-указатель
        for dict in diction //.values
        {
            //if diction.keys == "en"
            //var dictstr = keylanguage[i]
            for dud in dict.value
            {
                //if let dictstr = dud[word]
                if dud.value == word
                {
                    key = dud.key
                    //print(diction.keys," ", dict.keys)
                    //print(dict.key," ",dictstr)
                }
            }
        }

        for dict in diction //.values
        {
            //if diction.keys == "en"
            //var dictstr = keylanguage[i]
            if let dictstr = dict.value[key]
            {
                //print(diction.keys," ", dict.keys)
                print(dict.key," ",dictstr)
            }
        }
        */