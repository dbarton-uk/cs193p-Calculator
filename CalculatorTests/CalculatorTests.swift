//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by David Barton on 14/07/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import XCTest

@testable import Calculator

class CalculatorTests: XCTestCase {
    
    var controller: ViewController!
    
    var zeroButton: UIButton!
    var oneButton: UIButton!
    var twoButton: UIButton!
    var threeButton: UIButton!
    var fourButton: UIButton!
    var fiveButton: UIButton!
    var sixButton: UIButton!
    var sevenButton: UIButton!
    var eightButton: UIButton!
    var nineButton: UIButton!
    var pointButton: UIButton!
    
    var piButton: UIButton!
    
    var rootButton: UIButton!
    
    var plusButton: UIButton!
    var multiplyButton: UIButton!
    var equalsButton: UIButton!
    
    var button: UIButton!
    
    override func setUp() {
        super.setUp()
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController!
        _ = controller.view
        
        zeroButton = UIButton()
        zeroButton.setTitle("0", for: .normal)
        
        oneButton = UIButton()
        oneButton.setTitle("1", for: .normal)
        
        twoButton = UIButton()
        twoButton.setTitle("2", for: .normal)
        
        threeButton = UIButton()
        threeButton.setTitle("3", for: .normal)
        
        fourButton = UIButton()
        fourButton.setTitle("4", for: .normal)
        
        fiveButton = UIButton()
        fiveButton.setTitle("5", for: .normal)
        
        sixButton = UIButton()
        sixButton.setTitle("6", for: .normal)
        
        sevenButton = UIButton()
        sevenButton.setTitle("7", for: .normal)
        
        eightButton = UIButton()
        eightButton.setTitle("8", for: .normal)
        
        nineButton = UIButton()
        nineButton.setTitle("9", for: .normal)
        
        pointButton = UIButton()
        pointButton.setTitle(".", for: .normal)
        
        piButton = UIButton()
        piButton.setTitle("π", for: .normal)
        
        rootButton = UIButton()
        rootButton.setTitle("√", for: .normal)
        
        plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        
        multiplyButton = UIButton()
        multiplyButton.setTitle("×", for: .normal)
        
        equalsButton = UIButton()
        equalsButton.setTitle("=", for: .normal)
        
        button = UIButton()
        
    }
    
    override func tearDown() {
        super.tearDown()
        controller = nil
    }
    
    func test2a() {
        controller.touchDigit(oneButton)
        controller.touchDigit(nineButton)
        controller.touchDigit(twoButton)
        controller.touchPoint(pointButton)
        controller.touchDigit(oneButton)
        controller.touchDigit(sixButton)
        controller.touchDigit(eightButton)
        controller.touchPoint(pointButton)
        controller.touchDigit(zeroButton)
        controller.touchPoint(pointButton)
        controller.touchDigit(oneButton)
        
        assertExpectedDisplayValue(for: "192.168.0.1", hasDisplayValue: "192.16801", hasSequenceValue: " ")
        
    }
    
    func test2b() {
        controller.touchPoint(pointButton)
        
        assertExpectedDisplayValue(for: ".", hasDisplayValue: "0.", hasSequenceValue: " ")
    }
    
    
    func test7a() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        
        assertExpectedDisplayValue(for: "7+", hasDisplayValue: "7", hasSequenceValue: "7 + ...")
    }
    
    func test7b() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        
        assertExpectedDisplayValue(for: "7+9", hasDisplayValue: "9", hasSequenceValue: "7 + ...")
    }
    
    func test7c() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "7+9=", hasDisplayValue: "16", hasSequenceValue: "7 + 9 =")
    }
    
    func test7d() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        controller.performOperation(rootButton)
        
        assertExpectedDisplayValue(for: "7+9=√", hasDisplayValue: "4", hasSequenceValue: "√(7 + 9) =")
    }
    
    func test7e() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        controller.performOperation(rootButton)
        controller.performOperation(plusButton)
        controller.touchDigit(twoButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "7+9=√+2=", hasDisplayValue: "6", hasSequenceValue: "√(7 + 9) + 2 =")
    }
    
    func test7f() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(rootButton)
        
        assertExpectedDisplayValue(for: "7+9√", hasDisplayValue: "3", hasSequenceValue: "7 + √(9) ...")
    }
    
    func test7g() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(rootButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "7+9√=", hasDisplayValue: "10", hasSequenceValue: "7 + √(9) =")
    }
    
    func test7h() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        controller.performOperation(plusButton)
        controller.touchDigit(sixButton)
        controller.performOperation(equalsButton)
        controller.performOperation(plusButton)
        controller.touchDigit(threeButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "7+9=+6=+3=", hasDisplayValue: "25", hasSequenceValue: "7 + 9 + 6 + 3 =")
    }
    
    func test7i() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        controller.performOperation(rootButton)
        controller.touchDigit(sixButton)
        controller.performOperation(plusButton)
        controller.touchDigit(threeButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "7+9=√6+3=", hasDisplayValue: "9", hasSequenceValue: "6 + 3 =")
    }
    
    func test7j() {
        
        controller.touchDigit(fiveButton)
        controller.performOperation(plusButton)
        controller.touchDigit(sixButton)
        controller.performOperation(equalsButton)
        controller.touchDigit(sevenButton)
        controller.touchDigit(threeButton)
        
        assertExpectedDisplayValue(for: "5+6=73", hasDisplayValue: "73", hasSequenceValue: "5 + 6 =")
    }
    
    func test7k() {
        
        controller.touchDigit(fourButton)
        controller.performOperation(multiplyButton)
        controller.performOperation(piButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "4×π=", hasDisplayValue: "12.566371", hasSequenceValue: "4 × π =")
    }
    
    func test8() {
        
        controller.touchClear(button)
        assertExpectedDisplayValue(for: "C", hasDisplayValue: "0", hasSequenceValue: " ")
    }
    
    func testHint7() {
        
        controller.touchDigit(sixButton)
        controller.performOperation(multiplyButton)
        controller.touchDigit(fiveButton)
        controller.performOperation(multiplyButton)
        controller.touchDigit(fourButton)
        controller.performOperation(multiplyButton)
        controller.touchDigit(threeButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: "6×5×4×3=", hasDisplayValue: "360", hasSequenceValue: "6 × 5 × 4 × 3 =")
    }
    
    func testExtraCredit1a() {
        
        controller.touchDigit(sixButton)
        controller.touchDigit(sevenButton)
        controller.touchBackspace(button)
        assertExpectedDisplayValue(for: "67B", hasDisplayValue: "6", hasSequenceValue: " ")
    }
    
    func testExtraCredit1b() {
        
        controller.touchDigit(sixButton)
        controller.touchDigit(sevenButton)
        controller.touchBackspace(button)
        controller.touchBackspace(button)
        
        assertExpectedDisplayValue(for: "67BB", hasDisplayValue: " ", hasSequenceValue: " ")
    }
    
   
    func testExtraCredit1c() {
        
        controller.touchDigit(sixButton)
        controller.touchDigit(sevenButton)
        controller.touchBackspace(button)
        controller.touchBackspace(button)
        
        controller.touchBackspace(button)
        assertExpectedDisplayValue(for: "67BBB", hasDisplayValue: " ", hasSequenceValue: " ")        
    }
    
    func testExtraCredit1d() {
        
        controller.touchDigit(sixButton)
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchBackspace(button)
        
        assertExpectedDisplayValue(for: "67+B", hasDisplayValue: "67", hasSequenceValue: "67 + ...")
        
    }
    
    func testExtraCredit2a() {

        controller.touchPoint(pointButton)
        controller.touchDigit(oneButton)
        controller.touchDigit(twoButton)
        controller.touchDigit(threeButton)
        controller.touchDigit(fourButton)
        controller.touchDigit(fiveButton)
        controller.touchDigit(sixButton)
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(oneButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(for: ".1234567+1=", hasDisplayValue: "1.123457")
    }
    
    func testExtraCredit2b() {
        
        controller.touchDigit(oneButton)
        controller.touchDigit(sixButton)
        controller.performOperation(rootButton)
        
        assertExpectedDisplayValue(for: "16√", hasDisplayValue: "4", hasSequenceValue: "√(16) =")
        
    }
    
    func testExtraCredit3a() {
        
        controller.touchRandom(button)
        
        XCTAssert(controller.displayValue > 0, "R displays \(controller.displayValue) which is not > 0")
        XCTAssert(controller.displayValue < 1, "R displays \(controller.displayValue) which is not < 1")
    }
    
    func testExtraCredit3b() {
        
        controller.touchDigit(oneButton)
        controller.performOperation(plusButton)
        controller.touchRandom(button)
        controller.performOperation(equalsButton)
        
        XCTAssert(controller.displayValue > 1, "R displays \(controller.displayValue) which is not > 1")
        XCTAssert(controller.displayValue < 2, "R displays \(controller.displayValue) which is not < 2")
    }
    
    private func assertExpectedDisplayValue(for input: String, hasDisplayValue expectedDisplayValue: String! = nil, hasSequenceValue expectedSequenceValue: String! = nil) {
        
        if let displayValue = expectedDisplayValue {
            XCTAssertEqual(controller.display.text!, displayValue, "Input for \(input) does not display as \(displayValue).")
        }
        
        if let sequenceValue = expectedSequenceValue {
             XCTAssertEqual(controller.sequence.text!, sequenceValue, "Input for \(input) does not display as \(sequenceValue).")
        }
        
       
    }
    
    
}
