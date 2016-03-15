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
    
    let nodeTypesList = NodeTypesList(model: model)
    let glslViewer = GLSLViewer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.documentView = canvas
        scrollView.hasHorizontalRuler = true
        scrollView.hasVerticalScroller = true
        
        view.addSubview(scrollView)
        view.addSubview(nodeTypesList)
        view.addSubview(glslViewer)
        
        model.filteringDelegate = glslViewer
        model.updateGLSL()
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        
        // view.window?.styleMask =  NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
        view.window?.setContentSize(NSSize(width: 1024, height: 768))
        view.window?.showsResizeIndicator = false
        view.window?.center()
        view.window?.title = "Sweetcorn: Node Based Kernel Creation"
        
        print(view.window?.contentView)
        
        view.window?.delegate = self
    }
     
    override func viewDidLayout()
    {
        super.viewDidLayout()
        
        resizeUI(toSize: view.frame.size)
    }
    
    func resizeUI(toSize frameSize: NSSize)
    {
        let tableViewWidth: CGFloat = 100
        
        scrollView.frame = CGRect(x: tableViewWidth,
            y: 0,
            width: frameSize.width - tableViewWidth - frameSize.height * 0.5,
            height: frameSize.height)
        
        glslViewer.frame = CGRect(x: frameSize.width - frameSize.height * 0.5,
            y: frameSize.height - frameSize.height * 0.5,
            width: frameSize.height * 0.5,
            height: frameSize.height)
        
        nodeTypesList.frame = CGRect(x: 0,
            y: 0,
            width: tableViewWidth,
            height: frameSize.height)
    }
    
}
