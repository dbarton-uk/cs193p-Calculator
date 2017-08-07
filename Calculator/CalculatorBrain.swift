//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by David Barton on 06/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import Foundation

func sqrtValidator(operand: Double) -> (String?) {
    return operand < 0 ? "Cannot evaluate the square root of a negative number." : nil
}


func divisionValidator(divider: Double, divisor: Double) -> String? {
    return divisor == 0 ? "Cannot evaluate a division where the divisor is 0." : nil
}



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
            return evaluate().result.value
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
        case unaryOperation(operation: (Double) -> Double, validator: ((Double) -> String?)?)
        case binaryOperation(operation: (Double, Double) -> Double, validator: ((Double, Double) -> String?)?)
        case equals
    }
    
    private enum Element {
        case number(Double)
        case operation(String)
        case variable(String)
    }
    
    struct Result {
        var value: Double?
        var error: String?
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(operation: sqrt, validator: sqrtValidator),
        "x²": Operation.unaryOperation(operation: {$0 * $0}, validator: nil),
        "sin": Operation.unaryOperation(operation: sin, validator: nil),
        "cos": Operation.unaryOperation(operation: cos, validator: nil),
        "tan": Operation.unaryOperation(operation: tan, validator: nil),
        "±": Operation.unaryOperation(operation: { -$0}, validator: nil),
        "×": Operation.binaryOperation(operation: { $0 * $1 }, validator: nil),
        "÷": Operation.binaryOperation(operation: { $0 / $1 }, validator: divisionValidator),
        "+": Operation.binaryOperation(operation: { $0 + $1 }, validator: nil),
        "−": Operation.binaryOperation(operation: { $0 - $1 }, validator: nil),
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
    
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: CalculatorBrain.Result, isPending: Bool, description: String) {
        
        var accumulator: (value: Double?, description: String?, error: String?)
        
        var pendingBinaryOperation: PendingBinaryOperation?
        
        func performPendingBinaryOperation() {
            
            if pendingBinaryOperation != nil {
                
                if let value = accumulator.value {
                    accumulator = pendingBinaryOperation!.perform(with: (value, accumulator.description))
                    pendingBinaryOperation = nil
                }
            }
        }
        
        func performOperation(_ symbol: String) {
            
            if let operation = operations[symbol] {
                
                switch operation {
                    
                case .constant(let value):
                    accumulator = (value, symbol, nil)
                    
                case .unaryOperation(let (operation, validator)):
                    
                    if let value = accumulator.value {

                        let newValue = operation(value)
                        let error = validator != nil ? validator!(value) : nil
                        let newDescription = symbol + "(" + (accumulator.description ?? "") + ")"
                        
                        accumulator = (newValue, newDescription, error)
                    }
                    
                case .binaryOperation(let (operation, validator)):
                    
                    performPendingBinaryOperation()
                    
                    if let value = accumulator.value {
                        pendingBinaryOperation = PendingBinaryOperation(operation: operation, validator: validator, firstOperand: (value, accumulator.description!), symbol: symbol)
                        accumulator = (nil, nil, nil)
                    }
                    
                case .equals:
                    performPendingBinaryOperation()
                    
                }                
            }
        }
        
        for element in stack {
            
            switch(element) {
                
            case .number(let value):
                accumulator = (value, format(value), nil)
                
            case .operation(let symbol):
                performOperation(symbol)
                
            case .variable(let variable):
                
                if variables != nil {
                    let value = variables![variable] ?? 0
                    accumulator = (value, variable, nil)
                } else {
                    accumulator = (0, variable, nil)
                }
                
            }
            
        }
        
        let result = Result(value: accumulator.value, error: accumulator.error)
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
