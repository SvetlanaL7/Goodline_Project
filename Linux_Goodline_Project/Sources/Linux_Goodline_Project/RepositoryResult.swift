import Foundation

public enum RepositoryResult: Equatable {
    case search( _ keywords: Keys, wordForWrite: String?, dictionary: [String: [String: String]]?)
    case updateSuccess
    case deleteSuccess
}

public enum RepositoryResultError: Error {
    case notFound
    case notFoundKey
    case notFoundLanguage
    case emptyDictionary
    case updateFailed
    case deleteFailed
    case deleteArgumentsFailed
    case dbConectFailed
    case deleteNotFound
}

public enum Keys: Equatable {
    case keysNil
    case keyK
    case keyL
    case keysKL
}
