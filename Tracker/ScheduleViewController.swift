//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 10.08.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func updateNewShedule(daysOfWeek: [WeekDay])
}

final class ScheduleViewController: UIViewController, UITableViewDelegate {
    
    weak var delegate: ScheduleViewControllerDelegate?
    lazy var selectedDay: [WeekDay] = []
    private let tableViewReusableCell =  "weekDayCell"
    private lazy var cell = UITableViewCell()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        return scrollView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewReusableCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.addTarget(self,
                              action: #selector(didTapReadyButton),
                              for: .touchUpInside)
        readyButton.backgroundColor = Color.ypBlack
        readyButton.setTitleColor(Color.ypWhite, for: .normal)
        readyButton.titleLabel?.font = Font.medium16
        readyButton.setTitle(Constant.readyButtonTitle, for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        return readyButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.ypWhite
        setupContent()
        setupConstraints()
        
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.medium16, .foregroundColor: Color.ypBlack ?? .label]
        title = Constant.scheduleTitle
        
        view.addSubview(scrollView)
        scrollView.addSubview(tableView)
        tableView.dataSource = self
        
        scrollView.addSubview(readyButton)
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            readyButton.topAnchor.constraint(greaterThanOrEqualTo: tableView.bottomAnchor, constant: 60),
            readyButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60)
            
        ])
    }
    
    @objc
    private func didTapReadyButton() {
        delegate?.updateNewShedule(daysOfWeek: selectedDay)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        let dayForChange = WeekDay.allCases[sender.tag]
        if sender.isOn {
            selectedDay.append(dayForChange)
            selectedDay = WeekDay.allCases.filter { selectedDay.contains($0) }
        } else {
            selectedDay = selectedDay.filter { $0 != dayForChange }
        }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReusableCell,
                                                 for: indexPath)
        cell.backgroundColor = Color.ypBackground
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(selectedDay.contains(WeekDay.allCases[indexPath.row]), animated: true)
        switchView.onTintColor = Color.ypBlue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = WeekDay.allCases[indexPath.row].rawValue
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
    
}
