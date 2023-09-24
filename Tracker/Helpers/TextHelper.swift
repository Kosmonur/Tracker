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
            ended =  Constant.wordOneDay
        }
        if "234".contains("\(cheсk)") {
            ended =  Constant.wordDay
        }
        if "567890".contains("\(cheсk)") {
            ended =  Constant.wordDays
        }
        if 11...14 ~= days % 100 {
            ended =  Constant.wordDays
        }
        return ended
    }
}
