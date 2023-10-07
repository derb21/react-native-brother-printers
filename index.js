import {NativeModules, NativeEventEmitter, Platform} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

const _printImage =
  Platform.OS === "ios" ? ReactNativeBrotherPrinters.printImage : () => {};
const _testPrint =
  Platform.OS === "ios" ? ReactNativeBrotherPrinters.testPrint : () => {};

/**
 * Prints an image
 *
 * @param device                  Device object
 * @param uri                     URI of image wanting to be printed
 * @param deviceClass
 * @param pageSize
 * @return {Promise<*>}
 */
export async function printImage(device, uri, deviceClass, pageSize) {
  return _printImage(device, uri, deviceClass, pageSize);
}

/**
 * Test print
 *
 * @param device                  Device object
 * @param deviceClass
 * @param paperSize
 * @return {Promise<*>}
 */
export async function testPrint(device, deviceClass, paperSize) {
  return _testPrint(device, deviceClass, paperSize);
}

const listeners = new NativeEventEmitter(ReactNativeBrotherPrinters);

export function registerBrotherListener(key, method) {
  return listeners.addListener(key, method);
}
