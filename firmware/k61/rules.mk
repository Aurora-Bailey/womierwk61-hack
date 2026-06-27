# Womier K61 — Sonix SN32F248F (HFD1101KBA, 64-pin). See PORTING.md / docs/matrix-probing.md.
# Phase 3a: KEYS-FIRST build to validate the matrix. RGB comes in Phase 3b once LEDs are mapped.

MCU = SN32F248F

# Build options
BOOTMAGIC_ENABLE = yes      # virtual DIP / bootmagic
MOUSEKEY_ENABLE  = no
EXTRAKEY_ENABLE  = yes      # media / system keys
CONSOLE_ENABLE   = yes      # <-- matrix debug for the flash-and-test loop
COMMAND_ENABLE   = no
NKRO_ENABLE      = no
BACKLIGHT_ENABLE = no
RGBLIGHT_ENABLE  = no
RGB_MATRIX_ENABLE = no      # TODO(Phase 3b): enable after mapping the LED matrix
AUDIO_ENABLE     = no
WAIT_FOR_USB     = no
# CUSTOM_MATRIX not set -> use QMK's default matrix scanner (keys-only, no LED coupling)
