# Phase 2 — Dumping the stock firmware with a Flipper Zero (SWD)

Flipper Zero + **DAP Link** app = a **CMSIS-DAP** SWD probe; OpenOCD drives it. No ST-Link needed.
Tooling is ready: `openocd/k61-swd.cfg`, `scripts/swd-connect.sh`, `scripts/swd-dump.sh`.

## Reality check (be set up for a fiddly read)
Connecting over SWD is easy. **Reading flash out is the hard part** on Sonix:
1. In **bootloader** mode the chip maps the **boot ROM** at `0x0`, so a naive read returns ROM, not
   firmware. 2. In **run** mode `0x0` *is* user flash — but the stock firmware may repurpose the
   SWD pins (P0.8/P0.9) as matrix lines, which can drop the SWD link after boot.
We handle this in tiers (below) and iterate live. The old `sonix_dumper` gadget scripts are gone,
so if the easy path fails we reconstruct the read from the boot ROM together.

## Solder points (4)
You located these already. Use the dedicated round **vias** by `U1`, confirming each with the
multimeter (continuity to the chip pin):

| Signal | Chip pin | Net you already found | Flipper pin (default — confirm on DAP Link screen) |
|--------|----------|------------------------|-----------------------------------------------------|
| **SWCLK** | P0.8 (phys 58) | your **R4 row** net | **pin 10** (SWC) |
| **SWDIO** | P0.9 (phys 57) | adjacent to SWCLK | **pin 12** (SIO) |
| **GND** | — | any ground / cap− / USB shield | **pin 8 / 11 / 18** |
| **BOOT** | P2.2 (phys 3) | your **C2 column** net | (to GND only for Tier 2) |

Power the **board from its own USB-C** (to the Mac), so no 3V3 wire is needed. Common ground
between Flipper and board is essential (the GND wire).

## Connect the Flipper
1. Install **DAP Link** (Flipper Lab → Apps → GPIO → DAP Link); launch it — it shows the SWC/SWD pins.
2. Wire SWC→SWCLK via, SIO→SWDIO via, GND→GND. Leave BOOT unconnected for now.
3. Board plugged into the Mac via USB-C (powered, stock firmware running).

## Tier 1 — confirm link + try the easy read
```sh
./scripts/swd-connect.sh     # should print an IDCODE/DAP info; peeks 0x0 and RAM
```
- See a valid DAP + RAM at `0x20000000` → SWD link works. 🎉
- `mdw 0x0` shows word0 ≈ `0x20000xxx` and word1 odd → **0x0 is flash**, so:
```sh
./scripts/swd-dump.sh        # dumps 64KB -> firmware/stock/k61-stock.bin, sanity-checks it
```

## Tier 2 — if `halt` fails or `0x0` reads as boot ROM
- **Halt fails / link drops after boot** (firmware took over P0.8/P0.9): power-cycle the board with
  OpenOCD already trying to attach (connect-under-reset style), or solder the **BOOT** wire and tie
  it to **GND** to sit in the bootloader where SWD stays alive.
- **In bootloader, `0x0` = ROM**: we read the boot ROM out first (`dump_image rom.bin 0x0 …`),
  find the remap mechanism / LDR-STR gadgets, and script word-by-word flash reads. This is the
  reverse-engineering bit — we do it together from the `swd-connect.sh` output.

## After a successful dump
`firmware/stock/k61-stock.bin` = your factory backup (restore it via the same SWD path or Sonix
Flasher). Then load it in Ghidra (ARM Cortex-M0, base 0x0) for the matrix/LED/USB-protocol RE that
feeds Phase 5. Only **after** you've got this backup is it "safe" to flash custom firmware.
