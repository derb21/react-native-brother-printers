//
//  ReactNativeBrotherPrinters.swift
//  react-native-brother-printers
//
//  Created by Dillen Erb on 11/16/21.
//

import Foundation
import UIKit
import CoreImage
import UniformTypeIdentifiers

@objc(ReactNativeBrotherPrinters)
class ReactNativeBrotherPrinters: NSObject {

    @objc
//    @objc(discoverPrinters:callback:)

 func discoverPrinters(_ callback: RCTResponseSenderBlock) -> [BRPtouchDeviceInfo] {
   // Date is ready to use!
     print("DISCOVERINGPRINTERS")

         let devices = BRPtouchBluetoothManager.shared().pairedDevices()
     print("devices DISCOVER PRINTERS=",devices)
//     print("devices DISCOVER PRINTERS.Optional=",devices.Optional)
//     print("devices DISCOVER PRINTERS.Optional[0=",devices.Optional[0])


     callback([NSNull(), [
        "devices": devices?[0]
         ]])
         return devices as! [BRPtouchDeviceInfo]
     
 }

    @available(iOS 13.0, *)
    @objc
    func printImage(_ device: String, uri printURI: String, deviceClass model:String, pageSize pageWidth:String) -> Void {
        var errorString:String? = nil

        let channel = BRLMChannel(bluetoothSerialNumber: device)
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                print("Error - Open Channel: \(generateResult.error.code)")
                return
        }
        defer {
            printerDriver.closeChannel()
        }
                
print("model=",model)
        print("pageWidth=",pageWidth)

        switch model {
        case "RJ-4230B":
            print("RJ-4230B=",model)

            guard
                let printSettings = BRLMRJPrintSettings(defaultPrintSettingsWith: .RJ_4230B)
                else {
                    print("Error - Image file is not found.")
                    return
            }
            
            errorString = checkPrinterStatus(printerDriver: printerDriver, expectedModel: printSettings.printerModel)
            if errorString != nil
            {
                // cleanup and return error
                printerDriver.closeChannel()
                print("errorString check printer status",errorString)
                return
            }


            
            switch pageWidth {
            case "192":

                //CHANGING PAPER WIDTH SETTINGS TO 2"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 2.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                

            case "288":
                //CHANGING PAPER WIDTH SETTINGS TO 3"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 3.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            case "384":
                //CHANGING PAPER WIDTH SETTINGS TO 4"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 4.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            default:
                print("DEFAULT WIDTH CASE")
            }
            //CHANGING PAPER WIDTH SETTINGS
//            let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//            let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 4.0,
//                                                        margins: margins,
//                                                        unitOfLength: .inch)
//            printSettings.customPaperSize = customPaperSize
            

            let validateErrorString:String? = validatePrintSettings(printSettings:printSettings)
            
        let url = URL(string: printURI)

            let printError = printerDriver.printImage(with: url!, settings: printSettings)

            

            if printError.code != .noError {
                print("Error - Print Image: \(printError.code)")
                print("Error - Print Image, printError.description=: \(printError.description)")

            }
            else {
                print("Success - Print Image")
            }
            
        case "RJ-4030Ai":
            print("RJ-4030Ai=",model)
            guard
                let printSettings = BRLMRJPrintSettings(defaultPrintSettingsWith: .rj_4030Ai)
                else {
                    print("Error - Image file is not found.")
                    return
            }
            
            errorString = checkPrinterStatus(printerDriver: printerDriver, expectedModel: printSettings.printerModel)
            if errorString != nil
            {
                // cleanup and return error
                printerDriver.closeChannel()
                print("errorString check printer status",errorString)
                return
            }

            switch pageWidth {
            case "192":

                print("pageWidth=",pageWidth)
                //CHANGING PAPER WIDTH SETTINGS TO 2"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 2.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                

            case "288":
                //CHANGING PAPER WIDTH SETTINGS TO 3"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 3.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            case "384":
                //CHANGING PAPER WIDTH SETTINGS TO 4"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 4.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            default:
                print("DEFAULT WIDTH CASE")
            }
            //CHANGING PAPER WIDTH SETTINGS
//            let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//            let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 4.0,
//                                                        margins: margins,
//                                                        unitOfLength: .inch)
//            printSettings.customPaperSize = customPaperSize
//

            let validateErrorString:String? = validatePrintSettings(printSettings:printSettings)
            
        let url = URL(string: printURI)

            let printError = printerDriver.printImage(with: url!, settings: printSettings)

            

            if printError.code != .noError {
                print("Error - Print Image: \(printError.code)")
                print("Error - Print Image, printError.description=: \(printError.description)")

            }
            else {
                print("Success - Print Image")
            }
        default:
            print("DEFAULT CASE")
        }
      
      
    
      
      
//        var imageURL = URL(string: "");
//        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//        if let dirPath          = paths.first
//        {
//           imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("testImg.jpg")
//           // Do whatever you want with the image
//        }
//        print("imageURL=",imageURL)
        
    
        //        let imageURLFromParse = URL(string : printURI)
        //        let printError = printerDriver.printImage(with: (imgUI?.cgImage)!, settings: printSettings)
        //    let message = "HELLO TEST PRINTING \n \n"
        //        let data: [UInt8] = Array(message.utf8)
        //        let writeData = Data(bytes: data)
        //
        //
        //        //WRITING TO PRINTER
        //       printerDriver.sendRawData(writeData)

    }
    
    @objc
    func testPrint(_ device: String, deviceClass model:String, pageSize pageWidth:String) -> Void {
        var errorString:String? = nil

        let channel = BRLMChannel(bluetoothSerialNumber: device)
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                print("Error - Open Channel: \(generateResult.error.code)")
                return
        }
        defer {
            printerDriver.closeChannel()
        }
                
print("model=",model)
        print("pageWidth=",pageWidth)

        switch model {
        case "RJ-4230B":
            print("RJ-4230B=",model)

            guard
                let url = Bundle.main.url(forResource: "testPrint", withExtension: "jpg"),
                let printSettings = BRLMRJPrintSettings(defaultPrintSettingsWith: .RJ_4230B)
                else {
                    print("Error - Image file is not found.")
                    return
            }
            
            errorString = checkPrinterStatus(printerDriver: printerDriver, expectedModel: printSettings.printerModel)
            if errorString != nil
            {
                // cleanup and return error
                printerDriver.closeChannel()
                print("errorString check printer status",errorString)
                return
            }


            
            switch pageWidth {
            case "192":

                //CHANGING PAPER WIDTH SETTINGS TO 2"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 2.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                

            case "288":
                //CHANGING PAPER WIDTH SETTINGS TO 3"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 3.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            case "384":
                //CHANGING PAPER WIDTH SETTINGS TO 4"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 4.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            default:
                print("DEFAULT WIDTH CASE")
            }
           

            let validateErrorString:String? = validatePrintSettings(printSettings:printSettings)
            

            let printError = printerDriver.printImage(with: url, settings: printSettings)

            

            if printError.code != .noError {
                print("Error - Print Image: \(printError.code)")
                print("Error - Print Image, printError.description=: \(printError.description)")

            }
            else {
                print("Success - Print Image")
            }
            
        case "RJ-4030Ai":
            print("RJ-4030Ai=",model)
            guard
                let url = Bundle.main.url(forResource: "testPrint", withExtension: "jpg"),
                let printSettings = BRLMRJPrintSettings(defaultPrintSettingsWith: .rj_4030Ai)
                else {
                    print("Error - Image file is not found.")
                    return
            }
            
            errorString = checkPrinterStatus(printerDriver: printerDriver, expectedModel: printSettings.printerModel)
            if errorString != nil
            {
                // cleanup and return error
                printerDriver.closeChannel()
                print("errorString check printer status",errorString)
                return
            }

            switch pageWidth {
            case "192":

                print("pageWidth=",pageWidth)
                //CHANGING PAPER WIDTH SETTINGS TO 2"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 2.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                

            case "288":
                //CHANGING PAPER WIDTH SETTINGS TO 3"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 3.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            case "384":
                //CHANGING PAPER WIDTH SETTINGS TO 4"
                let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                let customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: 4.0,
                                                            margins: margins,
                                                            unitOfLength: .inch)
                printSettings.customPaperSize = customPaperSize
                
            default:
                print("DEFAULT WIDTH CASE")
            }
    

            let validateErrorString:String? = validatePrintSettings(printSettings:printSettings)
            

            let printError = printerDriver.printImage(with: url, settings: printSettings)

            

            if printError.code != .noError {
                print("Error - Print Image: \(printError.code)")
                print("Error - Print Image, printError.description=: \(printError.description)")

            }
            else {
                print("Success - Print Image")
            }
        default:
            print("DEFAULT CASE")
        }
      
      
    
      
        //    let message = "HELLO TEST PRINTING \n \n"
        //        let data: [UInt8] = Array(message.utf8)
        //        let writeData = Data(bytes: data)
        //
        //
        //        //WRITING TO PRINTER
        //       printerDriver.sendRawData(writeData)

    }
    
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
      return true
    }
    //        let imgUI = UIImage(contentsOfFile: printURI)
            //            let url =  Bundle.main.url(forResource: "IMAGE_FILENAME_RJ4040", withExtension: IMAGE_FILEEXT) ?? URL(fileURLWithPath: printURI),
    //        let encodedImageData = printURI
    //        let imageData =    NSData(base64Encoded: encodedImageData)
    //     print("imageData=",imageData)
    //        let image = UIImage(data: imageData as! Data)
    //        let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\("jpg")"
    //        let imageDataS : Data = image!.pngData()! as Data
    //        let urlPath =  URL(string: filePath)
    //        print("urlPath=",urlPath)

    //        imageDataS.write(to: urlPath!)
// @objc
// func constantsToExport() -> [String: Any]! {
//   return ["someKey": "someValue"]
// }
    func checkPrinterStatus(printerDriver:BRLMPrinterDriver, expectedModel:BRLMPrinterModel) -> String?
    {
        print("checkPrinterStatus")
        
        let status:BRLMGetPrinterStatusResult = printerDriver.getPrinterStatus()
        if status.error.code != .noError
        {
            var errorMsg = "checkPrinterStatus: Error getting status: \(status.error.description)"
            // NOTE: Since BRLMGetStatusError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
            // If so, let's add it to the message. So far, it seems that nothing is available here. must check for nil.
            if status.error.errorRecoverySuggestion != nil {
                errorMsg += "\nRecovery: \(status.error.errorRecoverySuggestion!)"
            }
            print(errorMsg)
            
            return errorMsg
        } // if error getting status
        else
        {
            // status was received OK. Now evaluate it.
            
            // Assure model connected matches the expectedModel.
            // This assures that we won't send the wrong print data for the model.
            // Also, this can serve as a "gate" to prevent using the app with compatible non-certified models.
            if expectedModel != status.status?.model
            {
                let errorMsg = "checkPrinterStatus: Error - wrong model connected"
                print(errorMsg)
                
                return errorMsg
            }
            
            // TODO: Check other things by examining status and comparing against the Command Reference Guide
            // These will be model-dependent, but the status response data is similar for most models.
            // Ideally, SDK will add more capability to do this analysis for you and put it in the BRLMGetPrinterStatusResult.
            // For now, I'll only validate the connected printer model per above.
            
        } // else status received OK
        
        return nil // nil means all OK
        
    } // checkPrinterStatus
    
    // *********************************************************
    // validatePrintSettings
    // -> This can be used primarily for DEBUG, to get more information about the cause of an error at print-time
    // if it is related to print settings.
    //
    // RETURNS:
    // * nil if no issues
    // * error string if there are any significant issues
    // *********************************************************
    func validatePrintSettings(printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        //*** Generate a BRLMValidatePrintSettingsReport by allowing SDK to evaluate the printSettings.
        // NOTE:
        // * if report.errorCount > 0, printing will fail. But, if we proceed to print anyway, we can get an error code as well and handle that error.
        // * if report.warningCount > 0, there is an issue with settings, but the SDK will modify settings internally to print the job anyway.
        // * if report.noticeCount > 0, there is an issue with settings, but it is non-fatal and SDK can print without any internal modifications.
        // * In either case, you should investigate the settings and modify them as necessary.
        let report:BRLMValidatePrintSettingsReport = BRLMValidatePrintSettings.validate(printSettings)
        print("validatePrintSettings report:\n\(report.description)")
        
        if report.errorCount > 0 || report.warningCount > 0 || report.noticeCount > 0
        {
            // Allow caller to know there's a potential issue and add this to an alert if desired.
            return report.description
        }
        
        return nil // no issues
    } // validatePrintSettings
 
}

