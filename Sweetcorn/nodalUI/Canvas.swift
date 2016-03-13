//
//  Canvas.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 09/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Cocoa

class Canvas: NSView
{
    let curvesLayer = CAShapeLayer()
    
    required init(model: SweetcornModel, frame frameRect: NSRect)
    {
        self.model = model
        
        super.init(frame: frameRect)
        
        let checkerboard = CIFilter(name: "CICheckerboardGenerator",
            withInputParameters: [
                "inputColor0": CIColor(red: 0, green: 0, blue: 0),
                "inputColor1": CIColor(red: 0.05, green: 0.05, blue: 0.05),
            ])!
        
        backgroundFilters = [checkerboard]
        
        wantsLayer = true
        
        layer?.addSublayer(curvesLayer)
        curvesLayer.strokeColor = NSColor.lightGrayColor().CGColor
        curvesLayer.fillColor = nil
        curvesLayer.lineWidth = 2
        
        updateUI()
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var model: SweetcornModel
    {
        didSet
        {
            Swift.print("hola")
        }
    }
    
    override func mouseDown(theEvent: NSEvent)
    {
        Swift.print(theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) )
    }
    
    func updateUI()
    {
        for node in model.nodes
        {
            let nodeWidget = NodeWidget(canvas: self, node: node)
            
            nodeWidget.frame = CGRect(origin: node.position, size: nodeWidget.intrinsicContentSize)
            
            addSubview(nodeWidget)
        }
        
        renderRelationships()
    }
    
    func renderRelationships()
    {
        let path = CGPathCreateMutable()
        
        for node in model.nodes
        {
            for input in node.inputs
            {
                let sourceY = NodeWidget.verticalPositionForLabel(input.0.sourceIndex, widgetType: .Output, node: input.1)
                let targetY = NodeWidget.verticalPositionForLabel(input.0.targetIndex, widgetType: .Input, node: node)
             
                CGPathMoveToPoint(path, nil, node.position.x, node.position.y + targetY + rowHeight / 2)
                
                let controlPointOne = CGPoint(x: input.1.position.x + 100, y: node.position.y + targetY + rowHeight / 2)
                let controlPointTwo = CGPoint(x: node.position.x, y: input.1.position.y + sourceY + rowHeight / 2)
                let endPoint = CGPoint(x: input.1.position.x + 100, y: input.1.position.y + sourceY + rowHeight / 2)
                
                CGPathAddCurveToPoint(path, nil, controlPointOne.x, controlPointOne.y, controlPointTwo.x, controlPointTwo.y, endPoint.x, endPoint.y)
            }
        }
        
        curvesLayer.path = path
    }
}
