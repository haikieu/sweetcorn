//
//  NodeView.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 09/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Cocoa

let rowHeight: CGFloat = 20

class NodeWidget: NSView
{
    let canvas: Canvas
    let node: SweetcornNode
    
    let titleLabel = NSTextField()
    
    required init(canvas: Canvas, node: SweetcornNode)
    {
        self.canvas = canvas
        self.node = node
        
        super.init(frame: CGRectZero)
        
        layer = CALayer()
        layer?.backgroundColor = NSColor.redColor().CGColor
        wantsLayer = true
        
        titleLabel.stringValue = node.type.name
        
        titleLabel.editable = false
        titleLabel.bezeled = false
        titleLabel.bordered = false
        
        titleLabel.frame = CGRect(x: 0, y: NodeWidget.widgetHeightForNode(node), width: 100, height: rowHeight)
        
        addSubview(titleLabel)
       
        node.type.inputLabels.enumerate().forEach{
            addLabelWidget($0, name: $1, widgetType: .Input)}
        
        node.type.outputLabels.enumerate().forEach{
            addLabelWidget($0, name: $1, widgetType: .Output)}
    }
    
    func addLabelWidget(index: Int, name: String, widgetType: LabelWidgetType)
    {
        let y = NodeWidget.verticalPositionForLabel(index, widgetType: widgetType, node:  node)
        
        let label = NSTextField()
        
        label.alignment = widgetType == .Input ? .Left : .Right
        
        label.frame = CGRect(x: 0, y: y, width: 100, height: rowHeight)
        label.stringValue = name + "\(y)"
        
        addSubview(label)
    }
    
    override var intrinsicContentSize: CGSize
    {
        return CGSize(width: 100, height: NodeWidget.widgetHeightForNode(node))
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDragged(theEvent: NSEvent)
    {        
        frame = frame.offsetBy(dx: theEvent.deltaX, dy: -theEvent.deltaY)
        
        node.position = frame.origin
        
        canvas.renderRelationships()
    }
    
    class func verticalPositionForLabel(index: Int, widgetType: LabelWidgetType, node: SweetcornNode) -> CGFloat
    {
        let verticalOffset = widgetType == .Input ?
            NodeWidget.widgetHeightForNode(node) - rowHeight :
            NodeWidget.widgetHeightForNode(node) - rowHeight - CGFloat(node.type.inputLabels.count) * rowHeight
        
        return verticalOffset - (rowHeight * CGFloat(index))
    }
    
    class func widgetHeightForNode(node: SweetcornNode) -> CGFloat
    {
        return CGFloat((node.type.inputLabels.count + node.type.outputLabels.count) * 20)
    }
}

enum LabelWidgetType
{
    case Input, Output
}