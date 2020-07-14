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
        
        // UICollectionViewCompositionalLayout()
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom               = 16
        item.contentInsets.trailing             = 16
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .absolute(300)), subitems: [item])
        
        let section                             = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior     = .groupPaging
        section.contentInsets.leading           = 32
        
        let layout                              = UICollectionViewCompositionalLayout(section: section)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .red
        return cell
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor                          = .systemBackground
        navigationItem.title                                    = "Apps"
        navigationController?.navigationBar.prefersLargeTitles  = true
        
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
