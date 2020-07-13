//
//  ReviewCell.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/18/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    
    
    let titleLabel      = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    let authorLabel     = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let starLabel       = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let starsStackView: UIStackView = {
        var arrangeSubviews = [UIView]()
        (0..<5).forEach({ (_) in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangeSubviews.append(imageView)
        })
        
        arrangeSubviews.append(UIView())
        
        let stackView = UIStackView(arrangedSubviews: arrangeSubviews)
        return stackView
    }()
    
    let bodyLabel = UILabel(
        text: "Review Body\nReview Body\nReview Body\nReview Body\n",
        font: .systemFont(ofSize: 18),
        numberOfLines: 5)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor         = .systemGray3
        layer.cornerRadius      = 16
        clipsToBounds           = true
        
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel,
                authorLabel
            ], customSpacing: 8),
            starsStackView,
            bodyLabel
        ], spacing: 12)
        
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        
        
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(
                top: 20,
                left: 20,
                bottom: 0,
                right: 20))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
