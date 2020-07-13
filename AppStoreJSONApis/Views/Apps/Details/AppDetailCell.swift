//
//  AppDetailCelll.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/14/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    
    var app: Result! {
        didSet {
            nameLabel.text                 = app?.trackName
            releaseNotesLabel.text         = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceButton.setTitle(app?.formattedPrice, for: .normal)
        }
    }
    
    let appIconImageView    = UIImageView(cornerRadius: 16)
    let nameLabel           = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    let priceButton         = UIButton(title: "$4.99")
    let whatsNewLabel       = UILabel(text: "What's new", font: .boldSystemFont(ofSize: 20))
    let releaseNotesLabel   = UILabel(text: "Notes", font: .systemFont(ofSize: 18), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appIconImageView.backgroundColor = .red
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        
        priceButton.backgroundColor                     = .blue
        priceButton.constrainHeight(
            constant: 32)
        priceButton.layer.cornerRadius                  = 32 / 2
        priceButton.titleLabel?.font                    = UIFont.boldSystemFont(ofSize: 16)
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.constrainWidth(
            constant: 80)
        
        let stackView = VerticalStackView(
            arrangedSubviews: [
                UIStackView(
                    arrangedSubviews: [
                        appIconImageView,
                        VerticalStackView(
                            arrangedSubviews: [
                                nameLabel,
                                UIStackView(
                                    arrangedSubviews: [
                                        priceButton,
                                        UIView()
                                ]),
                                UIView()
                        ], spacing: 12)
                ], customSpacing:  20),
                whatsNewLabel,
                releaseNotesLabel
        ], spacing: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}
