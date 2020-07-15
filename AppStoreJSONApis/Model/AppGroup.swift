//
//  AppGroup.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/12/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import Foundation


struct AppGroup: Decodable {
    let feed: Feed
}


struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}


struct FeedResult: Decodable, Hashable {
    let id, name, artistName, artworkUrl100: String
}


