//
//  ViewController.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 09/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Cocoa

let model = SweetcornModel()

class ViewController: NSViewController, NSWindowDelegate
{
    let scrollView = NSScrollView()
    let canvas = Canvas(model: model, frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
    
    let imageView = NSImageView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.documentView = canvas
        
        scrollView.hasHorizontalRuler = true
        scrollView.hasVerticalScroller = true
        
        imageView.image = NSImage(named: "monalisa.jpg")!
        imageView.shadow = NSShadow()
        imageView.shadow?.shadowColor = NSColor.blackColor()
        imageView.shadow?.shadowOffset = NSSize(width: 0, height: 0)
        imageView.shadow?.shadowBlurRadius = 10

        view.addSubview(imageView)
        
//        let xxx = CIColorKernel(string: "kernel vec4 color(__sample pixel) { return pixel; }")
//        
//        print(xxx.debugDescription)
    }
    
    override func viewWillAppear()
    {
        view.window?.delegate = self
        
        scrollView.frame = view.frame
        
        imageView.frame = CGRect(x: view.frame.width * 0.6666,
            y: view.frame.height - view.frame.width * 0.33333,
            width: view.frame.width * 0.33333,
            height: view.frame.width * 0.33333)
    }
    
    
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize
    {
        scrollView.frame = CGRect(origin: CGPointZero, size: frameSize)
        
        imageView.frame = CGRect(x: frameSize.width * 0.6666,
            y: frameSize.height - frameSize.width * 0.33333,
            width: frameSize.width * 0.33333,
            height: frameSize.width * 0.33333)
        
        return frameSize
    }
    
    
}
