//
//  EndPoint.swift
//  StarzPlayCodeChallenge
//
//  Created by Qazi Mudassar Tanveer on 09/09/2022.
//

import Foundation

public protocol ApiEndpoint: Sendable {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}

