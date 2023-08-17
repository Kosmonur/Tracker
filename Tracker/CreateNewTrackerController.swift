//
//  CreateNewTrackerController.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import UIKit

final class CreateNewTrackerController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private lazy var newHabitButton: UIButton = {
        let newHabitButton = UIButton()
        newHabitButton.addTarget(self,
                                 action: #selector(didTapNewHabitButton),
                                 for: .touchUpInside)
        newHabitButton.backgroundColor = Color.ypBlack
        newHabitButton.setTitleColor(Color.ypWhite, for: .normal)
        newHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newHabitButton.setTitle(Constant.newHabitButtonTitle, for: .normal)
        newHabitButton.layer.cornerRadius = 16
        newHabitButton.translatesAutoresizingMaskIntoConstraints = false
        return newHabitButton
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.addTarget(self,
                                       action: #selector(didTapNewEventButton),
                                       for: .touchUpInside)
        irregularEventButton.backgroundColor = Color.ypBlack
        irregularEventButton.setTitleColor(Color.ypWhite, for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.setTitle(Constant.irregularEventButtonTitle, for: .normal)
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        return irregularEventButton
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 16
        return buttonsStack
    }()
    
    override func viewDidLoad() {
        
        setupContent()
        setupConstraints()
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: Color.ypBlack ?? .label]
        title = Constant.newTrackerControllerTitle
        buttonsStack.addArrangedSubview(newHabitButton)
        buttonsStack.addArrangedSubview(irregularEventButton)
        view.addSubview(buttonsStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    @objc
    private func didTapNewHabitButton() {
        let newHabitViewController = NewTrackerViewController(.habit)
        newHabitViewController.delegate = self
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc
    private func didTapNewEventButton() {
        let newIrregularEventViewController = NewTrackerViewController(.event)
        newIrregularEventViewController.delegate = self
        navigationController?.pushViewController(newIrregularEventViewController, animated: true)
    }
}

extension CreateNewTrackerController: NewTrackerViewControllerDelegate {
    func updateCategory(newCategory: TrackerCategory) {
        delegate?.updateCategory(newCategory: newCategory)
    }
}

