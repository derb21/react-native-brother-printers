// main index.js

import {NativeModules, NativeEventEmitter} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

const {
  discoverPrinters: _discoverPrinters,
  pingPrinter: _pingPrinter,
  printImage: _printImage,
  printPDF: _printPDF,
  testPrint: _testPrint,

} = ReactNativeBrotherPrinters;

/**
 * Starts the discovery process for brother printers
 *
 * @param params
 * @param params.V6             If we should searching using IP v6.
 * @param params.printerName    If we should name the printer something specific.
 *
 * @return {Promise<void>}
 */
export async function discoverPrinters(params = {}) {
  return _discoverPrinters(params);
}

/**
 * Checks if a reader is discoverable
 *
 * @param ip
 *
 * @return {Promise<void>}
 */
export async function pingPrinter(ip) {
  return _pingPrinter(ip);
}

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
