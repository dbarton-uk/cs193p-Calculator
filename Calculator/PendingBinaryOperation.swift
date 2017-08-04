//
//  PendingBinaryOperation.swift
//  Calculator
//
//  Created by David Barton on 04/08/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct PendingBinaryOperation {
    let function: (Double, Double) -> Double
    let firstOperand: (value: Double?, description: String?)
    let symbol: String
    
    var description: String {
        
        get {
            return firstOperand.description! + " " + symbol + " "
        }
    }
    
    func perform(with secondOperand: (value: Double?, description: String?)) -> (Double?, String?) {
        
        let newValue = function(firstOperand.value!, secondOperand.value!)
        let newDescription = self.description + (secondOperand.description ?? "")
        
        return (newValue, newDescription)
    }
}
