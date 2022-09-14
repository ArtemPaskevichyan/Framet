//
//  IntentHandler.swift
//  AlbumIntent
//
//  Created by Artem Paskevichyan on 22.12.2021.
//

import Intents
import CoreData
import UIKit

//class IntentHandler: INExtension {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    override func handler(for intent: INIntent) -> Any {
//        return self
//    }
//
//}
//
//extension IntentHandler: AlbumTitleIntentHandling {
//    func provideAlbumNameOptionsCollection(for intent: AlbumTitleIntent, with completion: @escaping (INObjectCollection<NSString>?, Error?) -> Void) {
//        var titles = [NSString]()
//
//        do {
//            let albums = try context.fetch(CDAlbum.fetchRequest())
//            albums.forEach { album in
//                titles.append(NSString(string: album.title))
//            }
//        } catch {
//            fatalError("\(error)")
//        }
//
//        let collection = INObjectCollection(items: titles)
//        completion(collection, nil)
//
//    }
//
//    func defaultAlbumName(for intent: AlbumTitleIntent) -> String? {
//        var firstTitle: String? = "It seems you did not added an albums"
//
//        firstTitle = try context.fetch(CDAlbum.fetchRequest()).first?.title
//
//        return firstTitle
//    }
//
//
//}
//
//
