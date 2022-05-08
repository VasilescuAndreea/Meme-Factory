//
//  DataManager.swift
//  Meme Factory
//
//  Created by Alex Weng on 08.05.2022.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MemeCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveMeme (caption: String, img: Data, thumbnail: Data) {
        let context = persistentContainer.viewContext
        let memeInstance = Meme(context: context)
        memeInstance.caption = caption
        memeInstance.img = img
        memeInstance.thumbnail = thumbnail
        self.saveContext()
    }
    
    func deleteMeme(meme: Meme) {
        let context = persistentContainer.viewContext
        context.delete(meme)
        self.saveContext()
    }
    
    func fetchMeme() -> [Meme] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Meme> = Meme.fetchRequest()
        var fetchedMemes: [Meme] = []
        do {
            fetchedMemes = try context.fetch(request)
        } catch {
            print("Error while fetching memes")
        }
        
        return fetchedMemes
    }
}
