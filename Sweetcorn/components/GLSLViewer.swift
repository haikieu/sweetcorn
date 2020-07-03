//
//  GLSLViewer.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 15/03/2016.
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

class GLSLViewer: NSView
{
    @objc let imageView = NSImageView()
    @objc let codeView = NSTextField()
    @objc let textScrollView = NSScrollView()
    
    @objc let monalisa = NSImage(named: "monalisa.jpg")!
    @objc let ciMonaLisa: CIImage
    
    @objc var glslString: String?
    {
        didSet
        {
            if let glslString = glslString
            {
                codeView.stringValue = glslString
                
                codeView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: frame.width,
                                        height: max(textScrollView.frame.height, codeView.intrinsicContentSize.height + 60))
            }
        }
    }
    
    override init(frame frameRect: NSRect)
    {
        let tiffData = monalisa.tiffRepresentation!
        let bitmap = NSBitmapImageRep(data: tiffData)
        ciMonaLisa = CIImage(bitmapImageRep: bitmap!)!
        
        super.init(frame: frameRect)
        
        imageView.image = monalisa
        
        codeView.font = NSFont.userFixedPitchFont(ofSize: 10)
        codeView.isEditable = false
        codeView.isSelectable = true
        codeView.isBordered = false
        codeView.backgroundColor = NSColor.darkGray
        codeView.maximumNumberOfLines = 0
  
        addSubview(textScrollView)
        addSubview(imageView)
        
        textScrollView.documentView = codeView
        textScrollView.hasVerticalScroller = true
        
        shadow = NSShadow()
        shadow?.shadowColor = NSColor.black
        shadow?.shadowBlurRadius = 5
        shadow?.shadowOffset = NSSize(width: 0, height: 0)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func copyCode()
    {
        guard let glslString = glslString else
        {
            return
        }
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([glslString as NSPasteboardWriting])
    }
    
    override var frame: NSRect
    {
        didSet
        {
            imageView.frame = CGRect(x: 0,
                y: frame.height - frame.width,
                width: frame.width,
                height: frame.width)
            
            textScrollView.frame = CGRect(x: 0,
                y: 0,
                width: frame.width,
                height: frame.height - frame.width)
            
            codeView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: frame.width,
                                    height: max(textScrollView.frame.height, codeView.intrinsicContentSize.height))
        }
    }
}

extension GLSLViewer: FilteringDelegate
{
    @objc func glslDidUpdate(_ glslString: String)
    {
        self.glslString = glslString
        
        let filteredImage: CIImage?
        
        switch model.mode
        {
        case .Color:
            let kernel = CIColorKernel(source: glslString)
            
            filteredImage = kernel?.apply(extent: ciMonaLisa.extent, arguments: [ciMonaLisa])
            
        case .Warp:
            let kernel = CIWarpKernel(source: glslString)
            
            filteredImage = kernel?.apply(extent: ciMonaLisa.extent,
                roiCallback:
                {
                    (index, rect) in
                    return rect
                },
                image: ciMonaLisa,
                arguments: [])
        }

        let imageRep = NSCIImageRep(ciImage: filteredImage!)
        let final = NSImage(size: ciMonaLisa.extent.size)
        
        final.addRepresentation(imageRep)
        
        imageView.image = final
    }
}
