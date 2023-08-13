//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//


import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func addNewCategory(newCategory: TrackerCategory)
}

final class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    convenience init(isIrregularEvent: Bool) {
        self.init()
        self.isIrregularEvent = isIrregularEvent
    }
    
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colors: [UIColor] = (1...18).map { UIColor(named:"Color selection \($0)") ?? .clear }
    
    private var isIrregularEvent: Bool = false
    private var trackerName: String? = nil
    
    private var cellTitles = ["Категория", "Расписание"]
    private var header = ["Emoji", "Цвет"]
    private var indexOfSelectedEmoji: IndexPath?
    private var indexOfSelectedColor: IndexPath?
    
    private var cell = UITableViewCell()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
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
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
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
        
        if isIrregularEvent {
            cellTitles.removeLast()
        }
        
        setupContent()
        setupConstraints()
    }
    
    private func setupContent() {
        view.backgroundColor = UIColor(named: "YP_White")
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: UIColor(named: "YP_Black") ?? .label]
        title = isIrregularEvent ? "Новое нерегулярное событие" : "Новая привычка"
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(trackerNameField)
        scrollView.addSubview(resrtictionLabel)
        scrollView.addSubview(tableView)
        scrollView.addSubview(collectionView)
        
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(createButton)
        scrollView.addSubview(buttonsStack)
        
        resrtictionLabel.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionView.register(CollectionSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func setupConstraints() {
        
        tableView.heightAnchor.constraint(equalToConstant: 75).isActive = isIrregularEvent
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = !isIrregularEvent
        
        NSLayoutConstraint.activate([
            
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            trackerNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            resrtictionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            resrtictionLabel.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 4),
            
            tableView.topAnchor.constraint(equalTo: resrtictionLabel.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            buttonsStack.heightAnchor.constraint(equalToConstant: 60),
            buttonsStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60)
            
        ])
    }
    
    private func setCreateButtonState() {
        if let trackerName = trackerName,
           !trackerName.isEmpty,
           (indexOfSelectedEmoji != nil),
           (indexOfSelectedColor != nil) {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "YP_Black")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "YP_Gray")
        }
    }
    
    @objc
    private func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        print(#function)
        
        let newTracker = Tracker(id: UUID(),
                                 name: trackerNameField.text ?? "",
                                 color: colors[indexOfSelectedColor?.row ?? 0],
                                 emoji: emojis[indexOfSelectedEmoji?.row ?? 0],
                                 schedule: [WeekDay.sunday, WeekDay.monday, WeekDay.tuesday, WeekDay.wednesday, WeekDay.thurshday, WeekDay.friday, WeekDay.saturday])
        
        let newCategory = TrackerCategory(header: "New temporary category",
                                          trackers: [newTracker])
        
        delegate?.addNewCategory(newCategory: newCategory)
        
        
        dismiss(animated: true)
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
        
        if currentLenght <= maxLenght {
            setCreateButtonState()
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
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)}
        return cell
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            navigationController?.pushViewController(categoryViewController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            navigationController?.pushViewController(scheduleViewController, animated: true)
        }
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
        if indexPath.section == 0 {
            if let selectedCell = indexOfSelectedEmoji {
                let cell = collectionView.cellForItem(at: selectedCell) as? CollectionViewCell
                cell?.isSelected(false)
            }
            indexOfSelectedEmoji = indexPath
        } else {
            if let selectedCell = indexOfSelectedColor {
                let cell = collectionView.cellForItem(at: selectedCell) as? CollectionViewCell
                cell?.isSelected(false)
            }
            indexOfSelectedColor = indexPath
        }
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.isSelected(true)
        setCreateButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension NewTrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        header.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell
        if indexPath.section == 0 {
            cell?.cellLabel.text = emojis[indexPath.row]
        } else {
            cell?.cellLabel.backgroundColor = colors[indexPath.row]
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "header",
                                                                   for: indexPath) as? CollectionSupplementaryView
        view?.headerLabel.text = header[indexPath.section]
        return view ?? CollectionSupplementaryView()
    }
}

extension UITextField {
    func indent(_ size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}

