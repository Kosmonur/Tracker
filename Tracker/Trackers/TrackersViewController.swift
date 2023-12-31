//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 27.07.2023.
//


import UIKit

final class TrackersViewController: UIViewController {
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerStore = TrackerStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let analyticsService = AnalyticsService.shared
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var pinnedTrackers: [Tracker] = []
    
    private var selectedFilter = Filter.allTrackers
    
    private lazy var stub: UIImageView = {
        let stub = UIImageView()
        stub.translatesAutoresizingMaskIntoConstraints = false
        return stub
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.font = Font.medium12
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
        datePicker.calendar.firstWeekday = 2
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(didSelectNewDate), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = NSLocalizedString("searchPlaceholder", comment: "Text displayed on empty state")
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
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.addTarget(self,
                               action: #selector(didTapFilterButton),
                               for: .touchUpInside)
        filterButton.backgroundColor = Color.ypBlue
        filterButton.setTitleColor(Color.ypWhiteConst, for: .normal)
        filterButton.titleLabel?.font = Font.regular17
        filterButton.setTitle(NSLocalizedString("filters", comment: ""), for: .normal)
        filterButton.layer.cornerRadius = 16
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        return filterButton
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        analyticsService.reportEvent(Events.openMainScreenEvent)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        analyticsService.reportEvent(Events.closeMainScreenEvent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
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
        addButton.target = self
        navigationItem.leftBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        view.addSubview(stub)
        view.addSubview(stubLabel)
        view.addSubview(searchField)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            trackerRecord.idRecord == id && Calendar.current.isDate(trackerRecord.dateRecord, inSameDayAs: datePicker.date)
        }
    }
    
    private func showStubIfNeed() {
        if categories.isEmpty {
            showStub(stubImageName: "stub_star",
                     stubText: NSLocalizedString("stubStarText", comment: ""))
            filterButton.isHidden = true
        } else
        if visibleCategories.isEmpty {
            showStub(stubImageName: "stub_not_found",
                     stubText: NSLocalizedString("stubNotFoundText", comment: ""))
            if selectedFilter == .allTrackers || selectedFilter == .todayTrackers {
                filterButton.isHidden = true
            }
        } else
        { hideStub()
            filterButton.isHidden = false
        }
    }
    
    @objc
    private func didSelectNewDate() {
        selectedFilter = .allTrackers
        reloadVisibleCategories()
    }
    
    @objc
    private func reloadVisibleCategories() {
        
        categories = trackerCategoryStore.trackerCategories
        completedTrackers = trackerRecordStore.completedTrackers
        pinnedTrackers = categories.flatMap({$0.trackers.filter({$0.isPinned})})
        
        if !pinnedTrackers.isEmpty {
            categories = categories.compactMap { category in
                let trackers = category.trackers.filter { !$0.isPinned }
                if trackers.isEmpty {
                    return nil
                }
                return TrackerCategory(header: category.header,
                                       trackers: trackers)
            }
            categories.insert(TrackerCategory(header: NSLocalizedString("isPinned", comment: ""),
                                              trackers: pinnedTrackers),
                              at: 0)
        }
        
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
                
                switch selectedFilter {
                    
                case .allTrackers, .todayTrackers:
                    return textCondition && dateCondition
                    
                case .completed:
                    return textCondition && dateCondition && isTrackerCompletedToday(id: tracker.id)
                    
                case .notCompeted:
                    return textCondition && dateCondition && !isTrackerCompletedToday(id: tracker.id)
                }
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(header: category.header, trackers: trackers)
        }
        
        showStubIfNeed()
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    @objc
    private func addTracker() {
        let createNewTrackerController = CreateNewTrackerController()
        createNewTrackerController.delegate = self
        let navigationController = UINavigationController(rootViewController: createNewTrackerController)
        analyticsService.reportEvent(Events.clickAddTrackerEvent)
        present(navigationController, animated: true)
    }
    
    @objc
    private func didTapFilterButton() {
        let filterViewController = FilterViewController()
        filterViewController.filterSelectionDelegate = self
        filterViewController.selectedFilter = selectedFilter
        let navigationController = UINavigationController(rootViewController: filterViewController)
        analyticsService.reportEvent(Events.clickFilterButtonEvent)
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
                title: NSLocalizedString("futureAlertTitle", comment: ""),
                message: NSLocalizedString("futureAlertMessage", comment: ""),
                preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("actionOk", comment: ""),
                                       style: .cancel) { _ in
                self.dismiss(animated: false)
            }
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        let trackerRecord = TrackerRecord(idRecord: id, dateRecord: datePicker.date)
        try? trackerRecordStore.addRecord(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(idRecord: id, dateRecord: datePicker.date)
        try? trackerRecordStore.removeRecord(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func contextMenu(_ trackerId: UUID?, at indexPath: IndexPath) -> UIContextMenuConfiguration? {
        
        let trackerIsPinned = categories.contains(where: {category in
            category.trackers.contains(where: {$0.id == trackerId && $0.isPinned})
        })
        
        let pinTracker = UIAction(title: trackerIsPinned ? NSLocalizedString("unpin", comment: "") : NSLocalizedString("pin", comment: "")) { [weak self] _ in
            try? self?.trackerStore.setTrackerPinnedState(trackerId, isPinned: !trackerIsPinned)
            self?.reloadVisibleCategories()
        }
        
        let editTracker = UIAction(title: NSLocalizedString("edit", comment: "")) { [weak self] _ in
            
            self?.analyticsService.reportEvent(Events.clickEditTrackerEvent)
            
            let categoryName = try? self?.trackerCategoryStore.categoryNameIncludedTrackerWithId(trackerId)
            let editedTracker = try? self?.trackerStore.getTrackerFromID(trackerId)
            
            guard let editedTracker,
                  let categoryName else { return }
            
            let editViewController = editedTracker.schedule.isEmpty ? EditTrackerViewController(.event, categoryName: categoryName, tracker: editedTracker) : EditTrackerViewController(.habit, categoryName: categoryName, tracker: editedTracker)
            
            editViewController.completedTrackerWithId = (try? self?.trackerRecordStore.comletedTrackerWithId(editedTracker.id)) ?? 0
            editViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: editViewController)
            self?.present(navigationController, animated: true)
        }
        
        let deleteTracker = UIAction(title: NSLocalizedString("delete", comment: ""),
                                     attributes: .destructive) { [weak self] _ in
            
            self?.analyticsService.reportEvent(Events.clickDeleteTrackerEvent)
            
            let alert = UIAlertController(
                title: "",
                message: NSLocalizedString("areYouSureQuestion", comment: ""),
                preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""),
                                          style: .destructive) { [self] _ in
                try? self?.trackerStore.deleteTracker(trackerId)
                try? self?.trackerRecordStore.removeRecordWithId(trackerId)
                
                let newVisibleCategories = self?.visibleCategories.map { category in
                    let trackers = category.trackers.filter { $0.id != trackerId }
                    return TrackerCategory(header: category.header, trackers: trackers)
                }
                
                self?.visibleCategories = newVisibleCategories.map { category in
                    category.filter { !$0.trackers.isEmpty }
                } ?? []
                
                self?.collectionView.performBatchUpdates ({
                    if self?.collectionView.numberOfItems(inSection: indexPath.section) == 1 {
                        self?.collectionView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet)
                    } else {
                        self?.collectionView.deleteItems(at: [indexPath])
                    }
                }) {_ in
                    self?.collectionView.reloadItems(at: (self?.collectionView.indexPathsForVisibleItems)!)
                    self?.showStubIfNeed()
                }
            })
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""),
                                          style: .cancel))
            self?.present(alert, animated: true)
            return
        }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [pinTracker, editTracker, deleteTracker])
        })
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 16 - 9 - 16) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
        try? trackerCategoryStore.updateCategory(newCategory)
        reloadVisibleCategories()
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        categories = trackerCategoryStore.trackerCategories
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords() {
        completedTrackers = trackerRecordStore.completedTrackers
    }
}

extension TrackersViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        filterButton.isHidden = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { scrollViewDidEndScrolling(scrollView) }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrolling(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScrolling(scrollView)
    }
    
    func scrollViewDidEndScrolling(_ scrollView: UIScrollView) {
        filterButton.isHidden = false
    }
}

extension TrackersViewController: FilterViewControllerDelegate {
    func selectedFilter(filter: Filter) {
        selectedFilter = filter
        if filter == .todayTrackers {
            datePicker.date = Date()
        }
        reloadVisibleCategories()
    }
}

