//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Barton on 06/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var accumulator: Double?
    private var description: String?
    
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
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private var pendingBinaryDescription = ""
    
    private var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var sequence: String {
        get {
            let postfix = resultIsPending ? "..." : "="
            
            let currentDescription = description != nil ? description! + " " : ""
            
            if (resultIsPending) {
                return pendingBinaryDescription + currentDescription + postfix
            } else {
                return currentDescription + postfix
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        description = String(operand)
    }
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            
            switch operation {
            case .constant(let value):
                accumulator = value
                description = symbol
                
            case .unaryOperation(let function):
                
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    
                    let currentDescription = description == nil ? "" : description!
                    description = symbol + "(" + currentDescription + ")"
                }
                
            case .binaryOperation(let function):
                
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    pendingBinaryDescription = description! + " " + symbol + " "
                    
                    accumulator = nil
                    description = nil
                    
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            description = pendingBinaryDescription + (description == nil ? "" : description!)
            pendingBinaryOperation = nil
        }
    }

}
