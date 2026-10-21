from pathlib import Path
import json, os, shutil, subprocess, tempfile, textwrap

root = Path(__file__).resolve().parents[1]
source = (root / 'ios/ReactNativeBrotherPrinters.swift').read_text()

def block_at(start):
    opening = source.index('{', start)
    depth = 1
    end = opening + 1
    while depth:
        if source[end] == '{': depth += 1
        if source[end] == '}': depth -= 1
        end += 1
    return source[start:end]

test_method = block_at(source.index('func testPrint('))
guard_start = source.index('guard statusResult.error.code')
guard_open = source.index('else {', guard_start) + len('else ')
depth, end = 1, guard_open + 1
while depth:
    if source[end] == '{': depth += 1
    if source[end] == '}': depth -= 1
    end += 1
status_guard = source[guard_start:end]

packed = json.loads(subprocess.check_output(['npm','pack','--dry-run','--json'], cwd=root, stderr=subprocess.DEVNULL))[0]
package_files = {entry['path'] for entry in packed['files']}
spec = json.loads(subprocess.check_output(['pod','ipc','spec',str(root / 'react-native-bluetooth-brother-printers.podspec')], cwd=root, stderr=subprocess.DEVNULL))

with tempfile.TemporaryDirectory(prefix='brother-package-') as temporary:
    base = Path(temporary)
    host = base / 'Host.app/Contents'
    (host / 'MacOS').mkdir(parents=True)
    resources = host / 'Resources'
    resources.mkdir()
    (host / 'Info.plist').write_text('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>CFBundleIdentifier</key><string>fixture.brother.host</string><key>CFBundleExecutable</key><string>replay</string><key>CFBundlePackageType</key><string>APPL</string></dict></plist>')
    for name, patterns in spec.get('resource_bundles', {}).items():
        bundle = resources / (name + '.bundle')
        bundle.mkdir()
        (bundle / 'Info.plist').write_text('<?xml version="1.0" encoding="UTF-8"?><plist version="1.0"><dict><key>CFBundleIdentifier</key><string>fixture.brother.resources</string><key>CFBundlePackageType</key><string>BNDL</string></dict></plist>')
        for pattern in ([patterns] if isinstance(patterns, str) else patterns):
            for asset in root.glob(pattern):
                if asset.is_file() and str(asset.relative_to(root)) in package_files:
                    shutil.copy2(asset, bundle / asset.name)
    harness = r'''
import Foundation
import Darwin

typealias RCTPromiseResolveBlock = (Any?) -> Void
typealias RCTPromiseRejectBlock = (String?, String?, NSError?) -> Void
var printedImage: URL?
var rejection: (String?, String?, NSError?)?
class ReactNativeBrotherPrinters: NSObject {
    TEST_METHOD
    private func printRJ(imageURL: URL, device: String, accessoryModel: String, pageWidth: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        printedImage = imageURL
        resolve(nil)
    }
}
enum StatusCode: Int { case noError = 20000, printerNotFound, timeout }
struct StatusError { let code: StatusCode; let description = "" }
struct PrinterStatus {}
struct StatusResult { let error: StatusError; let status: PrinterStatus? }
func invokeStatusGuard(_ statusResult: StatusResult) {
    let accessoryModel = "RJ-fixture"
    let device = "fixture-serial"
    let reject: RCTPromiseRejectBlock = { rejection = ($0, $1, $2) }
    STATUS_GUARD
    _ = status
}
var failed = 0
func check(_ condition: Bool, _ name: String) {
    print("\(condition ? "PASS" : "FAIL") \(name)")
    if !condition { failed += 1 }
}
let printer = ReactNativeBrotherPrinters()
printer.testPrint("fixture-serial", deviceClass: "RJ-fixture", pageSize: "384", resolver: { _ in }, rejecter: { rejection = ($0, $1, $2) })
let imageBytes = printedImage.flatMap { try? Data(contentsOf: $0) }
check(imageBytes?.starts(with: [137,80,78,71,13,10,26,10]) == true && rejection == nil, "testPrint loads a packaged image without host-app artwork")
for code in [StatusCode.printerNotFound, .timeout, .noError] {
    rejection = nil
    invokeStatusGuard(StatusResult(error: StatusError(code: code), status: nil))
    check(rejection?.0 == "PRINTER_STATUS_FAILED" && rejection?.1?.contains(String(code.rawValue)) == true && rejection?.2?.code == code.rawValue, "empty SDK description retains native status code \(code.rawValue)")
}
rejection = nil
invokeStatusGuard(StatusResult(error: StatusError(code: .noError), status: PrinterStatus()))
check(rejection == nil, "valid status still passes")
exit(failed == 0 ? 0 : 1)
'''.replace('TEST_METHOD', test_method).replace('STATUS_GUARD', status_guard)
    swift = base / 'replay.swift'
    swift.write_text(harness)
    binary = host / 'MacOS/replay'
    subprocess.run(['xcrun','swiftc',str(swift),'-o',str(binary)], check=True, stdout=subprocess.DEVNULL)
    result = subprocess.run([str(binary)])
    raise SystemExit(result.returncode)
