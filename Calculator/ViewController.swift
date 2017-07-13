//
//  ViewController.swift
//  Calculator
//
//  Created by David Barton on 05/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
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
            touchDigit(sender)
        }

    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        brain.performOperation(sender.currentTitle!)
        
        let postfix = brain.resultIsPending ? " ..." : " ="
        
        print(brain.description + postfix);
        
    }
}

