//
//  SweetcornModel.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 09/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//
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

import Foundation
import Cocoa

class SweetcornNode
{
    var type: SweetcornNodeType
  
    var position: CGPoint
    var inputs: [InputIndex: SweetcornNode]
    
    // For when type is numeric
    var floatValue: Float = 0.0
    
    init(type: SweetcornNodeType, position: CGPoint, inputs: [InputIndex: SweetcornNode] = [:])
    {
        self.type = type
        
        self.position = position
        self.inputs = inputs
    }
    
    func isAscendant(_ node: SweetcornNode) -> Bool
    {
        for inputNode in inputs
        {
            if inputNode.1 === node
            {
                return true
            }
            else if inputNode.1.isAscendant(node)
            {
                return true
            }
        }
        
        return false
    }
}

class SweetcornModel
{
    weak var filteringDelegate: FilteringDelegate?
    weak var nodeInterfaceDelegate: NodeInterfaceDelegate?
    
    var nodes: [SweetcornNode]
    var glslLines = [String]()
    var draggingNodeTypeName: String?
    
    var mode: Mode
    
    let nodeTypes = [smoothstepNodeType,
        addNodeType,
        subtractNodeType,
        divideNodeType,
        multiplyNodeType,
        destCoordNormType,
        stepNodeType,
        lumaCoefficientsNodeType,
        dotNodeType,
        mixNodeType,
        numericNodeType,
        sinNodeType,
        cosNodeType,
        atanNodeType, 
        destCoordType,
        moduloNodeType,
        clampNodeType,
        absolutetNodeType,
        piNodeType,
        powerNodeType,
        fractNodeType,
        ceilNodeType,
        floorNodeType,
        lengthNodeType, 
        squareRootNodeType,
        reflectNodeType,
        refractNodeType, 
        normalizeNodeType,
        symmetricCoordNormType,
        rgbToCMYKNodeType,
        cmykToRGBNodeType,
        rgbToHSVNodeType,
        hsvToRGBNodeType,
        lumaNodeType].sorted(by: {$0.name < $1.name})
    
    init()
    {
        mode = .Color
        
        let inputNode = SweetcornNode(type: inputNodeType, position: CGPoint(x: 20, y: 400))

        let inputs = [
            InputIndex(sourceIndex: 0, targetIndex: 0): inputNode,
            InputIndex(sourceIndex: 1, targetIndex: 1): inputNode,
            InputIndex(sourceIndex: 2, targetIndex: 2): inputNode
        ]
        
        let outputNode = SweetcornNode(type: outputNodeType, position: CGPoint(x: 380, y: 300), inputs: inputs)
     
        nodes = [inputNode, outputNode]
        
        updateGLSL()
    }
    
    func nodeTypeForName(_ name: String, mode: Mode = .Color) -> SweetcornNodeType?
    {
        switch name
        {
        case "Input":
            return inputNodeType
        case "Output":
            return mode == .Warp ? outputWarpNodeType : outputNodeType
        default:
            return nodeTypes.filter({$0.name == name}).first
        }
    }
    
    func node_id(_ node: SweetcornNode) -> String
    {
        return node.type.name == "Input" ?
            "pixel" :
            "var_\(nodes.index(where: {$0 === node})!)"
    }
    
    func deleteNode(_ nodeToDelete: SweetcornNode)
    {
        for node in nodes
        {
            for input in node.inputs
            {
                if input.1 === nodeToDelete
                {
                    node.inputs[input.0] = nil
                }
            }
        }
        
        nodes.remove(at: nodes.index(where: {$0 === nodeToDelete})!)
    }
    
    func updateGLSL()
    {
        guard let outputNode = nodes.filter({$0.type.name == "Output"}).first else
        {
            return
        }
        
        glslLines = [String]()
        
        generateGLSLForNode(outputNode)
        
        let glslString:String

        switch mode
        {
        case .Color:
            glslString = "kernel vec4 color(__sample pixel)\n{\n" + glslLines.reduce("", +) + "}"
        case .Warp:
            glslString = "kernel vec2 warp()\n{\n" + glslLines.reduce("", +) + "}"
        }
        
        let includes = Set<String>(nodes.filter({ $0.type.includeFunction != nil }).map({ $0.type.includeFunction! })).reduce("", +)
        
        filteringDelegate?.glslDidUpdate(includes + glslString)
    }
    
    func generateGLSLForNode(_ node: SweetcornNode)
    {
        let inputs = node.inputs.sorted{ $0.0.targetIndex <  $1.0.targetIndex }
        
        var glslString = node.type.glslString
        
        if let varNameRange = glslString.range(of: "$VAR_NAME")
        {
           glslString.replaceSubrange(varNameRange, with: node_id(node))
        }
        
        if node.type.name == "Float"
        {
            glslString.replaceSubrange(glslString.range(of: "$0")!,
                with: "\(node.floatValue)")
        }
        
        for i in 0 ..< inputs.count
        {
            let replacePostfix = inputs[i].1.type.outputLabels.count == 1 ?
                "" :
                "." + rgba[inputs[i].0.sourceIndex]
            
            glslString.replaceSubrange(glslString.range(of: "$\(i)")!,
                with: node_id(inputs[i].1) + replacePostfix)
        }
        
        if !glslString.isEmpty
        {
            while glslLines.contains(glslString)
            {
                glslLines.remove(at: glslLines.index(of: glslString)!)
            }
            
            glslLines.insert(glslString, at: 0)
        }
        
        for input in inputs
        {
            generateGLSLForNode(input.1)
        }
    }
    
    // MARK: Saving and opening...
    // TODO: Refactor these monster functions!
    
    func newDocument(_ mode: Mode)
    {
        self.mode = mode
        
        switch mode
        {
        case .Color:
            let inputNode = SweetcornNode(type: inputNodeType, position: CGPoint(x: 20, y: 400))
            
            let inputs = [
                InputIndex(sourceIndex: 0, targetIndex: 0): inputNode,
                InputIndex(sourceIndex: 1, targetIndex: 1): inputNode,
                InputIndex(sourceIndex: 2, targetIndex: 2): inputNode
            ]
            
            let outputNode = SweetcornNode(type: outputNodeType, position: CGPoint(x: 380, y: 300), inputs: inputs)
            
            nodes = [inputNode, outputNode]
        case .Warp:
            let inputNode = SweetcornNode(type: destCoordType, position: CGPoint(x: 20, y: 400))
            
            let inputs = [
                InputIndex(sourceIndex: 0, targetIndex: 0): inputNode,
                InputIndex(sourceIndex: 1, targetIndex: 1): inputNode
            ]
            
            let outputNode = SweetcornNode(type: outputWarpNodeType, position: CGPoint(x: 380, y: 300), inputs: inputs)
            
            nodes = [inputNode, outputNode]
        }
        

        
        nodeInterfaceDelegate?.refresh()
        updateGLSL()
    }
    
    func saveDocument()
    {
        var serializableNodes = [[String: AnyObject]]()
        
        for (idx, node) in nodes.enumerated()
        {
            var dict = [String: AnyObject]()

            dict["index"] = idx as AnyObject
            dict["type"] = node.type.name as AnyObject
            dict["floatValue"] = node.floatValue as AnyObject
            dict["positionx"] = node.position.x as AnyObject
            dict["positiony"] = node.position.y as AnyObject
            
            if node.type.name == "Output"
            {
                dict["mode"] = mode.rawValue as AnyObject
            }

            var inputs = [[String: AnyObject]]()
            
            for input in node.inputs
            {
                var inputDict = [String: AnyObject]()
                
                inputDict["sourceIndex"] = input.0.sourceIndex as AnyObject
                inputDict["targetIndex"] = input.0.targetIndex as AnyObject
                inputDict["inputNodeIndex"] = nodes.index(where: {$0 === input.1}) as AnyObject
                
                inputs.append(inputDict)
            }
            
            dict["inputs"] = inputs as AnyObject
            
            serializableNodes.append(dict)
        }
        
        let jsonString: NSString
        
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: serializableNodes,
                options: JSONSerialization.WritingOptions.prettyPrinted)
            
             jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
        }
        catch
        {
             fatalError("Failed to generate JSON")
        }

        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["sweetcorn"]
        
        savePanel.beginSheetModal(for: NSApplication.shared.windows.first!)
        { (result) in
        
            if let url = savePanel.url, result.rawValue == 1
            {
                do
                {
                    try jsonString.write(to: url,
                        atomically: true,
                        encoding: String.Encoding.utf8.rawValue)
                }
                catch
                {
                    alert("Unable to save file.")
                }
            }
        }
    }
    
    func openDocument()
    {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["sweetcorn"]
        
        openPanel.beginSheetModal(for: NSApplication.shared.windows.first!)
        { (result) in
            
            if let url = openPanel.url, result.rawValue == 1
            {
                do
                {
                    let json = try NSString(contentsOf: url,
                        encoding: String.Encoding.utf8.rawValue)
                    
                    self.populateNodesFromJSON(json)
                }
                catch
                {
                    alert("Unable to open file.")
                }
            }
        }
    }
    
    func populateNodesFromJSON(_ jsonString: NSString)
    {
        guard let data = jsonString.data(using: String.Encoding.utf8.rawValue) else
        {
            return
        }
        
        let jsonObject: Any
        
        do
        {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        }
        catch
        {
            alert("Unable to parse JSON")
            return
        }

        mode = .Color
        
        if let jsonArray = jsonObject as? [[String: Any]]
        {
            nodes.removeAll()
            var nodesByIndex = [Int: SweetcornNode]()
            
            for node in jsonArray
            {
                if let modeName = node["mode"] as? String, let mode = Mode(rawValue: modeName)
                {
                    self.mode = mode
                }
                
                let nodeType = nodeTypeForName(String(node["type"] as! NSString), mode: mode)!
                let nodeFloatValue = node["floatValue"] as! Float
                let nodePositionX = CGFloat(truncating: node["positionx"] as! NSNumber)
                let nodePositionY = CGFloat(truncating: node["positiony"] as! NSNumber)
                
                let newNode = SweetcornNode(type: nodeType, position: CGPoint(x: nodePositionX, y: nodePositionY))
                newNode.floatValue = nodeFloatValue
                
                nodes.append(newNode)
                
                nodesByIndex[node["index"] as! Int] = newNode
            }
            
            // Now nodes are updated, we can create relationsips
            
            for node in jsonArray
            {
                for input in node["inputs"] as! [[String: Any]]
                {
                    let inputNode = nodesByIndex[input["inputNodeIndex"] as! Int]
                    let sourceIndex = input["sourceIndex"] as! Int
                    let targetIndex = input["targetIndex"] as! Int
                    let targetNode = nodesByIndex[node["index"] as! Int]
                    
                    targetNode?.inputs[ InputIndex(sourceIndex: sourceIndex, targetIndex: targetIndex) ] = inputNode
                }
            }
            
            nodeInterfaceDelegate?.refresh()
            updateGLSL()
        }
    }
}

// -----

enum Mode: String
{
    case Color, Warp
}

// -----

func alert(_ message: String)
{
    let alert = NSAlert()
    alert.messageText = message
    alert.alertStyle = .warning
    alert.runModal()
}

// -----

protocol FilteringDelegate: class
{
    func glslDidUpdate(_ glslString: String)
}

protocol NodeInterfaceDelegate: class
{
    func refresh()
}

// -----

let rgba = ["r", "g", "b", "a"]

struct InputIndex: Hashable, Equatable
{
    let sourceIndex: Int
    let targetIndex: Int
    
    var hashValue: Int
    {
        return sourceIndex.hashValue + targetIndex.hashValue
    }
}

func == (lhs: InputIndex, rhs: InputIndex) -> Bool
{
    return (lhs.sourceIndex == rhs.sourceIndex) && (lhs.targetIndex == rhs.targetIndex)
}

