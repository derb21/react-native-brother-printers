import {NativeModules, Platform} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

const iosOnly = name => {
  if (Platform.OS !== "ios") {
    return Promise.reject(
      new Error(`react-native-bluetooth-brother-printers: ${name} is iOS-only`),
    );
  }
  return null;
};

/**
 * Prints an image on a paired Brother RJ printer.
 *
 * @param device       EAAccessory serial number
 * @param uri          file URI of the image
 * @param deviceClass  accessory model, used in error messages
 * @param pageSize     "288" (3") or "384" (4"); anything else keeps the model default
 * @return {Promise<void>} rejects with a code and message when printing fails
 */
export async function printImage(device, uri, deviceClass, pageSize) {
  return (
    iosOnly("printImage") ||
    ReactNativeBrotherPrinters.printImage(device, uri, deviceClass, pageSize)
  );
}

/**
 * Prints the package's bundled calibration image.
 *
 * @param device       EAAccessory serial number
 * @param deviceClass  accessory model, used in error messages
 * @param paperSize    "288" (3") or "384" (4")
 * @return {Promise<void>}
 */
export async function testPrint(device, deviceClass, paperSize) {
  return (
    iosOnly("testPrint") ||
    ReactNativeBrotherPrinters.testPrint(device, deviceClass, paperSize)
  );
}
