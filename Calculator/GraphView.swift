//
//  GraphView.swift
//  Calculator
//
//  Created by David Barton on 11/08/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var fx: (Double) -> Double = cos
    
    @IBInspectable
    var pointsPerUnit: CGFloat = 50
    
    @IBInspectable
    var colour: UIColor = UIColor.red
    
    private var origin: CGPoint {
        return self.center
    }
    
    private var originInPixels: CGPoint {
        return scaleToPixel(fromPoint: origin)
    }
    
    private func scalePointsToPixels(_ value: CGFloat) -> CGFloat {
        return value * contentScaleFactor
    }
    
    private func scaleToPixel(fromPoint: CGPoint) -> CGPoint {
        return CGPoint(x: scalePointsToPixels(fromPoint.x), y: scalePointsToPixels(fromPoint.y))
        
    }
    
    private func pathForFunction(in rect: CGRect) -> UIBezierPath {
        
        func convertToUnitX(forPixel x: CGFloat) -> CGFloat {
            return (x - originInPixels.x) / (pointsPerUnit * contentScaleFactor)
        }
        
        func convertToPixelY(forUnit y: CGFloat) -> CGFloat {
            return (y * pointsPerUnit * contentScaleFactor * -1) + originInPixels.y
        }
        
        func calculatePixelY(forPixel x: CGFloat) -> CGFloat {
            
            let ux = convertToUnitX(forPixel: x)
            let uy = CGFloat(fx(Double(ux)))
        
            return convertToPixelY(forUnit: uy)
        }
        
        func calculatePoint(forPixel x: CGFloat) -> CGPoint {
            let y = calculatePixelY(forPixel: x)
            return scaleToPoint(pixel: CGPoint(x: x, y: y))
        }
        
        func scaleToPoint(_ value: CGFloat) -> CGFloat {
            return value / contentScaleFactor
        }
        
        func scaleToPoint(pixel: CGPoint) -> CGPoint {
            return CGPoint(x: scaleToPoint(pixel.x), y: scaleToPoint(pixel.y))
        }
        
        let widthInPixels = scalePointsToPixels(rect.width)
        let path = UIBezierPath()
        
        path.move(to: calculatePoint(forPixel: 0))
        
        for x in stride(from: 1, through: widthInPixels, by: 1) {
            path.addLine(to: calculatePoint(forPixel: x))
        }
        
        return path
    }
    
    
    override func draw(_ rect: CGRect) {

        AxesDrawer(contentScaleFactor: self.contentScaleFactor).drawAxes(in: bounds, origin: origin, pointsPerUnit: pointsPerUnit)
        colour.set()
        pathForFunction(in: rect).stroke();

    }

}
