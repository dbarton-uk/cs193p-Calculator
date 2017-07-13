//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Barton on 06/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    var description: String = ""
    var operandDescription: String = ""
    
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
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
          
            switch operation {
            case .constant(let value):
                accumulator = value
                operandDescription = symbol
            case .unaryOperation(let function):
                
                if accumulator != nil {
                    
                    if resultIsPending {
                        description += " " + symbol + "(" + operandDescription + ")"
                    } else {
                        description = symbol + "(" + description + ")"
                    }
                    accumulator = function(accumulator!)
                    operandDescription = ""
                }
                
            case .binaryOperation(let function):
                
                if accumulator != nil {
                    
                    description += operandDescription + " " + symbol

                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)

                    accumulator = nil
            
                }
            case .equals:
                if operandDescription != "" {
                    description += " " + String(operandDescription)
                    operandDescription = ""
                }
                performPendingBinaryOperation()

            }
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if resultIsPending && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if !resultIsPending {
            description = ""
        }
        operandDescription = String(operand)
    }

    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var sequence: String {
        get {
            let postfix = resultIsPending ? " ..." : " ="
            return description + postfix
        }
    }
   
}
