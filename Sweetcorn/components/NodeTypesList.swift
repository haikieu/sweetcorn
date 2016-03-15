//
//  NodesCollectionView.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 14/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Cocoa


class NodeTypesList: NSScrollView
{
    let tableView = TableViewNoDragImage()
    
    let model: SweetcornModel
    
    required init(model: SweetcornModel)
    {
        self.model = model
        
        super.init(frame: CGRectZero)

        let column = NSTableColumn(identifier: "")
        tableView.addTableColumn(column)

        tableView.headerView = nil
        tableView.backgroundColor = NSColor.darkGrayColor()
        
        tableView.setDataSource(self)
        tableView.setDelegate(self)
        
        documentView = tableView
        
        horizontalScroller = nil
        
        shadow = NSShadow()
        shadow?.shadowColor = NSColor.blackColor()
        shadow?.shadowBlurRadius = 5
        shadow?.shadowOffset = NSSize(width: 0, height: 0)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

class TableViewNoDragImage: NSTableView
{
    override func dragImageForRowsWithIndexes(dragRows: NSIndexSet, tableColumns: [NSTableColumn], event dragEvent: NSEvent, offset dragImageOffset: NSPointPointer) -> NSImage {
        return NSImage()
    }
}

extension NodeTypesList: NSTableViewDataSource, NSTableViewDelegate
{
    func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool
    {
        pboard.addTypes(["DraggingSweetcornNodeType"], owner: self)
        
        model.draggingNodeTypeName = model.nodeTypes[rowIndexes.firstIndex].name
        
        return true
    }
    
    func tableView(tableView: NSTableView, shouldEditTableColumn tableColumn: NSTableColumn?, row: Int) -> Bool
    {
        return false
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        return model.nodeTypes.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        return model.nodeTypes[row].name
    }
}
