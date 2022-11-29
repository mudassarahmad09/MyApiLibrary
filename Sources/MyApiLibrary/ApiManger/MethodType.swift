//
//  File.swift
//  
//
//  Created by Mudassar Ahmad on 29/11/2022.
//

import Foundation

public enum HttpMethod {
    case get([URLQueryItem])
    case put([String:Any]?)
    case post([String:Any]?)
    case delete
    case head

    public var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}
