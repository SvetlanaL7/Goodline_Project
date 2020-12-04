@testable import Linux_Goodline_Project

import XCTest

final class RepositoryTests: XCTestCase {
    private var dbMock: DBProtocolMocks!
    private var repositoryGetValue: RepositoryGetValue!

    override func setUp() {
        super.setUp()
        dbMock = DBProtocolMocks()
        repositoryGetValue = RepositoryGetValue(dictionaryProtocol: dbMock)  
    }

    override func tearDown() {
        dbMock = nil
        repositoryGetValue = nil
        super.tearDown()
    }

    func testDeleteWithKeyAndLanguage() throws {
        dbMock.requestWriteResult = true

        let key = "hello"
        let language = "ru"
        
        guard case .success(let deleteResult) = repositoryGetValue.repositoryValueForDelete(key: key, language: language) else {
            XCTFail()
            return
        }
               
        XCTAssertEqual(dbMock.requestWriteCallsCount, 1)
    }

    func testDeleteWithKey() throws {
        dbMock.requestWriteResult = true
        let result = repositoryGetValue.repositoryValueForDelete(key: "hello", language: nil) 
        
        guard case .success(.deleteSuccess) = result else {
            XCTFail()
            return
        }
    }

    func testDeleteWithLanguage() throws {
        dbMock.requestWriteResult = true
        let result = repositoryGetValue.repositoryValueForDelete(key: nil, language: "ru")
        
        guard case .success(.deleteSuccess) = result else {
            XCTFail()
            return
        }
    }

    func testDeleteWithoutKeys() throws {
        let result = repositoryGetValue.repositoryValueForDelete(key: nil, language: nil)
        
        guard case .failure(.deleteArgumentsFailed) = result else {
            XCTFail()
            return
        }
    }

    func testDeleteNotFound() throws {
        let result = repositoryGetValue.repositoryValueForDelete(key: "-", language: "-")
        
        guard case .failure(.deleteNotFound) = result else {
            XCTFail()
            return
        }
    }

    func testDeleteArgumentsFailed() throws {
        let result = repositoryGetValue.repositoryValueForDelete(key: nil, language: nil)
        
        guard case .failure(.deleteArgumentsFailed) = result else {
            XCTFail()
            return
        }
    }
    
    func testUpdate() throws {
        dbMock.requestWriteResult = true
        let result = repositoryGetValue.repositoryValueForUpdate(word: "Ola", key: "hello", language: "ru")
        
        guard case .success(.updateSuccess) = result else {
            XCTFail()
            return
        }
    }

    func testSearchWithKeyAndLanguage() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: "day", language: "en")
        
        guard case .success(.search(.keysKL, wordForWrite: Optional("Day"), dictionary: nil)) = result else {
            XCTFail()
            return
        }
    }


    func testSearchRepositoryWithoutKeys() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: nil, language: nil)
        
        guard case .success(let searchResult) = result else {
            XCTFail()
            return
        }
    }    

    func testSearchRepositoryWithKey() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: "hello", language: nil)
        
        guard case .success(let searchResult) = result else {
            XCTFail()
            return
        }
    }

    func testSearchRepositoryWithLanguage() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: nil, language: "en")
        
        guard case .success(let searchResult) = result else {
            XCTFail()
            return
        }
    }

    func testSearchNotFound() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: "-", language: "-")
        
        guard case .failure(.notFound) = result else {
            XCTFail()
            return
        }
    }

    func testSearchNotFoundKey() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: "-", language: nil)
        
        guard case .failure(.notFoundKey) = result else {
            XCTFail()
            return
        }
    }
    
    func testSearchNotFoundLanguage() throws {
        let result = repositoryGetValue.repositoryValueForSearch(key: nil, language: "-")
        
        guard case .failure(.notFoundLanguage) = result else {
            XCTFail()
            return
        }
    }

    static var allTests = [
        ("testSearchRepositoryWithoutKeys", testSearchRepositoryWithoutKeys),
        ("testDeleteWithKeyAndLanguage", testDeleteWithKeyAndLanguage),
        ("testDeleteWithKey", testDeleteWithKey),
        ("testDeleteWithLanguage", testDeleteWithLanguage),
        ("testDeleteWithoutKeys", testDeleteWithoutKeys),
        ("testDeleteNotFound", testDeleteNotFound),
        ("testDeleteArgumentsFailed", testDeleteArgumentsFailed),
        ("testUpdate", testUpdate),
        ("testSearchWithKeyAndLanguage", testSearchWithKeyAndLanguage),
        ("testSearchRepositoryWithKey", testSearchRepositoryWithKey),
        ("testSearchRepositoryWithLanguage", testSearchRepositoryWithLanguage),
        ("testSearchNotFound", testSearchNotFound),
        ("testSearchNotFoundKey", testSearchNotFoundKey),
        ("testSearchNotFoundLanguage", testSearchNotFoundLanguage)
    ]
}
