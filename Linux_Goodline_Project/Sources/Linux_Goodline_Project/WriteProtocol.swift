protocol WriteProtocol {
    func DisplayAnError(keywords: RepositoryResultError)
    func PrintResultKeyL(dictionary: [String: [String: String]])
    func PrintResult(dictionary: [String: [String: String]])
}