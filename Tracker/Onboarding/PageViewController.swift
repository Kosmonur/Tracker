//
//  PageViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 11.09.2023.
//

import UIKit

final class PageViewController: UIViewController {
    
    private lazy var backgroundImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    
    init(title: String, backgroundImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = Font.bold32
        titleLabel.textColor = Color.ypBlackConst
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        let screenSize: CGRect = backgroundImageView.bounds
        let heightRatio =   screenSize.height / screenSize.width
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: heightRatio),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }
}


