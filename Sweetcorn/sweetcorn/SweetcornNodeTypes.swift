//
//  SweetcornNodeTypes.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 14/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Foundation

// ----

let inputNodeType = SweetcornNodeType(name: "Input",
    inputLabels: [],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "")

let outputNodeType = SweetcornNodeType(name: "Output",
    inputLabels: ["Red", "Green", "Blue"],
    outputLabels: [],
    glslString: "  return vec4($0, $1, $2, 1.0); \n")

// -----

let multiplyNodeType = SweetcornNodeType(name: "Multiply",
    inputLabels: ["x", "y"],
    outputLabels: ["x * y"],
    glslString: "  float $VAR_NAME = $0 * $1; \n")

let divideNodeType = SweetcornNodeType(name: "Divide",
    inputLabels: ["x", "y"],
    outputLabels: ["x / y"],
    glslString: "  float $VAR_NAME = $0 / $1; \n")

let subtractNodeType = SweetcornNodeType(name: "Subtract",
    inputLabels: ["x", "y"],
    outputLabels: ["x * y"],
    glslString: "  float $VAR_NAME = $0 - $1; \n")

let addNodeType = SweetcornNodeType(name: "Add",
    inputLabels: ["x", "y"],
    outputLabels: ["x / y"],
    glslString: "  float $VAR_NAME = $0 + $1; \n")

// -----

let smoothstepNodeType = SweetcornNodeType(name: "Smoothstep",
    inputLabels: ["Edge 0: Red", "Edge 0: Green", "Edge 0: Blue", "Edge 1: Red", "Edge 1: Green", "Edge 1: Blue", "Value (x)", "Value (y)", "Value (z)"],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "  vec3 $VAR_NAME = smoothstep(vec3($0, $1, $2), vec3($3, $4, $5), vec3($6, $7, $8)); \n")



let squareRootNodeType = SweetcornNodeType(name: "Square Root",
    inputLabels: ["x"],
    outputLabels: ["√x"],
    glslString: "  float $VAR_NAME = sqrt($0); \n")

let destCoordType = SweetcornNodeType(name: "Coordinate",
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