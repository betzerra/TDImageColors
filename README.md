TDImageColors
=============
iOS Library used to detect a number of most used colors in a UIImage.

![TDImageColors](/demo.gif)

## Use
```objc
/*  anImage is the UIImage you want to analyze.
 *  count is the maximum amount of colors you want to get.
 *  threshold is the 'tolerance' between colors or distance you want to get. */
 
TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:anImage count:64 threshold:0.25f];

//  Boom! Here's your generated color palette
NSArray *paletteColors = imageColors.colors;
```

## Installation
### Using CocoaPods
`pod 'TDImageColors@betzerra', '~> 0.3'`
### Traditional method
Just download the source files and drag them into your project.
