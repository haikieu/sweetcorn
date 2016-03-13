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
    
    let titleLabel = NodeWidget.readonlyLabel()
    
    required init(canvas: Canvas, node: SweetcornNode)
    {
        self.canvas = canvas
        self.node = node
        
        super.init(frame: CGRectZero)

        titleLabel.stringValue = node.type.name
        titleLabel.font = NSFont.boldSystemFontOfSize(12)
        titleLabel.alignment = .Center
        titleLabel.backgroundColor = NSColor.darkGrayColor()
        titleLabel.textColor = NSColor.whiteColor()
        addSubview(titleLabel)
       
        node.type.inputLabels.enumerate().forEach{
            addLabelWidget($0, name: $1, widgetType: .Input)}
        
        node.type.outputLabels.enumerate().forEach{
            addLabelWidget($0, name: $1, widgetType: .Output)}
        
        titleLabel.frame = CGRect(x: 0, y: NodeWidget.widgetHeightForNode(node) - rowHeight, width: 100, height: rowHeight)
        
        
    }
    
    func addLabelWidget(index: Int, name: String, widgetType: LabelWidgetType)
    {
        let y = NodeWidget.verticalPositionForLabel(index, widgetType: widgetType, node:  node)
        
        let label = NodeWidget.readonlyLabel()
        
        label.alignment = widgetType == .Input ? .Left : .Right
        
        label.frame = CGRect(x: 0, y: y, width: 100, height: rowHeight)
        label.stringValue = name
        
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
    
    class func readonlyLabel() -> NSTextField
    {
        let label = NSTextField()
        
        label.editable = false
        label.bezeled = false
        label.bordered = false
        
        label.backgroundColor = NSColor.lightGrayColor()
        
        return label
    }
    
    class func verticalPositionForLabel(index: Int, widgetType: LabelWidgetType, node: SweetcornNode) -> CGFloat
    {
        let verticalOffset = widgetType == .Input ?
            NodeWidget.widgetHeightForNode(node) - rowHeight :
            NodeWidget.widgetHeightForNode(node) - rowHeight - CGFloat(node.type.inputLabels.count) * rowHeight
        
        return verticalOffset - (rowHeight * CGFloat(index)) - rowHeight
    }
    
    class func widgetHeightForNode(node: SweetcornNode) -> CGFloat
    {
        return CGFloat((node.type.inputLabels.count + node.type.outputLabels.count) * 20) + rowHeight
    }
}

enum LabelWidgetType
{
    case Input, Output
}