//
//  MockData.swift
//  Tracker
//
//  Created by Александр Пичугин on 17.08.2023.
//

import UIKit

var mockCategories: [TrackerCategory] = [TrackerCategory(header: "Домашние дела",
                                                         trackers: [Tracker(id: UUID(),
                                                                            name: "Дудеть в дудку",
                                                                            color: UIColor(named: "Color selection 5")!,
                                                                            emoji: "❤️",
                                                                            schedule: [WeekDay.monday, WeekDay.friday])]
                                                        ),
                                         TrackerCategory(header: "Рабочее безделье",
                                                         trackers: [Tracker(id: UUID(),
                                                                            name: "Плевать в потолок",
                                                                            color: UIColor(named: "Color selection 1")!,
                                                                            emoji: "🥝",
                                                                            schedule: []),
                                                                    Tracker(id: UUID(),
                                                                            name: "Бесить начальника",
                                                                            color: UIColor(named: "Color selection 8")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.monday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Смотреть сериал",
                                                                            color: UIColor(named: "Color selection 15")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.monday, WeekDay.tuesday, WeekDay.wednesday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Спать",
                                                                            color: UIColor(named: "Color selection 8")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.saturday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Кормить рыбок",
                                                                            color: UIColor(named: "Color selection 6")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.sunday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Смотреть долго в окно",
                                                                            color: UIColor(named: "Color selection 5")!,
                                                                            emoji: "🥥",
                                                                            schedule: [])]
                                                        ),
                                         TrackerCategory(header: "Отдых",
                                                         trackers: [Tracker(id: UUID(),
                                                                            name: "Долго спать",
                                                                            color: UIColor(named: "Color selection 12")!,
                                                                            emoji: "🍇",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday])]
                                                        ),
                                         TrackerCategory(header: "Вкусно поесть",
                                                         trackers: [Tracker(id: UUID(),
                                                                            name: "Есть мороженое",
                                                                            color: UIColor(named: "Color selection 10")!,
                                                                            emoji: "🥝",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Есть торт",
                                                                            color: UIColor(named: "Color selection 14")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Есть шоколад",
                                                                            color: UIColor(named: "Color selection 15")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Пить пиво и закусыать чипсами",
                                                                            color: UIColor(named: "Color selection 9")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Есть пироженые",
                                                                            color: UIColor(named: "Color selection 8")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday]),
                                                                    Tracker(id: UUID(),
                                                                            name: "Есть картошку",
                                                                            color: UIColor(named: "Color selection 18")!,
                                                                            emoji: "🥥",
                                                                            schedule: [WeekDay.saturday,WeekDay.thurshday])]
                                                        )
]


