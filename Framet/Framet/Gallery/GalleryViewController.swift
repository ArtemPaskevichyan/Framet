//
//  CollectionViewController.swift
//  Framet
//
//  Created by Artem Paskevichyan on 22.12.2021.
//

import UIKit
import Photos

class GalleryViewController: UICollectionViewController {
    var dataArray = [String]()
    var images = [UIImage]()
    
    override var title: String? {
        didSet {
        }
    }
    
    var requestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        return options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        collectionView.alwaysBounceVertical = true
        getImages(withSize: CGSize(width: 250, height: 250))
        
        self.collectionView!.register(GalleryViewCell.nib(), forCellWithReuseIdentifier: GalleryViewCell.baseIdentifier)
        
    }
    
    static func fetchData(outOf s: String!) -> [String] {
        return s.components(separatedBy: Album.splitter)
    }
    
    func reloadCollectionView(withAnimation a: Bool) {
        if a {
            collectionView.reloadSections(IndexSet(integersIn: 0..<collectionView.numberOfSections))
        } else {
            collectionView.reloadData()
        }
    }

}

extension GalleryViewController {
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.baseIdentifier, for: indexPath) as! GalleryViewCell
        
        let image = images[indexPath.row]
        cell.imageView.image = image
        
        return cell
    }
}

extension GalleryViewController {
    func getImages(withSize size: CGSize) {
        
        let manager = PHCachingImageManager.default()
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects { asset, _, _ in
            if self.dataArray.contains(asset.localIdentifier) {
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
                    
                    if image != nil {
                        self.images.append(image!)
                    }
                }
            }
        }
    }
}
