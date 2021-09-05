//
//  PhotosViewController.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var userId: Int?
    private var photos = [Photo]()
    private var loader = PhotosLoader()
    
    private var mainView: PhotosView! {
        return view as? PhotosView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = PhotosView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        mainView.collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reuseIdentifier)
        getPhotos()
    }
    
    private func getPhotos() {
        guard let userId = userId else {
            return
        }
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
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        let approximateWidthOfText = width - 10 - 10
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
        cell.titleLabel.text = photos[indexPath.item].title
        cell.imageView.setImage(urlString: photos[indexPath.item].url)
        
        return cell
    }
}
