//
//  NetworkManger.swift
//  StarzPlayCodeChallenge
//
//  Created by Qazi Ammar Arshad on 09/09/2022.
//

import Foundation

public protocol NetworkManagerService {
    func sendApiRequest<T: Decodable>(endpoint: ApiEndpoint, responseModel: T.Type) async -> Result<T, RequestError>
}
extension NetworkManagerService {
  public  func sendApiRequest<T: Decodable>(endpoint: ApiEndpoint, responseModel: T.Type) async -> Result<T, RequestError> {

        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            } catch {
                return .failure(.unknown)
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
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
    private func parseJSON(from data: Data) throws -> GenricModel {
        do {
            return try JSONDecoder().decode(GenricModel.self, from: data)
            /// force logout here if neened
        } catch let error {
            print(error)

        }
        return GenricModel()
    }
}
