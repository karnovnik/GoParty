//
//  CoreDataHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper: NSObject {
    
    static fileprivate let instance = CoreDataHelper()
    
    static func getInstance() -> CoreDataHelper {
        return instance;
    }
    
    //let coordinator: NSPersistentStoreCoordinator
    //let model: NSManagedObjectModel
    //let context: NSManagedObjectContext

    var context: NSManagedObjectContext
    
    fileprivate override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "GoPartyServerModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("GoPartyServerModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
    }
    
//    private override init() {
//        let modelURL = NSBundle.mainBundle().URLForResource("GoPartyServerModel", withExtension: "momb")!
//        model = NSManagedObjectModel(contentsOfURL: modelURL)!
//        
//        let fileManager = NSFileManager.defaultManager()
//        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask ).last! as NSURL
//        let storeURL = docsURL.URLByAppendingPathComponent("GoPartyServerModel.sqlite")
//        
//        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
//        
//        do {
//            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil )
//        } catch {
//            abort()
//        }
//        
//        context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
//        context.persistentStoreCoordinator = coordinator
//        super.init()
//        
//    }
    
    func save() -> Bool {
        do {
            try context.save()
        } catch {
            print("Something wrong into CoreDataHelper::save \(error)")
            
            return false
        }
        
        return true
    }
    
    func deleteEntity( _ entity: NSManagedObject ) {
        
        context.delete( entity )
        save()
    }
    
    func deleteAllEntitesByTypeName( _ entityTypeName: String ) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>( entityName: entityTypeName )
        do {
            let result = try context.fetch( request )
            for entity in result {
//                if let user = entity as? User {
//                    print(user.uid?)
//                    print(AppDelegate.TheModel.currentUser!.uid?)
//                    if user.uid? == AppDelegate.TheModel.currentUser!.uid? {
//                        continue
//                    }
//                }
                context.delete(entity as! NSManagedObject)
            }
            save()
        } catch {
            print("Something wrong into CoreDataHelper::deleteAllEntitesByTypeName \(error)")
            return false
        }
        
        print("All \(entityTypeName) was deleted")
        return true
    }
    
    func clearAllCoreData() {
        let entitesNames = ["User","Event","Group","Connections"]
        for name in entitesNames {
            deleteAllEntitesByTypeName( name )
        }
    }
}
