import Foundation
   
class DBConnect: DBProtocol  {
    
    private var dictionaryValue: [String: [String: String]] = [:]
    private let pathurl: String
    
    init() {    
        //объявляем путь к файлу с данными из словаря    
        //private let url = Bundle.module.url(forResource:"dictionary", withExtension: "json")!
        self.pathurl = Bundle.module.path(forResource:"dictionary", ofType: "json") ?? "dictionary.json"
    }

    func GetValueFromDB() -> [String: [String: String]]? {
        do {      
            //считывание данных (словаря) из файла -------------------------
            let fileManager = FileManager.default
            //if let dataFile = fileManager.contents(atPath: url.path){
            if let dataFile = fileManager.contents(atPath: pathurl) {
                dictionaryValue = (try? JSONDecoder().decode([String: [String: String]].self, from: dataFile)) ?? [:]
                return dictionaryValue
            }
            else {
                return nil
            } 
        }  
        //catch {return nil}
    }    

    func WriteDictionaryToDB(dictionaryValue: [String: [String: String]]) -> Bool { 
        do {
            JSONEncoder().outputFormatting = .prettyPrinted
            let json = try JSONEncoder().encode(dictionaryValue.self)
            try json.write(to: URL(fileURLWithPath: pathurl))
            return true
        } 
        catch {
            return false
        }    
            
    }
    
}
