//
//  Constant&Helper.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import Foundation

enum Constant {
    
    // AppDelegate
    
    static var notFirstStart = UserDefaults.standard.bool(forKey: "notFirstStart")

    static let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

    static let newTrackerHeaders = Locale.current.languageCode == "ru" ? ["Emoji", "Цвет"] : ["Emoji", "Color"]
}

enum TrackerType {
    case habit
    case event
}

