protocol RepositoryProtocol {
    func repositoryValue(subcommand: String, word: String?, key: String?, language: String?) -> RepositoryResult?  
}