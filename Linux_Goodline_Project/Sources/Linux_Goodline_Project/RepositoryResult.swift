enum RepositoryResult {
    case search(status: Bool, dictionary: [String: [String: String]])
    case update(status: Bool)
    case delete(status: Bool)
}