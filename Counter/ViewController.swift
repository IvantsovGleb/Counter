//
//  ViewController.swift
//  Counter
//
//  Created by Gleb Ivantsov on 08.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        enum Label {
            static let initialCounterValue = "0"
            static let fontSize: CGFloat = 52
        }
        enum TextView {
            static let fontSize: CGFloat = 16
            static let placeholder = "История изменений:\n"
            static let counterValueChanged = ": значение изменено на"
            static let counterValueReset = ": значение сброшено\n"
            static let attemptToChangeCounterValueBelowZero = ": попытка уменьшить значение счётчика ниже 0\n"
        }
        static let plusImage = UIImage(systemName: "plus")
        static let minusImage = UIImage(systemName: "minus")
        static let clearImage = UIImage(systemName: "clear")
    }
    
    private enum Layout {
        static let offset: CGFloat = 100
    }
    
    // MARK: - Private properties
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M HH:mm"
        return dateFormatter
    }()
    
    private var currentDateAndTime: String {
        dateFormatter.string(from: Date())
    }
    
    private var stackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private lazy var counterLabel = {
        let label = UILabel()
        label.text = Constants.Label.initialCounterValue
        label.textAlignment = .center
        label.font = label.font.withSize(Constants.Label.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var additionAction: () -> Void {
        { [weak self] in
            guard let self, let sounterString = self.counterLabel.text, let counterInteger = Int(sounterString) else { return }
            self.counterLabel.text = String(counterInteger + 1)
            self.textView.text.append("\(self.currentDateAndTime)\(Constants.TextView.counterValueChanged) +1\n")
        }
    }
    
    private var subtractionAction: () -> Void {
        { [weak self] in
            guard let self, let sounterString = self.counterLabel.text, let counterInteger = Int(sounterString) else { return }
            guard counterInteger == 0 else {
                let newCounterInteger = counterInteger - 1
                if newCounterInteger == 0 {
                    self.textView.text.append("\(self.currentDateAndTime)\(Constants.TextView.counterValueReset)")
                } else {
                    self.textView.text.append("\(self.currentDateAndTime)\(Constants.TextView.counterValueChanged) -1\n")
                }
                self.counterLabel.text = String(counterInteger - 1)
                return
            }
            self.textView.text.append("\(self.currentDateAndTime)\(Constants.TextView.attemptToChangeCounterValueBelowZero)")
        }
    }
    
    private var resetAction: () -> Void {
        { [weak self] in
            guard let self else { return }
            self.counterLabel.text = Constants.Label.initialCounterValue
            self.textView.text.append("\(self.currentDateAndTime)\(Constants.TextView.counterValueReset)")
        }
    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = Constants.TextView.placeholder
        textView.font = UIFont.systemFont(ofSize: Constants.TextView.fontSize)
        textView.textAlignment = .center
        textView.isSelectable = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        
        let plusButton = Button(backgroundColor: .red, size: .m)
        plusButton.setImage(Constants.plusImage, for: .normal)
        plusButton.touchUpInside = additionAction
        
        let minusButton = Button(backgroundColor: .blue, size: .m)
        minusButton.setImage(Constants.minusImage, for: .normal)
        minusButton.touchUpInside = subtractionAction
        
        let resetButton = Button(backgroundColor: .clear, size: .s)
        resetButton.setImage(Constants.clearImage, for: .normal)
        resetButton.touchUpInside = resetAction
        
        let mainStackView = stackView
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)
        
        let stackWithCounterAndClearButton = stackView
        stackWithCounterAndClearButton.axis = .vertical
        stackWithCounterAndClearButton.alignment = .center
        stackWithCounterAndClearButton.addArrangedSubview(resetButton)
        stackWithCounterAndClearButton.addArrangedSubview(counterLabel)
                
        let stackWithPlusAndMinusButton = stackView
        stackWithPlusAndMinusButton.axis = .horizontal
        stackWithPlusAndMinusButton.alignment = .center
        stackWithPlusAndMinusButton.distribution = .fillEqually
        stackWithPlusAndMinusButton.addArrangedSubview(minusButton)
        stackWithPlusAndMinusButton.addArrangedSubview(plusButton)
        
        mainStackView.addArrangedSubview(stackWithCounterAndClearButton)
        mainStackView.addArrangedSubview(textView)
        mainStackView.addArrangedSubview(stackWithPlusAndMinusButton)

        let constraints = [
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.offset),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.offset),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
