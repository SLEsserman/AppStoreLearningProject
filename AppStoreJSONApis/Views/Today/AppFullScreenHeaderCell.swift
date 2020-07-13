//
//  AppFullScreenHeaderCell.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/21/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class AppFullScreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(todayCell)
        todayCell.fillSuperview()
        
//        addSubview(closeButton)
//        closeButton.anchor(
//            top: topAnchor,
//            leading: nil,
//            bottom: nil,
//            trailing: trailingAnchor,
//            padding: .init(
//                top: 44,
//                left: 0,
//                bottom: 0,
//                right: 12),
//            size: .init(
//                width: 80,
//                height: 38))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
