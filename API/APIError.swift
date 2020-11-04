//
//  APIError.swift
//  API
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import Foundation

public enum APIError: Error {
    case noConnection
    case unauthorized
    case serverError
    case invalidResource
    case endPointError([String: Any])
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noConnection:
            return "ERROR_CONNECTION".localized()
        case .unauthorized:
            return "Unautorized"
        case .serverError, .invalidResource:
            return "ERROR_SERVER_RESPONSE".localized()
        case .endPointError(let details):
            if let error = details["error"] as? [String: Any], let msg = error["message"] as? String {
                return msg
            } else if let msg = details["message"]  as? String {
                return msg
            } else {
                return "ERROR_SERVER_RESPONSE".localized()
            }
        }
    }
}

extension String {
    func localized(table: String? = nil) -> String {
        return NSLocalizedString(self, tableName: table, bundle: Bundle(identifier: "com.juanvillaescusa.API")!, value: "", comment: "")
    }
}
