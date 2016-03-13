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
    let relationshipCreationLayer = CAShapeLayer()
    
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
        
        layer?.addSublayer(relationshipCreationLayer)
        relationshipCreationLayer.strokeColor = NSColor.magentaColor().CGColor
        relationshipCreationLayer.lineDashPattern = [5,5]
        relationshipCreationLayer.fillColor = nil
        relationshipCreationLayer.lineWidth = 2
        
        updateUI()
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var model: SweetcornModel
    
    var relationshipCreationSource: (node: SweetcornNode, index: Int)?
    {
        didSet
        {
            if relationshipCreationSource == nil
            {
                relationshipCreationLayer.path = nil
            }
        }
    }
    
    var relationshipTarget: (node: SweetcornNode, index: Int)?
    
    override func mouseDragged(theEvent: NSEvent)
    {
        guard let relationshipCreationSource = relationshipCreationSource else
        {
            return
        }
        
        let mouseLocation = convertPoint(theEvent.locationInWindow, fromView: nil)
        
        
        let path = CGPathCreateMutable()
        let sourceNode = relationshipCreationSource.node
        let sourceIndex = relationshipCreationSource.index
        
        let sourceY = NodeWidget.verticalPositionForLabel(sourceIndex, widgetType: .Output, node: sourceNode)
        
        CGPathMoveToPoint(path, nil,
            mouseLocation.x, mouseLocation.y)
        
        let controlPointOne = CGPoint(x: sourceNode.position.x + 100,
            y: mouseLocation.y)
        let controlPointTwo = CGPoint(x: mouseLocation.x,
            y: sourceNode.position.y + sourceY + rowHeight / 2)
        let endPoint = CGPoint(x: sourceNode.position.x + 100,
            y: sourceNode.position.y + sourceY + rowHeight / 2)
        
        CGPathAddCurveToPoint(path, nil,
            controlPointOne.x, controlPointOne.y,
            controlPointTwo.x, controlPointTwo.y,
            endPoint.x, endPoint.y)
        
        relationshipCreationLayer.path = path
    }
    
    // Creates the relationship. TODO - move logic to `SweetcornModel`
    override func mouseUp(theEvent: NSEvent)
    {
        guard let relationshipCreationSource = relationshipCreationSource,
            relationshipTarget = relationshipTarget else
        {
            self.relationshipCreationSource = nil
            self.relationshipTarget = nil
            return
        }
        
        for input in relationshipTarget.node.inputs where input.0.targetIndex == relationshipTarget.index
        {
            relationshipTarget.node.inputs[input.0] = nil
        }
        
        let inputIndex = InputIndex(sourceIndex: relationshipCreationSource.index,
            targetIndex: relationshipTarget.index)
        
        relationshipTarget.node.inputs[inputIndex] = relationshipCreationSource.node
    
        renderRelationships()
        
        self.relationshipCreationSource = nil
    }

    func updateUI()
    {
        for node in model.nodes
        {
            let nodeWidget = NodeWidget(canvas: self, node: node)
            
            nodeWidget.frame = CGRect(origin: node.position,
                size: nodeWidget.intrinsicContentSize)
            
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
                let sourceY = NodeWidget.verticalPositionForLabel(input.0.sourceIndex,
                    widgetType: .Output,
                    node: input.1)
                let targetY = NodeWidget.verticalPositionForLabel(input.0.targetIndex,
                    widgetType: .Input,
                    node: node)
             
                CGPathMoveToPoint(path, nil,
                    node.position.x, node.position.y + targetY + rowHeight / 2)
                
                let controlPointOne = CGPoint(x: input.1.position.x + 100,
                    y: node.position.y + targetY + rowHeight / 2)
                let controlPointTwo = CGPoint(x: node.position.x,
                    y: input.1.position.y + sourceY + rowHeight / 2)
                let endPoint = CGPoint(x: input.1.position.x + 100,
                    y: input.1.position.y + sourceY + rowHeight / 2)
                
                CGPathAddCurveToPoint(path, nil,
                    controlPointOne.x, controlPointOne.y,
                    controlPointTwo.x, controlPointTwo.y,
                    endPoint.x, endPoint.y)
            }
        }
        
        curvesLayer.path = path
    }
}
