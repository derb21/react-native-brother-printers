from pathlib import Path
import json, shutil, subprocess, tempfile

root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='brother-git-pack-') as temporary:
    fixture = Path(temporary) / 'package'
    shutil.copytree(root, fixture, ignore=shutil.ignore_patterns('.git', 'node_modules', '*.tgz', '.yarn'))
    manifest = fixture / 'package.json'
    package = json.loads(manifest.read_text())
    package['packageManager'] = 'yarn@3.4.1'
    manifest.write_text(json.dumps(package))
    (fixture / 'yarn.lock').touch()
    output = subprocess.check_output(['corepack', 'yarn', 'pack', '--dry-run', '--json'], cwd=fixture, text=True)
    entries = [json.loads(line) for line in output.splitlines() if line.startswith('{')]
    files = {entry['location'].removeprefix('./') for entry in entries if 'location' in entry}
    required = {'index.js', 'ios/ReactNativeBrotherPrinters.swift', 'ios/ReactNativeBrotherPrinters.m',
                'ios/ReactNativeBrotherPrinters.h', 'ios/Resources/testPrint.png',
                'react-native-bluetooth-brother-printers.podspec'}
    missing = sorted(required - files)
    print(('FAIL' if missing else 'PASS') + ' Yarn 3.4.1 Git package contains native sources and calibration image')
    if missing:
        print('Missing: ' + ', '.join(missing))
    raise SystemExit(1 if missing else 0)
