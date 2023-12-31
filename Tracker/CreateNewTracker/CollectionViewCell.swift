//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Александр Пичугин on 09.08.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CollectionViewCell"
    private lazy var cellView = UIView()
    lazy var cellLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellView)
        contentView.addSubview(cellLabel)
        
        cellLabel.font = UIFont.systemFont(ofSize: 32)
        cellLabel.textAlignment = .center
        cellView.layer.masksToBounds = true
        cellView.layer.borderWidth = 3
        cellView.layer.cornerRadius = 8
        cellLabel.layer.masksToBounds = true
        cellLabel.layer.cornerRadius = 8
        isSelected(false)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.widthAnchor.constraint(equalToConstant: 52),
            cellView.heightAnchor.constraint(equalToConstant: 52),
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cellLabel.widthAnchor.constraint(equalToConstant: 40),
            cellLabel.heightAnchor.constraint(equalToConstant: 40),
            cellLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func isSelected(_ isSelect: Bool = false) {
        if cellLabel.text == nil {
            cellView.layer.borderColor = isSelect ? cellLabel.backgroundColor?.withAlphaComponent(0.3).cgColor : cellLabel.backgroundColor?.withAlphaComponent(0).cgColor
        } else {
            cellView.backgroundColor = isSelect ? Color.ypLightGray : .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
