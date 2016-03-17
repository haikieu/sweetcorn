//
//  ViewController.swift
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
//
//  icon: Corn by Creative Stall from the Noun Project

import Cocoa

let model = SweetcornModel()

class ViewController: NSViewController
{
    let scrollView = NSScrollView()
    let canvas = Canvas(model: model, frame: CGRect(x: 0, y: 0, width: 2000, height: 2000))
    
    let nodeTypesList = NodeTypesList(model: model)
    let glslViewer = GLSLViewer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.documentView = canvas
        scrollView.hasVerticalRuler = true
        scrollView.hasHorizontalRuler = true
        
        view.addSubview(scrollView)
        view.addSubview(nodeTypesList)
        view.addSubview(glslViewer)
        
        model.nodeInterfaceDelegate = canvas
        model.filteringDelegate = glslViewer
        model.updateGLSL()
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        
        view.window?.setContentSize(NSSize(width: 1024, height: 768))
        view.window?.showsResizeIndicator = false
        view.window?.center()
        view.window?.title = "Sweetcorn: Node Based Kernel Creation"
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
            y: 0,
            width: frameSize.height * 0.5,
            height: frameSize.height)
        
        nodeTypesList.frame = CGRect(x: 0,
            y: 0,
            width: tableViewWidth,
            height: frameSize.height)
    }
}

extension ViewController // Menu Items
{
    func newDocument(_:NSMenuItem)
    {
        model.newDocument()
    }
    
    func saveDocumentAs(_:NSMenuItem)
    {
        model.saveDocument()
    }
    
    func openDocument(_:NSMenuItem)
    {
        model.openDocument()
    }
}
