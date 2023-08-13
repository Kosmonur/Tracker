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
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(named: "YP_Gray")
        lineView.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        tabBar.addSubview(lineView)
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem.image = UIImage(named: "trackers_icon")
        trackersViewController.title = "Трекеры"
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem.image = UIImage(named: "stats_icon")
        statisticViewController.title = "Статистика"
        
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        
        viewControllers = [navigationController, statisticViewController]
    }
}
