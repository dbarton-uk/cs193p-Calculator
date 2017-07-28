//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Barton on 06/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var result: String? {
        get {
            return accumulator.value != nil ? format(accumulator.value!) : nil
        }
    }
    
    var sequence: String {
        get {
            
            let accumulatorDescription = accumulator.description == nil ? "" : accumulator.description! + " "
            
            if let pending = pendingBinaryOperation {
                return pending.description + accumulatorDescription
            } else {
                return accumulatorDescription
            }
            
        }
    }
    
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
    
    private let formatter = NumberFormatter()
    
    init() {
        formatter.maximumFractionDigits = 6
    }
    
    mutating func setOperand(variable named: String) {
        accumulator = (0, named)
    }
    
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        return (30.0, false, "10 + 20 ")
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, format(operand))
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
    
    private func format(_ double: Double) -> String {
        return formatter.string(from: (double as NSNumber))!
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
