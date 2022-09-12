//
//  RequestError.swift
//  StarzPlayCodeChallenge
//
//  Created by Qazi Ammar Arshad on 09/09/2022.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized(reason: String?)
    case sessionExpried
    case unexpectedStatusCode
    case unknown

   public var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized(let reason):
            return reason ?? "Session expired"
        default:
            return "Unknown error"
        }
    }
}
