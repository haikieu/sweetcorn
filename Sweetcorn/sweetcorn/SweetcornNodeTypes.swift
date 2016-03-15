//
//  SweetcornNodeTypes.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 14/03/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import Foundation

// Special Types (TODO move names to constants :)

let inputNodeType = SweetcornNodeType(name: "Input",
    inputLabels: [],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "")

let outputNodeType = SweetcornNodeType(name: "Output",
    inputLabels: ["Red", "Green", "Blue"],
    outputLabels: [],
    glslString: "  return vec4($0, $1, $2, 1.0); \n")

let numericNodeType = SweetcornNodeType(name: "Float",
    inputLabels: [],
    outputLabels: ["x"],
    glslString: "  float $VAR_NAME = $0 ; \n")

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
    outputLabels: ["x - y"],
    glslString: "  float $VAR_NAME = $0 - $1; \n")

let addNodeType = SweetcornNodeType(name: "Add",
    inputLabels: ["x", "y"],
    outputLabels: ["x + y"],
    glslString: "  float $VAR_NAME = $0 + $1; \n")

// -----

let squareRootNodeType = SweetcornNodeType(name: "Square Root",
    inputLabels: ["x"],
    outputLabels: ["√x"],
    glslString: "  float $VAR_NAME = sqrt($0); \n")

let absolutetNodeType = SweetcornNodeType(name: "Absolute",
    inputLabels: ["x"],
    outputLabels: ["|x|"],
    glslString: "  float $VAR_NAME = abs($0); \n")

// -----

let sinNodeType = SweetcornNodeType(name: "Sine",
    inputLabels: ["x"],
    outputLabels: ["sin(x)"],
    glslString: "  float $VAR_NAME = sin($0); \n")

let cosNodeType = SweetcornNodeType(name: "Cosine",
    inputLabels: ["x"],
    outputLabels: ["cos(x)"],
    glslString: "  float $VAR_NAME = cos($0); \n")

// -----

let smoothstepNodeType = SweetcornNodeType(name: "Smoothstep",
    inputLabels: ["Edge 0: Red", "Edge 0: Green", "Edge 0: Blue", "Edge 1: Red", "Edge 1: Green", "Edge 1: Blue", "Value (x)", "Value (y)", "Value (z)"],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "  vec3 $VAR_NAME = smoothstep(vec3($0, $1, $2), vec3($3, $4, $5), vec3($6, $7, $8)); \n")

let clampNodeType = SweetcornNodeType(name: "Clamp",
    inputLabels: ["Value (x)", "Value (y)", "Value (z)", "Min: Red", "Min: Green", "Min: Blue", "Max: Red", "Max: Green", "Max: Blue"],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "  vec3 $VAR_NAME = clamp(vec3($0, $1, $2), vec3($3, $4, $5), vec3($6, $7, $8)); \n")

let stepNodeType = SweetcornNodeType(name: "Step",
    inputLabels: ["Edge: Red", "Edge: Green", "Edge: Blue", "Value (x)", "Value (y)", "Value (z)"],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "  vec3 $VAR_NAME = step(vec3($0, $1, $2), vec3($3, $4, $5)); \n")

let mixNodeType = SweetcornNodeType(name: "Mix",
    inputLabels: ["X: Red", "X: Green", "X: Blue", "Y: Red", "Y: Green", "Y: Blue", "A: Red", "A: Green", "A: Blue"],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "  vec3 $VAR_NAME = mix(vec3($0, $1, $2), vec3($3, $4, $5), vec3($6, $7, $8)); \n")

let dotNodeType = SweetcornNodeType(name: "Dot Product",
    inputLabels: ["X: Red", "X: Green", "X: Blue", "Y: Red", "Y: Green", "Y: Blue"],
    outputLabels: ["dot(x, y)"],
    glslString: "  float $VAR_NAME = dot(vec3($0, $1, $2), vec3($3, $4, $5)); \n")

// -----

let lumaCoefficientsNodeType = SweetcornNodeType(name: "Luma Coef",
    inputLabels: [],
    outputLabels: ["Red", "Green", "Blue"],
    glslString: "  vec3 $VAR_NAME = vec3(0.2126, 0.7152, 0.0722); \n")

let piNodeType = SweetcornNodeType(name: "Pi",
    inputLabels: [],
    outputLabels: ["𝛑"],
    glslString: "  float $VAR_NAME = \(M_PI) ; \n")

// -----

let destCoordNormType = SweetcornNodeType(name: "Norm Coord",
    inputLabels: [],
    outputLabels: ["x", "y"],
    glslString: "  vec2 $VAR_NAME = destCoord() / 640.0; \n")

let destCoordType = SweetcornNodeType(name: "Coord",
    inputLabels: [],
    outputLabels: ["x", "y"],
    glslString: "  vec2 $VAR_NAME = destCoord(); \n")

let moduloNodeType =  SweetcornNodeType(name: "Modulo",
    inputLabels: ["x", "y"],
    outputLabels: ["mod(x, y)"],
    glslString: "  float $VAR_NAME = mod($0, $1); \n")

// -----

struct SweetcornNodeType
{
    let name: String
    
    let inputLabels: [String]
    let outputLabels: [String]
    
    let glslString: String
}