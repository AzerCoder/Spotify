//
//  AuthResponse.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 03/02/26.
//

import Foundation

struct AuthResponse: Codable{
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
}
