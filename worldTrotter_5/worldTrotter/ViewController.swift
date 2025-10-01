//
//  ViewController.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/20/25.
//

import UIKit

final class ConversionViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Views
    private var fahrenheitField: UITextField!
    private var isReallyLabel: UILabel!
    private var celsiusLabel: UILabel!
    private var degreesFLabel: UILabel!
    private var degreesCLabel: UILabel!

    // MARK: - Model
    private var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet { updateCelsiusLabel() }
    }

    private var celsiusValue: Measurement<UnitTemperature>? {
        guard let f = fahrenheitValue else { return nil }
        return f.converted(to: .celsius)
    }

    // Number formatter, max 1 fractional digit
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()

    // MARK: - Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 0xF5/255.0, green: 0xF4/255.0, blue: 0xF1/255.0, alpha: 1.0)

        // Create views
        fahrenheitField = UITextField()
        fahrenheitField.placeholder = "value"
        fahrenheitField.textAlignment = .center
        fahrenheitField.font = .systemFont(ofSize: 70)
        fahrenheitField.textColor = UIColor(red: 0xE1/255.0, green: 0x58/255.0, blue: 0x29/255.0, alpha: 1.0)
        fahrenheitField.borderStyle = .none
        fahrenheitField.keyboardType = .decimalPad
        fahrenheitField.autocorrectionType = .no
        fahrenheitField.spellCheckingType = .no
        fahrenheitField.delegate = self

        isReallyLabel = UILabel()
        isReallyLabel.text = "is really"
        isReallyLabel.textAlignment = .center
        isReallyLabel.font = .systemFont(ofSize: 36)
        isReallyLabel.textColor = UIColor(red: 0xE1/255.0, green: 0x58/255.0, blue: 0x29/255.0, alpha: 1.0)

        celsiusLabel = UILabel()
        celsiusLabel.text = "???"
        celsiusLabel.textAlignment = .center
        celsiusLabel.font = .systemFont(ofSize: 70)
        celsiusLabel.textColor = UIColor(red: 0xE1/255.0, green: 0x58/255.0, blue: 0x29/255.0, alpha: 1.0)

        degreesFLabel = UILabel()
        degreesFLabel.text = "degrees Fahrenheit"
        degreesFLabel.textAlignment = .center
        degreesFLabel.font = .systemFont(ofSize: 36)
        degreesFLabel.textColor = UIColor(red: 0xE1/255.0, green: 0x58/255.0, blue: 0x29/255.0, alpha: 1.0)

        degreesCLabel = UILabel()
        degreesCLabel.text = "degrees Celsius"
        degreesCLabel.textAlignment = .center
        degreesCLabel.font = .systemFont(ofSize: 36)
        degreesCLabel.textColor = UIColor(red: 0xE1/255.0, green: 0x58/255.0, blue: 0x29/255.0, alpha: 1.0)

        // Add subviews
        [fahrenheitField, isReallyLabel, celsiusLabel, degreesFLabel, degreesCLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        // Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)

        // Layout with safe area and margins
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            // Top text field
            fahrenheitField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            fahrenheitField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            fahrenheitField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            // "degrees Fahrenheit"
            degreesFLabel.topAnchor.constraint(equalTo: fahrenheitField.bottomAnchor, constant: 16),
            degreesFLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            degreesFLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            // "is really"
            isReallyLabel.topAnchor.constraint(equalTo: degreesFLabel.bottomAnchor, constant: 16),
            isReallyLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            isReallyLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            // Celsius value
            celsiusLabel.topAnchor.constraint(equalTo: isReallyLabel.bottomAnchor, constant: 16),
            celsiusLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            celsiusLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            // "degrees Celsius"
            degreesCLabel.topAnchor.constraint(equalTo: celsiusLabel.bottomAnchor, constant: 16),
            degreesCLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            degreesCLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Convert"
        updateCelsiusLabel()
    }

    // MARK: - Actions
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fahrenheitField.resignFirstResponder()
    }

    // Editing changed handler: wire this in code since we built the view programmatically
    @objc private func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Add target for editing changed when user starts editing
        textField.addTarget(self, action: #selector(fahrenheitFieldEditingChanged(_:)), for: .editingChanged)
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Allow only one decimal separator
        let decimalSeparator = Locale.current.decimalSeparator ?? "."

        let existingHasSep = textField.text?.contains(decimalSeparator) ?? false
        let replacingHasSep = string.contains(decimalSeparator)

        if existingHasSep && replacingHasSep {
            return false
        }

        // Allow digits, decimal separator, and deletion
        if string.isEmpty { return true } // backspace
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return true }
        if string == decimalSeparator { return true }

        return false
    }

    // MARK: - Helpers
    private func updateCelsiusLabel() {
        if let c = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: c.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
}