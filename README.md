# ImageDetect

[![Version](https://img.shields.io/cocoapods/v/ImageDetect.svg?style=flat)](http://cocoapods.org/pods/ImageDetect)
[![License](https://img.shields.io/cocoapods/l/ImageDetect.svg?style=flat)](http://cocoapods.org/pods/ImageDetect)
[![Platform](https://img.shields.io/cocoapods/p/ImageDetect.svg?style=flat)](http://cocoapods.org/pods/ImageDetect)

## Example

![ScreenShot](https://raw.github.com/Feghal/ImageDetect/master/Screenshots/1.png)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
1) Xcode 9.0 (beta) or higher.
2)  iOS 11.0 (beta) or higher.

## Installation

### CocoaPods

ImageDetect is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ImageDetect'
```
Then, run the following command:
```ruby
pod install
```
### Manually

1. Drag and Drop it into your project

2. Import `ImageDetect`

3. You are ready to go!

## Usage
Crop your (UIImage or CGImage)
```Swift

// `type` in this method can be face, barcode or text
image.detector.crop(type: .face) { [weak self] result in
    switch result {
        case .success(let croppedImages):
            // When the `Vision` successfully find type of object you set and successfuly crops it.
            print("Found")
        case .notFound:
            // When the image doesn't contain any type of object you did set, `result` will be `.notFound`.
            print("Not Found")
        case .failure(let error):
            // When the any error occured, `result` will be `failure`.
            print(error.localizedDescription)
            }
}
```

## Author

Arthur Sahakyan, feghaldev@gmail.com

## License

ImageDetect is available under the MIT license. See the LICENSE file for more info.
