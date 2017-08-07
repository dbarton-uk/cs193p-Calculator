//
//  PendingBinaryOperation.swift
//  Calculator
//
//  Created by David Barton on 04/08/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct PendingBinaryOperation {
    let operation: (Double, Double) -> Double
    let validator: ((Double, Double) -> String?)?
    let firstOperand: (value: Double?, description: String?)
    let symbol: String
    
    var description: String {
        
        get {
            return firstOperand.description! + symbol
        }
    }
    
    func perform(with secondOperand: (value: Double?, description: String?)) -> (Double?, String?, String?) {
        
        let newValue = operation(firstOperand.value!, secondOperand.value!)
        let error = validator != nil ? validator!(firstOperand.value!, secondOperand.value!) : nil
        let newDescription = self.description + (secondOperand.description ?? "")
        
        return (newValue, newDescription, error)
    }
}
