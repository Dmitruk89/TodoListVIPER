//
//  MockURLSession.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import Foundation
@testable import ToDoAppVIPER

final class MockURLSession: URLSessionProtocol {

    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {

        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}
