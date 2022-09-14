//
//  Frame.swift
//  Frame
//
//  Created by Artem Paskevichyan on 13.12.2021.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    
    var coreDataURL: URL? {
        let fileManager = FileManager.default
        var url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yourcompany.Framet")
        url?.appendPathComponent("CoreDataBasics")
        url?.appendPathComponent("AlbumsData.xcdatamodeld")
        if url != nil {
            print(url?.absoluteString)
            print(url)
            do {
            print(try fileManager.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles))
            }
            catch {
                print("UNABLE")
            }
            return url!
        } else {
            print("FAILED TO LOAD URL")
            print(url?.absoluteString)
            return nil
        }
    }
    
    var persistentContainer: NSPersistentContainer? {
        
        if let url = coreDataURL {
        
            let description = NSPersistentStoreDescription(url: url)
            
            let container = NSPersistentContainer(name: "AlbumsData")
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            
            return container
        }
        else {
            return nil
        }
    }
    
    var context: NSPersistentContainer?
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        print("TIMELINE")
        fetchDataFromCD()

        let currentDate = Date()
        let keepTimeSeconds = 5
        
        for el in 0 ..< 3 {
            let entryDate = Calendar.current.date(byAdding: .second, value: el * keepTimeSeconds, to: currentDate)!
            
            let entry = SimpleEntry(date: entryDate, imageName: "J"+String(el), configuration: configuration)
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func fetchDataFromCD() {
        if let context = persistentContainer?.viewContext {
            do {
//                let coreData = try context.fetch(CDAlbum.fetchRequest())
            } catch {
//                print("Empty Core Data \(error)")
            }
        } else {
//            return
        }
        print("CONTEXT IS \(context)")
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var imageName: String?
    let configuration: ConfigurationIntent
}

struct FrameEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall: SmallView(entry: entry)
        case .systemLarge: LargeView(entry: entry)
        default: SmallView(entry: entry)
        }
    }
}


struct SmallView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(entry.imageName ?? "baseEmptyImage")
            .resizable().scaledToFit()
    }
}


struct LargeView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(entry.imageName ?? "baseEmptyImage")
            .resizable().aspectRatio(contentMode: .fill)
    }
}


@main
struct Frame: Widget {
    let kind: String = "Frame"

    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FrameEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct Frame_Previews: PreviewProvider {
    static var previews: some View {
        FrameEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
