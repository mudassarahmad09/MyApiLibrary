//
//  File.swift
//  
//
//  Created by Qazi Ammar Arshad on 15/09/2022.
//

import Foundation

public protocol Request {
    var url: URL {get}
    var methodType: HttpMethod {get}
    var headers: [String: String]? { get }
}

extension Request {

    var headers: [String: String]?{
        return ["Content-Type": "application/json;charset=utf-8"]
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)

        switch methodType {
        case .post(let data), .put(let data):
            if let body = data {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                    request.httpBody = jsonData
                } catch {
                    preconditionFailure("Couldn't create a body of url")
                }
            }
            //request.httpBody = data
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = methodType.name
        return request
    }
}
