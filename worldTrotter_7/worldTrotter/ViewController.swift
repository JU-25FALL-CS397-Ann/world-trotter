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
        if let text = textField.text,
           let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
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

        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."

        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)

        if existingTextHasDecimalSeparator != nil,
           replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
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