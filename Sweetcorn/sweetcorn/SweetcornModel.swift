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
    
    init()
    {
        let inputNode = SweetcornNode(type: inputNodeType, position: CGPoint(x: 20, y: 400))
        
        let multiplyNode = SweetcornNode(type: multiplyNodeType,
            position: CGPoint(x: 200, y: 300))
        
//        let divideNode = SweetcornNode(type: divideNodeType,
//            position: CGPoint(x: 200, y: 50),
//            inputs: [
//                InputIndex(sourceIndex: 1, targetIndex: 0): inputNode,
//                InputIndex(sourceIndex: 2, targetIndex: 1): inputNode])
        
        let squareRootNode = SweetcornNode(type: squareRootNodeType, position: CGPoint(x: 200, y: 50))
        let destCoordNode = SweetcornNode(type: destCoordType, position: CGPoint(x: 250, y: 50))
        
        let inputs = [
            InputIndex(sourceIndex: 0, targetIndex: 0): inputNode,
            InputIndex(sourceIndex: 1, targetIndex: 1): inputNode,
            InputIndex(sourceIndex: 2, targetIndex: 2): inputNode
        ]
        
        let outputNode = SweetcornNode(type: outputNodeType, position: CGPoint(x: 380, y: 300), inputs: inputs)
        
        // let abcd = SweetcornNode(type: smoothstepNodeType, position: CGPoint(x: 380, y: 400), inputs: [InputIndex(sourceIndex: 0, targetIndex: 6): inputNode])
        
        
        
        nodes = [inputNode, outputNode, multiplyNode, squareRootNode, destCoordNode]
        
        updateGLSL()
    }
    
    func node_id(node: SweetcornNode) -> String
    {
        if node.type.name == "Input"
        {
            return "pixel"
        }
        
        return "var_\(nodes.indexOf({$0 === node})!)"
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
    
    var glslLines = [String]()
    
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

// -----

let inputNodeType = SweetcornNodeType(name: "Input",
    inputLabels: [],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "")

let outputNodeType = SweetcornNodeType(name: "Output",
    inputLabels: ["Red", "Green", "Blue"],
    outputLabels: [],
    glslString: "  return vec4($0, $1, $2, 1.0); \n")

let smoothstepNodeType = SweetcornNodeType(name: "Smoothstep",
    inputLabels: ["Edge 0: Red", "Edge 0: Green", "Edge 0: Blue", "Edge 1: Red", "Edge 1: Green", "Edge 1: Blue", "x"],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "[TBA]")

let multiplyNodeType = SweetcornNodeType(name: "Multiply",
    inputLabels: ["x", "y"],
    outputLabels: ["x * y"],
    glslString: "  float $VAR_NAME = $0 * $1; \n")

let divideNodeType = SweetcornNodeType(name: "Divide",
    inputLabels: ["x", "y"],
    outputLabels: ["x / y"],
    glslString: "  float $VAR_NAME = $0 / $1; \n")

let squareRootNodeType = SweetcornNodeType(name: "Square Root",
    inputLabels: ["x"],
    outputLabels: ["√x"],
    glslString: "  float $VAR_NAME = sqrt($0); \n")

let destCoordType = SweetcornNodeType(name: "destCoord",
    inputLabels: [],
    outputLabels: ["x", "y"],
    glslString: "  vec2 $VAR_NAME = destCoord() / 640.0; \n")

struct SweetcornNodeType
{
    let name: String
    
    let inputLabels: [String]
    let outputLabels: [String]
    
    let glslString: String
}