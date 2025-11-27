//
//  TodoAPIServiceTests.swift
//  ToDoAppVIPERTests
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import XCTest
@testable import ToDoAppVIPER

private enum TestData {
    static let baseURL = URL(string: "https://dummyjson.com/todos")!

    static let validJSON = """
    {
        "todos": [{ "id": 1, "todo": "Test", "completed": false }],
        "total": 1
    }
    """.data(using: .utf8)!

    static let invalidJSON = "invalid json".data(using: .utf8)!
}


private func makeResponse(status: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: TestData.baseURL, statusCode: status, httpVersion: nil, headerFields: nil)!
}


final class TodoAPIServiceTests: XCTestCase {

    private var mockSession: MockURLSession!
    private var service: TodoAPIService!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        service = TodoAPIService(baseURLString: "https://dummyjson.com", session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        service = nil
        super.tearDown()
    }

    func testFetchTodosSuccess() {
        mockSession.data = TestData.validJSON
        mockSession.response = makeResponse(status: 200)
        mockSession.error = nil

        let expectation = expectation(description: "Success fetch")

        service.fetchTodos { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.todos.count, 1)
                XCTAssertEqual(response.total, 1)
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodosTransportError() {
        mockSession.error = NSError(domain: "test", code: -1)

        let expectation = expectation(description: "Transport error")

        service.fetchTodos { result in
            switch result {
            case .failure(let error):
                if case .transportError = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Wrong error type")
                }
            default:
                XCTFail("Expected error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodosBadStatusCode() {
        mockSession.response = makeResponse(status: 500)

        let expectation = expectation(description: "Bad response")

        service.fetchTodos { result in
            switch result {
            case .failure(let error):
                if case .badResponse(let code) = error {
                    XCTAssertEqual(code, 500)
                } else {
                    XCTFail("Wrong error case")
                }
            default:
                XCTFail("Expected error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFetchTodosDecodingError() {
        mockSession.data = TestData.invalidJSON
        mockSession.response = makeResponse(status: 200)

        let expectation = expectation(description: "Decoding error")

        service.fetchTodos { result in
            switch result {
            case .failure(let error):
                if case .decodingError = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Wrong error type")
                }
            default:
                XCTFail("Expected decoding error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
