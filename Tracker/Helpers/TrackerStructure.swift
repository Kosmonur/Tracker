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
    let schedule: [WeekDay]
    let isPinned: Bool
}

enum WeekDay: String, CaseIterable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thurshday = "thurshday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    var number: Int {
        switch self {
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thurshday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return "mon"
        case .tuesday: return "tue"
        case .wednesday: return "wed"
        case .thurshday: return "thu"
        case .friday: return "fri"
        case .saturday: return "sat"
        case .sunday: return "sun"
        }
    }
    
    var localizedValue: String {
        return self.rawValue.localized()
    }
    
    var localizedValueShort: String {
        return self.shortName.localized()
    }
    
}

struct TrackerCategory {
    let header: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let idRecord: UUID
    let dateRecord: Date
}
