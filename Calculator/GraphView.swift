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
    
    var fx: (Double) -> Double = cos {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var pixelScale: CGFloat {
        return scale * contentScaleFactor
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        
        switch pinchRecognizer.state {
            
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break;
        }
    }
   
    @IBInspectable
    var colour: UIColor = UIColor.red
    
    private var origin: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        origin = self.center
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        origin = self.center
    }
    
    func moveOrigin(byReactingToTap recognizer: UITapGestureRecognizer) {
        
        switch recognizer.state {
        case .ended:
            origin = recognizer.location(in: self)
        default:
            break
        }
    }
    
    func moveOrigin(byReactingToPan recognizer: UIPanGestureRecognizer) {
        switch  recognizer.state {
        case .changed,.ended:
            let translation = recognizer.translation(in: self)
            let x = (origin?.x)! + translation.x
            let y = (origin?.y)! + translation.y
            self.origin = CGPoint(x: x, y: y)
            recognizer.setTranslation(CGPoint.zero, in: self)
        default:break
            
        }
    }
    
    private var originInPixels: CGPoint {
        return scaleToPixel(fromPoint: origin!)
    }
    
    private func scalePointsToPixels(_ value: CGFloat) -> CGFloat {
        return value * contentScaleFactor
    }
    
    private func scaleToPixel(fromPoint: CGPoint) -> CGPoint {
        return CGPoint(x: scalePointsToPixels(fromPoint.x), y: scalePointsToPixels(fromPoint.y))
        
    }
    
    private func pathForFunction(in rect: CGRect) -> UIBezierPath {
        
        func convertToUnitX(forPixel x: CGFloat) -> CGFloat {
            return (x - originInPixels.x) / pixelScale
        }
        
        func convertToPixelY(forUnit y: CGFloat) -> CGFloat {
            return (y * pixelScale * -1) + originInPixels.y
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
        
        AxesDrawer(contentScaleFactor: self.contentScaleFactor).drawAxes(in: bounds, origin: origin!, pointsPerUnit: scale)
        
        colour.set()
        pathForFunction(in: rect).stroke()        
    }
    
}
