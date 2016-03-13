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

        titleLabel.stringValue = node.type.name
        titleLabel.font = NSFont.boldSystemFontOfSize(12)
        titleLabel.alignment = .Center
        titleLabel.backgroundColor = NSColor.darkGrayColor()
        titleLabel.textColor = NSColor.whiteColor()
        titleLabel.editable = false
        titleLabel.bezeled = false
        titleLabel.bordered = false
        
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
        
        let label = widgetType == .Input ?
            ReadonlyLabel(index: index, node: node, canvas: canvas) :
            OutputWidget(index: index, mouseDownCallback: mouseDownHandler, canvas: canvas)
        
        label.alignment = widgetType == .Input ? .Left : .Right
        
        label.frame = CGRect(x: 0, y: y, width: 100, height: rowHeight)
        
        if let btn = label as? OutputWidget
        {
            btn.title = name
        }
        else
        {
            label.stringValue = name
        }
        
        addSubview(label)
    }
    
    func mouseDownHandler(index: Int) -> Void
    {
        canvas.relationshipCreationSource = (node: node, index: index)
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
        
        return verticalOffset - (rowHeight * CGFloat(index)) - rowHeight
    }
    
    class func widgetHeightForNode(node: SweetcornNode) -> CGFloat
    {
        return CGFloat((node.type.inputLabels.count + node.type.outputLabels.count) * 20) + rowHeight
    }
}

// MARK: Readonly label with mouse over

class ReadonlyLabel: NSTextField
{
    let index: Int
    unowned let node: SweetcornNode
    unowned let canvas: Canvas
    
    init(index: Int, node: SweetcornNode, canvas: Canvas)
    {
        self.index = index
        self.node = node
        self.canvas = canvas
        
        super.init(frame: CGRectZero)
        
        editable = false
        bezeled = false
        bordered = false
        
        backgroundColor = NSColor.lightGrayColor()
    
    }

    override var frame: CGRect
    {
        didSet
        {
            let trackingArea = NSTrackingArea(rect: bounds,
                options: [NSTrackingAreaOptions.MouseEnteredAndExited,
                    NSTrackingAreaOptions.ActiveAlways,
                    NSTrackingAreaOptions.EnabledDuringMouseDrag],
                owner: self,
                userInfo: nil)
            
            addTrackingArea(trackingArea)
        }
    }
    
    override func mouseEntered(theEvent: NSEvent)
    {
        if canvas.relationshipCreationSource == nil
        {
            return
        }
        
        backgroundColor = NSColor.magentaColor()
        textColor = NSColor.whiteColor()
        
        canvas.relationshipTarget = (index: index, node: node)
    }
    
    override func mouseExited(theEvent: NSEvent)
    {
        backgroundColor = NSColor.lightGrayColor()
        textColor = NSColor.blackColor()
        
        canvas.relationshipTarget = nil
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Output widget to begin relationship creation

class OutputWidget: NSButton
{
    let index: Int
    let mouseDownCallback: (index: Int) -> Void
    unowned let canvas: Canvas
    
    init(index: Int, mouseDownCallback: (index: Int) -> Void, canvas: Canvas)
    {
        self.index = index
        self.mouseDownCallback = mouseDownCallback
        self.canvas = canvas
        
        super.init(frame: CGRectZero)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(theEvent: NSEvent)
    {
        mouseDownCallback(index: index)
        
        canvas.mouseDown(theEvent)
    }
    
    override func mouseDragged(theEvent: NSEvent)
    {
        canvas.mouseDragged(theEvent)
    }

}

enum LabelWidgetType
{
    case Input, Output
}