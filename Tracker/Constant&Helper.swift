//
//  Constant&Helper.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import UIKit

let iPhoneSE: Bool = UIScreen.main.bounds.height <= 667

extension UITextField {
    func indent(_ size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}


var tempCategories: [TrackerCategory] = [TrackerCategory(header: "Домашний уют 1",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Поливать растения, играть на баяне и дудеть в дудку",
                                                                               color: UIColor(named: "Color selection 5")!,
                                                                               emoji: "❤️",
                                                                               schedule: ["",""])]
                                                           ),
                                            TrackerCategory(header: "Разное 1",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Есть мороженое",
                                                                               color: .blue,
                                                                               emoji: "🥝",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""])]
                                                           ),
                                            TrackerCategory(header: "Домашний уют 2",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Поливать растения",
                                                                               color: .cyan,
                                                                               emoji: "🍇",
                                                                               schedule: ["",""])]
                                                           ),
                                            TrackerCategory(header: "Разное 2",
                                                            trackers: [Tracker(id: UUID(),
                                                                               name: "Есть мороженое",
                                                                               color: .blue,
                                                                               emoji: "🥝",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .blue,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .magenta,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""]),
                                                                       Tracker(id: UUID(),
                                                                               name: "Кормить рыбок",
                                                                               color: .cyan,
                                                                               emoji: "🥥",
                                                                               schedule: ["",""])]
                                                           )
]

