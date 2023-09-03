//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 02.09.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var bgBlueViewController: UIViewController = {
        let bgBlueViewController = UIViewController()
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage (named: "back1")
        imageView.center = view.center
        bgBlueViewController.view.addSubview(imageView)
        bgBlueViewController.view.addSubview(labelBlue)
        return bgBlueViewController
    }()
    
    private lazy var labelBlue: UILabel = {
        let label = UILabel()
        label.font = Font.bold32
        label.textColor = Color.ypBlackConst
        label.textAlignment = .center
        label.text = Constant.blueLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bgRedViewController: UIViewController = {
        let bgRedViewController = UIViewController()
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage (named: "back2")
        imageView.center = view.center
        bgRedViewController.view.addSubview(imageView)
        bgRedViewController.view.addSubview(labelRed)
        return bgRedViewController
    }()
    
    private lazy var labelRed: UILabel = {
        let label = UILabel()
        label.font = Font.bold32
        label.textColor = Color.ypBlackConst
        label.textAlignment = .center
        label.text = Constant.redLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(didTapButton),
                         for: .touchUpInside)
        button.backgroundColor = Color.ypBlackConst
        button.setTitleColor(Color.ypWhiteConst, for: .normal)
        button.titleLabel?.font = Font.medium16
        button.setTitle(Constant.buttonText, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pages: [UIViewController] = {
        return [bgBlueViewController, bgRedViewController]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = Color.ypBlackConst
        pageControl.pageIndicatorTintColor = Color.ypBlackConstAlpha
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        view.addSubview(pageControl)
        view.addSubview(button)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            labelBlue.leadingAnchor.constraint(equalTo: bgBlueViewController.view.leadingAnchor, constant: 16),
            labelBlue.trailingAnchor.constraint(equalTo: bgBlueViewController.view.trailingAnchor, constant: -16),
            labelBlue.bottomAnchor.constraint(equalTo: bgBlueViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            
            labelRed.leadingAnchor.constraint(equalTo: bgRedViewController.view.leadingAnchor, constant: 16),
            labelRed.trailingAnchor.constraint(equalTo: bgRedViewController.view.trailingAnchor, constant: -16),
            labelRed.bottomAnchor.constraint(equalTo: bgRedViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -270),

            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            
        ])
    }
    
    @objc
    private func didTapButton() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Unable create window")
        }
        window.rootViewController = TabBarController()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        return viewControllerIndex == 1 ? pages.first : pages.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        return viewControllerIndex == 0 ? pages.last : pages.first
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

