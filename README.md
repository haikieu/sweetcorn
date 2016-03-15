# sweetcorn
Node based CIKernel creation

![/Sweetcorn/sweetcorn.png](/Sweetcorn/sweetcorn.png)

While I've had some free time during a fortnight of conferences (try! Swift and RWDevCon were both amazing!), I've taken a small break from writing [my book](https://itunes.apple.com/us/book/core-image-for-swift/id1073029980?ls=1&mt=13) to create Sweetcorn - an open source OS X application to create Core Image color kernels using a node based interface.

The generated Core Image Shading Language code can be used to create CIColorKernels for both iOS and OS X and the node based user interface allows complex shaders to be written with the minimum of typing. 

The current version in my GitHub repository has mainly been written on planes and trains or in hotel rooms with little or no internet access. My knowledge of writing OS X apps in Cocoa is pretty limited - so I suspect some of my approaches may be sort of "special". However, the application is pretty solid and even with fairly complex networks, the UI is responsive and Core Image does a fantastic job of building and applying the filter in next to no time.

Of course, Sweetcorn would benefit from more functionality. I'm hoping to add support for saving and loading kernel code, support for warp and general kernels and implement the entire supported GLSL "vocabulary".

If you want to learn more about Core Image filters using custom kernels, I heartily recommend my book, [Core Image for Swift](https://itunes.apple.com/us/book/core-image-for-swift/id1073029980?ls=1&mt=13). Sweetcorn is available in my GitHub repository here - enjoy! 
