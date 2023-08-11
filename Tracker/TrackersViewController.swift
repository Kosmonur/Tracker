//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 27.07.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = tempCategories
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    
    private lazy var stub: UIImageView = {
        let stub = UIImageView()
        stub.image = UIImage(named: "stub")
        stub.translatesAutoresizingMaskIntoConstraints = false
        return stub
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questionLabel.textColor = UIColor(named: "YP_Black")
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        return questionLabel
    }()
    
    private var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem()
        addButton.tintColor = UIColor(named: "YP_Black")
        addButton.image = UIImage(named: "plus_icon")
        addButton.action = #selector(addTracker)
        return addButton
    }()
    
    private lazy var dateButton: UIBarButtonItem = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        return UIBarButtonItem(customView: datePicker)
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func setupContent() {
        view.backgroundColor = UIColor(named: "YP_White")
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Трекеры"
        addButton.target = self
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = dateButton
        
        view.addSubview(stub)
        view.addSubview(questionLabel)
        showStub(true)
        view.addSubview(searchField)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stub.widthAnchor.constraint(equalToConstant: 80),
            stub.heightAnchor.constraint(equalToConstant: 80),
            stub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            questionLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 40+8+9),
            questionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
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
    
    private func showStub (_ visible: Bool) {
        stub.isHidden = !visible
        questionLabel.isHidden = !visible
    }
    
    @objc
    private func addTracker() {
        let createNewTrackerController = CreateNewTrackerController()
        let navigationController = UINavigationController(rootViewController: createNewTrackerController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func selectDate(selectedDate: UIDatePicker) {
        currentDate = selectedDate.date
        dismiss(animated: true)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerViewCell
        cell?.setupCell(tracker: visibleCategories[indexPath.section].trackers[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "header",
                                                                   for: indexPath) as? SupplementaryView
        view?.headerLabel.text = visibleCategories[indexPath.section].header
        return view ?? SupplementaryView()
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

