import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Linux_Goodline_ProjectTests.allTests),
    ]
}
#endif