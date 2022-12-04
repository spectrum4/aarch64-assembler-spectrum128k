#!/bin/bash

CODE_ADDRESS=0x8000

set -e

z80-unknown-elf-as prometheus.s -o prometheus.o
z80-unknown-elf-ld -N -Ttext="${CODE_ADDRESS}" -o prometheus.elf prometheus.o
z80-unknown-elf-objcopy --set-start="${CODE_ADDRESS}" prometheus.elf -O binary prometheus.img

if ! diff -b prometheus.img orig.img; then
  echo "Whoops!"
  exit 64
fi

go build -o prometheus-assembler-spectrum128k main.go
rm -f prometheus.tzx
./prometheus-assembler-spectrum128k prometheus.img prometheus.tzx $((CODE_ADDRESS)) prometheus assembler 1000
rm prometheus-assembler-spectrum128k prometheus.elf prometheus.img prometheus.o
