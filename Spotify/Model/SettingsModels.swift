//
//  SettingsModels.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 09/02/26.
//

import Foundation

struct Section{
    let title:String
    let options: [Option]
}

struct Option{
    let title: String
    let handler: (() -> Void)
}
