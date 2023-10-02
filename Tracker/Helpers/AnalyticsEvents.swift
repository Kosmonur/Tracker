//
//  AnalyticsEvents.swift
//  Tracker
//
//  Created by Александр Пичугин on 02.10.2023.
//

import Foundation

enum Events {
    static var openMainScreenEvent = Event(name: "open", screen: "Main", item: "")
    static var closeMainScreenEvent = Event(name: "close", screen: "Main", item: "")
    static var clickAddTrackerEvent = Event(name: "click", screen: "Main", item: "add_track")
    static var clickFilterButtonEvent = Event(name: "click", screen: "Main", item: "filter")
    static var clickEditTrackerEvent = Event(name: "click", screen: "Main", item: "edit")
    static var clickDeleteTrackerEvent = Event(name: "click", screen: "Main", item: "delete")
    static var clickCompeteButtonEvent = Event(name: "click", screen: "Main", item: "track")
}
