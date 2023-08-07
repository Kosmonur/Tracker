//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Александр Пичугин on 01.08.2023.
//

import UIKit

final class TrackerViewCell: UICollectionViewCell {
    
    private lazy var viewCell: UIView = {
        let viewCell = UIView()
        viewCell.layer.cornerRadius = 16
        viewCell.layer.borderColor = UIColor(named: "YP_CellBorderColor")?.cgColor
        viewCell.layer.borderWidth = 1
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        return viewCell
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = UIColor(named: "YP_EmojiBgColor")
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .white
        textLabel.contentMode = .bottomLeft
        textLabel.numberOfLines = 2
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        dayLabel.textColor = UIColor(named: "YP_Black")
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    private lazy var plusButton: UIButton = {
        let plusButton = UIButton.systemButton(with: UIImage(),
                                               target: self,
                                               action: #selector(tapPlusButton))
        plusButton.backgroundColor = UIColor(named: "YP_White")
        plusButton.layer.cornerRadius = 17
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        return plusButton
    }()
    
    private var done = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContent()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        contentView.addSubview(viewCell)
        viewCell.addSubview(emojiLabel)
        viewCell.addSubview(textLabel)
        contentView.addSubview(footerView)
        footerView.addSubview(dayLabel)
        footerView.addSubview(plusButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewCell.heightAnchor.constraint(equalToConstant: 90),
            viewCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 12),
            
            textLabel.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 44),
            textLabel.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -12),
            
            footerView.topAnchor.constraint(equalTo: viewCell.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dayLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            dayLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8)
        ])
    }
    
    private func setupButtonState() {
        let buttonImage = done ? UIImage(named: "done_button") : UIImage(named: "plus_button")
        plusButton.setImage(buttonImage, for: .normal)
    }
    
    func setupCell(tracker: Tracker) {
        
        viewCell.backgroundColor = tracker.color
        plusButton.tintColor = tracker.color
        
        setupButtonState()
        
        emojiLabel.text = tracker.emoji
        textLabel.text = tracker.name
        dayLabel.text = "4 дня"
        
    }
    
    @objc
    private func tapPlusButton() {
        print (#function)
        done = !done
        setupButtonState()
    }
    
}