import Foundation

class Container {
    var argumentsParserProtocol: ArgumentsParserProtocol {
        return ArgumentParserKey()
    }
}

class DBContainer {
    var dbProtocol: DBProtocol {
        return DBConnect()
    }
}

class RepositoryContainer {
    var repoitoryProtocol: RepositoryProtocol {
        return RepositoryGetValue(dictionaryProtocol: DBContainer().dbProtocol)
    }
}

class WriteContainer {
    var writeProtocol: WriteProtocol {
        return DataOutput()
    }
}

