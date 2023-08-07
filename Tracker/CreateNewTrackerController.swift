//
//  CreateNewTrackerController.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import UIKit

final class CreateNewTrackerController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(named: "YP_Black")
        titleLabel.text = "Создание трекера"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
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
        view.backgroundColor = UIColor(named: "YP_White")
        setupContent()
        setupConstraints()
    }
    
    private func setupContent() {
        view.addSubview(titleLabel)
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(newHabitButton)
        buttonsStack.addArrangedSubview(irregularEventButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newHabitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    @objc
    private func didTapNewHabitButton() {
        let newHabitViewController = NewTrackerViewController(isIrregularEvent: false)
        present(newHabitViewController, animated: true)
    }
    
    @objc
    private func didTapNewEventButton() {
        let newIrregularEventViewController = NewTrackerViewController(isIrregularEvent: true)
        present(newIrregularEventViewController, animated: true)
    }
    
}
