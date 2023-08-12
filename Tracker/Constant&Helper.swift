//
//  Constant&Helper.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import UIKit

let iPhoneSE: Bool = UIScreen.main.bounds.height <= 667

var mockCategories: [TrackerCategory] = [TrackerCategory(header: "Домашний уют 1",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Поливать растения, играть на баяне",
                                                                               color: UIColor(named: "Color selection 5")!,
                                                                               emoji: "❤️",
                                                                               schedule: [WeekDay.monday, WeekDay.friday])]
                                                           ),
                                            TrackerCategory(header: "Рабочий неуют 2",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Есть мороженое",
                                                                               color: UIColor(named: "Color selection 1")!,
                                                                               emoji: "🥝",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 8")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.monday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Солить огурцы",
                                                                               color: UIColor(named: "Color selection 15")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.monday, WeekDay.tuesday, WeekDay.wednesday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Дудеть в дудку",
                                                                               color: UIColor(named: "Color selection 8")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 6")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.sunday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Есть пирожки",
                                                                               color: UIColor(named: "Color selection 5")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday])]
                                                           ),
                                            TrackerCategory(header: "Категория 3",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Поливать растения",
                                                                               color: UIColor(named: "Color selection 12")!,
                                                                               emoji: "🍇",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday])]
                                                           ),
                                            TrackerCategory(header: "Категория 4",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Есть мороженое",
                                                                               color: UIColor(named: "Color selection 10")!,
                                                                               emoji: "🥝",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 14")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 15")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 9")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 8")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: UIColor(named: "Color selection 18")!,
                                                                               emoji: "🥥",
                                                                               schedule: [WeekDay.saturday,WeekDay.thurshday])]
                                                           )
]

