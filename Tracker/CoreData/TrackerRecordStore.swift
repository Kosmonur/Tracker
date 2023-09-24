//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Пичугин on 21.08.2023.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords()
}

enum TrackerRecordError: Error {
    case errorDecodingRecord
}

final class TrackerRecordStore: NSObject {
    
    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.dateRecord, ascending: true)]
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
    
    var completedTrackers: [TrackerRecord] {
        if let objects = fetchedResultsController.fetchedObjects,
           let completedTrackers = try? objects.map({ try getTrackerRecord(from: $0)}) {
            return completedTrackers
        } else {
            return []
        }
    }
    
    private func getTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        if let idRecord = trackerRecordCoreData.idRecord,
           let dateRecord = trackerRecordCoreData.dateRecord {
            return TrackerRecord(idRecord: idRecord,
                                 dateRecord: dateRecord)
        }
        else {
            throw TrackerRecordError.errorDecodingRecord
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
    
    func addRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.idRecord = trackerRecord.idRecord
        trackerRecordCoreData.dateRecord = trackerRecord.dateRecord
        try context.save()
    }
    
    func removeRecord(_ trackerRecord: TrackerRecord) throws {
        guard let record = fetchedResultsController.fetchedObjects?.first(where: {
            $0.idRecord == trackerRecord.idRecord &&
            Calendar.current.isDate($0.dateRecord ?? trackerRecord.dateRecord, inSameDayAs: trackerRecord.dateRecord)
        }) else { return }
        context.delete(record)
        try context.save()
    }
    
    func comletedTrackerWithId(_ trackerId: UUID) throws  -> Int {
        completedTrackers.filter({$0.idRecord == trackerId}).count
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
