//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 11.08.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategoryName: String?)
}

final class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
    
    var selectedCategoryName: String?
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.addTarget(self,
                                    action: #selector(didTapAddCategoryButton),
                                    for: .touchUpInside)
        addCategoryButton.backgroundColor = Color.ypBlack
        addCategoryButton.setTitleColor(Color.ypWhite, for: .normal)
        addCategoryButton.titleLabel?.font = Font.medium16
        addCategoryButton.setTitle(Constant.addCategoryButtonTitle, for: .normal)
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
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = Font.medium12
        textLabel.textColor = Color.ypBlack
        textLabel.numberOfLines = 2
        textLabel.text = Constant.stubLabelText
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
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
        title = Constant.categoryTitle
        
        view.addSubview(addCategoryButton)
        
        view.addSubview(stub)
        view.addSubview(textLabel)
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stub.widthAnchor.constraint(equalToConstant: 80),
            stub.heightAnchor.constraint(equalToConstant: 80),
            stub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40+8+9),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
        ])
    }
    
    @objc
    private func didTapAddCategoryButton() {
        
        let mockCategory = ["Развлечения", "Спорт", "Учёба"].randomElement()
        delegate?.updateNewCategory(newCategoryName: mockCategory)
        
        navigationController?.popViewController(animated: true)
    }
    
    
}

