public protocol DBProtocol {
    func GetValueFromDB() -> [String: [String: String]]? 
    func WriteDictionaryToDB(dictionaryValue: [String: [String: String]]) -> Bool
}    