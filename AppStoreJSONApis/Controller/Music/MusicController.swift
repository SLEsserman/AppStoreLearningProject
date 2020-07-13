//
//  MusicController.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 7/13/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit
// 1. Implement Cell
// 2. Implement a footer for the loader view

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId      = "cellId"
    fileprivate let footerId    = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        
        fetchData()
    }
    
    var results = [Result]()
    
    fileprivate let searchTerm = "kendrick-lamar"
    
    
    fileprivate func fetchData() {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=40&limit=20"
        Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
            
            if let err = err {
                print("Failed to paginate data:", err)
                return
            }
            
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(
            width: view.frame.width,
            height: 100)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    
    var isPaginating = false
    var isDonePaginating = false
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell                    = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        
        let track                   = results[indexPath.item]
        
        cell.nameLabel.text         = track.trackName
        cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
        cell.subtitleLabel.text     = "\(track.artistName ?? "") • \(track.collectionName ?? "")"
        
        // initiate pagination
        if indexPath.item == results.count - 1 && !isPaginating {
            print("fetch more data")
            
            isPaginating = true
            
            let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
                
                if let err = err {
                    print("Failed to paginate data:", err)
                    return
                }
                
                if searchResult?.results.count == 0 {
                    self.isDonePaginating = true
                }
                
                sleep(2)
                
                self.results += searchResult?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(
            width: view.frame.width,
            height: height)
    }
}
