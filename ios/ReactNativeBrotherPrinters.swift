import Foundation
import UIKit

@objc(ReactNativeBrotherPrinters)
class ReactNativeBrotherPrinters: NSObject {

    @objc
    func printImage(_ device: String, uri printURI: String, deviceClass model: String, pageSize pageWidth: String,
                    resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let url = URL(string: printURI) else {
            reject("INVALID_URI", "Brother print: invalid image URI \(printURI)", nil)
            return
        }
        printRJ(imageURL: url, device: device, accessoryModel: model, pageWidth: pageWidth, resolve: resolve, reject: reject)
    }

    @objc
    func testPrint(_ device: String, deviceClass model: String, pageSize pageWidth: String,
                   resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let bundleURL = Bundle(for: ReactNativeBrotherPrinters.self)
                .url(forResource: "BrotherPrinterResources", withExtension: "bundle"),
              let resources = Bundle(url: bundleURL),
              let url = resources.url(forResource: "testPrint", withExtension: "png") else {
            reject("TEST_IMAGE_MISSING", "Brother test print: package test image is missing", nil)
            return
        }
        printRJ(imageURL: url, device: device, accessoryModel: model, pageWidth: pageWidth, resolve: resolve, reject: reject)
    }

    @objc
    static func requiresMainQueueSetup() -> Bool {
        return false
    }

    // Settings come from the model the printer reports, so every RJ model the SDK knows prints.
    private func printRJ(imageURL: URL, device: String, accessoryModel: String, pageWidth: String,
                         resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let channel = BRLMChannel(bluetoothSerialNumber: device)
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
              let printerDriver = generateResult.driver else {
            reject("OPEN_CHANNEL_FAILED",
                   "Brother print: could not open channel to \(accessoryModel) (serial \(device)), error code \(generateResult.error.code.rawValue)",
                   nil)
            return
        }
        defer {
            printerDriver.closeChannel()
        }

        let statusResult = printerDriver.getPrinterStatus()
        guard statusResult.error.code == .noError, let status = statusResult.status else {
            let cause: String
            switch statusResult.error.code {
            case .printerNotFound: cause = "printer not found"
            case .timeout: cause = "status request timed out"
            case .noError: cause = "SDK returned no printer status"
            @unknown default: cause = "unknown status error"
            }
            let code = statusResult.error.code.rawValue
            let message = "Brother print: could not read status from \(accessoryModel) (serial \(device)), SDK code \(code): \(cause)"
            let error = NSError(domain: "BRLMGetStatusError", code: code,
                                userInfo: [NSLocalizedDescriptionKey: message])
            reject("PRINTER_STATUS_FAILED", message, error)
            return
        }
        guard let printSettings = BRLMRJPrintSettings(defaultPrintSettingsWith: status.model) else {
            reject("UNSUPPORTED_MODEL",
                   "Brother print: \(accessoryModel) (SDK model \(status.model.rawValue)) is not an RJ-series printer",
                   nil)
            return
        }

        switch pageWidth {
        case "288":
            printSettings.customPaperSize = rollPaper(widthInches: 3.0)
        case "384":
            printSettings.customPaperSize = rollPaper(widthInches: 4.0)
        default:
            break
        }

        let report = BRLMValidatePrintSettings.validate(printSettings)
        if report.errorCount > 0 {
            reject("INVALID_PRINT_SETTINGS",
                   "Brother print: settings rejected for \(accessoryModel) at pageWidth=\(pageWidth): \(report.description)",
                   nil)
            return
        }

        let printError = printerDriver.printImage(with: imageURL, settings: printSettings)
        if printError.code != .noError {
            let printerState = status.errorCode == .noError ? "" : " (printer reports \(describe(status.errorCode)))"
            reject("PRINT_FAILED",
                   "Brother print failed on \(accessoryModel) (serial \(device)), error code \(printError.code.rawValue): \(printError.description)\(printerState)",
                   nil)
            return
        }
        resolve(nil)
    }

    private func rollPaper(widthInches: CGFloat) -> BRLMCustomPaperSize {
        let margins = BRLMCustomPaperSizeMargins(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return BRLMCustomPaperSize(rollWithTapeWidth: widthInches, margins: margins, unitOfLength: .inch)
    }

    private func describe(_ code: BRLMPrinterStatusErrorCode) -> String {
        switch code {
        case .noPaper: return "no paper"
        case .coverOpen: return "cover open"
        case .busy: return "busy"
        case .paperJam: return "paper jam"
        case .batteryEmpty: return "battery empty"
        case .batteryTrouble: return "battery trouble"
        case .highVoltageAdapter: return "high-voltage adapter"
        case .unsupportedCharger: return "unsupported charger"
        case .systemError: return "system error"
        default: return "printer error \(code.rawValue)"
        }
    }
}
