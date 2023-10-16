//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by pierrick viret on 15/10/2023.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Singleton

    static let sharedInstance = CoreDataManager(modelName: "Reciplease")

    // MARK: - Public
    private let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else { fatalError(error!.localizedDescription)}
            completion?()
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
