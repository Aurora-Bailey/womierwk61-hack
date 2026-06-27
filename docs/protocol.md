# K61 host ↔ keyboard protocol

How to talk to the keyboard from macOS. Two possible transports:

1. **Stock vendor protocol** — reverse-engineered from the Windows config tool
   (capture with Wireshark + USBPcap in a Windows VM with USB passthrough).
2. **Custom raw-HID endpoint** — if/once we add `RAW_ENABLE` to our SonixQMK
   build (plan Phase 4a), we define this protocol ourselves and it's much cleaner.

Document whichever we end up using here.

## Transport
- VID/PID: **`0x05AC` / `0x024F`** (see [hardware.md](./hardware.md))
- HID interfaces exposed by the stock firmware (from `hidutil list`, 2026-06-09):

  | Usage Page | Usage | Role |
  |-----------|-------|------|
  | `0x01` | `0x06` | Boot keyboard (normal typing) |
  | `0x0C` | `0x01` | Consumer control (media keys) |
  | **`0xFF13`** | **`0x01`** | **Vendor-defined — the control channel** ⭐ |

  → The host app (Phase 5) should open the **`0xFF13` / `0x01`** vendor collection and
  send/receive reports there. That's where RGB + remap commands almost certainly live.
- Report ID(s) / length: _TBD_ (capture from the Windows config tool, or fuzz carefully).

## Commands (decoded)

| Command | Direction | Report bytes | Meaning |
|---------|-----------|--------------|---------|
| _TBD_ | host→kbd | _TBD_ | set global RGB color/effect |
| _TBD_ | host→kbd | _TBD_ | set per-key color |
| _TBD_ | host→kbd | _TBD_ | remap key |
| _TBD_ | kbd→host | _TBD_ | ack / status |

## Capture log
- See `captures/` for raw `.pcapng` files and decoded notes.

## Reference implementations to cross-check
- OpenRGB (Sonix/SN32 boards) — known-good RGB command sequences.
- SonixQMK raw-HID examples — for the custom-endpoint path.
