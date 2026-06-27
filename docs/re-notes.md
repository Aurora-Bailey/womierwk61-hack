# Reverse-engineering notes (stock firmware)

Findings from disassembling the stock firmware dump (`firmware/stock/k61-stock.bin`)
in Ghidra. Goal: understand the USB HID handling, key-matrix scan, and RGB/LED
driver well enough to (a) write a host-side protocol decoder and (b) inform
bare-metal firmware.

## Setup
- Load `k61-stock.bin` as raw binary, **ARM Cortex-M0**, little-endian, base `0x0000`.
- The Cortex-M0 vector table is at `0x0`: word[0] = initial SP, word[1] = reset
  handler entry. Use those to anchor the disassembly.
- Pull register names/addresses from the Sonix SN32F2xx datasheet (USB, GPIO, PWM/LED).

## Memory map / vector table
_TBD_

## USB HID
- Endpoints: _TBD_
- Report descriptor(s): _TBD_
- Vendor/feature reports used by the config tool: _TBD_

## Key matrix
- Rows / cols GPIO: _TBD_
- Scan routine: _TBD_

## RGB / LED driver
- LED controller (internal PWM vs external driver IC): _TBD_
- Per-key mapping (LED index → physical key): _TBD_

## Open questions
_TBD_
