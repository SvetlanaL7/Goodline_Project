@testable import Linux_Goodline_Project

import XCTest

final class ArgumentsParserTests: XCTestCase {
    private var argumentsParser: ArgumentParserKey!

    override func setUp() {
        argumentsParser = ArgumentParserKey()
    }

    func testSearchWithoutKey() throws {
        let result = argumentsParser.argumentsParser(["search"])
        switch result {
            case .search(let key, let language):
                XCTAssertEqual(key, nil)
                XCTAssertEqual(language, nil)
            default:
                XCTFail()
        }
    }

    func testSearchKeyK() throws {
        let result = argumentsParser.argumentsParser(["search","-k","day"])
        switch result {
            case .search(let key, let language):
                XCTAssertEqual(key, "day")
                XCTAssertEqual(language, nil)
            default:
                XCTFail()
        }
    }

    func testSearchKeyL() throws {
        let result = argumentsParser.argumentsParser(["search","-l","ru"])
        switch result {
            case .search(let key, let language):
                XCTAssertEqual(key, nil)
                XCTAssertEqual(language, "ru")
            default:
                XCTFail()
        }
    }

    func testSearchKeysKL() throws {
        let result = argumentsParser.argumentsParser(["search","-k","hello","-l","ru"])
        switch result {
            case .search(let key, let language):
                XCTAssertEqual(key, "hello")
                XCTAssertEqual(language, "ru")
            default:
                XCTFail()
        }
    }

    func testUpdate() throws {
        let result = argumentsParser.argumentsParser(["update","Ola","-k","hello","-l","pt"])
        switch result {
            case .update(let word, let key, let language):
                XCTAssertEqual(word, "Ola")
                XCTAssertEqual(key, "hello")
                XCTAssertEqual(language, "pt")
            default:
                XCTFail()
        }
    }

    func testDeleteKeyK() throws {
        let result = argumentsParser.argumentsParser(["delete","-k","hello"])
        switch result {
            case .delete(let key, let language):
                XCTAssertEqual(key, "hello")
                XCTAssertEqual(language, nil)
            default:
                XCTFail()
        }
    }

    func testDeleteKeyL() throws {
        let result = argumentsParser.argumentsParser(["delete","-l","pt"])
        switch result {
            case .delete(let key, let language):
                XCTAssertEqual(key, nil)
                XCTAssertEqual(language, "pt")
            default:
                XCTFail()
        }
    }

    func testDeleteKeysKL() throws {
        let result = argumentsParser.argumentsParser(["delete","-k","hello","-l","ru"])
        switch result {
            case .delete(let key, let language):
                XCTAssertEqual(key, "hello")
                XCTAssertEqual(language, "ru")
            default:
                XCTFail()
        }
    }

    static var allTests = [
        ("testSearchWithoutKey", testSearchWithoutKey),
        ("testSearchKeyK", testSearchKeyK),
        ("testSearchKeyL", testSearchKeyL),
        ("testSearchKeysKL", testSearchKeysKL),
        ("testUpdate", testUpdate),
        ("testDeleteKeyK", testDeleteKeyK),
        ("testDeleteKeyL", testDeleteKeyL),
        ("testDeleteKeysKL", testDeleteKeysKL)
    ]
}