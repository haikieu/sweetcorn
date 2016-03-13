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
    var nodes: [SweetcornNode]
    
    init()
    {
        let inputNode = SweetcornNode(type: inputNodeType, position: CGPoint(x: 20, y: 400))
        
        let inputs = [
            InputIndex(sourceIndex: 0, targetIndex: 0): inputNode,
            InputIndex(sourceIndex: 1, targetIndex: 1): inputNode,
            InputIndex(sourceIndex: 2, targetIndex: 2): inputNode
        ]
        
        let outputNode = SweetcornNode(type: outputNodeType, position: CGPoint(x: 240, y: 600), inputs: inputs)
        
        let abcd = SweetcornNode(type: smoothstepNodeType, position: CGPoint(x: 380, y: 400), inputs: [InputIndex(sourceIndex: 0, targetIndex: 6): inputNode])
        
        nodes = [inputNode, outputNode, abcd]
        
    }
}

// -----

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

let inputNodeType = SweetcornNodeType(name: "Input", inputLabels: [], outputLabels: ["R", "G", "B"])
let outputNodeType = SweetcornNodeType(name: "Output", inputLabels: ["R", "G", "B"], outputLabels: [])

let smoothstepNodeType = SweetcornNodeType(name: "Smoothstep",
    inputLabels: ["Edge 0: Red", "Edge 0: Green", "Edge 0: Blue", "Edge 1: Red", "Edge 1: Green", "Edge 1: Blue", "x"],
    outputLabels: ["R", "G", "B"])


struct SweetcornNodeType
{
    let name: String
    
    let inputLabels: [String]
    let outputLabels: [String]
}