#!/usr/bin/env python3
"""list_hid.py — enumerate HID devices on macOS and highlight the K61.

Complements scripts/recon-usb.sh: where that reads USB descriptors via
system_profiler, this lists the *HID interfaces* (usage page / usage / report
info) that a host app actually opens. Useful for confirming VID/PID and finding
the right vendor interface to talk to in Phase 5.

Usage:
    pip install hid          # needs the hidapi C lib: brew install hidapi
    python3 host/list_hid.py [--vid 0xXXXX] [--pid 0xXXXX]

With no filter it prints everything; pass --vid/--pid (from docs/hardware.md)
to narrow to the keyboard once you know its IDs.
"""
from __future__ import annotations

import argparse
import sys


def main() -> int:
    ap = argparse.ArgumentParser(description="List HID devices (highlight the K61).")
    ap.add_argument("--vid", type=lambda s: int(s, 0), default=None, help="filter by vendor id, e.g. 0x0c45")
    ap.add_argument("--pid", type=lambda s: int(s, 0), default=None, help="filter by product id")
    args = ap.parse_args()

    try:
        import hid  # type: ignore
    except ImportError:
        print(
            "The 'hid' package isn't installed.\n"
            "  brew install hidapi      # the native library\n"
            "  pip install hid          # the Python binding\n",
            file=sys.stderr,
        )
        return 1

    devices = hid.enumerate(args.vid or 0, args.pid or 0)
    if not devices:
        print("No matching HID devices. Is the keyboard plugged in? Try without --vid/--pid.")
        return 0

    for d in devices:
        print(f"{d['vendor_id']:#06x}:{d['product_id']:#06x}  "
              f"{d.get('manufacturer_string') or '?'} / {d.get('product_string') or '?'}")
        print(f"    path          {d['path'].decode(errors='replace') if isinstance(d['path'], bytes) else d['path']}")
        print(f"    usage_page    {d.get('usage_page'):#06x}    usage {d.get('usage'):#06x}")
        print(f"    interface     {d.get('interface_number')}")
        if d.get("serial_number"):
            print(f"    serial        {d['serial_number']}")
        print()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
