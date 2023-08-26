//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//


import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func updateCategory(newCategory: TrackerCategory)
}

final class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    init(_ trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let newTableReusableCell =  "tableCell"
    
    private var trackerType: TrackerType
    private var trackerName: String?
    private var categoryName: String?
    private lazy var sheduleList: [WeekDay] = []
    
    private var indexOfSelectedEmoji: IndexPath?
    private var indexOfSelectedColor: IndexPath?
    
    private lazy var cell = UITableViewCell()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    private lazy var trackerNameField: UITextField = {
        let trackerNameField = UITextField()
        trackerNameField.layer.cornerRadius = 16
        trackerNameField.indent(16)
        trackerNameField.clearButtonMode = .whileEditing
        trackerNameField.placeholder = Constant.newTrackerNameFieldPlaceholder
        trackerNameField.backgroundColor = Color.ypBackground
        trackerNameField.addTarget(self,
                                   action: #selector(trackerNameChanged(_:)),
                                   for: .editingChanged)
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameField
    }()
    
    private lazy var resrtictionLabel: UILabel = {
        let resrtictionLabel = UILabel()
        resrtictionLabel.font = Font.regular17
        resrtictionLabel.textColor = Color.ypRed
        resrtictionLabel.text = Constant.newTrackerResrtictionLabel
        resrtictionLabel.translatesAutoresizingMaskIntoConstraints = false
        return resrtictionLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: newTableReusableCell)
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
        cancelButton.backgroundColor = Color.ypWhite
        cancelButton.setTitleColor(Color.ypRed, for: .normal)
        cancelButton.layer.borderColor = Color.ypRed?.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.titleLabel?.font = Font.medium16
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
        createButton.backgroundColor = Color.ypGray
        createButton.setTitleColor(Color.ypWhite, for: .normal)
        createButton.titleLabel?.font = Font.medium16
        createButton.setTitle("Cоздать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    override func viewDidLoad() {
        
        setupContent()
        setupConstraints()
        setupTypeTracker()
        
        trackerNameField.delegate = self
        initializeHideKeyboard()
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.medium16, .foregroundColor: Color.ypBlack ?? .label]
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
                                withReuseIdentifier: CollectionSupplementaryView.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func setupTypeTracker() {
        switch trackerType {
        case .habit:
            title = Constant.newHabit
            tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        case .event:
            title = Constant.newIrregularEvent
            tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    private func setupConstraints() {
        
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
           (indexOfSelectedColor != nil),
           categoryName != nil,
           trackerType == .event || trackerType == .habit && !sheduleList.isEmpty {
            createButton.isEnabled = true
            createButton.backgroundColor = Color.ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = Color.ypGray
        }
    }
    
    @objc
    private func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        let newTracker = Tracker(id: UUID(),
                                 name: trackerNameField.text ?? "",
                                 color: Color.colorsArray[indexOfSelectedColor?.row ?? 0],
                                 emoji: Constant.emojis[indexOfSelectedEmoji?.row ?? 0],
                                 schedule: sheduleList)
        
        guard let categoryName = categoryName else { return }
        let newCategory = TrackerCategory(header: categoryName,
                                          trackers: [newTracker])
        
        delegate?.updateCategory(newCategory: newCategory)
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
        switch trackerType {
        case .habit:
            return 2
        case .event:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newTableReusableCell,
                                                 for: indexPath)
        cell.backgroundColor = Color.ypBackground
        cell.accessoryType = .disclosureIndicator
        var stringWithNewAtributes = NSMutableAttributedString()
        var textLabel: String
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row == 0 {
            textLabel = Constant.categoryTitle
            if let categoryName = categoryName {
                textLabel += "\n" + categoryName}
        } else {
            textLabel = Constant.scheduleTitle
            if !sheduleList.isEmpty {
                textLabel += "\n"
                textLabel += sheduleList.count == 7 ? Constant.everyDay : sheduleList.map({ $0.shortName }).joined(separator: ", ")
            }
        }
        
        stringWithNewAtributes = NSMutableAttributedString(string: textLabel, attributes: [NSAttributedString.Key.font: Font.regular17])
        
        stringWithNewAtributes.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.ypBlack ?? .black, range: NSRange(location:0,length: textLabel.count))
        
        if textLabel.contains("\n") {
            let position = textLabel.distance(from: textLabel.startIndex, to: textLabel.firstIndex(of: "\n") ?? textLabel.startIndex)
            stringWithNewAtributes.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.ypGray ?? .gray, range: NSRange(location: position, length: textLabel.count - position))
        }
        
        cell.textLabel?.attributedText = stringWithNewAtributes
        
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
            categoryViewController.delegate = self
            navigationController?.pushViewController(categoryViewController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            scheduleViewController.selectedDay = sheduleList
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
        Constant.newTrackerHeaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? Constant.emojis.count : Color.colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell
        if indexPath.section == 0 {
            cell?.cellLabel.text = Constant.emojis[indexPath.row]
        } else {
            cell?.cellLabel.backgroundColor = Color.colorsArray[indexPath.row]
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: CollectionSupplementaryView.reuseIdentifier,
                                                                   for: indexPath) as? CollectionSupplementaryView
        view?.headerLabel.text = Constant.newTrackerHeaders[indexPath.section]
        return view ?? CollectionSupplementaryView()
    }
}

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func updateNewShedule(daysOfWeek: [WeekDay]) {
        sheduleList = daysOfWeek
        setCreateButtonState()
        tableView.reloadData()
    }
}

extension NewTrackerViewController: CategoryViewControllerDelegate {
    func updateNewCategory(newCategoryName: String?) {
        categoryName = newCategoryName
        setCreateButtonState()
        tableView.reloadData()
    }
}

extension UITextField {
    func indent(_ size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension NewTrackerViewController {
    private func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

