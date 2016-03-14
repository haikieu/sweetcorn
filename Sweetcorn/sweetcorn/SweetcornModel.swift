//
//  SweetcornModel.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 09/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//
// kernel vec4 color(__sample pixel)
// { return pixel; }

import Foundation

class SweetcornNode
{
    var type: SweetcornNodeType
    
    var position: CGPoint
    var inputs: [InputIndex: SweetcornNode]
    
    init(type: SweetcornNodeType, position: CGPoint, inputs: [InputIndex: SweetcornNode] = [:])
    {
        self.type = type
        
        self.position = position
        self.inputs = inputs
    }
}

class SweetcornModel
{
    weak var filteringDelegate: FilteringDelegate?
    
    var nodes: [SweetcornNode]
    var glslLines = [String]()
    var draggingNodeTypeName: String?
    
    let nodeTypes = [smoothstepNodeType,
        addNodeType,
        subtractNodeType,
        divideNodeType,
        multiplyNodeType,
        destCoordType,
        squareRootNodeType].sort({$0.name < $1.name})
    
    init()
    {
        let inputNode = SweetcornNode(type: inputNodeType, position: CGPoint(x: 20, y: 400))

        let inputs = [
            InputIndex(sourceIndex: 0, targetIndex: 0): inputNode,
            InputIndex(sourceIndex: 1, targetIndex: 1): inputNode,
            InputIndex(sourceIndex: 2, targetIndex: 2): inputNode
        ]
        
        let outputNode = SweetcornNode(type: outputNodeType, position: CGPoint(x: 380, y: 300), inputs: inputs)
     
        nodes = [inputNode, outputNode] //, multiplyNode, squareRootNode, destCoordNode]
        
        updateGLSL()
    }
    
    func nodeTypeForName(name: String) -> SweetcornNodeType?
    {
        return nodeTypes.filter({$0.name == name}).first
    }
    
    func node_id(node: SweetcornNode) -> String
    {
        return node.type.name == "Input" ?
            "pixel" :
            "var_\(nodes.indexOf({$0 === node})!)"
    }
    
    func updateGLSL()
    {
        guard let outputNode = nodes.filter({$0.type.name == "Output"}).first else
        {
            return
        }
        
        glslLines = [String]()
        generateGLSLForNode(outputNode)
        
        let glslString = "kernel vec4 color(__sample pixel)\n{\n" + glslLines.reduce("", combine: +) + "}"
     
        filteringDelegate?.glslDidUpdate(glslString)
    }
    
    func generateGLSLForNode(node: SweetcornNode)
    {
        let inputs = node.inputs.sort{ $0.0.targetIndex <  $1.0.targetIndex }
        
        var glslString = node.type.glslString
        
        if let varNameRange = glslString.rangeOfString("$VAR_NAME")
        {
           glslString.replaceRange(varNameRange, with: node_id(node))
        }
        
        for i in 0 ..< inputs.count
        {
            let replacePostfix = inputs[i].1.type.outputLabels.count == 1 ?
                "" :
                "." + rgba[inputs[i].0.sourceIndex]
            
            glslString.replaceRange(glslString.rangeOfString("$\(i)")!,
                with: node_id(inputs[i].1) + replacePostfix)
        }
        
        if !glslString.characters.isEmpty
        {
            while glslLines.contains(glslString)
            {
                glslLines.removeAtIndex(glslLines.indexOf(glslString)!)
            }
            
            glslLines.insert(glslString, atIndex: 0)
        }
        
        for input in inputs
        {
            generateGLSLForNode(input.1)
        }
    }
}

// -----

protocol FilteringDelegate: class
{
    func glslDidUpdate(glslString: String)
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

