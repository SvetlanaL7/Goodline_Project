protocol RepositoryProtocol {
   func repositoryValueForSearch(key: String?, language: String?) -> Result<RepositoryResult, RepositoryResultError> 
   func repositoryValueForUpdate(word: String, key: String, language: String) -> Result<RepositoryResult, RepositoryResultError> 
   func repositoryValueForDelete(key: String?, language: String?) -> Result<RepositoryResult, RepositoryResultError>    
}