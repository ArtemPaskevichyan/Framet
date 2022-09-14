//
//  LibraryViewController.swift
//  Framet
//
//  Created by Artem Paskevichyan on 13.12.2021.
//

import UIKit
import Photos
import PhotosUI
import SwiftUI

class LibraryViewController: UICollectionViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var images = [UIImage]()
    var imageIdentifiers = [String?]()
    var dataArray: [Album]? {
        didSet {
            for i in 0..<dataArray!.count {
                dataArray![i].index = i
            }
        }
    }
    var requestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        return options
    }
    
    var filteredArray = [Album]()
    let searchController = UISearchController()
    var newAlbumTitle: String?
    var albumTitleAlertSheet = UIAlertController()
    let manager = PHImageManager()
    let refreshControl = UIRefreshControl()
    
    
    
    @IBAction func photoPickerPresentation(_ sender: Any) {
        titleAlertConfigure()
        present(albumTitleAlertSheet, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(context)
        fetchAlbumsDataFromCD()
        filteredArray = dataArray!
        getImages(withSize: LibraryViewCell.imageSize)
        
        refreshConfigure()
        checkForAutorization()
        navigationConfigure()
        layoutConfigure()
        
        self.collectionView!.register(LibraryViewCell.nib(), forCellWithReuseIdentifier: LibraryViewCell.baseIdentifire)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("DISAPPEARED")
    }
    
    func navigationConfigure() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Albums"
        navigationController?.navigationBar.tintColor = .orange
    }
    
    func layoutConfigure() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        collectionView.collectionViewLayout = layout
    }
    
    func galleryLayoutConfigure() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width / 3 - 1,
                                 height: view.frame.size.width / 3)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1

        return layout
    }
    
    func refreshConfigure() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        reloadCollectionView(withAnimation: false)
        fetchAlbumsDataFromCD()
        DispatchQueue.main.async {
            self.getImages(withSize: LibraryViewCell.imageSize)
        }
//        getImages(withSize: LibraryViewCell.imageSize)
        refreshControl.endRefreshing()
    }
    
    func titleAlertConfigure() {
        albumTitleAlertSheet = UIAlertController(title: "Album title", message: "Set the album title in the text field below", preferredStyle: .alert)
        newAlbumTitle = nil
        albumTitleAlertSheet.addTextField { (textField) in
            textField.placeholder = "Title"
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .sentences
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        albumTitleAlertSheet.addAction(cancel)
        
        let done = UIAlertAction(title: "Done", style: .default) { action in
            let text = self.albumTitleAlertSheet.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if text != "" {
                self.newAlbumTitle = text
                self.present(self.photoPickerConfigure(), animated: true, completion: nil)
            }
        }
        
        albumTitleAlertSheet.addAction(done)
    }
    
    func reloadCollectionView(withAnimation a: Bool) {
        filteredArray = dataArray!
        if a {
            collectionView.reloadSections(IndexSet(integersIn: 0..<collectionView.numberOfSections))
        } else {
            collectionView.reloadData()
        }
    }
    
    func goToGallery(album: Album) {
        let vc = GalleryViewController(collectionViewLayout: galleryLayoutConfigure())
        let data = album.imageIdentifiers ?? []
        
        vc.title = album.title
        vc.dataArray = data
        vc.reloadCollectionView(withAnimation: true)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LibraryViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryViewCell.baseIdentifire, for: indexPath) as! LibraryViewCell
        
        let model = filteredArray[indexPath.row]
        cell.model = model
//        cell.previewImage.image = getImage(byIdentifier: imageIdentifiers[indexPath.row]!, withSize: CGSize(width: 450, height: 450))
        cell.previewImage.image = images[indexPath.row]
//        print(images[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        goToGallery(album: filteredArray[indexPath.row])

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension LibraryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(startsWith: searchText.lowercased())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filter(startsWith: "")
    }
    
    func filter(startsWith st: String) {
        filteredArray = dataArray!.filter { album in
            album.title.lowercased().starts(with: st)
        }
        
        collectionView.reloadSections(IndexSet(integersIn: 0..<collectionView.numberOfSections))
    }
}


extension LibraryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var identifiers = [String]()

        results.forEach { result in
            identifiers.append(result.assetIdentifier!)
        }
        
        if identifiers.count != 0 {
            var album = Album.AlbumWeak(title: newAlbumTitle, previewImageIdentifier: identifiers[0])
            album.imageIdentifiers = identifiers
            
            addAlbumsDataToCD(album: album)
            fetchAlbumsDataFromCD()
            filteredArray = dataArray!
            getImages(withSize: LibraryViewCell.imageSize)
            reloadCollectionView(withAnimation: false)
        }

        newAlbumTitle = nil
        picker.dismiss(animated: true, completion: nil)
    }
}

extension LibraryViewController {
    
    func photoPickerConfigure() -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 100
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        return picker
    }
    
    func checkForAutorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            
            switch status {
            case .authorized:
                break
                
            case .limited: print("Just limited")
                
            case .denied: print("denied")
                
            default: print("no status")
            }
        }
    }
    
    
    func getImage(byIdentifier requiredIdentifier: String, withSize size: CGSize) -> UIImage? {
        var image: UIImage? = nil
        
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects { asset, _, _ in
            if asset.localIdentifier == requiredIdentifier {
                self.manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: self.requestOptions) { img, _ in
                    image = img
                }
            }
        }
        return image
    }
    
    
    
    // FINNALY WORKS FULLY CORRECT
    func getImages(withSize size: CGSize) {
        images = []
        
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        for _ in 0..<assets.count {
            images.append(UIImage(named: "baseEmptyImage")!)
        }
        
        assets.enumerateObjects { asset, _, _ in
            var identifiers = self.imageIdentifiers
            let countOfSameIdentifiers = identifiers.filter{$0 == asset.localIdentifier}.count
            for _ in 0..<countOfSameIdentifiers {
                let index = identifiers.firstIndex(of: asset.localIdentifier)!
                identifiers[index] = nil
                
                self.manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: self.requestOptions) { img, _ in
                    let result = img ?? UIImage(named: "baseEmptyImage")!

                    self.images[index] = result
                }
            }
        }
    }
    
}
