//
//  GLSLViewer.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 15/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Cocoa

class GLSLViewer: NSView
{
    let imageView = NSImageView()
    let codeView = NSTextField()
    
    let monalisa = NSImage(named: "monalisa.jpg")!
    let ciMonaLisa: CIImage
    
    override init(frame frameRect: NSRect)
    {
        let tiffData = monalisa.TIFFRepresentation!
        let bitmap = NSBitmapImageRep(data: tiffData)
        ciMonaLisa = CIImage(bitmapImageRep: bitmap!)!
        
        super.init(frame: frameRect)
        
        imageView.image = monalisa
        
        codeView.font = NSFont.userFixedPitchFontOfSize(8)
        codeView.editable = false
        codeView.selectable = true
        codeView.bordered = false
        
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
    
    override var frame: NSRect
    {
        didSet
        {
            imageView.frame = CGRect(x: 0,
                y: 0,
                width: frame.width,
                height: frame.width)
            
            codeView.frame = CGRect(x: 0,
                y: -frame.width,
                width: frame.width,
                height: frame.height - frame.width)
        }
    }
}

extension GLSLViewer: FilteringDelegate
{
    func glslDidUpdate(glslString: String)
    {
        codeView.stringValue = glslString
        
        let kernel = CIColorKernel(string: glslString)
        
        let filtered = kernel?.applyWithExtent(ciMonaLisa.extent, arguments: [ciMonaLisa])
        
        let imageRep = NSCIImageRep(CIImage: filtered!)
        let final = NSImage(size: ciMonaLisa.extent.size)
        
        final.addRepresentation(imageRep)
        
        imageView.image = final
    }
}
