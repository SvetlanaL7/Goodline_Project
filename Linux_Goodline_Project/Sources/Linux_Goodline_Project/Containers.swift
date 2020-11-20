import Foundation

class Container {
    var argumentsParserProtocol: ArgumentsParserProtocol {
        return ArgumentParserKey()
    }
}

class RepositoryContainer {
    var repoitoryProtocol: RepositoryProtocol {
        return RepositoryGetValue()
    }
}

class WriteContainer {
    var writeProtocol: WriteProtocol {
        return DataOutput()
    }
}

/*class DBContainer {
    var dbProtocol: DBProtocol {
        return DBConnect()
    }
}*/