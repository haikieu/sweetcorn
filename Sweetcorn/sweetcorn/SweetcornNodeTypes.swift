//
//  SweetcornNodeTypes.swift
//  Sweetcorn
//
//  Created by Simon Gladman on 14/03/2016.
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

let outputWarpNodeType = SweetcornNodeType(name: "Output",
    inputLabels: ["x", "y"],
    outputLabels: [],
    glslString: "  return vec2($0, $1); \n")

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

let lengthNodeType = SweetcornNodeType(name: "Length",
    inputLabels: ["x", "y"],
    outputLabels: ["length(xy)"],
    glslString: "  float $VAR_NAME = length(vec2($0, $1)); \n")

let squareRootNodeType = SweetcornNodeType(name: "Square Root",
    inputLabels: ["x"],
    outputLabels: ["√x"],
    glslString: "  float $VAR_NAME = sqrt($0); \n")

let absolutetNodeType = SweetcornNodeType(name: "Absolute",
    inputLabels: ["x"],
    outputLabels: ["|x|"],
    glslString: "  float $VAR_NAME = abs($0); \n")

let powerNodeType = SweetcornNodeType(name: "Power",
    inputLabels: ["x", "y"],
    outputLabels: ["xʸ"],
    glslString: "  float $VAR_NAME = pow($0, $1); \n")

let fractNodeType = SweetcornNodeType(name: "Fractional",
    inputLabels: ["x"],
    outputLabels: ["fract(x)"],
    glslString: "  float $VAR_NAME = fract($0); \n")

let ceilNodeType = SweetcornNodeType(name: "Ceiling",
    inputLabels: ["x"],
    outputLabels: ["fract(x)"],
    glslString: "  float $VAR_NAME = ceil($0); \n")

let floorNodeType = SweetcornNodeType(name: "Floor",
    inputLabels: ["x"],
    outputLabels: ["fract(x)"],
    glslString: "  float $VAR_NAME = floor($0); \n")

// -----

let sinNodeType = SweetcornNodeType(name: "Sine",
    inputLabels: ["x"],
    outputLabels: ["sin(x)"],
    glslString: "  float $VAR_NAME = sin($0); \n")

let cosNodeType = SweetcornNodeType(name: "Cosine",
    inputLabels: ["x"],
    outputLabels: ["cos(x)"],
    glslString: "  float $VAR_NAME = cos($0); \n")

let atanNodeType = SweetcornNodeType(name: "Arc Tangent",
                                     inputLabels: ["x", "y"],
                                     outputLabels: ["atan(x, y)"],
                                     glslString: "  float $VAR_NAME = atan($0, $1); \n")


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
    glslString: "  float $VAR_NAME = \(Float.pi) ; \n")

// -----

let destCoordNormType = SweetcornNodeType(name: "Norm Coord",
    inputLabels: [],
    outputLabels: ["x", "y"],
    glslString: "  vec2 $VAR_NAME = destCoord() / 640.0; \n")

let symmetricCoordNormType = SweetcornNodeType(name: "[-1...+1] Coord",
    inputLabels: [],
    outputLabels: ["x", "y"],
    glslString: "  vec2 $VAR_NAME = ((destCoord() / 640.0) * 2.0) - 1.0; \n")

let destCoordType = SweetcornNodeType(name: "Coord",
    inputLabels: [],
    outputLabels: ["x", "y"],
    glslString: "  vec2 $VAR_NAME = destCoord(); \n")

let moduloNodeType =  SweetcornNodeType(name: "Modulo",
    inputLabels: ["x", "y"],
    outputLabels: ["mod(x, y)"],
    glslString: "  float $VAR_NAME = mod($0, $1); \n")

// -----

let reflectNodeType = SweetcornNodeType(name: "Reflect",
                                        inputLabels: ["Incident x", "Incident y", "Incident z", "Normal x", "Normal y", "Normal z"],
                                        outputLabels: ["Reflect x", "Reflect y", "Reflect z"],
                                        glslString: "  vec3 $VAR_NAME = reflect(vec3($0, $1, $2), vec3($3, $4, $5)); \n")

let refractNodeType = SweetcornNodeType(name: "Refract",
                                        inputLabels: ["Incident x", "Incident y", "Incident z", "Normal x", "Normal y", "Normal z", "Refractive Index"],
                                        outputLabels: ["Reflect x", "Reflect y", "Reflect z"],
                                        glslString: "  vec3 $VAR_NAME = refract(vec3($0, $1, $2), vec3($3, $4, $5), $6); \n")

let normalizeNodeType = SweetcornNodeType(name: "Normalize",
                                        inputLabels: ["x", "y", "z"],
                                        outputLabels: ["x", "y", "z"],
                                        glslString: "  vec3 $VAR_NAME = normalize(vec3($0, $1, $2)); \n")

// -----

let rgbToCMYKNodeType = SweetcornNodeType(name: "RGB to CMYK",
                                          inputLabels: ["r", "g", "b"],
                                          outputLabels: ["c", "m", "y", "k"],
                                          glslString: "  vec4 $VAR_NAME = rgbToCMYK(vec3($0, $1, $2)); \n",
                                          includeFunction: rgbToCMYK)
                                        

let rgbToCMYK = "vec4 rgbToCMYK(vec3 rgb) \n" +
    "{ \n" +
    "   float k = 1.0 - max(max(rgb.r, rgb.g), rgb.b); \n" +
    "   float c = (1.0 - rgb.r - k) / (1.0 - k);  \n" +
    "   float m = (1.0 - rgb.g - k) / (1.0 - k); \n"  +
    "   float y = (1.0 - rgb.b - k) / (1.0 - k); \n"  +
    
    "   return vec4(c, m, y, k); \n" +
    "} \n\n"

// ----

let cmykToRGBNodeType = SweetcornNodeType(name: "CMYK to RGB",
                                          inputLabels: ["c", "m", "y", "k"],
                                          outputLabels: ["r", "g", "b"],
                                          glslString: "  vec3 $VAR_NAME = cmykToRGB($0, $1, $2, $3); \n",
                                          includeFunction: cmykToRGB)

let cmykToRGB = "vec3 cmykToRGB(float c, float m, float y, float k) \n" +
    "{ \n" +
    "    float r = (1.0 - c) * (1.0 - k); \n" +
    "    float g = (1.0 - m) * (1.0 - k); \n" +
    "    float b = (1.0 - y) * (1.0 - k); \n" +
    "    return vec3(r, g, b); \n" +
    "} \n\n"

// ----

let rgbToHSVNodeType = SweetcornNodeType(name: "RGB to HSV",
                                          inputLabels: ["r", "g", "b"],
                                          outputLabels: ["h", "s", "v"],
                                          glslString: "  vec3 $VAR_NAME = rgbToHSV(vec3($0, $1, $2)); \n",
                                          includeFunction: rgbToHSV)

let rgbToHSV = "vec3 rgbToHSV(vec3 c) \n" +
    "{ \n" +
    "    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0); \n" +
    "    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g)); \n" +
    "    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r)); \n" +
    "    float d = q.x - min(q.w, q.y); \n" +
    "    float e = 1.0e-10; \n" +
    "    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x); \n" +
    "} \n\n"

// ----

let hsvToRGBNodeType = SweetcornNodeType(name: "HSV to RGB",
                                         inputLabels: ["h", "s", "v"],
                                         outputLabels: ["r", "g", "b"],
                                         glslString: "  vec3 $VAR_NAME = hsvToRGB(vec3($0, $1, $2)); \n",
                                         includeFunction: hsvToRGB)

let hsvToRGB = "vec3 hsvToRGB(vec3 c) \n" +
    "{ \n" +
    "    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0); \n" +
    "    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www); \n" +
    "    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y); \n" +
    "} \n\n"

// ----

let lumaNodeType = SweetcornNodeType(name: "RGB to Luma",
                                         inputLabels: ["r", "g", "b"],
                                         outputLabels: ["luma"],
                                         glslString: "  float $VAR_NAME = dot(vec3($0, $1, $2), vec3(0.2126, 0.7152, 0.0722)); \n")

struct SweetcornNodeType
{
    init(name: String, inputLabels: [String], outputLabels: [String], glslString: String, includeFunction: String? = nil)
    {
        self.name = name
        self.inputLabels = inputLabels
        self.outputLabels = outputLabels
        self.glslString = glslString
        self.includeFunction = includeFunction
    }

    
    let name: String
    
    let inputLabels: [String]
    let outputLabels: [String]
    
    let glslString: String
    let includeFunction: String?
}
