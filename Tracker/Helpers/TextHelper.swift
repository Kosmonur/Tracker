//
//  TextHelper.swift
//  Tracker
//
//  Created by Александр Пичугин on 25.09.2023.
//

import Foundation

final class TextHelper {
    static func correctDaysWord(for days: Int) -> String {
        var ended = ""
        let cheсk = days % 10
        if "1".contains("\(cheсk)") {
            ended = NSLocalizedString("wordOneDay", comment: "")
        }
        if "234".contains("\(cheсk)") {
            ended = NSLocalizedString("wordDay", comment: "")
        }
        if "567890".contains("\(cheсk)") {
            ended = NSLocalizedString("wordDays", comment: "")
        }
        if 11...14 ~= days % 100 {
            ended =  NSLocalizedString("wordDays", comment: "")
        }
        return ended
    }
}
