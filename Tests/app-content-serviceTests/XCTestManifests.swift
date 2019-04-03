import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(app_content_serviceTests.allTests),
    ]
}
#endif