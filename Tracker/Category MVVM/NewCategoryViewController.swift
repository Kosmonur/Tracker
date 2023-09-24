//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 05.09.2023.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func updateNewCategory(newCategoryName: String)
}

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    private var categoryName: String?
    
    private lazy var categoryNameField: UITextField = {
        let categoryNameField = UITextField()
        categoryNameField.layer.cornerRadius = 16
        categoryNameField.indent(16)
        categoryNameField.clearButtonMode = .never
        categoryNameField.placeholder = NSLocalizedString("newCategoryNameFieldPlaceholder", comment: "")
        categoryNameField.backgroundColor = Color.ypBackground
        categoryNameField.addTarget(self,
                                    action: #selector(categoryNameChanged(_:)),
                                    for: .editingChanged)
        categoryNameField.translatesAutoresizingMaskIntoConstraints = false
        return categoryNameField
    }()
    
    private lazy var readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.addTarget(self,
                              action: #selector(didTapReadyButton),
                              for: .touchUpInside)
        readyButton.backgroundColor = Color.ypGray
        readyButton.setTitleColor(Color.ypWhite, for: .normal)
        readyButton.titleLabel?.font = Font.medium16
        readyButton.setTitle(NSLocalizedString("readyButtonTitle", comment: ""), for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.isEnabled = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        return readyButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
        categoryNameField.delegate = self
        initializeHideKeyboard()
        
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.medium16, .foregroundColor: Color.ypBlack ?? .label]
        title = NSLocalizedString("categoryNew", comment: "")
        
        view.addSubview(categoryNameField)
        view.addSubview(readyButton)
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            categoryNameField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 27+22+38),
            categoryNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            
        ])
    }
    
    private func setCreateButtonState() {
        if let categoryName = categoryName,
           !categoryName.isEmpty {
            readyButton.isEnabled = true
            readyButton.backgroundColor = Color.ypBlack
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = Color.ypGray
        }
    }
    
    @objc
    private func didTapReadyButton() {
        guard let categoryName else { return }
        delegate?.updateNewCategory(newCategoryName: categoryName)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func categoryNameChanged(_ textField: UITextField) {
        categoryName = textField.text
        let currentLenght = categoryName?.count ?? 0
        let maxLenght = 29
        if currentLenght > maxLenght {
            textField.text = String(textField.text?.prefix(maxLenght) ?? "")
        }
        
        if currentLenght <= maxLenght {
            setCreateButtonState()
        }
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

