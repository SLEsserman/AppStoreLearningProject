//
//  TodayController.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/19/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var items = [TodayItem]()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let aiv                 = UIActivityIndicatorView(style: .large)
        aiv.color               = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped    = true
        return aiv
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha                      = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden     = true
        collectionView.backgroundColor                  = #colorLiteral(red: 0.948936522, green: 0.9490728974, blue: 0.9489069581, alpha: 1)
        
        collectionView.register(TodayCell.self,forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self,forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    fileprivate func fetchData() {
        //dispatch group
        let dispatchGroup = DispatchGroup()
        
        var topFreeGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            topFreeGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        //Completion Block
        dispatchGroup.notify(queue: .main) {
            //Ill have access to grossing and games
            print("It worked")
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                
                TodayItem.init(
                    category: "LIFE HACK",
                    title: "Utilizing your Time",
                    image: #imageLiteral(resourceName: "garden"),
                    description: "All the tools and apps you need to intelligently organize your life the right way.",
                    backgroundColor: .white,
                    cellType: .single,
                    apps: []),
                
                TodayItem.init(
                    category: "Daily List",
                    title: topFreeGroup?.feed.title ?? "",
                    image: #imageLiteral(resourceName: "garden"),
                    description: "",
                    backgroundColor: .white,
                    cellType: .multiple,
                    apps: topFreeGroup?.feed.results ?? []),
                
                TodayItem.init(
                    category: "Daily List",
                    title: gamesGroup?.feed.title ?? "",
                    image: #imageLiteral(resourceName: "garden"),
                    description: "",
                    backgroundColor: .white,
                    cellType: .multiple,
                    apps: gamesGroup?.feed.results ?? []),
                
                TodayItem.init(
                    category: "HOLIDAYS",
                    title: "Travel on a Budget",
                    image: #imageLiteral(resourceName: "holiday"),
                    description: "Find out all you need to know on how to travel without packing everything!",
                    backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1),
                    cellType: .single,
                    apps: []),
            ]
            
            self.collectionView.reloadData()
        }
    }
    
    var appFullScreenController: AppFullScreenController!
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController          = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps         = self.items[indexPath.item].apps
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullScreen(indexPath: indexPath)
        }
    }
    
    
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullScreenController                                 = AppFullScreenController()
        appFullScreenController.todayItem                           = items[indexPath.row]
        appFullScreenController.dismissHandler = {
            self.handleAppFullScreenDismissal()
        }
        appFullScreenController.view.layer.cornerRadius             = 16
        self.appFullScreenController                                = appFullScreenController
        
        let gesture                                                 = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate                                            = self
        appFullScreenController.view.addGestureRecognizer(gesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var appFullScreenBeginOffset: CGFloat = 0
    
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullScreenBeginOffset                                = appFullScreenController.tableView.contentOffset.y
        }
        
        if appFullScreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY                                            = gesture.translation(in: appFullScreenController.view).y
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullScreenBeginOffset
                
                var scale                                           = 1 - trueOffset / 1000
                
                scale                                               = min(1, scale)
                scale                                               = max(0.5, scale)
                
                let transform: CGAffineTransform                    = .init(scaleX: scale, y: scale)
                self.appFullScreenController.view.transform         = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullScreenDismissal()
            }
        }
    }
    
    
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell                                              = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame                                     = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame                                          = startingFrame
    }
    
    
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullScreenView                                          = appFullScreenController.view!
        view.addSubview(fullScreenView)

        addChild(appFullScreenController)
        
        self.collectionView.isUserInteractionEnabled                = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame                                     = self.startingFrame else { return }
        
        self.anchoredConstraints = fullScreenView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(
                top: startingFrame.origin.y,
                left: startingFrame.origin.x,
                bottom: 0,
                right: 0),
            size: .init(
                width: startingFrame.width,
                height: startingFrame.height))
        
        self.view.layoutIfNeeded()
    }
    
    var anchoredConstraints: AnchoredConstraints?
    
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut,
            animations: {
                
                self.blurVisualEffectView.alpha                     = 1
                
                self.anchoredConstraints?.top?.constant             = 0
                self.anchoredConstraints?.leading?.constant         = 0
                self.anchoredConstraints?.width?.constant           = self.view.frame.width
                self.anchoredConstraints?.height?.constant          = self.view.frame.height

                self.view.layoutIfNeeded()
                
                self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
                
                guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
                
                cell.todayCell.topConstraint.constant               = 48
                cell.layoutIfNeeded()

        }, completion: nil)
    }
    
    
    
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
        // #1
        setupSingleAppFullscreenController(indexPath)
        
        // #2 setup Fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)
        
        // #3 Begin fullS animation
        beginAnimationAppFullscreen()
    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullScreenDismissal() {
        
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            self.tabBarController?.tabBar.frame.origin.y                = self.view.frame.size.height - tabBarFrame.height
        }
        
        self.navigationController?.navigationBar.isHidden               = false
        //access startingFrame
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut,
            animations: {
                
                self.blurVisualEffectView.alpha                         = 0
                self.appFullScreenController.view.transform             = .identity

                self.appFullScreenController.tableView.contentOffset    = .zero

                guard let startingFrame                                 = self.startingFrame else { return }

                self.anchoredConstraints?.top?.constant                 = startingFrame.origin.y
                self.anchoredConstraints?.leading?.constant             = startingFrame.origin.x
                self.anchoredConstraints?.width?.constant               = startingFrame.width
                self.anchoredConstraints?.height?.constant              = startingFrame.height

                self.view.layoutIfNeeded()

                self.tabBarController?.tabBar.transform                 = .identity
                
                guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
                
                self.appFullScreenController.closeButton.alpha          = 0 
                cell.todayCell.topConstraint.constant                   = 24
                cell.layoutIfNeeded()

        }, completion: { _ in
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled                = true
        })
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //multiple App cell
        let cellId      = items[indexPath.item].cellType.rawValue
        let cell        = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem  = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        
        let collectionView                  = gesture.view
        
        var superview                       = collectionView?.superview
        
        while superview != nil {
            if let cell                     = superview as? TodayMultipleAppCell {
                
                guard let indexPath         = self.collectionView.indexPath(for: cell) else { return }
                
                let apps                    = self.items[indexPath.item].apps
                
                let fullController          = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps         = apps
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            superview                       = superview?.superview
        }
    }
    
    
    static let cellSize: CGFloat = 500
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: view.frame.width - 64,
            height: TodayController.cellSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: 32,
            left: 0,
            bottom: 32,
            right: 0)
    }
}
