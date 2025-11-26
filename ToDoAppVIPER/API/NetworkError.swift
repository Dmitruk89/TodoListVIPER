//
//  NetworkError.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

import Foundation

public enum NetworkError: Error {
    case badURL
    case transportError(Error)
    case badResponse(statusCode: Int)
    case decodingError(Error)
    case unknown
}
