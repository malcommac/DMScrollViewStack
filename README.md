# DMScrollViewStack

[![CI Status](http://img.shields.io/travis/Daniele Margutti/DMScrollViewStack.svg?style=flat)](https://travis-ci.org/Daniele Margutti/DMScrollViewStack)
[![Version](https://img.shields.io/cocoapods/v/DMScrollViewStack.svg?style=flat)](http://cocoadocs.org/docsets/DMScrollViewStack)
[![License](https://img.shields.io/cocoapods/l/DMScrollViewStack.svg?style=flat)](http://cocoadocs.org/docsets/DMScrollViewStack)
[![Platform](https://img.shields.io/cocoapods/p/DMScrollViewStack.svg?style=flat)](http://cocoadocs.org/docsets/DMScrollViewStack)

## Introduction

DMScrollViewStack is a UIScrollView subclass that efficently handles a vertical stack of multiple sub views/scrollviews.
With this class you can make a single scrollview composed by multiple views, tables or collection views without losing in performances or waste your device’s memory.

A more detailed description of this class and how it works under the hood can be found in my blog's article here: ["How to efficiently handle a stack of scroll views in iOS"](http://danielemargutti.com/how-to-efficiently-handle-a-stack-of-scroll-views-in-ios/)

## Usage

Usage is pretty simple. You can use exposed methods to add or remove subviews. Subviews can be straight UIView or UIScrollView subclasses.

```
-setViews: // set a subview list (no animation)
-addSubview:animated:completion: // add subview at the bottom
-insertSubview:atIndex:animated:completion: // insert subview
-removeSubviewAtIndex:animated:completion: // remove subview
```

<div style="width:100%;">
<img src="Example/demo.gif" align="center" height="50%" width="50%" style="margin-left:20px;">
</div>



## Requirements
I've created it in iOS 8 but it should also works in previous iOS versions without changes.

## Installation

DMScrollViewStack is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "DMScrollViewStack"

## Author

Daniele Margutti

Mail: [me@danielemargutti.com](mailto://me@danielemargutti.com)

Web: [danielemargutti.com](http://www.danielemargutti.com)

## License

If you are using DMScrollViewStack in your project, I'd love to hear about it.

Let Daniele know by sending an email to me@danielemargutti.com.

This is the MIT License.

Copyright (c) 2015 Daniele Margutti [danielemargutti.com](http://www.danielemargutti.com).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
