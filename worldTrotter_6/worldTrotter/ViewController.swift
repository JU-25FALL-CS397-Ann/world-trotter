//
//  ViewController.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/20/25.
//

import UIKit

final class ConversionViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets (connect in Interface Builder)
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!

    // MARK: - Model
    private var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet { updateCelsiusLabel() }
    }

    private var celsiusValue: Measurement<UnitTemperature>? {
        guard let f = fahrenheitValue else { return nil }
        return f.converted(to: .celsius)
    }

    // MARK: - Formatting (≤ 1 fractional digit)
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Text field keyboard and editing traits per Ch. 6
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.textAlignment = .center
        textField.delegate = self

        // Background tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)

        updateCelsiusLabel()
    }

    // MARK: - IBActions (wire "Editing Changed" from the text field to this)
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }

    // MARK: - Keyboard dismiss
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    // MARK: - UITextFieldDelegate (Bronze Challenge: Disallow alphabetic characters)
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Allow deletion
        if string.isEmpty { return true }

        // Locale-aware decimal separator
        let sep = Locale.current.decimalSeparator ?? "."
        
        // Bronze Challenge: Create allowed character set (digits + decimal separator)
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: sep))
        
        // Check if the replacement string contains only allowed characters
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }

        // Prevent multiple decimal separators
        let current = textField.text ?? ""
        if string == sep, current.contains(sep) {
            return false
        }

        return true
    }

    // MARK: - UI update
    private func updateCelsiusLabel() {
        if let c = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: c.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
}