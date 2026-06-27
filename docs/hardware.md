# K61 Hardware Notes

Living record of what's actually inside *this* keyboard. Fill in as you go —
everything downstream (which firmware path, which flasher settings, host-app
VID/PID matching) depends on getting this right.

## MCU

| Field | Value | Notes |
|-------|-------|-------|
| Marking | **`HFD` / `HFD1T01KBA` / `211SNWE01`** | `U1`, read off photos IMG_6137/6138. |
| Part (effective) | **Sonix `SN32F248B`** (HFD-rebadged) | HFD is a listed SN32 rebadger; USB mfr string = "SONiX". |
| Core | ARM **Cortex-M0** | |
| Package | **LQFP-48** | ~12 pins/side; pin-1 dot at bottom-left by `U1` silkscreen. |
| Flash size | ~64 KB | per SN32F248B. |
| SonixQMK supported? | **Yes** ✅ | Same family as the `womier/k87` template (`MCU = SN32F248BF`). |

**Decision gate: PASSED** → full SonixQMK plan applies. Flasher setting = **SN32F24x**,
offset `0x00`. Use the `womier/k87` definition as the K61 template (see `firmware/k61/`).

### Board / PCB markings (from photos)
- Single hot-swap PCB with **per-key SMD RGB LEDs** (full RGB matrix confirmed).
- LED/switch PCB: **`X80 HFD UP LED US  EK226Z307300  H=1.2mm  2023.11.06`**.
- Small daughterboard: **`X80 KAI GUAN  SN:EK2162307360  2023.07.27`** (开关 = "switch"; has slide switch `K2`) — likely the Win/Mac or layer toggle / USB board.
- Connectors: 6-pin FFC ribbon (`P2`) between boards; controller area has `U2`, `X1`, `L1/L2`, resistor arrays `RA9–RA12`.
- This is an **"X80"-series** PCB — useful keyword when searching for an existing SonixQMK config to crib the matrix/LED maps.

## USB identity

| Field | Normal mode | Bootloader mode |
|-------|-------------|-----------------|
| Vendor ID (VID) | **`0x05AC`** (1452 — spoofed Apple!) | _TBD_ |
| Product ID (PID) | **`0x024F`** (591) | _TBD_ |
| Product string | `Gaming Keyboard` | _TBD_ |
| Manufacturer | **`SONiX`** ✅ (confirms Sonix MCU) | _TBD_ |
| Device rev (bcdDevice) | `0x0103` (1.03) | _TBD_ |

> Captured 2026-06-09 via `ioreg` (normal mode). `system_profiler` is sandbox-blocked
> in the agent shell but works in a normal terminal. The keyboard reports the **Apple
> VID `0x05AC`** for plug-and-play Mac compat, but the manufacturer string **"SONiX"**
> confirms it's a Sonix SN32 chip. Host app (Phase 5) should match VID `0x05AC` / PID
> `0x024F`. Bootloader-mode IDs still TBD (likely `0x0C45` Sonix) — capture after first
> entering the bootloader.

> Run `./scripts/recon-usb.sh` with the keyboard plugged in (normal mode), then
> again after entering the bootloader. Captures get appended below.

> **Hint:** the sibling `womier/k87` definition in SonixQMK records a stock USB ID
> of `VID_320F & PID_502A`. **`0x320F` = SinoWealth/Womier**, so the K61's stock
> firmware very likely enumerates under VID `0x320F` too (PID will differ). The
> Sonix ISP **bootloader** typically shows up as `0x0C45` (Sonix) — confirm both.

## Bootloader entry

- **BOOT pin = pin 3** (confirmed: this is the 48-pin SN32F248B). On LQFP-48, pin 1 is
  the corner with the dot (bottom-left, by the `U1` silkscreen); pin 3 is the 3rd pin
  along that edge. Short pin 3 to **GND** *before* plugging in USB. Success = keys dead
  + RGB off. Re-run `./scripts/recon-usb.sh` then to capture the bootloader VID/PID
  (expect Sonix `0x0C45`).
- Alternative: "Reboot to Bootloader" in Sonix Flasher (once running custom fw).

## SWD / debug pads (for ST-Link dump in Phase 2)

| Signal | Pad location | Notes |
|--------|-------------|-------|
| SWDIO | _TBD_ | On SN32F248B, find SWDIO/SWCLK from the LQFP-48 datasheet pinout, then |
| SWCLK | _TBD_ | trace with a multimeter to a via/test-point, or tack a wire to the pin. |
| GND | _TBD_ | Any ground (e.g. USB shield / cap negative). |
| 3V3 | _TBD_ | Power the board from USB, not the ST-Link, unless you know it's safe. |

> **Note:** SWD is only needed for **Phase 2 (dumping the stock firmware as a backup
> + matrix/LED recon)**. Flashing *custom* SonixQMK firmware uses the **USB bootloader**
> (BOOT pin) and needs no probe. We'll use the user's **Flipper Zero (DAP Link app =
> CMSIS-DAP)** as the SWD probe — see **`dumping.md`**. The SWD pads are small round vias
> next to `U1` (candidates visible near `U2`/the chip in IMG_6134/6136); meter them for
> SWDIO/SWCLK/BOOT/GND.

## Photos

Drop close-ups of the PCB / chip / pads in `docs/img/` and link them here.

---

## Captures
<!-- recon-usb.sh appends timestamped USB capture blocks below this line -->

### USB capture — 2026-06-09 (ioreg, normal mode)
```
Gaming Keyboard@01110000  (IOUSBHostDevice)
  idVendor   = 1452   (0x05AC)   USB Vendor Name  = "SONiX"
  idProduct  = 591    (0x024F)   USB Product Name = "Gaming Keyboard"
  bcdDevice  = 259    (0x0103)
```

### USB capture — 2026-06-09 16:44:54
```
0x05AC:0x024F  "SONiX" / "Gaming Keyboard"  rev=259  [Gaming Keyboard]
```
