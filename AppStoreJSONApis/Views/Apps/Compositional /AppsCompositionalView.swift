//
//  AppsCompositionalView.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 7/14/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import SwiftUI


class CompositionalController: UICollectionViewController {
    
    init() {
        
        let layout = UICollectionViewCompositionalLayout{ (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                // second section
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(
                    top: 0,
                    leading: 0,
                    bottom: 16,
                    trailing: 16)
                
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(0.8),
                        heightDimension: .absolute(300)),
                    subitems: [item])
                
                
                let section                             = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior     = .groupPaging
                section.contentInsets.leading           = 16
                
                let kind                                = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(50)),
                          elementKind: kind,
                          alignment: .topLeading)
                ]
                return section
            }
        }
        super.init(collectionViewLayout: layout) 
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerId,
            for: indexPath) as! CompositionalHeader
        
        var title: String?
        if indexPath.section == 1 {
            title = games?.feed.title
        } else if indexPath.section == 2 {
            title = topGrossingApps?.feed.title
        } else {
            title = freeApps?.feed.title
        }
        header.label.text = title
        return header
    }
    
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom                       = 16
        item.contentInsets.trailing                     = 16
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(300)), subitems: [item])
        
        let section                                     = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior             = .groupPaging
        section.contentInsets.leading                   = 16
        return section
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var socialApps = [SocialApp]()
    var games: AppGroup?
    var topGrossingApps: AppGroup?
    var freeApps: AppGroup?
    
    private func fetchApps() {
        Service.shared.fetchSocialApps { (apps, err) in
            self.socialApps = apps ?? []
            Service.shared.fetchGames { (appGroup, err) in
                self.games = appGroup
                Service.shared.fetchTopGrossing { (appGroup, err) in
                    self.topGrossingApps = appGroup
                    Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
                        self.freeApps = appGroup
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        // fire all fetches at once
        fetchAppsDispatchGroup()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label = UILabel(
            text: "Editor's Choice Games",
            font: .boldSystemFont(ofSize: 32))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(
            CompositionalHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerId)
        
        collectionView.register(
            AppsHeaderCell.self,
            forCellWithReuseIdentifier: "cellId")
        
        collectionView.register(
            AppRowCell.self,
            forCellWithReuseIdentifier: "smallCellId")
        
        collectionView.backgroundColor                          = .systemBackground
        navigationItem.title                                    = "Apps"
        navigationController?.navigationBar.prefersLargeTitles  = true
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free Apps", style: .plain, target: self, action: #selector(handleFetchTopFree))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        //fetchApps()
        
        setupDiffableDataSource()
    }
    
    
    @objc fileprivate func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.topFree])
        
        diffableDataSource.apply(snapshot)
    }
    
    
    @objc fileprivate func handleFetchTopFree() {
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
            
            var snapshot = self.diffableDataSource.snapshot()
            
            snapshot.insertSections([.topFree], afterSection: .topSocial)
            
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
            
            self.diffableDataSource.apply(snapshot)
        }
    }
    
    enum AppSection {
        case topSocial
        case grossing
        case games
        case topFree
    }
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            cell.app = object
            return cell
            
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            cell.app = object
            
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            
            return cell
        }
        return nil
    }
    
    
    @objc func handleGet(button: UIView) {
        
        var superview = button.superview
        
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectIClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                diffableDataSource.apply(snapshot)
                print(objectIClickedOnto)
            }
            superview = superview?.superview
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            
            navigationController?.pushViewController(appDetailController, animated: true)
            
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
    
    private func setupDiffableDataSource() {
        
        collectionView.dataSource = diffableDataSource
        
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            if let object = self.diffableDataSource.itemIdentifier(for: indexPath) {
                if let section = snapshot.sectionIdentifier(containingItem: object) {
                    if section == .games {
                        header.label.text = "GAMES"
                    } else if section == .grossing {
                        header.label.text = "Top Grossing"
                    } else {
                        header.label.text = "Top Free"
                    }
                }
            }
            return header
        })
        
        Service.shared.fetchSocialApps { (socialApps, err) in
            
            Service.shared.fetchTopGrossing { (appGroup, err) in
                
                Service.shared.fetchGames { (gamesGrup, err) in
                    var snapshot = self.diffableDataSource.snapshot()
                    
                    //top social
                    snapshot.appendSections([.topSocial, .grossing, .games])
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    //top grossing
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .grossing)
                    
                    snapshot.appendItems(gamesGrup?.feed.results ?? [], toSection: .games)
                    
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }
}


extension CompositionalController {
    func fetchAppsDispatchGroup() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            self.games = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            self.topGrossingApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
            self.freeApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { (apps, err) in
            dispatchGroup.leave()
            self.socialApps = apps ?? []
        }
        
        // completion
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}


struct AppsView: UIViewControllerRepresentable {
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    
    typealias UIViewControllerType = UIViewController
    
    
}


struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
