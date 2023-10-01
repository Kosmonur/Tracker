//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Александр Пичугин on 30.07.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore.shared
    
    private var bestPeriod = 0
    private var perfectDays = 0
    private var trackersCompleted = 0
    private var averageCompleted = 0
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = Font.bold34
        titleLabel.textColor = Color.ypBlack
        titleLabel.text = NSLocalizedString("statisticsTitle", comment: "")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var bestPeriodView: StatisticView = {
        let bestPeriodView = StatisticView()
        bestPeriodView.valueLabel.text = "0"
        bestPeriodView.nameLabel.text = NSLocalizedString("bestPeriod", comment: "")
        return bestPeriodView
    }()
    
    private lazy var perfectDaysView: StatisticView = {
        let perfectDaysView = StatisticView()
        perfectDaysView.valueLabel.text = "0"
        perfectDaysView.nameLabel.text = NSLocalizedString("perfectDays", comment: "")
        return perfectDaysView
    }()
    
    private lazy var trackersCompletedView: StatisticView = {
        let trackersCompletedView = StatisticView()
        trackersCompletedView.valueLabel.text = "0"
        trackersCompletedView.nameLabel.text = NSLocalizedString("trackersCompleted", comment: "")
        return trackersCompletedView
    }()
    
    private lazy var averageCompletedView: StatisticView = {
        let averageCompletedView = StatisticView()
        averageCompletedView.valueLabel.text = "0"
        averageCompletedView.nameLabel.text = NSLocalizedString("averageCompleted", comment: "")
        return averageCompletedView
    }()
    
    private lazy var viewStack: UIStackView = {
        let viewStack = UIStackView()
        viewStack.translatesAutoresizingMaskIntoConstraints = false
        viewStack.axis = .vertical
        viewStack.spacing = 12
        viewStack.distribution = .equalSpacing
        return viewStack
    }()
    
    private lazy var stub: UIImageView = {
        let stub = UIImageView()
        stub.image = UIImage(named: "nothing_analyze")
        stub.translatesAutoresizingMaskIntoConstraints = false
        return stub
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.font = Font.medium12
        stubLabel.textColor = Color.ypBlack
        stubLabel.textAlignment = .center
        stubLabel.text = NSLocalizedString("nothingAnalyze", comment: "")
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        return stubLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        trackersCompleted = trackerRecordStore.completedTrackers.count
        averageCompleted = (try? trackerRecordStore.averageCompleted()) ?? 0
        
        if bestPeriod != 0 ||
            perfectDays != 0 ||
            trackersCompleted != 0 ||
            averageCompleted != 0 {
            
            bestPeriodView.valueLabel.text = String("\(bestPeriod)")
            perfectDaysView.valueLabel.text = String("\(perfectDays)")
            trackersCompletedView.valueLabel.text = String("\(trackersCompleted)")
            averageCompletedView.valueLabel.text = String("\(averageCompleted)")
            
            hideStub()
            
        } else {
            showStub()
        }
    }
    
    private func showStub() {
        stub.isHidden = false
        stubLabel.isHidden = false
        viewStack.isHidden = true
        
    }
    
    private func hideStub() {
        stub.isHidden = true
        stubLabel.isHidden = true
        viewStack.isHidden = false
    }
    
    private func setupContent() {
        view.backgroundColor = Color.ypWhite
        view.addSubview(titleLabel)
        
        viewStack.addArrangedSubview(bestPeriodView)
        viewStack.addArrangedSubview(perfectDaysView)
        viewStack.addArrangedSubview(trackersCompletedView)
        viewStack.addArrangedSubview(averageCompletedView)
        view.addSubview(viewStack)
        
        view.addSubview(stub)
        view.addSubview(stubLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            viewStack.heightAnchor.constraint(equalToConstant: 90*4+12*3),
            viewStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            viewStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            stub.widthAnchor.constraint(equalToConstant: 80),
            stub.heightAnchor.constraint(equalToConstant: 80),
            stub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stubLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 40+8+9),
            stubLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
        ])
    }
}
