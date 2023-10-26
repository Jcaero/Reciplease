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
        ValueTransformer.setValueTransformer(ArrayIngredientTransformer(), forName: NSValueTransformerName("ArrayIngredientTransformer"))
        
        persistentContainer = NSPersistentContainer(name: modelName)
        print("init container")
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError(error!.localizedDescription)}
            print("load container")
            completion?()
        }
    }

    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("save")
            } catch {
                print("Error while saving: \(error.localizedDescription )")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
