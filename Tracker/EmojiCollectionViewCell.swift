//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Пичугин on 06.08.2023.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "emojiCell"
    let cellLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellLabel)
        cellLabel.layer.masksToBounds = true
        cellLabel.layer.cornerRadius = 8
        cellLabel.font = UIFont.systemFont(ofSize: 32)
        cellLabel.textAlignment = .center
        isSelected(false)
        
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellLabel.widthAnchor.constraint(equalToConstant: 52),
            cellLabel.heightAnchor.constraint(equalToConstant: 52),
            cellLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func isSelected(_ isSelect: Bool = false) {
        cellLabel.backgroundColor = isSelect ? UIColor(named: "YP_LightGray") : .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

