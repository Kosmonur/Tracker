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
        newHabitButton.backgroundColor = UIColor(named: "YP_Black")
        newHabitButton.setTitleColor(UIColor(named: "YP_White"), for: .normal)
        newHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newHabitButton.setTitle("Привычка", for: .normal)
        newHabitButton.layer.cornerRadius = 16
        newHabitButton.translatesAutoresizingMaskIntoConstraints = false
        return newHabitButton
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.addTarget(self,
                                       action: #selector(didTapNewEventButton),
                                       for: .touchUpInside)
        irregularEventButton.backgroundColor = UIColor(named: "YP_Black")
        irregularEventButton.setTitleColor(UIColor(named: "YP_White"), for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
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
        view.backgroundColor = UIColor(named: "YP_White")
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor: UIColor(named: "YP_Black") ?? .label]
        title = "Создание трекера"
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
        let newHabitViewController = NewTrackerViewController(isIrregularEvent: false)
        newHabitViewController.delegate = self
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc
    private func didTapNewEventButton() {
        let newIrregularEventViewController = NewTrackerViewController(isIrregularEvent: true)
        newIrregularEventViewController.delegate = self
        navigationController?.pushViewController(newIrregularEventViewController, animated: true)
    }
}

extension CreateNewTrackerController: NewTrackerViewControllerDelegate {
    func addNewCategory(newCategory: TrackerCategory) {
        delegate?.addNewCategory(newCategory: newCategory)
    }
}

