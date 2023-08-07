//
//  TrackerStructure.swift
//  Tracker
//
//  Created by Александр Пичугин on 01.08.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [String]
}

struct TrackerCategory {
    let header: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let dateRecord: Date
    let idRecord: UUID
}
