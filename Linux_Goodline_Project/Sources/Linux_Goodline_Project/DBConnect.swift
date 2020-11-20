import Foundation
   
class DBConnect: DBProtocol  {
    
    private var dictionaryarr: [String: [String: String]] = [:]
    private let pathurl: String
    
    init() {    
        //объявляем путь к файлу с данными из словаря    
        //private let url = Bundle.module.url(forResource:"dictionary", withExtension: "json")!
        //private let pathurl = Bundle.module.path(forResource:"dictionary", ofType: "json") ?? "dictionary.json"
        self.pathurl = Bundle.module.path(forResource:"dictionary", ofType: "json") ?? "dictionary.json"
        
    }

    func ConnectToDB() -> [String: [String: String]]? { 
        do {      
            //считывание данных (словаря) из файла -------------------------
            let fileManager = FileManager.default
            //if let dataFile = fileManager.contents(atPath: url.path){
            if let dataFile = fileManager.contents(atPath: pathurl){
                dictionaryarr = (try? JSONDecoder().decode([String: [String: String]].self, from: dataFile)) ?? [:]
            //} else { dictionaryarr = [:]
            }
            return dictionaryarr
        }  
        catch {
            return nil
            //print("Ошибка соединения с базой данных!")
            //exit(0)
        }          
    }

    func WriteDictionaryToDB(dictionaryarr: [String: [String: String]]) -> Bool { 
        do {
            JSONEncoder().outputFormatting = .prettyPrinted
            let json = try JSONEncoder().encode(dictionaryarr.self)
            try json.write(to: URL(fileURLWithPath: pathurl))
            return true
        } 
        catch {
            return false
        }    
            
    }
    
}