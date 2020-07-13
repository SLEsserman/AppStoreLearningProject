//
//  MusicLoadingFooter.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 7/13/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let aiv             = UIActivityIndicatorView(style: .large)
        aiv.color           = .darkGray
        aiv.startAnimating()
        
        let label           = UILabel(text: "Loading More...", font: .systemFont(ofSize: 16))
        label.textAlignment = .center
        let stackView       = VerticalStackView(arrangedSubviews: [aiv, label], spacing: 30)
        
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 20))
        
        addSubview(aiv)
        aiv.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
