# Firmware

This dir holds the **stock firmware backup** (`stock/k61-stock.bin`) and any
**bare-metal** experiments. The SonixQMK build tree itself is large (~1GB with
submodules) and lives **outside** this repo, referenced via `qmk_home`.

## SonixQMK build tree

We use the SonixQMK fork of QMK on the `sn32_master` branch (the Sonix MCU port).

```sh
# One-time: clone the fork + toolchain submodules into ~/qmk_firmware
qmk setup SonixQMK/qmk_firmware -b sn32_master -y
qmk doctor                       # sanity-check the toolchain

# Point the qmk CLI at it (if not already)
qmk config user.qmk_home=$HOME/qmk_firmware
```

The K61 keyboard definition (`keyboards/womier/k61/`) is developed inside that
tree. Keep a copy of our keymap + keyboard config mirrored here under
`firmware/k61/` so it's version-controlled in this repo, and symlink/copy it into
the qmk tree when building. (Set up once we confirm the MCU in Phase 0.)

## Build

```sh
qmk compile -kb womier/k61 -km default     # -> $qmk_home/.build/womier_k61_default.bin
```

## Enter the Sonix bootloader

- **Hardware:** short the **BOOT pin** to GND (see `docs/hardware.md`) *before*
  plugging in USB. Keys dead + RGB off = you're in the ROM ISP bootloader.
- **Software:** once running our firmware, "Reboot to Bootloader" in Sonix Flasher.

## Flash

Use **Sonix Flasher** (community tool from SonixQMK releases):
1. Select the device / SN32F24x radio button.
2. Offset `0x00`.
3. Load the `.bin` from `$qmk_home/.build/`.
4. Flash, then replug normally.

## Recover to factory

Enter the bootloader again and flash `stock/k61-stock.bin` (from Phase 2).
Because the ISP bootloader is in unerasable ROM, this path always works.
