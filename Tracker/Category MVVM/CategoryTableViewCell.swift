//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Александр Пичугин on 03.09.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CategoryTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Color.ypBackground
        textLabel?.textColor = Color.ypBlack
        textLabel?.font = Font.regular17
        clipsToBounds = true
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
