//
//  UserProfile.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 03/02/26.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let displayName: String
    let email: String
    let explicitContent: ExplicitContent
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let product: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case id
        case images
        case product
    }
}

struct ExplicitContent: Codable {
    let filterEnabled: Bool
    let filterLocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

struct APIImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}
