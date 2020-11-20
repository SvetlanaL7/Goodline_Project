protocol DBProtocol {
    func ConnectToDB() -> [String: [String: String]]? 
    func WriteDictionaryToDB(dictionaryarr: [String: [String: String]]) -> Bool
}    