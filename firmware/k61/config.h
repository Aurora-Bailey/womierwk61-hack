/* Womier K61 — SonixQMK port (SN32F248F / HFD1101KBA, 64-pin).
 * Matrix mapped by multimeter; pin-name translation verified against pin_defs.h.
 * Phase 3a = keys-only validation build.
 */
#pragma once

#include "config_common.h"

/* USB descriptor (QMK-side; arbitrary). Stock board enumerates as 0x05AC/0x024F "SONiX". */
#define VENDOR_ID    0xFEED
#define PRODUCT_ID   0x4B61   /* "K61" */
#define DEVICE_VER   0x0001
#define MANUFACTURER Womier
#define PRODUCT      K61

/* ---- Key matrix (from docs/matrix-probing.md) ---------------------------------
 * 5 rows x 14 cols, COL2ROW. Physical chip pin -> Pn.m -> QMK name:
 *   rows: 62=P3.3=D3, 61=P3.2=D2, 60=P3.1=D1, 59=P3.0=D0, 58=P0.8=A8
 *   cols: 13=C10,12=C9,11=C8,10=C7,9=C6,8=C5,7=C15,6=C14,5=C4,4=C3,3=C2,2=C1,1=C0,64=D15
 * NOTE/RISK: rows sit on special-function pins (P3.0=RESET, P3.1-3=clock, P0.8=SWCLK).
 *   If the board fails to enumerate, D0 (P3.0/RESET) is the prime suspect — verify via
 *   `qmk console` matrix debug and re-order/replace as needed.
 * NOTE: physical pin 3 (C2) is also P2.2/BOOT — fine as a column (driven, not strapped).
 */
#define MATRIX_ROWS 5
#define MATRIX_COLS 14
#define DIODE_DIRECTION COL2ROW

#define MATRIX_ROW_PINS { D3, D2, D1, D0, A8 }
#define MATRIX_COL_PINS { C10, C9, C8, C7, C6, C5, C15, C14, C4, C3, C2, C1, C0, D15 }

#define DEBOUNCE 5
