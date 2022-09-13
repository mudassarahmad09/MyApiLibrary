//
//  File.swift
//  
//
//  Created by Qazi Mudassar Tanveer on 12/09/2022.
//

import Foundation

struct GenricModel: Codable {
    var statusCode: Int?
    var statusMessage: String?
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case statusCode
        case statusMessage
        case success
    }
}
