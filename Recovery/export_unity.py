#!/usr/bin/env python3
"""Export an installed game using a local AssetRipper 2.0 server."""
import argparse
from html.parser import HTMLParser
import json
from pathlib import Path
from urllib.parse import urlencode
from urllib.request import Request, urlopen


class SettingsForm(HTMLParser):
    def __init__(self):
        super().__init__()
        self.values = {}
        self.inside = False
        self.select = None

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag == "form":
            self.inside = a.get("action") == "/Settings/Update"
        if not self.inside or "disabled" in a:
            return
        if tag == "input" and "name" in a:
            if a.get("type") == "checkbox":
                if "checked" in a:
                    self.values[a["name"]] = a.get("value", "")
            elif a.get("type") != "submit":
                self.values[a["name"]] = a.get("value", "")
        elif tag == "select":
            self.select = a["name"]
        elif tag == "option" and self.select:
            if self.select not in self.values or "selected" in a:
                self.values[self.select] = a["value"]

    def handle_endtag(self, tag):
        if tag == "form":
            self.inside = False
        elif tag == "select":
            self.select = None


def request(server, route, data=None):
    req = Request(server.rstrip("/") + route,
                  data=None if data is None else urlencode(data).encode())
    with urlopen(req, timeout=7200) as response:
        return response.read()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("installation", type=Path)
    parser.add_argument("destination", type=Path)
    parser.add_argument("--server", default="http://127.0.0.1:58080")
    args = parser.parse_args()
    if not args.installation.is_dir():
        parser.error("installation must be an unpacked game directory")
    if args.destination.exists() and any(args.destination.iterdir()):
        parser.error("destination must be empty")
    form = SettingsForm()
    form.feed(request(args.server, "/Settings/Edit").decode())
    # Default decodes the bank into its embedded WAV/OGG compression.
    # AssetRipper's "Native" mode produces raw FSB, which Unity cannot import.
    # Level2 recovers Mono method bodies; Hybrid keeps vendor dependencies as DLLs.
    form.values.update(AudioExportFormat="Default", ScriptContentLevel="Level2",
                       ScriptExportMode="Hybrid", ExportUnreadableAssets="")
    form.values.pop("IgnoreStreamingAssets", None)
    args.destination.mkdir(parents=True, exist_ok=True)
    settings_report = args.destination.parent / (args.destination.name + "-settings.json")
    settings_report.write_text(json.dumps(form.values, indent=2) + "\n")
    request(args.server, "/Settings/Update", form.values)
    print("Loading game and StreamingAssets bundles", flush=True)
    request(args.server, "/LoadFolder", {"path": str(args.installation.resolve())})
    print("Exporting Unity project", flush=True)
    request(args.server, "/Export/UnityProject", {"path": str(args.destination.resolve())})
    print("Export finished; inspect logs, scripts, shaders, and references before use", flush=True)
