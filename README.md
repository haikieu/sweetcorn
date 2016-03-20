# sweetcorn
Node based CIKernel creation

![/Sweetcorn/sweetcorn.png](/Sweetcorn/sweetcorn.png)

## Introduction

*Sweetcorn* is an OS X app which implements a node based user interface to create Core Image Shader Language code. The resulting code can be used as the basis for custom Core Image filters for either OS X or iOS. Currently, Sweetcorn creates code for `CIColorKernel` based filters with `CIWarpKernel` support coming soon.

## Usage

[Here's a YouTube video of Sweetcorn in action](https://youtu.be/xrxDVxZrKDY). 

When Sweetcorn first launches, it generates a passthrough filter where the red, green and blue input channels are mapped one-to-one to the red, green and blue output channels. To start creating a custom filter, drag a function from the left hand pane into the main workspace. 

To create a relationship between two nodes, simply drag from an output and mouseup over an input channel on a target node. Legal drop targets will highlight in magenta. However, Sweetcorn won't allow circular relationships between nodes, invalid drop targets will highlight in red on mouseover. 

Nodes (apart from the mandatory input and output nodes) can be deleted with a right click.

## Creating a Core Image Filter

The code created by Sweetcorn is displayed in the bottom right panel. For example, a black and white filter may generate:

```
kernel vec4 color(__sample pixel)
{
  vec3 var_2 = vec3(0.2126, 0.7152, 0.0722); 
  float var_3 = dot(vec3(var_2.r, var_2.g, var_2.b), vec3(pixel.r, pixel.g, pixel.b)); 
  return vec4(var_3, var_3, var_3, 1.0); 
}
```

That code can be copied and pasted into a new text file (in Xcode, use `File -> New -> File...` and create an empty file under `Other`). If the code above is saved to a file named `monochrome.cikernel`, a `CIColorKernel` would be created with this code:

```
lazy var monochromeKernel: CIColorKernel =
{
    let monochromeShaderPath = NSBundle.mainBundle().pathForResource("monochrome", ofType: "cikernel")
    
    guard let path = monochromeShaderPath,
        code = try? String(contentsOfFile: path),
        kernel = CIColorKernel(string: code) else
    {
        fatalError("Unable to build monochrome shader")
    }
    
    return kernel
}()
```

To generate a filtered `CIImage` using the kernel, use this following Swift code:

```swift
let arguments = [inputImage] // inputImage is of type CIImage
        
let outputImage = monochromeKernel.applyWithExtent(inputImage.extent, 
    arguments: arguments)
```

If you want to learn more about Core Image filters using custom kernels and how to wrap up this kernel as a fully fledged `CIFilter`, I heartily recommend my book, [Core Image for Swift](https://itunes.apple.com/us/book/core-image-for-swift/id1073029980?ls=1&mt=13). 

## Revision History

* March 16, 2016 - Added support for saving and opening Sweetcorn project files. This functions are called from the main application menu and the projects are saved as JSON. Some of the functions are quite long, so will refactor. Also needs a step to ensure user doesn't lose data if they don't want to. 

* March 17, 2016 - Added icons. Added length, power, fractional, ceiling and floor functions. Added new _vignette_ project example.

## Acknowledgements

The app icon is: **Corn by Creative Stall from the Noun Project**
