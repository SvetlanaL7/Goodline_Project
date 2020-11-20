enum RepositoryResult {
    case search(status: Bool, keywords: String?, wordForWrite: String?, dictionary: [String: [String: String]]?)
    case update(status: Bool)
    case delete(status: Bool)
}