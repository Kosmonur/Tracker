//
//  TabBarController.swift
//  Tracker
//
//  Created by Александр Пичугин on 30.07.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem.image = UIImage(named: "trackers_icon")
        trackersViewController.title = "Трекеры"
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem.image = UIImage(named: "stats_icon")
        statisticViewController.title = "Статистика"
        
        viewControllers = [trackersViewController, statisticViewController]
    }
}

