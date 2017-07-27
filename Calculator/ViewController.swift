//
//  ViewController.swift
//  Calculator
//
//  Created by David Barton on 05/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 6
            display.text = formatter.string(from: (newValue as NSNumber))
        }
    }
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequence: UILabel!
    
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
        
        userIsInTheMiddleOfTyping = false
        display.text = "0"
        sequence.text = " "
    }
    
    @IBAction func touchBackspace(_ sender: UIButton) {
        
        if display.text!.characters.count == 1 {
            display.text = " "
            userIsInTheMiddleOfTyping = false;
            return;
        }
        
        let index = display.text!.index(before:display.text!.endIndex)        
        
        display.text!.remove(at: index)
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }

        sequence.text = brain.sequence
    }

}

