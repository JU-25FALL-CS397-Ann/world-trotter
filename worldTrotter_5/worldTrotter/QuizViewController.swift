//
//  QuizViewController.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/27/25.
//

import UIKit

class QuizViewController: UIViewController {
    
    private let questionLabel = UILabel()
    private let currentQuestionIndexLabel = UILabel()
    private let answerLabel = UILabel()
    private let nextQuestionButton = UIButton(type: .system)
    private let showAnswerButton = UIButton(type: .system)
    
    private let questions: [String] = [
        "From what is cognac made?",
        "What is 7+7?",
        "What is the capital of Vermont?"
    ]
    
    private let answers: [String] = [
        "Grapes",
        "14",
        "Montpelier"
    ]
    
    private var currentQuestionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure labels
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        currentQuestionIndexLabel.textAlignment = .center
        currentQuestionIndexLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        currentQuestionIndexLabel.textColor = .secondaryLabel
        
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        answerLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        answerLabel.textColor = .systemBlue
        
        // Configure buttons
        nextQuestionButton.setTitle("Next Question", for: .normal)
        nextQuestionButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nextQuestionButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        showAnswerButton.setTitle("Show Answer", for: .normal)
        showAnswerButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        showAnswerButton.addTarget(self, action: #selector(showAnswer), for: .touchUpInside)
        
        // Add to view and set constraints
        [questionLabel, currentQuestionIndexLabel, answerLabel, nextQuestionButton, showAnswerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            currentQuestionIndexLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentQuestionIndexLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentQuestionIndexLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            answerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            showAnswerButton.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 30),
            showAnswerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextQuestionButton.topAnchor.constraint(equalTo: showAnswerButton.bottomAnchor, constant: 20),
            nextQuestionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateUI() {
        questionLabel.text = questions[currentQuestionIndex]
        currentQuestionIndexLabel.text = "Question #\(currentQuestionIndex + 1)"
        answerLabel.text = "" // Hide answer initially
    }
    
    @objc private func nextQuestion() {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
        updateUI()
    }
    
    @objc private func showAnswer() {
        answerLabel.text = answers[currentQuestionIndex]
    }
}
