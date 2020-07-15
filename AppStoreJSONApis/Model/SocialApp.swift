//
//  SocialApp.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/12/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import Foundation

struct SocialApp: Decodable, Hashable {
    let id, name, imageUrl, tagline: String
}
