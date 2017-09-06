//
//  GraphViewController.swift
//  Calculator
//
//  Created by David Barton on 11/08/2017.
//  Copyright © 2017 David Barton. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            let pinchHandler = #selector(GraphView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: pinchHandler)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            let tapHandler = #selector(GraphView.moveOrigin(byReactingToTap:))
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: tapHandler)
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
            
            let panHandler = #selector(GraphView.moveOrigin(byReactingToPan:))
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: panHandler)
            graphView.addGestureRecognizer(panRecognizer)
            
            updateUI()
        }
    }
    
    var evaluator: (Double) -> Double = tan
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        graphView?.fx = evaluator
    }
    
}
