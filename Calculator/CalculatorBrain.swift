//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Barton on 06/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "x²": Operation.unaryOperation({ $0 * $0 }),
        "sin": Operation.unaryOperation(sin),
        "cos": Operation.unaryOperation(cos),
        "tan": Operation.unaryOperation(tan),
        "±": Operation.unaryOperation({ -$0}),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals
    ]
    
    private var accumulator: (value: Double?, description: String?)
    
    private var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private let formatter = NumberFormatter()
    
    var result: Double? {
        get {
            return accumulator.value
        }
    }
    
    var sequence: String {
        get {
            let postfix = resultIsPending ? "..." : "="
            
            let accumulatorDescription = accumulator.description == nil ? "" : accumulator.description! + " "
            
            if (resultIsPending) {
                return pendingBinaryOperation!.description + accumulatorDescription + postfix
            } else {
                return accumulatorDescription + postfix
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, format(operand))
    }
    
    private func format(_ double: Double) -> String {
        return formatter.string(from: (double as NSNumber))!
    }
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            
            switch operation {
                
            case .constant(let value):
                accumulator = (value, symbol)
                
            case .unaryOperation(let function):
                
                if accumulator.value != nil {
                    
                    let newValue = function(accumulator.value!)
                    let newDescription = symbol + "(" + (accumulator.description ?? "") + ")"
                    
                    accumulator = (newValue, newDescription)
                }
                
            case .binaryOperation(let function):
                
                performPendingBinaryOperation()
                                        
                if accumulator.value != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator, symbol: symbol)
                    accumulator = (nil, nil)
                }
                
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?    
    
    private struct PendingBinaryOperation {
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
    
    private mutating func performPendingBinaryOperation() {
        
        if pendingBinaryOperation != nil && accumulator.value != nil {
            
            accumulator = pendingBinaryOperation!.perform(with: accumulator)
            pendingBinaryOperation = nil
            
        }
    }
    
}
