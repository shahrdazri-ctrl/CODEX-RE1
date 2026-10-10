#!/usr/bin/env python3
"""Install the pinned Linux x64 SDK locally, verifying Microsoft's SHA-512."""
import argparse
import hashlib
from pathlib import Path
import tarfile
import subprocess
from urllib.request import urlopen

VERSION = "8.0.425"
URL = f"https://builds.dotnet.microsoft.com/dotnet/Sdk/{VERSION}/dotnet-sdk-{VERSION}-linux-x64.tar.gz"
SHA512 = "934b8060a7190e5909ad1fd0785db542f487b3bbf6cdd14826b02095fdd0d0394298b1634085eff302928fccc33f7c1a7253e9b87df555fc36fce819bcd2e798"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    executable = args.destination / "dotnet"
    if executable.is_file() and (args.destination / "sdk" / VERSION).is_dir():
        result = subprocess.run([str(executable.resolve()), "--version"], capture_output=True, text=True)
        if result.returncode == 0 and result.stdout.strip() == VERSION:
            print(f".NET SDK {VERSION} already installed at {args.destination}")
            raise SystemExit(0)
    args.destination.mkdir(parents=True, exist_ok=True)
    archive = args.destination / "sdk-download.tar.gz"
    digest = hashlib.sha512()
    with urlopen(URL, timeout=120) as response, archive.open("wb") as output:
        while chunk := response.read(8 * 1024 * 1024):
            digest.update(chunk)
            output.write(chunk)
    if digest.hexdigest() != SHA512:
        raise SystemExit("Downloaded SDK failed SHA-512 verification")
    with tarfile.open(archive) as package:
        package.extractall(args.destination, filter="data")
    archive.unlink()
    print(f"Verified and installed .NET SDK {VERSION} to {args.destination}")
