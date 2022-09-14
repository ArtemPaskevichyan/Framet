//
//  EXTLibraryCoreData.swift
//  Framet
//
//  Created by Artem Paskevichyan on 20.12.2021.
//

import Foundation
import SwiftUI

extension LibraryViewController {
    func fetchAlbumsDataFromCD() {
        dataArray = []
        imageIdentifiers = []
        
        do {
            let coreData = try context.fetch(CDAlbum.fetchRequest())
            coreData.forEach { exAlbum in
                var album = Album(coreDataModel: exAlbum)
                album.imageIdentifiers = Album.unzip(pack: exAlbum.imageIdentifiers)
                
                dataArray?.append(album)
                imageIdentifiers.append(album.previewImageIdentifier)
            }
        } catch {
            print("Empty Core Data \(error)")
        }
    }
    
    func addAlbumsDataToCD(album: Album.AlbumWeak) {
        let newAlbum = CDAlbum(context: context)
        print("ADDING \(album)")
        
        newAlbum.title = album.title!
        newAlbum.imageIdentifiers = album.zippedImageIdentifiers
        newAlbum.previewImageIdentifier = album.previewImageIdentifier!
        
        do {
            try context.save()
        } catch {
            print("FATAL ERROR \(error)")
        }
    }
    
    func deleteAlbumsDataFromCD(album: CDAlbum) {
        context.delete(album)
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    
    func updateAlbumsDataToCD(albumPrevious: CDAlbum,
                              newTitle: String?,
                              newImageIdentifiers: String?,
                              newPreviewIdentifier: String?) {
        
        if newTitle != nil {
            albumPrevious.title = newTitle!
        }
        if newImageIdentifiers != nil {
            albumPrevious.imageIdentifiers = newImageIdentifiers
        }
        if newPreviewIdentifier != nil {
            albumPrevious.previewImageIdentifier = newPreviewIdentifier
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    
}
