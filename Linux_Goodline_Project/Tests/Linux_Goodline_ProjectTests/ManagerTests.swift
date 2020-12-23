@testable import Linux_Goodline_Project

import XCTest

final class ManagerTests: XCTestCase {
    private var dbMock: DbProtocolMocks!
    private var managerGetValue: ManagerGetValue!

    override func setUp() {
        super.setUp()
        dbMock = DbProtocolMocks()
        managerGetValue = ManagerGetValue(dictionaryProtocol: dbMock)  
    }

    override func tearDown() {
        dbMock = nil
        managerGetValue = nil
        super.tearDown()
    }

    func testDeleteWithKeyAndLanguage() throws {
        dbMock.requestWriteResult = true

        let key = "hello"
        let language = "ru"
        
        let result = managerGetValue.managerValueForDelete(key: key, language: language)
        
        guard case .success(let deleteResult) = result else {
            guard case .failure(.deleteNotFound) = result else {
                guard case .failure(.dbConectFailed) = result else {
                    XCTFail("Ошибка записи новых данных в словарь! Не удалось записать словарь после удаления данных в БД.")
                    return
                }

                XCTFail("Ошибка соединения с базой данных!")
                return
            }

            XCTFail("Не нашел слово для удаления по данным ключам.")
            return
        }
               
        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 1)
    }

    func testDeleteWithKey() throws {
        dbMock.requestWriteResult = true
        let result = managerGetValue.managerValueForDelete(key: "hello", language: nil) 
        
        guard case .success(.deleteSuccess) = result else {
            guard case .failure(.deleteNotFoundKey) = result else {
                guard case .failure(.dbConectFailed) = result else {
                    XCTFail("Ошибка записи новых данных в словарь! Не удалось записать словарь после удаления данных в БД.")
                    return
                }

                XCTFail("Ошибка соединения с базой данных!")
                return
            }

            XCTFail("Не нашел слово для удаления по данному ключу в словаре.")
            return
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 1)
    }

    func testDeleteWithLanguage() throws {
        dbMock.requestWriteResult = true
        let result = managerGetValue.managerValueForDelete(key: nil, language: "ru")
        
        guard case .success(.deleteSuccess) = result else {
            guard case .failure(.deleteNotFoundLanguage) = result else {
                guard case .failure(.dbConectFailed) = result else {
                    XCTFail("Ошибка записи новых данных в словарь! Не удалось записать словарь после удаления данных в БД.")
                    return
                }

                XCTFail("Ошибка соединения с базой данных!")
                return
            }

            XCTFail("Не нашел данный язык для удаления в словаре.")
            return
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 1)
    }

    func testDeleteNotFound() throws {
        let result = managerGetValue.managerValueForDelete(key: "-", language: "-")
        
        guard case .failure(.deleteNotFound) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Нашел и удалил слова по несуществующим ключам в словаре, но не смог записать измененный словарь в БД.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return 
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 0)
    }

    func testDeleteNotFoundKey() throws {
        let result = managerGetValue.managerValueForDelete(key: "-", language: nil)
        
        guard case .failure(.deleteNotFoundKey) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Нашел и удалил слово по несуществующим ключам в словаре, но не смог записать измененный словарь в БД.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return 
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 0)
    }

    func testDeleteNotFoundLanguage() throws {
        let result = managerGetValue.managerValueForDelete(key: nil, language: "-")
        
        guard case .failure(.deleteNotFoundLanguage) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Нашел и удалил слова по несуществующим ключам в словаре, но не смог записать измененный словарь в БД.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return 
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 0)
    }

    func testDeleteArgumentsFailed() throws {
        let result = managerGetValue.managerValueForDelete(key: nil, language: nil)
        
        guard case .failure(.deleteArgumentsFailed) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Удалил данные несмотря на то, что оба ключа были nil.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return    
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 0)
    }
    
    func testUpdate() throws {
        dbMock.requestWriteResult = true
        let result = managerGetValue.managerValueForUpdate(word: "Ola", key: "hello", language: "ru")
        
        guard case .success(.updateSuccess) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Не удалось добавить значение в словарь.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return  
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
        XCTAssertEqual(dbMock.requestWriteCallsCount, 1)
    }

    func testSearchWithKeyAndLanguage() throws {
        let result = managerGetValue.managerValueForSearch(key: "day", language: "en")
        
        guard case .success(.search(.keysKL, wordForWrite: Optional("Day"), dictionary: nil)) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Ошибка соединения с базой данных!")
                return
            }

            XCTFail("Не нашел слово по данным ключам в словаре.")
            return
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }


    func testSearchRepositoryWithoutKeys() throws {
        let result = managerGetValue.managerValueForSearch(key: nil, language: nil)
        
        guard case .success(let searchResult) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Словарь пуст!")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }    

    func testSearchRepositoryWithKey() throws {
        let result = managerGetValue.managerValueForSearch(key: "hello", language: nil)
        
        guard case .success(let searchResult) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Не нашел слово по данному ключу -k.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return    
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }

    func testSearchRepositoryWithLanguage() throws {
        let result = managerGetValue.managerValueForSearch(key: nil, language: "en")
        
        guard case .success(let searchResult) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Не нашел данный язык в словаре.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return       
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }

    func testSearchNotFound() throws {
        let result = managerGetValue.managerValueForSearch(key: "-", language: "-")
        
        guard case .failure(.notFound) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Нашел слова по несуществующим значениям ключей.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return     
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }

    func testSearchNotFoundKey() throws {
        let result = managerGetValue.managerValueForSearch(key: "-", language: nil)
        
        guard case .failure(.notFoundKey) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Нашел несуществующее слово (по данному ключу -k) в словаре.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return     
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }
    
    func testSearchNotFoundLanguage() throws {
        let result = managerGetValue.managerValueForSearch(key: nil, language: "-")
        
        guard case .failure(.notFoundLanguage) = result else {
            guard case .failure(.dbConectFailed) = result else {
                XCTFail("Нашел несуществующий язык в словаре.")
                return
            }

            XCTFail("Ошибка соединения с базой данных!")
            return 
        }

        XCTAssertEqual(dbMock.requestDBCallsCount, 1)
    }

    static var allTests = [
        ("testSearchRepositoryWithoutKeys", testSearchRepositoryWithoutKeys),
        ("testDeleteWithKeyAndLanguage", testDeleteWithKeyAndLanguage),
        ("testDeleteWithKey", testDeleteWithKey),
        ("testDeleteWithLanguage", testDeleteWithLanguage),
        ("testDeleteNotFound", testDeleteNotFound),
        ("testDeleteNotFoundKey", testDeleteNotFoundKey),
        ("testDeleteNotFoundLanguage", testDeleteNotFoundLanguage),
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
