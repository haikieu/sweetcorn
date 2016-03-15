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
    let imageView = NSImageView()
    let codeView = NSTextField()
    
    let monalisa = NSImage(named: "monalisa.jpg")!
    let ciMonaLisa: CIImage
    
    var glslString: String?
    {
        didSet
        {
            if let glslString = glslString
            {
                codeView.stringValue = glslString
            }
        }
    }
    
    override init(frame frameRect: NSRect)
    {
        let tiffData = monalisa.TIFFRepresentation!
        let bitmap = NSBitmapImageRep(data: tiffData)
        ciMonaLisa = CIImage(bitmapImageRep: bitmap!)!
        
        super.init(frame: frameRect)
        
        imageView.image = monalisa
        
        codeView.font = NSFont.userFixedPitchFontOfSize(10)
        codeView.editable = false
        codeView.selectable = true
        codeView.bordered = false
        codeView.backgroundColor = NSColor.darkGrayColor()
        codeView.maximumNumberOfLines = 0
  
        addSubview(imageView)
        addSubview(codeView)
        
        shadow = NSShadow()
        shadow?.shadowColor = NSColor.blackColor()
        shadow?.shadowBlurRadius = 5
        shadow?.shadowOffset = NSSize(width: 0, height: 0)
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func copyCode()
    {
        guard let glslString = glslString else
        {
            return
        }
        
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        pasteboard.writeObjects([glslString])
    }
    
    override var frame: NSRect
    {
        didSet
        {
            imageView.frame = CGRect(x: 0,
                y: frame.height - frame.width,
                width: frame.width,
                height: frame.width)
            
            codeView.frame = CGRect(x: 0,
                y: 0,
                width: frame.width,
                height: frame.height - frame.width)
        }
    }
}

extension GLSLViewer: FilteringDelegate
{
    func glslDidUpdate(glslString: String)
    {
        self.glslString = glslString
        
        let kernel = CIColorKernel(string: glslString)
        
        let filtered = kernel?.applyWithExtent(ciMonaLisa.extent, arguments: [ciMonaLisa])
        
        let imageRep = NSCIImageRep(CIImage: filtered!)
        let final = NSImage(size: ciMonaLisa.extent.size)
        
        final.addRepresentation(imageRep)
        
        imageView.image = final
    }
}
