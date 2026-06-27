# Flashing & verifying the K61 (Phase 3a, keys-only)

Firmware: `build/womier_k61_default.bin` (rebuild: `source scripts/env.sh && cd ~/qmk_firmware
&& qmk compile -kb womier/k61 -km default`). Flasher: `~/Downloads/sonix-flasher-mac.dmg`.

> ⚠️ **Point of no return for stock firmware:** we deferred the SWD dump, so this first flash
> **replaces the factory firmware with no backup**. You can always reflash SonixQMK (ROM
> bootloader is unerasable), but the original Womier firmware will be gone. Proceed when ready.

## 1. Enter the Sonix bootloader
The chip samples the **BOOT** strap at power-on. BOOT = **physical pin 3 = P2.2** (also our
column `C2`, which is harmless — it's only sampled at reset).
- With USB unplugged, **short BOOT (pin 3 / the C2 column net / BOOT test-point) to GND**, then
  plug in USB while holding the short. Keys dead = you're in the bootloader.
- Confirm: `./scripts/recon-usb.sh` — expect a **Sonix `0x0C45`** device to appear.

## 2. Flash
1. Open the DMG, run **Sonix Flasher**. (First launch: right-click → Open to bypass Gatekeeper.)
2. Click to detect/connect the device.
3. Set MCU family = **SN32F240 / "SN32F24x"**, flash **offset `0x00`**.
4. Load `build/womier_k61_default.bin` and flash.
5. Unplug, remove the BOOT short, replug normally.

## 3. Verify the matrix (the real goal of 3a)
Keys may be mismapped — that's expected; we use the console to fix it.
```sh
qmk console          # leave running; matrix debug is auto-enabled in the keymap
```
Press each physical key and watch the printed **`(row,col)`**:
- **No output at all / board won't enumerate** → suspect `D0` (P3.0/RESET) in the rows. Tell me;
  we'll swap it out and rebuild.
- **Right row, wrong horizontal spot** → reorder `MATRIX_COL_PINS` in `firmware/k61/config.h`.
- **Rows vertically swapped** → reorder `MATRIX_ROW_PINS`.
- **A key reports nothing but neighbours work** → that cell's row or col pin is off.

Send me the (key → row,col) observations and I'll correct the pin order and rebuild. Once every
physical key maps correctly, Phase 3a is done and we move to RGB (Phase 3b) + your real keymap.

## Recovery
Wrong firmware never bricks it: re-enter the bootloader (step 1) and reflash. To get back to a
working state you just flash a known-good `.bin`.
