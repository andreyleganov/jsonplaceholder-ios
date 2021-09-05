//
//  PhotosView.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import UIKit

class PhotosView: UIView {
    
    // MARK: - View
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        view.backgroundColor = .white
        
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        super.updateConstraints()
    }
}
