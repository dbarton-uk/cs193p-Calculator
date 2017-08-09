//
//  ViewController.swift
//  Calculator
//
//  Created by David Barton on 05/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private static let MEMORY_KEY = "M"
    
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    private var variables = Dictionary<String, Double>()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var memoryValue: Double {
        get {
            return variables[CalculatorViewController.MEMORY_KEY] ?? 0
        }
        set {
            variables.updateValue(newValue, forKey: CalculatorViewController.MEMORY_KEY)
            memory.text = "M=" + String(format(newValue))
        }
    }
    
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequence: UILabel!
    @IBOutlet weak var memory: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
   
    @IBAction func touchPoint(_ sender: UIButton) {
        
        if (!userIsInTheMiddleOfTyping) {
            display.text = "0"
            userIsInTheMiddleOfTyping = true
        }
        
       
        if !display.text!.contains(".") {
            display.text! += "."
        }

    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        
        brain = CalculatorBrain()
        variables.removeAll()
        memory.text = " "
        
        userIsInTheMiddleOfTyping = false
        display.text = "0"
        sequence.text = " "
    }
    
    @IBAction func touchBackspace(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            performBackspace()
        } else {
            brain.undo()
            evaluateAndSetDisplay()
        }
    }
    
    private func performBackspace() {
        
        if display.text!.characters.count == 1 {
            display.text = " "
            userIsInTheMiddleOfTyping = false;
            return;
        }
        
        let index = display.text!.index(before:display.text!.endIndex)
        
        display.text!.remove(at: index)
        
    }
    
    @IBAction func touchRandom(_ sender: UIButton) {
        displayValue = Double(arc4random()) / Double(UInt32.max)
        setBrainOperand()

    }
    
    @IBAction func touchSetMButton(_ sender: UIButton) {
        
        memoryValue = displayValue
        evaluateAndSetDisplay()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func touchMButton(_ sender: UIButton) {
        
        brain.setOperand(variable: CalculatorViewController.MEMORY_KEY)
        evaluateAndSetDisplay();
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            setBrainOperand()
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.setOperation(mathematicalSymbol)
        }
        
        evaluateAndSetDisplay()

    }
    
    private func setBrainOperand() {
        brain.setOperand(displayValue)
        userIsInTheMiddleOfTyping = false
    }
    
    private func evaluateAndSetDisplay() {
        
        let (result, resultIsPending, description) = brain.evaluate(using: variables)
        
        if let error = result.error {
            display.text = error
        } else{
            if let value = result.value {
                display.text = format(value)
            }
        }

        let postfix = resultIsPending ? "..." : "="
        
        sequence.text = description == "" ? " " : description + postfix
        
    }
    
    private func format(_ double: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 6
        return formatter.string(from: (double as NSNumber))!
    }

}

