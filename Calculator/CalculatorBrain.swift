//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Barton on 06/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    @available(*, deprecated)
    var resultIsPending: Bool {
        get {
            return evaluate().isPending
        }
    }
    
    @available(*, deprecated)
    var result: Double? {
        get {
            return evaluate().result
        }
    }
    
    @available(*, deprecated)
    var description: String {
        get {
            return evaluate().description
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private enum Element {
        case number(Double)
        case operation(String)
        case variable(String)
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
    
    private var stack = [Element]()
    
    private let formatter = NumberFormatter()
    
    init() {
        formatter.maximumFractionDigits = 6
    }
    
    mutating func setOperand(variable named: String) {
        stack.append(Element.variable(named))
        
    }
    
    mutating func setOperand(_ operand: Double) {
        stack.append(Element.number(operand))
    }
    
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        
        var accumulator: (value: Double?, description: String?)
        
        var pendingBinaryOperation: PendingBinaryOperation?
        
        func performPendingBinaryOperation() {
            
            if pendingBinaryOperation != nil && accumulator.value != nil {
                
                accumulator = pendingBinaryOperation!.perform(with: accumulator)
                pendingBinaryOperation = nil
            }
        }
        
        func performOperation(_ symbol: String) {
            
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
        
        for element in stack {
            
            switch(element) {
                
            case .number(let value):
                accumulator = (value, format(value))
                
            case .operation(let symbol):
                performOperation(symbol)
                
            case .variable(let variable):
                
                if variables != nil {
                    let value = variables![variable] ?? 0
                    accumulator = (value, variable)
                } else {
                    accumulator = (0, variable)
                }
                
            }
            
        }
        
        let result = accumulator.value
        let isPending = pendingBinaryOperation != nil
        
        var description = accumulator.description ?? ""
        
        if isPending {
            description = pendingBinaryOperation!.description + description
        }
        
        return (result, isPending, description)
        
    }
    
    
    mutating func setOperation(_ symbol: String) {
        stack.append(Element.operation(symbol))
    }
    
    mutating func undo() {
        if !stack.isEmpty {
        stack.removeLast()
        }
    }
    
    private func format(_ double: Double) -> String {
        return formatter.string(from: (double as NSNumber))!
    }
    
    
    
    
    
}
