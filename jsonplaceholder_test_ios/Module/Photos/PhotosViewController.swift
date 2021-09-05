//
//  PhotosViewController.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import UIKit

enum PhotosViewType {
    case all(userId: Int)
    case album(album: Album)
}

class PhotosViewController: UIViewController {
    
    private var type: PhotosViewType
    private var photos = [Photo]()
    private var loader = PhotosLoader()
    
    private var mainView: PhotosView! {
        return view as? PhotosView
    }
    
    // MARK: - Lifecycle
    
    init(type: PhotosViewType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PhotosView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        getPhotos()
    }
    
    private func getPhotos() {
        switch type {
        case .all(userId: let userId):
            title = "Photos"
            loader.fetchPhotos(userId: userId) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let photos):
                    self.photos = photos
                    DispatchQueue.main.async {
                        self.mainView.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .album(album: let album):
            title = "\(album.title)"
            loader.fetchPhotos(albumId: album.id) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let photos):
                    self.photos = photos
                    DispatchQueue.main.async {
                        self.mainView.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        let approximateWidthOfText = width - 20
        let size = CGSize(width: approximateWidthOfText, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        let photo = photos[indexPath.item]
        let estimatedFrame = NSString(string: photo.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: width, height: width + estimatedFrame.height + 10)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(photos[indexPath.item])
        
        return cell
    }
}
