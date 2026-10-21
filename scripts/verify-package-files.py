from pathlib import Path
import json,subprocess
root=Path(__file__).resolve().parents[1]
meta=json.loads(subprocess.check_output(['npm','pack','--dry-run','--json'],cwd=root,stderr=subprocess.DEVNULL))[0]
files={f['path'] for f in meta['files']}
checks={
 'package excludes developer Xcode workspaces':not any(any(part in f for part in ['.xcodeproj/','.xcworkspace/','xcuserdata/']) for f in files),
 'package includes native source and calibration asset': {'ios/ReactNativeBrotherPrinters.swift','ios/ReactNativeBrotherPrinters.m','ios/ReactNativeBrotherPrinters.h','ios/Resources/testPrint.png','react-native-bluetooth-brother-printers.podspec','index.js'} <= files,
}
for name,ok in checks.items():print(('PASS' if ok else 'FAIL')+' '+name)
raise SystemExit(0 if all(checks.values()) else 1)
