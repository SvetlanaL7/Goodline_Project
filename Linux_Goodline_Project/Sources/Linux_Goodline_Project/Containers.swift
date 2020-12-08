import Foundation

class Container {
    var argumentsParserProtocol: ArgumentsParserProtocol {
        return ArgumentParserKey()
    }
}

class DbContainer {
    var dbProtocol: DbProtocol {
        return DbConnect()
    }
}

class RepositoryContainer {
    var repoitoryProtocol: RepositoryProtocol {
        return RepositoryGetValue(dictionaryProtocol: DbContainer().dbProtocol)
    }
}

class WriteContainer {
    var writeProtocol: WriteProtocol {
        return DataOutput()
    }
}

