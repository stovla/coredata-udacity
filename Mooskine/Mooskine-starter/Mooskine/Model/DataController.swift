//
//  DataController.swift
//  Mooskine
//
//  Created by Vlastimir Radojevic on 7/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        // setup merge policy so the app does not crash
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError((error?.localizedDescription)!)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
    
}

extension DataController {
    func saveViewContext(withContext viewContext: NSManagedObjectContext) {
        viewContext.perform {
            try? viewContext.save()
        }
    }
    
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("Autosaving")
        guard interval > 0 else {
            print("Can't set negative time interval")
            return
        }
        if viewContext.hasChanges {
            viewContext.perform {
                try? self.viewContext.save()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
