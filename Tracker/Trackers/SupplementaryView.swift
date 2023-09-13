//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Александр Пичугин on 01.08.2023.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "SupplementaryView"
    lazy var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.font = Font.bold19
        headerLabel.textColor = Color.ypBlack
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

