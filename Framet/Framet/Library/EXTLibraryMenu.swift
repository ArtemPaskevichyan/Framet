//
//  EXTLibraryMenu.swift
//  Framet
//
//  Created by Artem Paskevichyan on 13.12.2021.
//

import Foundation
import UIKit


extension LibraryViewController {
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: previewProviderClosure(indexPath: indexPath),
                                          actionProvider: actionProviderClosure(indexPath: indexPath))
        }
    
    func deleteMenuAction(indexPath: IndexPath) -> UIMenuElement {
        let deleteElement = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            
            let element = self.filteredArray[indexPath.row]
            
            self.dataArray!.remove(at: element.index!)
            self.deleteAlbumsDataFromCD(album: element.coreDataModel)
//            self.dataArray!.remove(at: indexPath.row)
//            self.deleteAlbumsDataFromCD(album: fileredArratindexPath.row)
            self.reloadCollectionView(withAnimation: false)
        }
        return deleteElement
    }
    
    
    func renameMenuAction(indexPath: IndexPath) -> UIMenuElement {
        let renameElement = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
            
            let alert = UIAlertController(title: "Rename album", message: "Type a new title of this album", preferredStyle: .alert)
            var element = self.dataArray![self.filteredArray[indexPath.row].index!]
            
            alert.addTextField { (textField) in
                textField.text = element.title
                textField.clearButtonMode = .whileEditing
                textField.autocapitalizationType = .sentences
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
                if let text = alert.textFields![0].text {
                    element.title = text
                    
                    let albumToUpdate = element.coreDataModel
                    self.updateAlbumsDataToCD(albumPrevious: albumToUpdate, newTitle: text, newImageIdentifiers: nil, newPreviewIdentifier: nil)
                }
                self.collectionView.reloadItems(at: [indexPath])
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        return renameElement
    }
    
    
    func actionProviderClosure(indexPath: IndexPath) -> ([UIMenuElement]) -> (UIMenu) {
        return { elements in
            
            let delete = self.deleteMenuAction(indexPath: indexPath)
            let rename = self.renameMenuAction(indexPath: indexPath)
            
            return UIMenu(title: "Album Menu", options: .destructive,
                          children: [rename, delete])
        }
    }
    
    func previewProviderClosure(indexPath: IndexPath) -> () -> (UIViewController?) {
        return {
//            let vc = UIViewController()
//
//            let iv = UIImageView(frame: vc.view.frame)
//            iv.image = UIImage(named: self.dataArray![indexPath.row].previewImageIdentifier ?? "BaseEmpltyImage")
//            iv.center = vc.view.center
            let album = self.filteredArray[indexPath.row]
            
            let vc = GalleryViewController(collectionViewLayout: self.galleryLayoutConfigure())
            vc.title = album.title
            vc.dataArray = album.imageIdentifiers ?? []
            vc.reloadCollectionView(withAnimation: true)
            
            return vc
        }
    }
}
