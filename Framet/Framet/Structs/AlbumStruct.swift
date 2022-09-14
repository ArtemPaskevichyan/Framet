//
//  AlbumStruct.swift
//  Framet
//
//  Created by Artem Paskevichyan on 13.12.2021.
//

import Foundation

struct Album {
    var zippedImageIdentifiers: String = ""
    var index: Int?
    var coreDataModel: CDAlbum
    static let splitter = "@#@"
    
    var title: String {
        get {
            coreDataModel.title
        }
        set {
            
        }
    }
    
    var previewImageIdentifier: String? {
        get {
            imageIdentifiers?[0]
        }
        set {
        }
    }
    
    var countLabel: Int {
        return imageIdentifiers?.count ?? 0
    }
    
    var imageIdentifiers: [String]? {
        get {
            zippedImageIdentifiers.components(separatedBy: Album.splitter)
        }
        set {
            zippedImageIdentifiers = newValue?.joined(separator: Album.splitter) ?? ""
        }
    }
    
    static func unzip(pack: String?) -> [String] {
        return pack?.components(separatedBy: Album.splitter) ?? []
    }
    
    struct AlbumWeak {
        let title: String?
        let previewImageIdentifier: String?
        var zippedImageIdentifiers: String = ""
        var imageIdentifiers: [String]? {
            get {
                zippedImageIdentifiers.components(separatedBy: Album.splitter)
            }
            set {
                zippedImageIdentifiers = newValue?.joined(separator: Album.splitter) ?? ""
            }
        }
    }
}
