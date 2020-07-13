//
//  SearchResultCell.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/7/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    var appResult: Result! {
        didSet {
            nameLabel.text      = appResult.trackName
            categoryLabel.text  = appResult.primaryGenreName
            ratingsLabel.text   = "Ratings: \(appResult.averageUserRating ?? 0)"
            
            let url = URL(string: appResult.artworkUrl100)
            appIconImageView.sd_setImage(with: url)
            
            screenshotOneImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
            if appResult.screenshotUrls.count > 1 {
                screenshotTwoImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
            }
            if appResult.screenshotUrls.count > 2 {
                screenshotThreeImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
            }
        }
    }
    
    let appIconImageView: UIImageView = {
        let iv                                                      = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 64).isActive     = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive    = true
        iv.layer.cornerRadius                                       = 12
        iv.clipsToBounds                                            = true
        return iv
    }()
    
    
    
    let nameLabel: UILabel = {
        let label       = UILabel()
        label.text      = "APP NAME"
        return label
    }()
    
    
    let categoryLabel: UILabel = {
        let label       = UILabel()
        label.text      = "Photos & Videos"
        return label
    }()
    
    
    let ratingsLabel: UILabel = {
        let label       = UILabel()
        label.text      = "9.56M"
        return label
    }()
    
    
    
    let getButton: UIButton = {
        let button                                                      = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font                                         = .boldSystemFont(ofSize: 14)
        button.backgroundColor                                          = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive     = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive    = true
        button.layer.cornerRadius                                       = 16
        return button
    }()
    
    lazy var screenshotOneImageView         = self.createScreenshotImageView()
    lazy var screenshotTwoImageView         = self.createScreenshotImageView()
    lazy var screenshotThreeImageView       = self.createScreenshotImageView()
    
    func createScreenshotImageView() -> UIImageView {
        let imageView                       = UIImageView()
        imageView.layer.cornerRadius        = 8
        imageView.clipsToBounds             = true
        imageView.layer.borderWidth         = 0.5
        imageView.layer.borderColor         = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode               = .scaleAspectFill
        return imageView
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let infoTopStackView = UIStackView(arrangedSubviews: [
            appIconImageView,
            VerticalStackView(
                arrangedSubviews: [
                nameLabel,
                categoryLabel,
                ratingsLabel
                ]),
            getButton])
        
        infoTopStackView.spacing          = 12
        infoTopStackView.alignment        = .center
        
        
        let screenshotsStackView = UIStackView(
            arrangedSubviews: [
                screenshotOneImageView,
                screenshotTwoImageView,
                screenshotThreeImageView])
        
        
        screenshotsStackView.spacing      = 12
        screenshotsStackView.distribution = .fillEqually
        
        
        let overallStackView = VerticalStackView(
            arrangedSubviews: [
                infoTopStackView,
                screenshotsStackView],
            spacing: 16)
        
        
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
