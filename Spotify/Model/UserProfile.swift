//
//  UserProfile.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 03/02/26.
//

import Foundation

struct UserProfile: Codable{
    let coubtry:String
    let display_name:String
    let email:String
    let explicit_content:[String:Bool]
    let external_urls:[String:String]
    let id:String
    let images:[APIImage]
    let product:String
}

struct APIImage: Codable{
    let height:Int
    let url:String
    let width:Int
}
