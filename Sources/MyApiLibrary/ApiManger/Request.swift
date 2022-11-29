//
//  File.swift
//  
//
//  Created by Qazi Ammar Arshad on 15/09/2022.
//

import Foundation

public protocol Request {
    var url: URL {get}
    var method: HttpMethod {get}
    var headers: [String: String]? { get }
}
extension Request {

    var headers: [String: String]?{
        [:]
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: url)

        switch method {
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
        request.httpMethod = method.name
        return request
    }
}


public enum HttpMethod{
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

public protocol NetworkManager{
    func sendApiRequest<T: Decodable>(request: Request, responseModel: T.Type) async -> Result<T, RequestError>
}
extension NetworkManager {
    public  func sendApiRequest<T: Decodable>(request: Request, responseModel: T.Type) async -> Result<T, RequestError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request.urlRequest, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }

            switch response.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                    return .success(decodedResponse)

                } catch let error {
                    print(error)
                    return .failure(.decode)
                }

            case 401:
                let error = try parseJSON(from: data)
                return .failure(.unauthorized(reason: error.statusMessage))

            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }

    }

}
//Useage Example
enum  apiLoginRequest{
    case fetchLogin(name:String,email:String)
}

extension apiLoginRequest:Request{
    var url: URL {
        switch self {
        case .fetchLogin:
            return URL(string: "https://api.github.com/search/repositories")!
        }
    }

    var method: HttpMethod {
        switch self {
        case .fetchLogin(let name, let email):
           
            return .post([
                "email": email,
                "name": name
            ])
        }
    }


}
