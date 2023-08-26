//
//  UISheduleMarshalling.swift
//  Tracker
//
//  Created by Александр Пичугин on 23.08.2023.
//

import Foundation

final class UIScheduleMarshalling {
    
    func int(from schedule: [WeekDay]) -> Int16 {
        schedule.map{1 << ($0.number - 1)}.reduce(0, |)
    }
    
    func weekDays(from int: Int16) -> [WeekDay] {
        var weekDays: [WeekDay] = []
        for bitNumber in (0...6) {
            if int >> bitNumber & 1 == 1 {
                weekDays.append(bitNumber != 0 ? WeekDay.allCases[bitNumber-1] : WeekDay.allCases[6])
            }
        }
        return weekDays
    }
}
