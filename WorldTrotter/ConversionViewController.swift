//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by ******* on 2/6/19.
//  Implementation of a Big Nerd Ranch example.

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var convertView: UIView!
    
    @IBOutlet var celsiusLabel: UILabel!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        //celsiusLabel.text = textField.text
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            //celsiusLabel.text = "\(celsiusValue.value)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Convert loaded.")
        updateCelsiusLabel()
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //print("Current text: \(textField.text)")
        //print("Replacement text: \(string)")
        
        //return true
        
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeperator = string.range(of: ".")
        
        if existingTextHasDecimalSeperator != nil,
            replacementTextHasDecimalSeperator != nil {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let temp = fahrenheitValue?.value, temp < 25.0 {
            let alert = UIAlertController(title: "Brrr!", message: "\(temp)F is cold!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isEvening() -> Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        print("hour: \(currentHour)")
        
        // "evening" is 5 AM to 7 PM, more or less:
        if currentHour < 5 || currentHour > 19 {
            return true
        } else {
            return false
        }
    }
    
    func applyDarkMode() {
        if isEvening() {
            convertView.backgroundColor = UIColor.darkGray
        } else {
            convertView.backgroundColor = UIColor.cyan
        }
    }
    
    // It only updates when tabs are changed;
    // if it becomes evening while this tab is open,
    // the background will not automatically change:
    override func viewWillAppear(_ animated: Bool) {
        applyDarkMode()
    }
}
