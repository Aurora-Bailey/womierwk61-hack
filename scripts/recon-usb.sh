#!/usr/bin/env bash
# recon-usb.sh — capture the K61's USB identity on macOS.
#
# Plug the keyboard in, then run:  ./scripts/recon-usb.sh
# It walks the IOKit USB tree, prints VID/PID + descriptor strings for every
# USB device (highlighting keyboard-ish ones), and appends a timestamped record
# to docs/hardware.md. Run it again after entering the bootloader — the VID/PID
# changes when the Sonix ISP bootloader is active, and you'll want both.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HW_DOC="$ROOT/docs/hardware.md"

# Parse the IOKit USB device tree into one line per device:
#   VID:PID  "Vendor" / "Product"  rev=bcdDevice
# ioreg is reliable everywhere; system_profiler is slower and can be sandboxed.
parse_usb() {
  ioreg -p IOUSB -l -w 0 2>/dev/null | awk '
    /\+-o .*<class IOUSBHostDevice/ {
      if (name != "") emit()
      name=$0; sub(/.*\+-o /,"",name); sub(/@.*/,"",name)
      vid=""; pid=""; ven=""; prod=""; rev=""
      next
    }
    /"idVendor" =/      { vid=$NF }
    /"idProduct" =/     { pid=$NF }
    /"bcdDevice" =/     { rev=$NF }
    /"USB Vendor Name" =/  { ven=$0;  sub(/.*= /,"",ven) }
    /"USB Product Name" =/ { prod=$0; sub(/.*= /,"",prod) }
    END { if (name != "") emit() }
    function emit(   v,p) {
      v=sprintf("0x%04X", vid+0); p=sprintf("0x%04X", pid+0)
      printf "%s:%s  %s / %s  rev=%d  [%s]\n",
             v, p, (ven==""?"\"?\"":ven), (prod==""?"\"?\"":prod), rev+0, name
    }
  '
}

all="$(parse_usb)"

echo "== Keyboard-ish USB devices =="
kb="$(echo "$all" | grep -iE "keyboard|sonix|womier|gamakay|skyloong|sino|hfd|evision|bootloader" || true)"
if [[ -n "$kb" ]]; then echo "$kb"; else echo "  (no obvious match — see full list below)"; fi

echo
echo "== All USB devices =="
echo "$all"

{
  echo
  echo "### USB capture — $(date '+%Y-%m-%d %H:%M:%S')"
  echo '```'
  echo "${kb:-$all}"
  echo '```'
} >> "$HW_DOC"

echo
echo "Appended a capture block to docs/hardware.md."
echo "Tip: VID 0x05AC + 'SONiX' = your K61 in normal mode; re-run in bootloader mode (expect ~0x0C45)."
