//
//  CoreDataManagerMock.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 29/10/2023.
//

import Foundation
import UIKit
import CoreData

@testable import Reciplease

class CoreDataManagerMock: CoreDataManagerProtocol {
    // MARK: - Singleton

    static let sharedInstance = CoreDataManager(modelName: "Reciplease")

    // MARK: - Propertie
    private let persistentContainer: NSPersistentContainer

    // MARK: - INIT
    init(modelName: String) {

        persistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
            } catch {
                print("Error while saving: \(error.localizedDescription )")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
