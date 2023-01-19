//
//  RequestError.swift
//  StarzPlayCodeChallenge
//
//  Created by Qazi Mudassar Tanveer on 09/09/2022.
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
    case noInternet

   public  var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized(let reason):
            return reason ?? "Session expired"
        case .noInternet:
            return "No Internet Connection"
        default:
            return "Unknown error"
        }
    }
}
