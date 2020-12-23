protocol WriteProtocol {
    func DisplayAnError(keywords: RepositoryResultError) -> Int
    func PrintResultKeyL(dictionary: [String: [String: String]])
    func PrintResult(dictionary: [String: [String: String]])
}