//
//  AlbumsViewController.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/6/21.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private var userId: Int
    private var albums = [Album]()
    private var loader = AlbumsLoader()
    private var mainView: AlbumsView! {
        return view as? AlbumsView
    }
    
    // MARK: - Lifecycle
    
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AlbumsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Albums"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "All Photos", style: .plain, target: self, action: #selector(allButtonTapped))
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseIdentifier)
        getAlbums()
    }
    
    // MARK: - Handler
    
    @objc private func allButtonTapped(_ sender: UIBarButtonItem) {
        let viewController = PhotosViewController(type: .all(userId: userId))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Get Data
    
    private func getAlbums() {
        loader.fetchAlbums(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let albums):
                self.albums = albums
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
extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        return CGSize(width: (width / 2) - 10, height: (width / 2) - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PhotosViewController(type: .album(album: albums[indexPath.item]))
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier, for: indexPath) as! AlbumCell
        cell.configureCell(albums[indexPath.item])
        
        return cell
    }
    
    
}
