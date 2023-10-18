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

    // MARK: - Propertie
    private let persistentContainer: NSPersistentContainer

    // MARK: - INIT
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else { fatalError(error!.localizedDescription)}
            completion?()
        }
    }

    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error while saving: \(error.localizedDescription )")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
