#!/usr/bin/env bash
# swd-connect.sh — first contact: confirm the Flipper DAP Link sees the SN32 over SWD.
# Run with the Flipper in DAP Link mode, wired to the K61, board powered via its USB-C.
#
#   ./scripts/swd-connect.sh
#
# Prints the DAP/IDCODE, tries to halt, and peeks low flash + RAM so we can tell
# whether 0x0 currently shows user flash (good) or boot ROM (need the remap/gadget path).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

openocd -f "$ROOT/openocd/k61-swd.cfg" \
  -c "init" \
  -c "echo {== dap info ==}" \
  -c "dap info" \
  -c "echo {== try halt ==}" \
  -c "catch { halt }" \
  -c "echo {== vector table @ 0x0 (word0=SP ~0x20000xxx, word1=reset handler) ==}" \
  -c "mdw 0x00000000 8" \
  -c "echo {== RAM @ 0x20000000 ==}" \
  -c "mdw 0x20000000 4" \
  -c "shutdown"
