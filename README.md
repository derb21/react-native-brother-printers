# react-native-bluetooth-brother-printers

React Native Bluetooth Brother Printers is a react-native module that will allow you to interact with the brother printers. 

## Getting started

Install version 0.0.5 from its Git tag:

`$ npm install 'https://github.com/derb21/react-native-brother-printers.git#v0.0.5' --save`

or 

`$ yarn add 'react-native-bluetooth-brother-printers@https://github.com/derb21/react-native-brother-printers.git#v0.0.5'`

The npm registry version is separate from this Git release.

### Mostly automatic installation

`$ cd ios;pod install`

or if you are using React Native before version 0.60, 

`$ react-native link react-native-bluetooth-brother-printers`

## Usage


iOS only. Works with any Brother RJ printer supported by BRLMPrinterKit 4.13
(RJ-2xxx, RJ-3xxx, RJ-4xxx, including RJ-4230B and RJ-4250WB). The printer must be
paired in iOS Settings with Bluetooth mode set to Classic or Classic & LE.

```js
import {printImage, testPrint} from "react-native-bluetooth-brother-printers";

await printImage(accessory.serialNumber, fileUri, accessory.modelNumber, "384"); // "288" = 3", "384" = 4"
await testPrint(accessory.serialNumber, accessory.modelNumber, "384");
```

`testPrint` uses the package's calibration image. No image needs to be added to the host app. Run `pod install` and rebuild after updating so CocoaPods copies the resource bundle.

Both promises reject with one of these codes:

| Code | Meaning |
|---|---|
| `OPEN_CHANNEL_FAILED` | Could not connect to the printer |
| `PRINTER_STATUS_FAILED` | Connected but could not read printer status; message and native error preserve SDK code 20001 (printer not found), 20002 (timeout), or an unexpected empty status |
| `UNSUPPORTED_MODEL` | Connected printer is not an RJ model |
| `INVALID_PRINT_SETTINGS` | Paper width not valid for this model |
| `PRINT_FAILED` | The SDK reported a print error; the message includes printer state such as no paper or cover open |
| `INVALID_URI` / `TEST_IMAGE_MISSING` | Bad image path / package resource bundle missing |

## Development checks

Run `npm test` on macOS with Xcode command-line tools, CocoaPods and Python 3 installed. It checks the packed resource bundle and native status-error forwarding without sending a printer job. Physical printing still requires a paired printer.
