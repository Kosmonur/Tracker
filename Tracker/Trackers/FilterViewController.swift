//
//  FilterViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 27.09.2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func selectedFilter(filter: Filter)
}

enum Filter: String, CaseIterable {
    case allTrackers = "allTrackers"
    case todayTrackers = "todayTrackers"
    case completed = "completed"
    case notCompeted = "notCompeted"
    
    var localizedValue: String {
        return self.rawValue.localized()
    }
}

final class FilterViewController: UIViewController {
    
    weak var filterSelectionDelegate: FilterViewControllerDelegate?
    
    var selectedFilter = Filter.allTrackers
    
    private var filters = Filter.allCases.map ({$0.localizedValue})
    private let tableViewReusableCell =  "filterCell"
    private lazy var cell = UITableViewCell()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewReusableCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.medium16, .foregroundColor: Color.ypBlack ?? .label]
        title = NSLocalizedString("filters", comment: "")
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReusableCell,
                                                 for: indexPath)
        cell.backgroundColor = Color.ypBackground
        cell.selectionStyle = .none
        cell.textLabel?.text = filters[indexPath.row]
        if Filter.allCases[indexPath.row] == selectedFilter {
            cell.accessoryType = .checkmark
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterSelectionDelegate?.selectedFilter(filter: Filter.allCases[indexPath.row])
        dismiss(animated: true)
    }
}

