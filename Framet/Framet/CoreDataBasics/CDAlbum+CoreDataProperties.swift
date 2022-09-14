//
//  CDAlbum+CoreDataProperties.swift
//  Framet
//
//  Created by Artem Paskevichyan on 20.12.2021.
//
//

import Foundation
import CoreData


extension CDAlbum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAlbum> {
        return NSFetchRequest<CDAlbum>(entityName: "CDAlbum")
    }

    @NSManaged public var title: String
    @NSManaged public var imageIdentifiers: String?
    @NSManaged public var previewImageIdentifier: String?

}

extension CDAlbum : Identifiable {

}
