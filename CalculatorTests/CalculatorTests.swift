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
    
    var clearButton: UIButton!
    
    
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
        
        clearButton = UIButton()
        
    }
    
    override func tearDown() {
        super.tearDown()
        controller = nil
    }
    
    private func assertExpectedDisplayValue(of input: String, asDisplayValue expectedDisplayValue: String, asSequenceValue expectedSequenceValue: String) {
        XCTAssertEqual(controller.display.text!, expectedDisplayValue, "Input for \(input) does not display as \(expectedDisplayValue).")
        XCTAssertEqual(controller.sequence.text!, expectedSequenceValue, "Input for \(input) does not display as \(expectedSequenceValue).")
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
        
        assertExpectedDisplayValue(of: "192.168.0.1", asDisplayValue: "192.16801", asSequenceValue: " ")
        
    }
    
    func test2b() {
        controller.touchPoint(pointButton)
        
        assertExpectedDisplayValue(of: ".", asDisplayValue: "0.", asSequenceValue: " ")
    }
    
    
    func test7a() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        
        assertExpectedDisplayValue(of: "7+", asDisplayValue: "7", asSequenceValue: "7.0 + ...")
    }
    
    func test7b() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        
        assertExpectedDisplayValue(of: "7+9", asDisplayValue: "9", asSequenceValue: "7.0 + ...")
    }
    
    func test7c() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(of: "7+9=", asDisplayValue: "16.0", asSequenceValue: "7.0 + 9.0 =")
    }
    
    func test7d() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(equalsButton)
        controller.performOperation(rootButton)
        
        assertExpectedDisplayValue(of: "7+9=√", asDisplayValue: "4.0", asSequenceValue: "√(7.0 + 9.0) =")
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
        
        assertExpectedDisplayValue(of: "7+9=√+2=", asDisplayValue: "6.0", asSequenceValue: "√(7.0 + 9.0) + 2.0 =")
    }
    
    func test7f() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(rootButton)
        
        assertExpectedDisplayValue(of: "7+9√", asDisplayValue: "3.0", asSequenceValue: "7.0 + √(9.0) ...")
    }
    
    func test7g() {
        
        controller.touchDigit(sevenButton)
        controller.performOperation(plusButton)
        controller.touchDigit(nineButton)
        controller.performOperation(rootButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(of: "7+9√=", asDisplayValue: "10.0", asSequenceValue: "7.0 + √(9.0) =")
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
        
        assertExpectedDisplayValue(of: "7+9=+6=+3=", asDisplayValue: "25.0", asSequenceValue: "7.0 + 9.0 + 6.0 + 3.0 =")
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
        
        assertExpectedDisplayValue(of: "7+9=√6+3=", asDisplayValue: "9.0", asSequenceValue: "6.0 + 3.0 =")
    }
    
    func test7j() {
        
        controller.touchDigit(fiveButton)
        controller.performOperation(plusButton)
        controller.touchDigit(sixButton)
        controller.performOperation(equalsButton)
        controller.touchDigit(sevenButton)
        controller.touchDigit(threeButton)
        
        assertExpectedDisplayValue(of: "5+6=73", asDisplayValue: "73", asSequenceValue: "5.0 + 6.0 =")
    }
    
    func test7k() {
        
        controller.touchDigit(fourButton)
        controller.performOperation(multiplyButton)
        controller.performOperation(piButton)
        controller.performOperation(equalsButton)
        
        assertExpectedDisplayValue(of: "4×π=", asDisplayValue: "12.5663706143592", asSequenceValue: "4.0 × π =")
    }
    
    func test8() {
        
        controller.touchClear(clearButton)
        assertExpectedDisplayValue(of: "C", asDisplayValue: "0", asSequenceValue: " ")
        
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
        
        assertExpectedDisplayValue(of: "6×5×4×3=", asDisplayValue: "360.0", asSequenceValue: "6.0 × 5.0 × 4.0 × 3.0 =")
        
    }
    
}
