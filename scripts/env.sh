# env.sh — put the keg-only QMK toolchains on PATH for this shell.
#
#   source scripts/env.sh
#
# Homebrew installs arm-none-eabi-gcc@8 / binutils as *keg-only* (versioned),
# so they aren't symlinked into /opt/homebrew/bin. QMK's `make` calls
# `arm-none-eabi-gcc` directly, so it must be on PATH. This adds it.

for keg in arm-none-eabi-gcc@8 arm-none-eabi-binutils avr-gcc@8 avr-binutils; do
  d="/opt/homebrew/opt/$keg/bin"
  [ -d "$d" ] && case ":$PATH:" in *":$d:"*) ;; *) PATH="$d:$PATH" ;; esac
done
export PATH

# Point the qmk CLI at our SonixQMK clone (sn32_master).
export QMK_HOME="${QMK_HOME:-$HOME/qmk_firmware}"

command -v arm-none-eabi-gcc >/dev/null \
  && echo "toolchain ready: $(arm-none-eabi-gcc --version | head -1)" \
  || echo "WARNING: arm-none-eabi-gcc still not found"
