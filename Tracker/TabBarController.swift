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
        
        setupLine()
        let trackersViewController = setControllers(viewController: TrackersViewController(),
                                                    title: "Трекеры",
                                                    imageName: "trackers_icon")
        let statisticViewController = setControllers(viewController: StatisticViewController(),
                                                     title: "Статистика",
                                                     imageName: "stats_icon")
        let navigationController = UINavigationController(rootViewController: trackersViewController)
        viewControllers = [navigationController, statisticViewController]
    }
    
    private func setupLine() {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(named: "YP_Gray")
        lineView.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        tabBar.addSubview(lineView)
    }
    
    private func setControllers (viewController: UIViewController,
                                 title: String,
                                 imageName: String) -> UIViewController {
        viewController.tabBarItem.image = UIImage(named: imageName)
        viewController.title = title
        return viewController
    }
}
