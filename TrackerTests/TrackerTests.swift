//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Александр Пичугин on 26.09.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testStartViewController() throws {
        let vc = TrackersViewController()
        // Light mode
        assertSnapshots(of: vc, as: [.image(on: .iPhone13ProMax, traits: UITraitCollection(userInterfaceStyle: .light))])
        assertSnapshots(of: vc, as: [.image(on: .iPhoneSe, traits: UITraitCollection(userInterfaceStyle: .light))])
        
        // Dark mode
        assertSnapshots(of: vc, as: [.image(on: .iPhone13ProMax, traits: UITraitCollection(userInterfaceStyle: .dark))])
        assertSnapshots(of: vc, as: [.image(on: .iPhoneSe, traits: UITraitCollection(userInterfaceStyle: .dark))])
    }
}

