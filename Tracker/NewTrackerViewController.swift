//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    
    var isIrregularEvent: Bool = false
    var trackerName: String? = nil
    
    convenience init(isIrregularEvent: Bool) {
        self.init()
        self.isIrregularEvent = isIrregularEvent
    }
    
    private var cellTitles = ["Категория", "Расписание"]
    private var cell = UITableViewCell()
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colors: [UIColor] = (1...18).map { UIColor(named:"Color selection \($0)") ?? .clear }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(named: "YP_Black")
        titleLabel.text = isIrregularEvent ? "Новое нерегулярное событие" : "Новая привычка"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var trackerNameField: UITextField = {
        let trackerNameField = UITextField()
        trackerNameField.layer.cornerRadius = 16
        trackerNameField.indent(16)
        trackerNameField.clearButtonMode = .whileEditing
        trackerNameField.placeholder = "Введите название трекера"
        trackerNameField.backgroundColor = UIColor(named: "YP_Background")
        trackerNameField.addTarget(self,
                                   action: #selector(trackerNameChanged(_:)),
                                   for: .editingChanged)
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameField
    }()
    
    private lazy var resrtictionLabel: UILabel = {
        let resrtictionLabel = UILabel()
        resrtictionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        resrtictionLabel.textColor = UIColor(named: "YP_Red")
        resrtictionLabel.text = "Ограничение 38 символов"
        resrtictionLabel.translatesAutoresizingMaskIntoConstraints = false
        return resrtictionLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        emojiLabel.textColor = UIColor(named: "YP_Black")
        emojiLabel.text = "Emoji"
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    let emojiCollectionView: UICollectionView = {
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.contentInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        emojiCollectionView.backgroundColor = .clear
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return emojiCollectionView
    }()
    
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        colorLabel.textColor = UIColor(named: "YP_Black")
        colorLabel.text = "Цвет"
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    
    let colorCollectionView: UICollectionView = {
        let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollectionView.contentInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        colorCollectionView.backgroundColor = .clear
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return colorCollectionView
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually
        return buttonsStack
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.addTarget(self,
                               action: #selector(didTapCancelButton),
                               for: .touchUpInside)
        cancelButton.backgroundColor = UIColor(named: "YP_White")
        cancelButton.setTitleColor(UIColor(named: "YP_Red"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "YP_Red")?.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.addTarget(self,
                               action: #selector(didTapCreateButton),
                               for: .touchUpInside)
        createButton.backgroundColor = UIColor(named: "YP_Gray")
        createButton.setTitleColor(UIColor(named: "YP_White"), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Cоздать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "YP_White")
        if isIrregularEvent {
            cellTitles = ["Категория"]
        }
        
        setupContent()
        setupConstraints()
        
    }
    
    private func setupContent() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(trackerNameField)
        scrollView.addSubview(resrtictionLabel)
        scrollView.addSubview(tableView)
        scrollView.addSubview(emojiLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(colorCollectionView)
        
        scrollView.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        
        resrtictionLabel.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        emojiCollectionView.register(EmojiCollectionViewCell.self,
                                     forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        colorCollectionView.register(ColorCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
    }
    
    private func setupConstraints() {
        
        tableView.heightAnchor.constraint(equalToConstant: 75).isActive = isIrregularEvent
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = !isIrregularEvent
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            resrtictionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            resrtictionLabel.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 4),
            
            tableView.topAnchor.constraint(equalTo: resrtictionLabel.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            emojiLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            colorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            buttonsStack.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60)
            
        ])
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        print(#function)
    }
    
    @objc
    private func trackerNameChanged(_ textField: UITextField) {
        trackerName = textField.text
        let currentLenght = trackerName?.count ?? 0
        let maxLenght = 38
        if currentLenght > maxLenght {
            resrtictionLabel.isHidden = false
            textField.text = String(textField.text?.prefix(maxLenght) ?? "")
        } else {
            resrtictionLabel.isHidden = true
        }
        
        if let trackerName = trackerName,
           !trackerName.isEmpty,
           currentLenght <= maxLenght {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "YP_Black")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "YP_Gray")
        }
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "tableCell") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "tableCell")
            cell.backgroundColor = UIColor(named: "YP_Background")
            cell.accessoryType = .disclosureIndicator
        }
        
        let title = cellTitles[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
    
}

extension NewTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.isSelected(true)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.isSelected(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.isSelected(false)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.isSelected(false)
        }
    }
}

extension NewTrackerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == emojiCollectionView ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier, for: indexPath) as? EmojiCollectionViewCell
            cell?.cellLabel.text = emojis[indexPath.row]
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell
            cell?.cellLabel.backgroundColor = colors[indexPath.row]
            return cell ?? UICollectionViewCell()
        }
    }
}
