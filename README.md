# FDAlertPopup
FineDine Alert ViewController, written in Swift.

## Requirements

- iOS 9.0+
- Swift 5+

## Display Types

| Confirm | Dialog | Info |
| --- | --- | ---  |
| ![confirm_example](https://github.com/finedine/FDAlertPopup-iOS/blob/master/Media/confirmPopup.png) | ![dialog_example](https://github.com/finedine/FDAlertPopup-iOS/blob/master/Media/dialogPopup.png) | ![info_example](https://github.com/finedine/FDAlertPopup-iOS/blob/master/Media/infoPopup.png) |

## Installation

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftEntryKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/cocoapods/specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'FDAlertPopup'
```

Then, run the following command:

```bash
$ pod install
```
## Quick Usage

```Swift
let popup = FDAlertPopup()
/*
Do some customization on popup
*/
popup.titleText = "Title"
popup.bodyText = "Body"
popup.noteText = "Note"

popup.display()

```
## Resources

You can display the popup with image or lottie resources.

### Image Resources

```Swift
let popup = FDAlertPopup()
/*
  You can use default success, fail and info resources.
  Or with calling .custom("RESOURCE_NAME") you can use your custom images.
*/
popup.iconResource = .success
popup.display()
```

### Lottie Resources

If you set the image resource before the setting lottie resource, the lottie resource will be override the image resource and the popup will show only lottie resource.

```Swift
let popup = FDAlertPopup()
/*
  You can use default success, fail, info and wait resources.
  Or with calling .custom("RESOURCE_NAME") you can use your custom lottie files.
*/
popup.lottieResource = .success
popup.display()
```

### Supported Attributes

| Attribute        | Description      | Default value  |
| ------------- |-------------| -----|
| lottieResource      | The lottie resource for the animations  | nil |
| iconResource      | The image resource for the icons  | nil |
| titleLabelFont      | The font of the title label  | UIFont.boldSystemFont(ofSize: 22) |
| bodyLabelFont      | The font of the body label  | UIFont.systemFont(ofSize: 20) |
| noteLabelFont      | The font of the note label  | UIFont.italicSystemFont(ofSize: 18) |
| buttonsFont      | The font of the buttons' labels  | UIFont.boldSystemFont(ofSize: 20)  |
| titleLabelColor      | The text color of the title label  | UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) |
| bodyLabelColor      | The text color of the body label  | UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) |
| noteLabelColor      | The text color of the note label  | UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) |
| titleText      | The text will be displayed as Title Label  | "" |
| bodyText      | The text will be displayed as Body Label  | "" |
| noteText      | The text will be displayed as Note Label  | "" |
| confirmButtonText      | The text will be displayed on Confrim Button  | "" |
| confirmButtonTitleColor      | The text color of the Confirm Button Title  | UIColor.white |
| confirmButtonBgColor      | The background color of the Confirm Button  | UIColor.clear |
| confirmButtonBorderColor      | The border color of the Confirm Button  | UIColor(red: 0.9, green: 0.01, blue: 0.29, alpha: 1) |
| cancelButtonText      | The text will be displayed on Cancel Button  | "" |
| cancelButtonTitleColor      | The text color of the Cancel Button Title  | UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1) |
| cancelButtonBgColor      | The background color of the Cancel Button  | UIColor.clear |
| cancelButtonBorderColor      | The border color of the Cancel Button  | UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1) |

## Credits
[SnapKit](https://github.com/SnapKit/SnapKit) project is used in order to create Auto Layout constraints.

[LGButton](https://github.com/loregr/LGButton) project is used in order to create customisable buttons.

[Lottie](https://github.com/airbnb/lottie-ios) project is used in order to display smooth animations.
