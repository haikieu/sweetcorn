//
//  NodeView.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 09/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

import Cocoa

let rowHeight: CGFloat = 20

class NodeWidget: NSView
{
    @objc let canvas: Canvas
    let node: SweetcornNode
    
    @objc let titleLabel = TitleLabel()
    @objc let deleteButton = NSButton()
    
    required init(canvas: Canvas, node: SweetcornNode)
    {
        self.canvas = canvas
        self.node = node
        
        super.init(frame: CGRect.zero)

        titleLabel.stringValue = node.type.name
        
        if node.type.name == "Input" || node.type.name == "Output"
        {
            titleLabel.backgroundColor = NSColor.blue
        }
        
        addSubview(titleLabel)
       
        node.type.inputLabels.enumerated().forEach{
            addLabelWidget($0, name: $1, widgetType: .input)}
        
        node.type.outputLabels.enumerated().forEach{
            addLabelWidget($0, name: $1, widgetType: .output)}
        
        titleLabel.frame = CGRect(x: 0, y: NodeWidget.widgetHeightForNode(node) - rowHeight,
            width: 100,
            height: rowHeight)
        
        if node.type.name == "Float"
        {
            let numericInput = NumberEditor(node: node, model: canvas.model)
            
            numericInput.frame = CGRect(x: 0,
                y: NodeWidget.widgetHeightForNode(node) - rowHeight - rowHeight,
                width: 100,
                height: rowHeight)
            
            numericInput.floatValue = node.floatValue
            
            addSubview(numericInput)
        }
        
        if node.type.name != "Input" && node.type.name != "Output"
        {
            let menu = NSMenu(title: "sweetcorn")
            menu.addItem(NSMenuItem(title: "Delete node", action: #selector(NodeWidget.deleteNode), keyEquivalent: ""))
            
            self.menu = menu
        }
    }
    
    @objc func deleteNode()
    {
        model.deleteNode(node)
        
        removeFromSuperview()
        
        canvas.renderRelationships()
    }
    
    func addLabelWidget(_ index: Int, name: String, widgetType: LabelWidgetType)
    {
        let y = NodeWidget.verticalPositionForLabel(index, widgetType: widgetType, node:  node)
        
        let label = widgetType == .input ?
            ReadonlyLabel(index: index, node: node, canvas: canvas) :
            OutputWidget(index: index, mouseDownCallback: mouseDownHandler, canvas: canvas)
        
        label.alignment = widgetType == .input ? .left : .right
        
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
    
    @objc func mouseDownHandler(_ index: Int) -> Void
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
    
    override func mouseDragged(with theEvent: NSEvent)
    {        
        frame = frame.offsetBy(dx: theEvent.deltaX, dy: -theEvent.deltaY)
        
        node.position = frame.origin
        
        canvas.renderRelationships()
    }
    
    class func verticalPositionForLabel(_ index: Int, widgetType: LabelWidgetType, node: SweetcornNode) -> CGFloat
    {
        let verticalOffset = widgetType == .input ?
            NodeWidget.widgetHeightForNode(node) - rowHeight :
            NodeWidget.widgetHeightForNode(node) - rowHeight - CGFloat(node.type.inputLabels.count) * rowHeight
        
        return verticalOffset - (rowHeight * CGFloat(index)) - rowHeight - (node.type.name == "Float" ? 20 : 0)
    }
    
    class func widgetHeightForNode(_ node: SweetcornNode) -> CGFloat
    {
        return CGFloat((node.type.inputLabels.count + node.type.outputLabels.count) * 20) + rowHeight + (node.type.name == "Float" ? 20 : 0)
    }
}

// MARK: Single line numeric entry

class NumberEditor: NSTextField
{
    let node: SweetcornNode
    let model: SweetcornModel
    
    required init(node: SweetcornNode, model: SweetcornModel)
    {
        self.node = node
        self.model = model
        
        super.init(frame: CGRect.zero)
        
        font = NSFont.userFixedPitchFont(ofSize: NSFont.systemFontSize)
        alignment = .right
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textDidChange(_ notification: Notification)
    {
        node.floatValue = floatValue
        
        model.updateGLSL()
    }
    
    override func textDidEndEditing(_ notification: Notification)
    {
        stringValue = "\(floatValue)"
        
        node.floatValue = floatValue
        
        model.updateGLSL()
    }

}

// MARK: Readonly label with mouse over

class ReadonlyLabel: NSTextField
{
    @objc let index: Int
    unowned let node: SweetcornNode
    @objc unowned let canvas: Canvas
    
    init(index: Int, node: SweetcornNode, canvas: Canvas)
    {
        self.index = index
        self.node = node
        self.canvas = canvas
        
        super.init(frame: CGRect.zero)
        
        isEditable = false
        isBezeled = false
        isBordered = false
        
        backgroundColor = NSColor.lightGray
    
    }

    override var frame: CGRect
    {
        didSet
        {
            let trackingArea = NSTrackingArea(rect: bounds,
                options: [NSTrackingArea.Options.mouseEnteredAndExited,
                    NSTrackingArea.Options.activeAlways,
                    NSTrackingArea.Options.enabledDuringMouseDrag],
                owner: self,
                userInfo: nil)
            
            addTrackingArea(trackingArea)
        }
    }
    
    override func mouseEntered(with theEvent: NSEvent)
    {
        if canvas.relationshipCreationSource == nil
        {
            return
        }
        
        textColor = NSColor.white
        
        if canvas.relationshipCreationSource!.node.isAscendant(node)
        {
            backgroundColor = NSColor.red
            return
        }
        
        backgroundColor = NSColor.magenta
        canvas.relationshipTarget = (index: index, node: node)
    }
    
    override func mouseExited(with theEvent: NSEvent)
    {
        backgroundColor = NSColor.lightGray
        textColor = NSColor.black
        
        // canvas.relationshipTarget = nil
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Readonly Title label

class TitleLabel: NSTextField
{
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        
        font = NSFont.boldSystemFont(ofSize: 12)
        alignment = .center
        backgroundColor = NSColor.darkGray
        textColor = NSColor.white
        isEditable = false
        isBezeled = false
        isBordered = false
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Output widget to begin relationship creation

class OutputWidget: NSButton
{
    @objc let index: Int
    @objc let mouseDownCallback: (_ index: Int) -> Void
    @objc unowned let canvas: Canvas
    
    @objc init(index: Int, mouseDownCallback: @escaping (_ index: Int) -> Void, canvas: Canvas)
    {
        self.index = index
        self.mouseDownCallback = mouseDownCallback
        self.canvas = canvas
        
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with theEvent: NSEvent)
    {
        mouseDownCallback(index)
        
        canvas.mouseDown(with: theEvent)
    }
    
    override func mouseDragged(with theEvent: NSEvent)
    {
        canvas.mouseDragged(with: theEvent)
    }

}

enum LabelWidgetType
{
    case input, output
}
