//
//  MainViewController.swift
//  RxSwiftTest
//
//  Created by Ekaterina Nedelko on 12.08.22.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let viewModel = MainViewModel()
    
    // MARK: - Views
    
    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillProportionally
       
        return verticalStack
    }()
    
    // PublishSubject
    
    private lazy var publishSubjectTitleLabel: UILabel = {
        let publishSubjectTitleLabel = UILabel()
        publishSubjectTitleLabel.text = "Publish subject:"
        publishSubjectTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return publishSubjectTitleLabel
    }()
    
    private lazy var publishSubjectLabel: UILabel = {
        let publishSubjectLabel = UILabel()
        publishSubjectLabel.text = "0"
        publishSubjectLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return publishSubjectLabel
    }()
    
    // ReplaySubject
    
    private lazy var replaySubjectTitleLabel: UILabel = {
        let replaySubjectTitleLabel = UILabel()
        replaySubjectTitleLabel.text = "Replay subject:"
        replaySubjectTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return replaySubjectTitleLabel
    }()
    
    private lazy var replaySubjectLabel: UILabel = {
        let replaySubjectLabel = UILabel()
        replaySubjectLabel.text = "0"
        replaySubjectLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return replaySubjectLabel
    }()
    
    // BehaviorSubject
    
    private lazy var behaviorSubjectTitleLabel: UILabel = {
        let behaviorSubjectTitleLabel = UILabel()
        behaviorSubjectTitleLabel.text = "Behavior subject:"
        behaviorSubjectTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return behaviorSubjectTitleLabel
    }()
    
    private lazy var behaviorSubjectLabel: UILabel = {
        let behaviorSubjectLabel = UILabel()
        behaviorSubjectLabel.text = "0"
        behaviorSubjectLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return behaviorSubjectLabel
    }()
    
    // BehaviorRelay
    
    private lazy var behaviorRelayTitleLabel: UILabel = {
        let behaviorRelayTitleLabel = UILabel()
        behaviorRelayTitleLabel.text = "Behavior relay:"
        behaviorRelayTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return behaviorRelayTitleLabel
    }()
    
    private lazy var behaviorRelayLabel: UILabel = {
        let behaviorRelayLabel = UILabel()
        behaviorRelayLabel.text = "0"
        behaviorRelayLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return behaviorRelayLabel
    }()
    
    private lazy var updateButton: UIButton = {
        let updateButton = UIButton()
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .darkGray
        updateButton.layer.cornerRadius = 13
        
        return updateButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        addSubviews()
        configureLayout()
        
        addButtonActions()
        listenToObservables()
    }
    
    // MARK: - View Model Observables
    
    private func listenToObservables() {
        listenToPublishSubjectChanges()
        listenToReplaySubjectChanges()
        listenToBehaviorSubjectChanges()
        listenToBehaviorRelayChanges()
    }

    
    private func listenToPublishSubjectChanges() {
        viewModel.attemptsPublishSubjectObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] attemptsNumber in
                self?.publishSubjectLabel.text = String(attemptsNumber)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func listenToReplaySubjectChanges() {
        viewModel.attemptsReplaySubjectObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] attemptsNumber in
                self?.replaySubjectLabel.text = String(attemptsNumber)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func listenToBehaviorSubjectChanges() {
        viewModel.attemptsBehaviorSubjectObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] attemptsNumber in
                self?.behaviorSubjectLabel.text = String(attemptsNumber)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func listenToBehaviorRelayChanges() {
        viewModel.attemptsBehaviorRelayObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] attemptsNumber in
                self?.behaviorRelayLabel.text = String(attemptsNumber)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

private extension MainViewController {
    func setupAppearance() {
        view.backgroundColor = .white
    }
    
    func addSubviews() {
        view.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(publishSubjectTitleLabel)
        verticalStack.addArrangedSubview(publishSubjectLabel)
        
        verticalStack.addArrangedSubview(replaySubjectTitleLabel)
        verticalStack.addArrangedSubview(replaySubjectLabel)
        
        verticalStack.addArrangedSubview(behaviorSubjectTitleLabel)
        verticalStack.addArrangedSubview(behaviorSubjectLabel)
        
        verticalStack.addArrangedSubview(behaviorRelayTitleLabel)
        verticalStack.addArrangedSubview(behaviorRelayLabel)
        
        verticalStack.addArrangedSubview(updateButton)
    }
    
    func configureLayout() {
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addButtonActions() {
        updateButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.updateAttemptsNumber()
            })
            .disposed(by: disposeBag)
    }
}

