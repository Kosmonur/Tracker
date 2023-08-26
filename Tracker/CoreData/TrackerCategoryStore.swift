//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Пичугин on 21.08.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

enum TrackerCategoryError: Error {
    case errorDecodingCategory
}

final class TrackerCategoryStore: NSObject {
    
    public weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    var trackerCategories: [TrackerCategory] {
        if let objects = fetchedResultsController.fetchedObjects,
           let trackerCategories = try? objects.map({ try getTrackerCategory(from: $0)}) {
            return trackerCategories
        } else {
            return []
        }
    }
    
    convenience override init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable create delegate")
        }
        let context = delegate.persistentContainer.viewContext
        try! self.init(context: context)
        
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    private func getTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        if let header = trackerCategoryCoreData.header {
            let trackers = try trackerCategoryCoreData.trackers?.map({ try trackerStore.getTracker(from: $0) }) ?? []
            return TrackerCategory(
                header: header,
                trackers: trackers.sorted(by: { $0.name < $1.name}))
        }
        else {
            throw TrackerCategoryError.errorDecodingCategory
        }
    }
    
    func updateCategory(_ newCategory: TrackerCategory) throws {
        guard let newTracker = newCategory.trackers.first else { return }
        let tracker = trackerStore.newTracker(newTracker)
        
        if let category = fetchedResultsController.fetchedObjects?.first(where: { $0.header == newCategory.header }) {
            category.addToTrackers(tracker)
        } else {
            let category = TrackerCategoryCoreData(context: context)
            category.header = newCategory.header
            category.trackers = NSSet(array: [tracker])
        }
        try context.save()
    }
    
     // пригодится потом
    func removeCategory(_ removedCategory: TrackerCategory) throws {
        guard let removedCategory = fetchedResultsController.fetchedObjects?.first(where: { $0.header == removedCategory.header }) else { return }
        context.delete(removedCategory)
        try context.save()
    }
    
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}

