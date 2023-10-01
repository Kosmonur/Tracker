//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 11.08.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    lazy var categoryViewModel = CategoryViewModel()

    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.addTarget(self,
                                    action: #selector(didTapAddCategoryButton),
                                    for: .touchUpInside)
        addCategoryButton.backgroundColor = Color.ypBlack
        addCategoryButton.setTitleColor(Color.ypWhite, for: .normal)
        addCategoryButton.titleLabel?.font = Font.medium16
        addCategoryButton.setTitle(NSLocalizedString("addCategoryButtonTitle", comment: ""), for: .normal)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        return addCategoryButton
    }()
    
    private lazy var stub: UIImageView = {
        let stub = UIImageView()
        stub.image = UIImage(named: "stub_star")
        stub.translatesAutoresizingMaskIntoConstraints = false
        return stub
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.font = Font.medium12
        stubLabel.textColor = Color.ypBlack
        stubLabel.numberOfLines = 2
        stubLabel.text = NSLocalizedString("stubLabelText", comment: "")
        stubLabel.textAlignment = .center
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        return stubLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
        categoryViewModel.$categories.bind { [weak self] _ in
            guard let self else { return }
            showStubIfNeed()
            tableView.reloadData()
        }
        
        categoryViewModel.$selectedCategory.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.medium16,
                                                                   .foregroundColor: Color.ypBlack ?? .label]
        title = NSLocalizedString("categoryTitle", comment: "")
        
        view.addSubview(addCategoryButton)
        
        view.addSubview(stub)
        view.addSubview(stubLabel)
        view.addSubview(tableView)
        
        showStubIfNeed()
        
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stub.widthAnchor.constraint(equalToConstant: 80),
            stub.heightAnchor.constraint(equalToConstant: 80),
            stub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40+8+9),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27+22+38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -38)
            
        ])
    }
    
    private func showStubIfNeed() {
        stub.isHidden = categoryViewModel.categories.isEmpty ? false : true
        stubLabel.isHidden = categoryViewModel.categories.isEmpty ? false : true
    }
    
    @objc
    private func didTapAddCategoryButton() {
        
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = categoryViewModel
        navigationController?.pushViewController(newCategoryViewController, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = categoryViewModel.categories[indexPath.row].categoryName
        
        cell.layer.cornerRadius = 16
        cell.separatorInset.right = 16
        
        let cellCount = tableView.numberOfRows(inSection: indexPath.section)
        if cellCount == 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,
                                        .layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.separatorInset.right = tableView.bounds.width
        } else {
            switch indexPath.row {
            case 0:
                cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            case cellCount - 1:
                cell.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
                cell.separatorInset.right = tableView.bounds.width
            default:
                cell.layer.cornerRadius = 0
            }
        }
        
        cell.accessoryType = categoryViewModel.selectedCategory?.categoryName == cell.textLabel?.text ? .checkmark : .none
        
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            categoryViewModel.selected(categoryName: cell.textLabel?.text)
        }
        navigationController?.popViewController(animated: true)
    }
}

