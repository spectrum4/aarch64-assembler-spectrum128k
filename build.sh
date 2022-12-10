#!/bin/bash

CODE_ADDRESS=0x8000

set -e

cat prometheus.s | sed 's/\.byte/peter/' | sed 's/.ascii/jasper/' | ~/git/spectrum4/utils/asm-format/asm-format | sed 's/peter/\.byte/' | sed 's/jasper/.ascii/' > p.s
mv p.s prometheus.s

z80-unknown-elf-as prometheus.s -o prometheus.o
z80-unknown-elf-ld -N -Ttext="${CODE_ADDRESS}" -o prometheus.elf prometheus.o
z80-unknown-elf-objcopy --set-start="${CODE_ADDRESS}" prometheus.elf -O binary prometheus.img

if ! diff -b prometheus.img orig.img; then
  hexdump -C orig.img > A
  hexdump -C prometheus.img > B
  z80-unknown-elf-objdump -z -b binary --adjust-vma=0x4000 -mz80 -D orig.img > C
  z80-unknown-elf-objdump -z -b binary --adjust-vma=0x4000 -mz80 -D prometheus.img > D
  diff A B
  diff C D
  rm A B C D
  echo "Whoops!"
  exit 64
fi

go build -o prometheus-assembler-spectrum128k main.go
rm -f prometheus.tzx
./prometheus-assembler-spectrum128k prometheus.img prometheus.tzx $((CODE_ADDRESS)) prometheus assembler 1000
rm prometheus-assembler-spectrum128k prometheus.elf prometheus.img prometheus.o
