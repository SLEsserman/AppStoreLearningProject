//
//  SearchResult.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/11/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
    
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String
    var formattedPrice: String?
    let description: String
    let releaseNotes: String?
    
}
