//
//  TodayItem.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/21/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit


struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    
    //enum
    let cellType: CellType
    
    let apps: [FeedResult]
    
    enum CellType: String {
        case single, multiple
    }
}
