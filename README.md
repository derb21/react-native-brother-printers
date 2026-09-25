# react-native-bluetooth-brother-printers

React Native Bluetooth Brother Printers is a react-native module that will allow you to interact with the brother printers. 

## Getting started

`$ npm install react-native-bluetooth-brother-printers --save`

or 

`$ yarn add react-native-bluetooth-brother-printers`

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

Both promises reject with one of these codes:

| Code | Meaning |
|---|---|
| `OPEN_CHANNEL_FAILED` | Could not connect to the printer |
| `PRINTER_STATUS_FAILED` | Connected but could not read printer status |
| `PRINTER_NOT_READY` | Printer reports no paper, cover open, battery empty, etc. |
| `UNSUPPORTED_MODEL` | Connected printer is not an RJ model |
| `INVALID_PRINT_SETTINGS` | Paper width not valid for this model |
| `PRINT_FAILED` | The SDK reported a print error |
| `INVALID_URI` / `TEST_IMAGE_MISSING` | Bad image path / `testPrint.jpg` not bundled |
