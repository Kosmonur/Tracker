//
//  CollectionSupplementaryView.swift
//  Tracker
//
//  Created by Александр Пичугин on 07.08.2023.
//

import UIKit

final class CollectionSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "CollectionSupplementaryView"
    lazy var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.textColor = Color.ypBlack
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
