
import {NativeModules, NativeEventEmitter, Platform} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;


const {
  printImage: _printImage,
  testPrint: _testPrint,

} = ReactNativeBrotherPrinters;



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
  return _printImage(device, uri, deviceClass,pageSize);
}


export async function testPrint(device, deviceClass, paperSize) {
  return _testPrint(device, deviceClass, paperSize);
}

const listeners = new NativeEventEmitter(ReactNativeBrotherPrinters);

export function registerBrotherListener(key, method) {
  return listeners.addListener(key, method);
}
