//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Пичугин on 21.08.2023.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case errorDecodingTracker
}

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let uiScheduleMarshalling = UIScheduleMarshalling()
    
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
    
    func getTracker(from data: NSSet.Element) throws -> Tracker {
        guard
            let data = data as? TrackerCoreData,
            let id = data.id,
            let name = data.name,
            let color = data.color,
            let emoji = data.emoji
        else {
            throw TrackerStoreError.errorDecodingTracker
        }
        return Tracker(id: id,
                       name: name,
                       color: uiColorMarshalling.color(from: color),
                       emoji: emoji,
                       schedule: uiScheduleMarshalling.weekDays(from: data.schedule))
    }
    
    func newTracker(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = uiScheduleMarshalling.int(from: tracker.schedule)
        return trackerCoreData
    }
}
