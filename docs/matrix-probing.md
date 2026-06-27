# Mapping the K61 matrix with a multimeter

Goal: produce the real `MATRIX_ROWS/COLS`, `MATRIX_ROW_PINS`, `MATRIX_COL_PINS` (and
later the LED pins) for `firmware/k61/`. No soldering needed — just a multimeter in
**continuity** mode (the beeping one) and patience. Diodes are `COL2ROW` (col = anode,
row = cathode).

## QMK pin naming (SonixQMK / SN32F248B)
Letter = GPIO port, number = bit: **`A`=GPIOA, `B`=GPIOB, `C`=GPIOC, `D`=GPIOD**
(from `~/qmk_firmware/platforms/chibios/pin_defs.h`). So physical chip pin → (port,bit)
→ e.g. `C0`, `A5`, `D7`. We translate physical pins to these names together once you've
probed them (using the SN32F248B LQFP-48 datasheet pinout + the pin-1 dot for orientation).

## Step 1 — Logical matrix (no chip pinout needed)
Each switch has 2 pins. With diodes `COL2ROW`:
- **Row line** = the **cathode** side (diode stripe end). Switches on the same row beep
  continuous to each other on that side (through nothing / same net).
- **Column line** = the **anode** side, shared down a column.

Practical method (from the karliss porting writeup):
1. Pick a switch. Put one probe on a switch pin, the other on the **same-position pin of
   a neighbour**. Beep = same line. Sweep left/right to find the **column group**, up/down
   to find the **row group**.
2. For columns through the diode: one probe on the **far side of the diode** (away from
   switch), the other on the switch pin — confirms which side is the column.
3. Fill the worksheet below: assign every key a (row, col). You'll discover how many
   distinct row lines and column lines exist (the **electrical** matrix shape — may not be
   exactly 5×14).

## Step 2 — Lines → chip pins
For each distinct **row line** and **column line** (only ~19 nets, not 61 keys):
- Put one probe on that net (any switch pad on it), drag the other along the MCU (`U1`)
  pins until it beeps. Note the **physical pin number** (count from the **pin-1 dot**,
  bottom-left, counter-clockwise).
- Record `row/col → physical pin N`. We map N → QMK name (`Cx`/`Ax`/…) from the datasheet.

Tip: the row/col nets often run to a via or resistor-array (`RA9–RA12`) near the chip —
easier to land the probe there than on the 0.5 mm pins.

## Worksheet

Distinct ROW lines found: ___   Distinct COL lines found: ___

```
ROW nets → chip pin → QMK name
  R0: pin __  → ____
  R1: pin __  → ____
  R2: pin __  → ____
  R3: pin __  → ____
  R4: pin __  → ____
  (add more if >5)

COL nets → chip pin → QMK name
  C0: pin __ → ____    C7:  pin __ → ____
  C1: pin __ → ____    C8:  pin __ → ____
  C2: pin __ → ____    C9:  pin __ → ____
  C3: pin __ → ____    C10: pin __ → ____
  C4: pin __ → ____    C11: pin __ → ____
  C5: pin __ → ____    C12: pin __ → ____
  C6: pin __ → ____    C13: pin __ → ____
```

Per-key (row,col) grid — fill as you probe (logical 60% ANSI shown):
```
        c0  c1  c2  c3  c4  c5  c6  c7  c8  c9 c10 c11 c12 c13
 row0   Esc 1   2   3   4   5   6   7   8   9   0   -   =  Bksp
 row1   Tab Q   W   E   R   T   Y   U   I   O   P   [   ]   \
 row2   Cap A   S   D   F   G   H   J   K   L   ;   '   Ent .
 row3   Sft Z   X   C   V   B   N   M   ,   .   /  Sft  .   .
 row4   Ctl Win Alt ........Space........ Alt Fn Ctl  .   .
```
(`.` = no switch at that matrix cell. Actual row/col counts come from *your* probing.)

## Step 3 — Iterative verification (the safety net)
Even a wrong guess is harmless (recoverable via the ROM bootloader). Once you fill the
pins into `firmware/k61/config.h`, we build, flash via the USB bootloader, and confirm
with **`qmk console`** + matrix debug: press each key, watch the (row,col) it reports,
and permute pins until physical keys match the keymap. So the probing only needs to get
us *close* — the flash-and-test loop nails the rest.
