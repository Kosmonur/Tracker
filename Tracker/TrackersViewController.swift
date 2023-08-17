//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 27.07.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    var categories: [TrackerCategory] = [] //mockCategories
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private lazy var stub: UIImageView = {
        let stub = UIImageView()
        stub.translatesAutoresizingMaskIntoConstraints = false
        return stub
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stubLabel.textColor = Color.ypBlack
        stubLabel.textAlignment = .center
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        return stubLabel
    }()
    
    private var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem()
        addButton.tintColor = Color.ypBlack
        addButton.image = UIImage(named: "plus_icon")
        addButton.action = #selector(addTracker)
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(reloadVisibleCategories), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = Constant.searchPlaceholder
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.addTarget(self, action: #selector(reloadVisibleCategories), for: .allEditingEvents)
        searchField.delegate = self
        return searchField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        visibleCategories = categories
        reloadVisibleCategories()
    }
    
    private func showStub(stubImageName: String, stubText: String) {
        stub.image = UIImage(named: stubImageName)
        stubLabel.text = stubText
        stub.isHidden = false
        stubLabel.isHidden = false
    }
    
    private func hideStub() {
        stub.isHidden = true
        stubLabel.isHidden = true
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constant.trackerTitle
        addButton.target = self
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        view.addSubview(stub)
        view.addSubview(stubLabel)
        view.addSubview(searchField)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.reuseIdentifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseIdentifier)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            stub.widthAnchor.constraint(equalToConstant: 80),
            stub.heightAnchor.constraint(equalToConstant: 80),
            stub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stubLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 40+8+9),
            stubLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 18),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.dateRecord, inSameDayAs: datePicker.date)
        let isIrregularEvent = !(visibleCategories.filter {!($0.trackers.filter {$0.id == id && $0.schedule.isEmpty}).isEmpty}).isEmpty
        return trackerRecord.idRecord == id && (isSameDay || isIrregularEvent)
    }
    
    @objc
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.number == filterWeekDay
                } == true || tracker.schedule.isEmpty
                return textCondition && dateCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(header: category.header, trackers: trackers)
        }
        
        if categories.isEmpty {
            showStub(stubImageName: "stub_star",
                     stubText: Constant.stubStarText)
        } else
        if visibleCategories.isEmpty {
            showStub(stubImageName: "stub_not_found",
                     stubText: Constant.stubNotFoundText)
        } else
        {
            hideStub()
        }
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    @objc
    private func addTracker() {
        let createNewTrackerController = CreateNewTrackerController()
        createNewTrackerController.delegate = self
        let navigationController = UINavigationController(rootViewController: createNewTrackerController)
        present(navigationController, animated: true)
    }
}

extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reloadVisibleCategories()
        return textField.resignFirstResponder()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.reuseIdentifier, for: indexPath) as? TrackerViewCell
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        cell?.delegate = self
        let isComplitedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.idRecord == tracker.id
        }.count
        cell?.setupCell(tracker: tracker,
                        isCompletedToday: isComplitedToday,
                        completedDays: completedDays,
                        indexPath: indexPath)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: SupplementaryView.reuseIdentifier,
                                                                   for: indexPath) as? SupplementaryView
        view?.headerLabel.text = visibleCategories[indexPath.section].header
        return view ?? SupplementaryView()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if datePicker.date > Date() {
            let alert = UIAlertController(
                title: Constant.futureAlertTitle,
                message: Constant.futureAlertMessage,
                preferredStyle: .alert)
            let action = UIAlertAction(title: Constant.actionOk, style: .cancel) { _ in
                self.dismiss(animated: false)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let trackerRecord = TrackerRecord(idRecord: id, dateRecord: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 2 - 5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
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

extension TrackersViewController: NewTrackerViewControllerDelegate {
    
    func updateCategory(newCategory: TrackerCategory) {
        if let index = categories.firstIndex(where: {$0.header == newCategory.header}) {
            let updatedCategories = TrackerCategory(header: categories[index].header,
                                                    trackers: newCategory.trackers +  categories[index].trackers)
            categories.insert(updatedCategories, at: index)
            categories.remove(at: index + 1)
        } else {
            categories.insert(newCategory, at: 0)
        }
        reloadVisibleCategories()
    }
}
