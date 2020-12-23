@testable import Linux_Goodline_Project

class DBProtocolMocks: DBProtocol {
    
    var requestDBParameters: ()!
    var requestDBResult: [String: [String: String]]? = ["ru": ["house": "Дом", "country": "Страна", "cave": "Пещера", "tree": "Дерево", "hello": "Привет", "road": "Дорога", "grass": "Трава", "rain": "Дождь", "sea": "Море", "day": "День", "world": "Мир", "river": "Река", "sun": "Солнце", "goodbye": "До свидания", "bridge": "Мост", "snow": "Снег", "lake": "Озеро", "night": "Ночь"], "en": ["day": "Day", "snow": "Snow", "world": "World", "rain": "Rain", "hello": "Hello", "goodbye": "Goodbye", "tree": "Tree", "road": "Road", "grass": "Grass", "ocean": "Ocean", "sun": "Sun", "river": "River", "country": "Country", "mountain": "Mountain", "house": "House", "sea": "Sea", "cave": "Cave", "bridge": "Bridge", "lake": "Lake", "night": "Night"], "pt": ["goodbye": "Tchau", "sun": "Sol", "river": "Rio", "bridge": "Ponte", "snow": "Neve", "tree": "Arvore", "grass": "Grama", "night": "Noite", "sea": "Mar", "cave": "Caverna", "lake": "Lago", "mountain": "Montanha", "day": "Dia", "house": "Casa", "country": "Pai", "world": "Mundo", "rain": "Chuva", "ocean": "Oceano"]]
    var requestDBCallsCount = 0
    func GetValueFromDB() -> [String: [String: String]]? {
        requestDBCallsCount += 1
        requestDBParameters = ()
        return requestDBResult
    }

    var requestWriteParameters: ([String: [String: String]])! 
    var requestWriteResult: Bool = false
    var requestWriteCallsCount = 0
    func WriteDictionaryToDB(dictionaryValue: [String: [String: String]]) -> Bool {
        requestWriteCallsCount += 1
        requestWriteParameters = dictionaryValue
        return requestWriteResult
    }
}