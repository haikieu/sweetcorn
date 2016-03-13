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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.documentView = canvas
        
        scrollView.hasHorizontalRuler = true
        scrollView.hasVerticalScroller = true
        
        
//        let xxx = CIColorKernel(string: "kernel vec4 color(__sample pixel) { return pixel; }")
//        
//        print(xxx.debugDescription)
    }
    
    override func viewWillAppear()
    {
        view.window?.delegate = self
        
        scrollView.frame = view.frame
    }
    
    
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize
    {
        scrollView.frame = CGRect(origin: CGPointZero, size: frameSize)
        
        return frameSize
    }
    
    
}
