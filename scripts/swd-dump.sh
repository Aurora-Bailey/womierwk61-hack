#!/usr/bin/env bash
# swd-dump.sh — attempt to dump the 64KB stock firmware over SWD to firmware/stock/k61-stock.bin
#
#   ./scripts/swd-dump.sh
#
# Tier 1 (this script): halt the running firmware and read flash straight from 0x0.
# Works IF the chip currently maps user flash at 0x0 (i.e. firmware booted, not in
# bootloader) AND the stock firmware hasn't repurposed the SWD pins. swd-connect.sh
# tells you which case you're in. If 0x0 reads back as boot ROM, we escalate to the
# remap/gadget method (handled live — see docs/dumping.md).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/firmware/stock/k61-stock.bin"

openocd -f "$ROOT/openocd/k61-swd.cfg" \
  -c "init" \
  -c "halt" \
  -c "echo {== dumping 0x00000000 .. 0x10000 (64KB) ==}" \
  -c "dump_image $OUT 0x00000000 0x10000" \
  -c "shutdown"

echo "Wrote $OUT ($(wc -c < "$OUT") bytes). Sanity-check the vector table:"
echo "  python3 - <<'PY'
import struct,sys
d=open('$OUT','rb').read()
sp,rh=struct.unpack('<II', d[:8])
print(f'  SP=0x{sp:08x} (expect ~0x20000xxx)  ResetHandler=0x{rh:08x} (expect odd, in 0x0000xxxx)')
print('  looks like FLASH firmware' if 0x20000000<=sp<=0x20002000 and rh&1 else '  >> looks like boot ROM / not firmware - use remap/gadget path')
PY"
