# womierwk61-hack

Taking full, low-level control of a **Womier K61** keyboard on macOS — where the
vendor ships no software. Two fronts: **custom open-source firmware** flashed onto
the keyboard, and **my own macOS tooling** to drive it over USB.

## Why

No official macOS app exists, and stock firmware is a black box. The K61 is part
of the Skyloong **SK61/GK61** family and most revisions use a **Sonix SN32F2xx**
(ARM Cortex-M0) MCU — which the community [**SonixQMK**](https://sonixqmk.github.io/SonixDocs/install/)
project can flash with [QMK](https://docs.qmk.fm). Goal: remapping + layers,
full RGB control, and understanding how the thing actually works.

> The Sonix **ISP bootloader lives in unerasable mask ROM**, so a bad flash is
> always recoverable (short the BOOT pin to GND, reflash). Low brick risk — but
> dump the stock firmware first (Phase 2) so factory state is restorable too.

## Layout

```
docs/
  hardware.md   — MCU part, USB VID/PID, BOOT pin, SWD pads (fill in during recon)
  re-notes.md   — Ghidra notes from the stock-firmware disassembly
  protocol.md   — host ↔ keyboard USB protocol (stock or custom raw-HID)
  img/          — PCB / chip / pad photos
firmware/
  stock/        — backup dump of factory firmware (k61-stock.bin)
host/           — macOS control app (HID; RGB + remap)
captures/       — USB protocol captures (.pcapng)
scripts/
  recon-usb.sh  — capture the keyboard's USB identity on macOS
```

## Roadmap

- **Phase 0 — Recon (gating):** confirm the MCU, capture USB VID/PID, locate BOOT
  pin + SWD pads → `docs/hardware.md`. Gate: Sonix → SonixQMK path; else reroute.
- **Phase 1 — Toolchain:** qmk CLI, `arm-none-eabi-gcc`, SonixQMK `sn32_master`,
  Sonix Flasher, OpenOCD.
- **Phase 2 — Backup:** ST-Link SWD dump of stock firmware → `firmware/stock/`.
- **Phase 3 — Baseline firmware:** define `keyboards/womier/k61`, compile, flash,
  prove the recover loop, build the real layout + RGB.
- **Phase 4 — Deep custom:** extend SonixQMK in C (custom RGB, keycodes, raw HID),
  and/or bare-metal from the Sonix datasheet.
- **Phase 5 — macOS tooling:** decode the USB protocol, build a control app.

Full plan: `~/.claude/plans/reflective-enchanting-hanrahan.md`.

## Quick start

```sh
# with the keyboard plugged in:
./scripts/recon-usb.sh        # captures USB identity into docs/hardware.md
```

Then open the case, read the main chip, and fill in `docs/hardware.md`.

## ⚠️ Notes

- Opening the case voids warranty. Mind ESD when probing SWD/BOOT pads.
- This is for a keyboard I own. Everything here is defensive / personal tinkering.
