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
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton.systemButton(with: UIImage(named:"plus_icon") ?? UIImage(),
                                              target: self,
                                              action: #selector(addTracker))
        addButton.tintColor = UIColor(named: "YP_Black")
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var headingLabel: UILabel = {
        let headingLabel = UILabel()
        headingLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        headingLabel.textColor = UIColor(named: "YP_Black")
        headingLabel.text = "Трекеры"
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        return headingLabel
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
        
        view.backgroundColor = UIColor(named: "YP_White")
        setupContent()
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stub.widthAnchor.constraint(equalToConstant: 80),
            stub.heightAnchor.constraint(equalToConstant: 80),
            stub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            questionLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 40+8+9),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            
            datePicker.widthAnchor.constraint(equalToConstant: 110),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            headingLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            headingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: 12),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupContent() {
        
        view.addSubview(stub)
        view.addSubview(questionLabel)
        view.addSubview(addButton)
        view.addSubview(datePicker)
        view.addSubview(headingLabel)
        view.addSubview(searchField)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        showStub(true)
    }
    
    private func showStub (_ visible: Bool) {
        stub.isHidden = !visible
        questionLabel.isHidden = !visible
    }
    
    @objc
    private func addTracker() {
        let createNewTrackerController = CreateNewTrackerController()
        present(createNewTrackerController, animated: true)
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
                                                                   for: indexPath) as! SupplementaryView
        view.headerLabel.text = visibleCategories[indexPath.section].header
        return view
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

