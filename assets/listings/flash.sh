#!/usr/bin/env bash
set -euo pipefail

DEVICE="/dev/ttyUSB0"
BAUD=115200

echo "Flashing firmware to ${DEVICE}..."
esptool.py --port "$DEVICE" --baud "$BAUD" \
    write_flash 0x00000 firmware.bin

echo "Monitoring serial output..."
screen "$DEVICE" "$BAUD"
