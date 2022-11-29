//
//  File.swift
//  
//
//  Created by Mudassar Ahmad on 29/11/2022.
//

import Foundation

public protocol RequestManager{
    func sendApiRequest<T: Decodable>(request: Request, responseModel: T.Type) async -> Result<T, RequestError>
}
extension RequestManager {
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
