//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Александр Пичугин on 01.08.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
    func contextMenu(_ trackerId: UUID?, at indexPath: IndexPath) -> UIContextMenuConfiguration?
}

final class TrackerViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerViewCell"
    
    private let analyticsService = AnalyticsService.shared
    
    private lazy var viewCell: UIView = {
        let viewCell = UIView()
        viewCell.layer.cornerRadius = 16
        viewCell.layer.borderColor = Color.ypCellBorderColor?.cgColor
        viewCell.layer.borderWidth = 1
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        let interaction = UIContextMenuInteraction(delegate: self)
        viewCell.addInteraction(interaction)
        return viewCell
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.font = Font.medium13
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = Color.ypEmojiBgColor
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private lazy var isPinned: UIImageView = {
        let isPinned = UIImageView()
        isPinned.image = UIImage(named: "isPinned")
        isPinned.translatesAutoresizingMaskIntoConstraints = false
        return isPinned
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = Font.medium12
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
        dayLabel.font = Font.medium12
        dayLabel.textColor = Color.ypBlack
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    private lazy var plusButton: UIButton = {
        let plusButton = UIButton.systemButton(with: UIImage(),
                                               target: self,
                                               action: #selector(tapPlusButton))
        plusButton.backgroundColor = Color.ypWhite
        plusButton.layer.cornerRadius = 17
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        return plusButton
    }()
    
    private var isCompletedToday = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    weak var delegate: TrackerCellDelegate?
    
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
        viewCell.addSubview(isPinned)
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
            
            isPinned.heightAnchor.constraint(equalToConstant: 24),
            isPinned.widthAnchor.constraint(equalToConstant: 24),
            isPinned.topAnchor.constraint(equalTo: emojiLabel.topAnchor),
            isPinned.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 103),
            
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
    
    func setupCell(tracker: Tracker,
                   isCompletedToday: Bool,
                   completedDays: Int,
                   indexPath: IndexPath) {
        self.isCompletedToday = isCompletedToday
        self.trackerId = tracker.id
        self.indexPath = indexPath
        self.isPinned.isHidden = !tracker.isPinned
        
        viewCell.backgroundColor = tracker.color
        plusButton.tintColor = tracker.color
        
        let buttonImage = isCompletedToday ? UIImage(named: "done_button") : UIImage(named: "plus_button")
        plusButton.setImage(buttonImage, for: .normal)
        
        emojiLabel.text = tracker.emoji
        textLabel.text = tracker.name
        dayLabel.text = "\(completedDays) \(TextHelper.correctDaysWord(for: completedDays))"
    }
    
    @objc
    private func tapPlusButton() {
        analyticsService.reportEvent(Events.clickCompeteButtonEvent)
        guard let trackerId = trackerId,
              let indexPath = indexPath else {
            return
        }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}

extension TrackerViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath else { return UIContextMenuConfiguration()}
        return delegate?.contextMenu(trackerId, at: indexPath)
    }
}
