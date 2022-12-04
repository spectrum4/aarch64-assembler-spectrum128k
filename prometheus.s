# This is a commented disassembly of
#   * https://spectrumcomputing.co.uk/entry/25427/ZX-Spectrum/Prometheus
# (long 128K variant)


_start:
  di
  call    0x0052                          ; This is the first ret statement in ROM1
                                          ; It is called simply for the side effect of
                                          ; placing the next address on the stack so
                                          ; we can determine what address the code is
                                          ; loaded to (code is relocatable so could
                                          ; loaded at non-default address)
  dec     sp
  dec     sp                              ; lower the stack pointer to recover address
  pop     hl                              ; fetch it into HL
  push    hl                              ; stack it
  ld      bc,0x0013                       ;
  add     hl,bc                           ; add 0x13 bytes to HL => HL=_start+0x17=L0017
  ld      bc,0x01cd                       ; prepare to copy 0x1cd bytes memory region: (L0017 - L01E4)
  ld      de,0x4017                       ; target location is in 0x17 bytes into display file
  ldir                                    ; copy 0x1cd bytes from _start+0x17 to 0x4017 in display file
  jp      0x4017                          ; jump to the code that has just been copied to display file
                                          ; (L0017)


# The following section (L0017 until L0FAA) gets relocated to 0x4017-4fa9 in the display file

L0017:
  ld      bc,0x0dc6                       ; prepare to copy remaining 0xdc6 bytes (L01E4-L0FAA)
  push    de                              ; stack L01E4 location (0x41e4)
  ldir                                    ; relocate L01E4-L0FAA to 0x41e4
  xor     a                               ; a=0
  ld      (de),a                          ; [0x4faa] = 0 (first byte after code)
  inc     de                              ;
  ld      (de),a                          ; [0x4fab] = 0 (second byte after code)
  ld      de,0x5800                       ; DE = start of attributes file
  ld      b,0x00
  L0026:
    ld      a,0x3f
    ld      (de),a                        ; write 0x3f to next memory address
    inc     de
    ld      (de),a                        ; write 0x3f to next memory address
    inc     de
    djnz    L0026                         ; repeat 256 times
                                          ; top two screen thirds are now white on white (no flash no bright)
  L002E:
    ld      a,0x38                        ; white paper black ink
    ld      (de),a                        ; for bottom third of
    inc     de                            ; screen
    djnz    L002E                         ;
  ld      de,0x5000                       ; DE=display file address for start of bottom third of screen
  L0037:
    xor     a                             ; Clear
    ld      (de),a                        ; display file
    inc     de                            ; for entire
    ld      a,d                           ; bottom
    cp      0x58                          ; third
    jr      c,L0037                       ; of screen
  pop     ix                              ; IX=0x41e4 (location of L01E4)
  pop     de                              ; DE=original location of code block + 4
  dec     de
  dec     de
  dec     de
  dec     de                              ; DE=original location of code block
  push    hl                              ; push location of L0FAA (start of code that hasn't been relocated)
  push    ix                              ; push 0x41e4 (location of relocated L01E4)
  ex      de,hl                           ; DE=location of L0FAA (start of code that hasn't been relocated)
                                          ; HL=original location of code block
  ld      bc,0x40d0                       ; 01 d0 40
  ld      de,0x2710                       ; 11 10 27
  call    0x4126                          ; cd 26 41
  ld      de,0x03e8                       ; 11 e8 03
  call    0x4126                          ; cd 26 41
  ld      de,0x0064                       ; 11 64 00
  call    0x4126                          ; cd 26 41
  ld      e,0x0a                          ; 1e 0a
  call    0x4126                          ; cd 26 41
  ld      e,0x01                          ; 1e 01
  call    0x4126                          ; cd 26 41
  ld      hl,0x5041                       ; 21 41 50
  ld      (0x41bc),hl                     ; 22 bc 41
  call    0x41a9                          ; cd a9 41

.ascii "PROMETHEUS 128 disk version "
defb    0xcc

  ld      hl,0x5081                       ; 21 81 50
  ld      (0x41bc),hl                     ; 22 bc 41
  call    0x41a9                          ; cd a9 41

defb    0x7f                              ; (C)
.ascii " 1993 PROXIMA software "
L00AF:
defb    0x76
  ld      l,0x6f                          ; 2e 6f
  ld      l,0xf3                          ; 2e f3
  im      1                               ; ed 56
  ei                                      ; fb
  res     5,(iy+1)                        ; fd cb 01 ae
L00BC:
  ld      hl,0x50c8                       ; 21 c8 50
  ld      (0x41bc),hl                     ; 22 bc 41
  call    0x41a9                          ; cd a9 41

.ascii "Address"

L00CC:
  cp      d                               ; ba
  call    0x41a9                          ; cd a9 41
  defb    0x30, 0x30
  defb    0x30, 0x30
  jr      nc,L0135                        ; 30 5f
  and     b                               ; a0
L00D7:
  halt                                    ; 76
  bit     5,(iy+1)                        ; fd cb 01 6e
  jr      z,L00D7                         ; 28 f9
  ld      hl,0x00c8                       ; 21 c8 00
  ld      e,0x02                          ; 1e 02
  ld      d,h                             ; 54
  call    0x03b5                          ; cd b5 03
  ld      a,(0x5c08)                      ; 3a 08 5c
  res     5,(iy+1)                        ; fd cb 01 ae
  cp      0x0c                            ; fe 0c
L00F0:
  jr      nz,L0108                        ; 20 16
  ld      hl,(0x4115)                     ; 2a 15 41
  ld      bc,0x40d0                       ; 01 d0 40
  or      a                               ; b7
  sbc     hl,bc                           ; ed 42
  add     hl,bc                           ; 09
  jr      z,L00D7                         ; 28 d9
  ld      (hl),0x20                       ; 36 20
  dec     hl                              ; 2b
  ld      (hl),0x5f                       ; 36 5f
  ld      (0x4115),hl                     ; 22 15 41
  jr      L00BC                           ; 18 b4
L0108:
  cp      0x0d                            ; fe 0d
  jr      z,L0132                         ; 28 26
  cp      0x30                            ; fe 30
  jr      c,L00D7                         ; 38 c7
  cp      0x3a                            ; fe 3a
  jr      nc,L00D7                        ; 30 c3
  ld      hl,0x40d5                       ; 21 d5 40
  inc     hl                              ; 23
  bit     7,(hl)                          ; cb 7e
  dec     hl                              ; 2b
L011B:
  jr      nz,L00D7                        ; 20 ba
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),0x5f                       ; 36 5f
  ld      (0x4115),hl                     ; 22 15 41
  jr      L00BC                           ; 18 96
  ld      a,0x2f                          ; 3e 2f
L0128:
  or      a                               ; b7
  inc     a                               ; 3c
  sbc     hl,de                           ; ed 52
  jr      nc,L0128                        ; 30 fa
  add     hl,de                           ; 19
  ld      (bc),a                          ; 02
  inc     bc                              ; 03
  ret                                     ; c9
L0132:
  ld      bc,0x40d0                       ; 01 d0 40
L0135:
  ld      a,0x04                          ; 3e 04
  out     (0xfe),a                        ; d3 fe
  ld      hl,0x0000                       ; 21 00 00
L013C:
  ld      a,(bc)                          ; 0a
  inc     bc                              ; 03
  cp      0x5f                            ; fe 5f
  jr      z,L0150                         ; 28 0e
  add     hl,hl                           ; 29
  push    hl                              ; e5
  add     hl,hl                           ; 29
  add     hl,hl                           ; 29
  pop     de                              ; d1
  add     hl,de                           ; 19
  sub     0x30                            ; d6 30
  ld      e,a                             ; 5f
  ld      d,0x00                          ; 16 00
  add     hl,de                           ; 19
  jr      L013C                           ; 18 ec
L0150:
  ex      de,hl                           ; eb
  pop     ix                              ; dd e1
  pop     hl                              ; e1
  ld      bc,0x4ab8                       ; 01 b8 4a
  push    de                              ; d5
  call    0x41ce                          ; cd ce 41
  pop     hl                              ; e1
  push    hl                              ; e5
  ld      de,0xabe0                       ; 11 e0 ab
  or      a                               ; b7
  push    hl                              ; e5
  sbc     hl,de                           ; ed 52
  ld      c,l                             ; 4d
  ld      b,h                             ; 44
  pop     de                              ; d1
  xor     a                               ; af
  ld      (0x4196),a                      ; 32 96 41
L016B:
  ld      l,(ix+0)                        ; dd 6e 00
  ld      h,(ix+1)                        ; dd 66 01
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
  ld      a,h                             ; 7c
  or      l                               ; b5
  ret     z                               ; c8
  ld      a,h                             ; 7c
  and     0xc0                            ; e6 c0
  res     7,h                             ; cb bc
  res     6,h                             ; cb b4
  add     hl,de                           ; 19
  push    hl                              ; e5
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ex      de,hl                           ; eb
  or      a                               ; b7
  jr      z,L019D                         ; 28 15
  cp      0x40                            ; fe 40
  jr      z,L0195                         ; 28 09
  ld      a,l                             ; 7d
  add     a,c                             ; 81
  ld      l,a                             ; 6f
  ld      a,0x00                          ; 3e 00
  adc     a,0x00                          ; ce 00
  jr      L019F                           ; 18 0a
L0195:
  ld      a,0x00                          ; 3e 00
  add     a,l                             ; 85
  add     a,b                             ; 80
  ld      l,a                             ; 6f
  xor     a                               ; af
  jr      L019F                           ; 18 02
L019D:
  add     hl,bc                           ; 09
  xor     a                               ; af
L019F:
  ld      (0x4196),a                      ; 32 96 41
  ex      de,hl                           ; eb
  ld      (hl),d                          ; 72
  dec     hl                              ; 2b
  ld      (hl),e                          ; 73
  pop     de                              ; d1
  jr      L016B                           ; 18 c2
  pop     hl                              ; e1
L01AA:
  ld      a,(hl)                          ; 7e
  call    0x41b4                          ; cd b4 41
  bit     7,(hl)                          ; cb 7e
  inc     hl                              ; 23
  jr      z,L01AA                         ; 28 f7
  jp      (hl)                            ; e9
  add     a,a                             ; 87
  exx                                     ; d9
  ld      l,a                             ; 6f
  ld      h,0x0f                          ; 26 0f
  add     hl,hl                           ; 29
  add     hl,hl                           ; 29
  ld      de,0x0000                       ; 11 00 00
  push    de                              ; d5
  ld      b,0x08                          ; 06 08
L01C1:
  ld      a,(hl)                          ; 7e
  ld      (de),a                          ; 12
  inc     hl                              ; 23
  inc     d                               ; 14
  djnz    L01C1                           ; 10 fa
  pop     hl                              ; e1
  inc     l                               ; 2c
  ld      (0x41bc),hl                     ; 22 bc 41
  exx                                     ; d9
  ret                                     ; c9
  ld      a,b                             ; 78
  or      c                               ; b1
  ret     z                               ; c8
  push    hl                              ; e5
  xor     a                               ; af
  sbc     hl,de                           ; ed 52
  pop     hl                              ; e1
  jr      c,L01DB                         ; 38 03
  ldir                                    ; ed b0
  ret                                     ; c9
L01DB:
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  ex      de,hl                           ; eb
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  ex      de,hl                           ; eb
  lddr                                    ; ed b8
  ret                                     ; c9




L01E4:
  ld      bc,0x0400                       ; 01 00 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  jp      (hl)                            ; e9
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      d,0x00                          ; 16 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      e,c                             ; 59
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  adc     a,b                             ; 88
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  ld      e,a                             ; 5f
  nop                                     ; 00
  scf                                     ; 37
  nop                                     ; 00
  add     hl,de                           ; 19
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,c                             ; 41
  nop                                     ; 00
  ld      d,0x00                          ; 16 00
  ld      de,0x3600                       ; 11 00 36
  nop                                     ; 00
  inc     h                               ; 24
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  djnz    L0254                           ; 10 00
L0254:
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     h                               ; 25
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,de                           ; 19
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     h                               ; 24
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  ld      de,0x1100                       ; 11 00 11
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     e                               ; 1d
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      de,0x0800                       ; 11 00 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     hl                              ; 2b
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  adc     a,0x00                          ; ce 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      e,c                             ; 59
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0500                       ; 11 00 05
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0400                       ; 11 00 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0500                       ; 11 00 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0500                       ; 11 00 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      de,0x0500                       ; 11 00 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     e                               ; 1c
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0300                       ; 11 00 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      d,0x00                          ; 16 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rla                                     ; 17
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  djnz    L04CC                           ; 10 00
L04CC:
  dec     b                               ; 05
  nop                                     ; 00
  dec     de                              ; 1b
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  jr      nz,L04DC                        ; 20 00
L04DC:
  djnz    L04DE                           ; 10 00
L04DE:
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rla                                     ; 17
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  ld      hl,0x1f00                       ; 21 00 1f
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  ld      c,0x00                          ; 0e 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rla                                     ; 17
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  djnz    L05E2                           ; 10 00
L05E2:
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0700                       ; 11 00 07
  nop                                     ; 00
  ld      de,0x0400                       ; 11 00 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  daa                                     ; 27
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     h                               ; 25
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     de                              ; 13
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(de)                          ; 1a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  jr      nz,L0672                        ; 20 00
L0672:
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      de,0x1000                       ; 11 00 10
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  ld      a,(de)                          ; 1a
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     hl                              ; 23
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  djnz    L06B6                           ; 10 00
L06B6:
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      (hl),0x00                       ; 36 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      l,0x00                          ; 2e 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     sp                              ; 33
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rla                                     ; 17
  nop                                     ; 00
  ld      hl,(0x0800)                     ; 2a 00 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     e                               ; 1d
  nop                                     ; 00
  ld      a,(de)                          ; 1a
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     l                               ; 2d
  nop                                     ; 00
  ld      hl,(0x0400)                     ; 2a 00 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      hl,0x0500                       ; 21 00 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      de,0x1400                       ; 11 00 14
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      d,0x00                          ; 16 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      de,0x0600                       ; 11 00 06
  nop                                     ; 00
  rra                                     ; 1f
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  djnz    L0776                           ; 10 00
L0776:
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  xor     b                               ; a8
  ld      bc,0x0002                       ; 01 02 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      (bc),a                          ; 02
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      c,c                             ; 49
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      d,0x00                          ; 16 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      hl,0x0500                       ; 21 00 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      de,0x0a00                       ; 11 00 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      hl,0x0400                       ; 21 00 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     hl                              ; 23
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      de,0x0300                       ; 11 00 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     e                               ; 1c
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  djnz    L0A7A                           ; 10 00
L0A7A:
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      c,0x00                          ; 0e 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     de                              ; 1b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  jr      z,L0B3A                         ; 28 00
L0B3A:
  ex      af,af'                          ; 08
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,d                             ; 42
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     de                              ; 1b
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,hl                           ; 29
  nop                                     ; 00
  ld      d,b                             ; 50
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     hl                              ; 2b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  djnz    L0B8E                           ; 10 00
L0B8E:
  ld      b,0x00                          ; 06 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     h                               ; 25
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  djnz    L0BB6                           ; 10 00
L0BB6:
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  djnz    L0C0E                           ; 10 00
L0C0E:
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,b                             ; 40
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  ld      e,0x00                          ; 1e 00
  dec     h                               ; 25
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  jr      L0C84                           ; 18 00
L0C84:
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  jr      nz,L0C98                        ; 20 00
L0C98:
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  djnz    L0CA2                           ; 10 00
L0CA2:
  dec     b                               ; 05
  nop                                     ; 00
  ld      de,0x0a00                       ; 11 00 0a
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  jr      nz,L0CAE                        ; 20 00
L0CAE:
  dec     b                               ; 05
  nop                                     ; 00
  djnz    L0CB2                           ; 10 00
L0CB2:
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     h                               ; 25
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     de                              ; 1b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     h                               ; 25
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  djnz    L0D16                           ; 10 00
L0D16:
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  ld      c,(hl)                          ; 4e
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      de,0x0400                       ; 11 00 04
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  dec     d                               ; 15
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rla                                     ; 17
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  jr      nz,L0D5C                        ; 20 00
L0D5C:
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,c                             ; 49
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  jr      nz,L0D66                        ; 20 00
L0D66:
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rla                                     ; 17
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      de,0x4900                       ; 11 00 49
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      d,b                             ; 50
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     hl                              ; 2b
  nop                                     ; 00
  ld      (0x0f00),hl                     ; 22 00 0f
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      a,(de)                          ; 1a
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  dec     d                               ; 15
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      hl,0x0e00                       ; 21 00 0e
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      h,l                             ; 65
  nop                                     ; 00
  rla                                     ; 17
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  dec     sp                              ; 3b
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  add     hl,de                           ; 19
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     de                              ; 13
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  djnz    L0E1C                           ; 10 00
L0E1C:
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      c,0x00                          ; 0e 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  jr      nz,L0E5E                        ; 20 00
L0E5E:
  rrca                                    ; 0f
  nop                                     ; 00
  djnz    L0E62                           ; 10 00
L0E62:
  ld      b,0x00                          ; 06 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  cpl                                     ; 2f
  nop                                     ; 00
  ld      a,(de)                          ; 1a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     c                               ; 0c
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  dec     bc                              ; 0b
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  defb    0xdd
  djnz    L0F09                           ; 10 0c
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      (hl),0x00                       ; 36 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
L0F09:
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     bc                              ; 0b
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     l                               ; 2c
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  dec     c                               ; 0d
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  scf                                     ; 37
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      d,0x00                          ; 16 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     d                               ; 14
  nop                                     ; 00
  ld      (de),a                          ; 12
  nop                                     ; 00
  dec     h                               ; 25
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  dec     b                               ; 05
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
  rrca                                    ; 0f
  nop                                     ; 00
  rlca                                    ; 07
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  ld      de,0x1000                       ; 11 00 10
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  add     hl,bc                           ; 09
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00
  inc     bc                              ; 03
  nop                                     ; 00



L0FAA:
  jp      0xabe4                          ; c3 e4 ab
  nop                                     ; 00
  ld      hl,0xd43a                       ; 21 3a d4
  ld      (0xabe1),hl                     ; 22 e1 ab
  call    0xd40d                          ; cd 0d d4
  ld      hl,0x4864                       ; 21 64 48
  ld      (0xdf57),hl                     ; 22 57 df
  ld      hl,0xac1e                       ; 21 1e ac
  call    0xd868                          ; cd 68 d8
  call    0xde03                          ; cd 03 de
  cp      0x61                            ; fe 61
  jr      z,L0FE5                         ; 28 1b
  cp      0x79                            ; fe 79
  jr      z,L0FE5                         ; 28 17
  ld      hl,0xf3d7                       ; 21 d7 f3
  ld      (0xd098),hl                     ; 22 98 d0
  xor     a                               ; af
  ld      (0xcea7),a                      ; 32 a7 ce
  ld      a,0xc9                          ; 3e c9
  ld      (0xcc67),a                      ; 32 67 cc
  ld      (0xcc74),a                      ; 32 74 cc
  ld      a,0x01                          ; 3e 01
  ld      (0xb6e6),a                      ; 32 e6 b6
L0FE5:
  jp      0xd41c                          ; c3 1c d4
  ld      c,c                             ; 49
  ld      l,(hl)                          ; 6e
  ld      (hl),e                          ; 73
  ld      (hl),h                          ; 74
  ld      h,c                             ; 61
  ld      l,h                             ; 6c
  ld      l,h                             ; 6c
  jr      nz,L1035                        ; 20 44
  inc     (hl)                            ; 34
  jr      nc,L1023                        ; 30 2f
  ld      b,h                             ; 44
  jr      c,L1027                         ; 38 30
  jr      nz,L106F                        ; 20 76
  ld      h,l                             ; 65
  ld      (hl),d                          ; 72
  ld      (hl),e                          ; 73
  ld      l,c                             ; 69
  ld      l,a                             ; 6f
  ld      l,(hl)                          ; 6e
  cp      a                               ; bf
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L1023:
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L1027:
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L1035:
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L106F:
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L10CE:
  call    0xade9                          ; cd e9 ad
  ex      de,hl                           ; eb
  call    0xae29                          ; cd 29 ae
  ex      de,hl                           ; eb
  dec     hl                              ; 2b
  dec     de                              ; 1b
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L10CE                        ; 20 f1
  pop     bc                              ; c1
  jr      L10E6                           ; 18 06
L10E0:
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  ex      de,hl                           ; eb
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  ex      de,hl                           ; eb
L10E6:
  ld      a,b                             ; 78
  or      c                               ; b1
  jp      z,0xaf25                        ; ca 25 af
  push    hl                              ; e5
  push    de                              ; d5
  call    0xad6f                          ; cd 6f ad
  jr      nc,L10F3                        ; 30 01
  ex      de,hl                           ; eb
L10F3:
  inc     de                              ; 13
  ld      h,b                             ; 60
  ld      l,c                             ; 69
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  jr      nc,L1100                        ; 30 05
  add     hl,de                           ; 19
  ex      de,hl                           ; eb
  ld      hl,0x0000                       ; 21 00 00
L1100:
  ld      b,d                             ; 42
  ld      c,e                             ; 4b
  pop     de                              ; d1
  ex      (sp),hl                         ; e3
  ld      a,h                             ; 7c
  xor     d                               ; aa
  and     0xc0                            ; e6 c0
  jr      nz,L10CE                        ; 20 c4
  push    hl                              ; e5
  push    de                              ; d5
  push    bc                              ; c5
  ld      a,0x16                          ; 3e 16
  bit     7,h                             ; cb 7c
  jr      nz,L1115                        ; 20 02
  ld      a,0x13                          ; 3e 13
L1115:
  bit     6,h                             ; cb 74
  jr      nz,L111B                        ; 20 02
  sub     0x02                            ; d6 02
L111B:
  push    bc                              ; c5
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  pop     bc                              ; c1
  set     6,h                             ; cb f4
  set     7,h                             ; cb fc
  set     6,d                             ; cb f2
  set     7,d                             ; cb fa
  lddr                                    ; ed b8
  pop     bc                              ; c1
  pop     hl                              ; e1
  or      a                               ; b7
  sbc     hl,bc                           ; ed 42
  ex      de,hl                           ; eb
  pop     hl                              ; e1
  or      a                               ; b7
  sbc     hl,bc                           ; ed 42
  pop     bc                              ; c1
  jr      L10E6                           ; 18 ad
  res     6,h                             ; cb b4
  res     7,h                             ; cb bc
  res     6,d                             ; cb b2
  res     7,d                             ; cb ba
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  add     hl,de                           ; 19
  ret                                     ; c9
  call    0xad77                          ; cd 77 ad
  jr      c,L10E0                         ; 38 95
L114B:
  ld      a,b                             ; 78
  or      c                               ; b1
  jp      z,0xaf25                        ; ca 25 af
  push    hl                              ; e5
  push    de                              ; d5
  call    0xad6f                          ; cd 6f ad
  jr      c,L1158                         ; 38 01
  ex      de,hl                           ; eb
L1158:
  ld      hl,0x4000                       ; 21 00 40
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  ex      de,hl                           ; eb
  ld      h,b                             ; 60
  ld      l,c                             ; 69
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  jr      nc,L116B                        ; 30 05
  add     hl,de                           ; 19
  ex      de,hl                           ; eb
  ld      hl,0x0000                       ; 21 00 00
L116B:
  ld      b,d                             ; 42
  ld      c,e                             ; 4b
  pop     de                              ; d1
  ex      (sp),hl                         ; e3
  ld      a,h                             ; 7c
  xor     d                               ; aa
  and     0xc0                            ; e6 c0
  jr      nz,L11A0                        ; 20 2b
  push    hl                              ; e5
  push    de                              ; d5
  push    bc                              ; c5
  ld      a,0x16                          ; 3e 16
  bit     7,h                             ; cb 7c
  jr      nz,L1180                        ; 20 02
  ld      a,0x13                          ; 3e 13
L1180:
  bit     6,h                             ; cb 74
  jr      nz,L1186                        ; 20 02
  sub     0x02                            ; d6 02
L1186:
  push    bc                              ; c5
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  pop     bc                              ; c1
  set     6,h                             ; cb f4
  set     7,h                             ; cb fc
  set     6,d                             ; cb f2
  set     7,d                             ; cb fa
  ldir                                    ; ed b0
  pop     bc                              ; c1
  pop     hl                              ; e1
  add     hl,bc                           ; 09
  ex      de,hl                           ; eb
  pop     hl                              ; e1
  add     hl,bc                           ; 09
  pop     bc                              ; c1
  jr      L114B                           ; 18 ab
L11A0:
  call    0xade9                          ; cd e9 ad
  ex      de,hl                           ; eb
  call    0xae29                          ; cd 29 ae
  ex      de,hl                           ; eb
  inc     hl                              ; 23
  inc     de                              ; 13
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L11A0                        ; 20 f1
  pop     bc                              ; c1
  jp      0xad81                          ; c3 81 ad
  push    bc                              ; c5
  bit     7,h                             ; cb 7c
  ld      a,0x16                          ; 3e 16
  jr      nz,L11BC                        ; 20 02
  ld      a,0x13                          ; 3e 13
L11BC:
  bit     6,h                             ; cb 74
  jr      nz,L11C2                        ; 20 02
  sub     0x02                            ; d6 02
L11C2:
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  ld      b,h                             ; 44
  set     7,h                             ; cb fc
  set     6,h                             ; cb f4
  ld      a,(hl)                          ; 7e
  push    af                              ; f5
  ld      h,b                             ; 60
  ld      b,0x7f                          ; 06 7f
  ld      a,0x10                          ; 3e 10
  out     (c),a                           ; ed 79
  pop     af                              ; f1
  pop     bc                              ; c1
  ret                                     ; c9
  bit     7,h                             ; cb 7c
  ld      a,0x16                          ; 3e 16
  jr      nz,L11E0                        ; 20 02
  ld      a,0x13                          ; 3e 13
L11E0:
  bit     6,h                             ; cb 74
  jr      nz,L11E6                        ; 20 02
  sub     0x02                            ; d6 02
L11E6:
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  ld      b,h                             ; 44
  set     7,h                             ; cb fc
  set     6,h                             ; cb f4
  ld      a,(hl)                          ; 7e
  ld      h,b                             ; 60
  ret                                     ; c9
  push    bc                              ; c5
  push    af                              ; f5
  bit     7,h                             ; cb 7c
  ld      a,0x16                          ; 3e 16
  jr      nz,L11FD                        ; 20 02
  ld      a,0x13                          ; 3e 13
L11FD:
  bit     6,h                             ; cb 74
  jr      nz,L1203                        ; 20 02
  sub     0x02                            ; d6 02
L1203:
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  pop     af                              ; f1
  ld      b,h                             ; 44
  set     7,h                             ; cb fc
  set     6,h                             ; cb f4
  ld      (hl),a                          ; 77
  push    af                              ; f5
  ld      h,b                             ; 60
  ld      b,0x7f                          ; 06 7f
  ld      a,0x10                          ; 3e 10
  out     (c),a                           ; ed 79
  pop     af                              ; f1
  pop     bc                              ; c1
  ret                                     ; c9
  push    ix                              ; dd e5
  pop     hl                              ; e1
  bit     7,h                             ; cb 7c
  ld      d,0x16                          ; 16 16
  jr      nz,L1225                        ; 20 02
  ld      d,0x13                          ; 16 13
L1225:
  bit     6,h                             ; cb 74
  jr      nz,L122B                        ; 20 02
  dec     d                               ; 15
  dec     d                               ; 15
L122B:
  ld      bc,0x7ffd                       ; 01 fd 7f
  set     7,h                             ; cb fc
  set     6,h                             ; cb f4
  ret                                     ; c9
  ld      l,0x00                          ; 2e 00
  inc     l                               ; 2c
  ex      af,af'                          ; 08
  exx                                     ; d9
  call    0xae50                          ; cd 50 ae
  out     (c),d                           ; ed 51
  exx                                     ; d9
  di                                      ; f3
  ld      a,0x0f                          ; 3e 0f
  out     (0xfe),a                        ; d3 fe
  in      a,(0xfe)                        ; db fe
  rra                                     ; 1f
  and     0x20                            ; e6 20
  or      0x02                            ; f6 02
  ld      c,a                             ; 4f
  cp      a                               ; bf
L124C:
  jp      nz,0xaf25                       ; c2 25 af
L124F:
  call    0x05e7                          ; cd e7 05
  jr      nc,L124C                        ; 30 f8
  ld      hl,0x0415                       ; 21 15 04
L1257:
  djnz    L1257                           ; 10 fe
  dec     hl                              ; 2b
  ld      a,h                             ; 7c
  or      l                               ; b5
  jr      nz,L1257                        ; 20 f9
  call    0x05e3                          ; cd e3 05
  jr      nc,L124C                        ; 30 e9
L1263:
  ld      b,0x9c                          ; 06 9c
  call    0x05e3                          ; cd e3 05
  jr      nc,L124C                        ; 30 e2
  ld      a,0xc6                          ; 3e c6
  cp      b                               ; b8
  jr      nc,L124F                        ; 30 e0
  inc     h                               ; 24
  jr      nz,L1263                        ; 20 f1
L1272:
  ld      b,0xc9                          ; 06 c9
  call    0x05e7                          ; cd e7 05
  jr      nc,L124C                        ; 30 d3
  ld      a,b                             ; 78
  cp      0xd4                            ; fe d4
  jr      nc,L1272                        ; 30 f4
  call    0x05e7                          ; cd e7 05
  jr      nc,L12EF                        ; 30 6c
  ld      a,c                             ; 79
  xor     0x03                            ; ee 03
  ld      c,a                             ; 4f
  ld      h,0x00                          ; 26 00
  ld      b,0xb0                          ; 06 b0
  jr      L12D4                           ; 18 47
L128D:
  ex      af,af'                          ; 08
  jr      z,L12B7                         ; 28 27
  rl      c                               ; cb 11
  xor     l                               ; ad
  jr      nz,L12EF                        ; 20 5a
  ld      a,c                             ; 79
  rra                                     ; 1f
  ld      c,a                             ; 4f
  inc     de                              ; 13
  ex      af,af'                          ; 08
  jr      L12D1                           ; 18 35
L129C:
  xor     (hl)                            ; ae
  jr      z,L12BC                         ; 28 1d
  jr      L12EF                           ; 18 4e
  exx                                     ; d9
  ld      hl,0x0000                       ; 21 00 00
  ld      d,0x00                          ; 16 00
  out     (c),d                           ; ed 51
  exx                                     ; d9
  ld      de,(0xafcd)                     ; ed 5b cd af
  dec     de                              ; 1b
  ld      b,0xb1                          ; 06 b1
  ex      af,af'                          ; 08
  xor     a                               ; af
  dec     a                               ; 3d
  ex      af,af'                          ; 08
  jr      L12D4                           ; 18 1d
L12B7:
  ld      a,l                             ; 7d
  exx                                     ; d9
  jr      nc,L129C                        ; 30 e1
  ld      (hl),a                          ; 77
L12BC:
  ex      af,af'                          ; 08
  inc     hl                              ; 23
  bit     7,h                             ; cb 7c
  jr      nz,L12D0                        ; 20 0e
  ld      h,0xc0                          ; 26 c0
L12C4:
  inc     d                               ; 14
  ld      a,d                             ; 7a
  cp      0x12                            ; fe 12
  jr      z,L12C4                         ; 28 fa
  cp      0x15                            ; fe 15
  jr      z,L12C4                         ; 28 f6
  out     (c),d                           ; ed 51
L12D0:
  exx                                     ; d9
L12D1:
  dec     de                              ; 1b
  ld      b,0xb2                          ; 06 b2
L12D4:
  ld      l,0x01                          ; 2e 01
  call    0x05e3                          ; cd e3 05
  jr      nc,L12EF                        ; 30 14
  ld      a,0xcb                          ; 3e cb
  cp      b                               ; b8
  rl      l                               ; cb 15
  ld      b,0xb0                          ; 06 b0
  jp      nc,0xaf0c                       ; d2 0c af
  ld      a,h                             ; 7c
  xor     l                               ; ad
  ld      h,a                             ; 67
  ld      a,d                             ; 7a
  or      e                               ; b3
  jr      nz,L128D                        ; 20 a1
  ld      a,h                             ; 7c
  cp      0x01                            ; fe 01
L12EF:
  push    af                              ; f5
  push    bc                              ; c5
  ld      a,0x10                          ; 3e 10
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  pop     bc                              ; c1
  pop     af                              ; f1
  ret                                     ; c9
  call    0xaf5d                          ; cd 5d af
  ld      (de),a                          ; 12
  inc     de                              ; 13
  ld      (0xaf47),de                     ; ed 53 47 af
  ld      hl,0x0000                       ; 21 00 00
  inc     hl                              ; 23
  ld      (0xaf3b),hl                     ; 22 3b af
  jr      L12EF                           ; 18 e2
  call    0xaf5d                          ; cd 5d af
  ld      hl,0x0000                       ; 21 00 00
  dec     hl                              ; 2b
  ld      a,(hl)                          ; 7e
  dec     hl                              ; 2b
  ld      b,(hl)                          ; 46
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),b                          ; 70
  jr      L12EF                           ; 18 d3
  call    0xaf5d                          ; cd 5d af
  ld      hl,(0xaf47)                     ; 2a 47 af
  dec     hl                              ; 2b
  add     a,(hl)                          ; 86
  ld      (hl),a                          ; 77
  jr      L12EF                           ; 18 c8
  push    af                              ; f5
  push    bc                              ; c5
  ld      bc,0x7ffd                       ; 01 fd 7f
  ld      a,0x10                          ; 3e 10
  out     (c),a                           ; ed 79
  pop     bc                              ; c1
  pop     af                              ; f1
  ret                                     ; c9
  ld      a,0x00                          ; 3e 00
  ld      bc,0x7ffd                       ; 01 fd 7f
  out     (c),a                           ; ed 79
  call    0x0000                          ; cd 00 00
  di                                      ; f3
  jr      L12EF                           ; 18 af
  ld      hl,0x1f80                       ; 21 80 1f
  exx                                     ; d9
  out     (c),d                           ; ed 51
  exx                                     ; d9
  bit     7,a                             ; cb 7f
  jr      z,L134E                         ; 28 03
  ld      hl,0x0c98                       ; 21 98 0c
L134E:
  ex      af,af'                          ; 08
  inc     de                              ; 13
  ld      a,0x02                          ; 3e 02
  ld      b,a                             ; 47
L1353:
  djnz    L1353                           ; 10 fe
  out     (0xfe),a                        ; d3 fe
  xor     0x0f                            ; ee 0f
  ld      b,0xa4                          ; 06 a4
  dec     l                               ; 2d
  jr      nz,L1353                        ; 20 f5
  dec     b                               ; 05
  dec     h                               ; 25
  jp      p,0xaf89                        ; f2 89 af
  ld      b,0x2f                          ; 06 2f
L1365:
  djnz    L1365                           ; 10 fe
  out     (0xfe),a                        ; d3 fe
  ld      a,0x0d                          ; 3e 0d
  ld      b,0x37                          ; 06 37
L136D:
  djnz    L136D                           ; 10 fe
  out     (0xfe),a                        ; d3 fe
  ld      bc,0x3b0e                       ; 01 0e 3b
  ex      af,af'                          ; 08
  ld      l,a                             ; 6f
  jp      0xafb9                          ; c3 b9 af
  ld      a,d                             ; 7a
  or      e                               ; b3
  jr      z,L138A                         ; 28 0d
  exx                                     ; d9
  ld      a,(hl)                          ; 7e
  exx                                     ; d9
  ld      l,a                             ; 6f
L1381:
  ld      a,h                             ; 7c
  xor     l                               ; ad
  ld      h,a                             ; 67
  ld      a,0x01                          ; 3e 01
  scf                                     ; 37
  jp      0xaff1                          ; c3 f1 af
L138A:
  ld      l,h                             ; 6c
  jr      L1381                           ; 18 f4
  exx                                     ; d9
  ld      hl,0x0000                       ; 21 00 00
  ld      d,0x00                          ; 16 00
  out     (c),d                           ; ed 51
  exx                                     ; d9
  ld      de,0x0000                       ; 11 00 00
  ld      l,0xff                          ; 2e ff
  ld      a,h                             ; 7c
  xor     l                               ; ad
  ld      h,a                             ; 67
  ld      a,0x01                          ; 3e 01
  scf                                     ; 37
  rl      l                               ; cb 15
  ld      b,0x31                          ; 06 31
  jr      L13B0                           ; 18 09
L13A7:
  ld      a,c                             ; 79
  bit     7,b                             ; cb 78
L13AA:
  djnz    L13AA                           ; 10 fe
  jr      nc,L13B2                        ; 30 04
  ld      b,0x42                          ; 06 42
L13B0:
  djnz    L13B0                           ; 10 fe
L13B2:
  out     (0xfe),a                        ; d3 fe
  ld      b,0x3e                          ; 06 3e
  jr      nz,L13A7                        ; 20 ef
  dec     b                               ; 05
  xor     a                               ; af
  inc     a                               ; 3c
  rl      l                               ; cb 15
  jp      nz,0xafe0                       ; c2 e0 af
  dec     de                              ; 1b
  exx                                     ; d9
  inc     hl                              ; 23
  bit     7,h                             ; cb 7c
  jr      nz,L13D5                        ; 20 0e
  ld      h,0xc0                          ; 26 c0
L13C9:
  inc     d                               ; 14
  ld      a,d                             ; 7a
  cp      0x12                            ; fe 12
  jr      z,L13C9                         ; 28 fa
  cp      0x15                            ; fe 15
  jr      z,L13C9                         ; 28 f6
  out     (c),d                           ; ed 51
L13D5:
  exx                                     ; d9
  ld      b,0x2f                          ; 06 2f
  ld      a,0x7f                          ; 3e 7f
  in      a,(0xfe)                        ; db fe
  rra                                     ; 1f
  jr      nc,L13E8                        ; 30 09
  ld      a,d                             ; 7a
  inc     a                               ; 3c
  jp      nz,0xafaf                       ; c2 af af
  ld      b,0x3b                          ; 06 3b
L13E6:
  djnz    L13E6                           ; 10 fe
L13E8:
  exx                                     ; d9
  ld      a,0x10                          ; 3e 10
  out     (c),a                           ; ed 79
  exx                                     ; d9
  ret                                     ; c9
  push    bc                              ; c5
  exx                                     ; d9
  ld      de,0x0000                       ; 11 00 00
  call    0xca48                          ; cd 48 ca
  push    hl                              ; e5
  add     hl,bc                           ; 09
  add     hl,bc                           ; 09
  ld      (0xb055),hl                     ; 22 55 b0
  exx                                     ; d9
  pop     hl                              ; e1
  exx                                     ; d9
L1400:
  ld      a,b                             ; 78
  or      c                               ; b1
  scf                                     ; 37
  jr      z,L1435                         ; 28 30
  exx                                     ; d9
  inc     hl                              ; 23
  call    0xae0e                          ; cd 0e ae
  ld      c,a                             ; 4f
  and     0xc0                            ; e6 c0
  ld      a,c                             ; 79
  jr      nz,L1413                        ; 20 03
  inc     a                               ; 3c
  jr      L142E                           ; 18 1b
L1413:
  push    hl                              ; e5
  dec     hl                              ; 2b
  and     0x3f                            ; e6 3f
  ld      b,a                             ; 47
  push    bc                              ; c5
  call    0xae0e                          ; cd 0e ae
  pop     bc                              ; c1
  ld      c,a                             ; 4f
  ld      hl,0x0000                       ; 21 00 00
  add     hl,bc                           ; 09
  call    0xae0e                          ; cd 0e ae
  cp      e                               ; bb
  jr      nz,L142D                        ; 20 05
  inc     hl                              ; 23
  call    0xae0e                          ; cd 0e ae
  cp      d                               ; ba
L142D:
  pop     hl                              ; e1
L142E:
  inc     hl                              ; 23
  exx                                     ; d9
  dec     bc                              ; 0b
  inc     de                              ; 13
  jr      nz,L1400                        ; 20 cc
  exx                                     ; d9
L1435:
  exx                                     ; d9
  pop     bc                              ; c1
L1437:
  jp      0xaf25                          ; c3 25 af
  call    0xb1c1                          ; cd c1 b1
  call    0x1a00                          ; cd 00 1a
  jr      L1437                           ; 18 f5
  call    0xb1c1                          ; cd c1 b1
  call    0x19ae                          ; cd ae 19
  jr      L1437                           ; 18 ed
  ld      sp,0xad04                       ; 31 04 ad
  call    0xf430                          ; cd 30 f4
  call    0xf4df                          ; cd df f4
  call    0xaf25                          ; cd 25 af
  jp      0xbbf0                          ; c3 f0 bb
  call    0xae69                          ; cd 69 ae
  jr      L146C                           ; 18 0e
  inc     d                               ; 14
  ex      af,af'                          ; 08
  dec     d                               ; 15
  di                                      ; f3
  ld      a,0x0f                          ; 3e 0f
  out     (0xfe),a                        ; d3 fe
  call    0x0562                          ; cd 62 05
  call    0xaf25                          ; cd 25 af
L146C:
  push    af                              ; f5
  ld      a,0x7f                          ; 3e 7f
  in      a,(0xfe)                        ; db fe
  rra                                     ; 1f
  jp      nc,0xd81e                       ; d2 1e d8
  pop     af                              ; f1
  ret                                     ; c9
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  ld      a,(0x005c)                      ; 3a 5c 00
  nop                                     ; 00
  rst     0x38                            ; ff
  xor     a                               ; af
  ld      bc,0x0001                       ; 01 01 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  ld      a,0xe9                          ; 3e e9
  call    0xb820                          ; cd 20 b8
  ld      (0xb14d),sp                     ; ed 73 4d b1
  call    0xb1c1                          ; cd c1 b1
  ld      sp,0xb0ad                       ; 31 ad b0
  pop     hl                              ; e1
  ld      a,l                             ; 7d
  ld      r,a                             ; ed 4f
  ld      a,h                             ; 7c
  ld      i,a                             ; ed 47
  pop     bc                              ; c1
  pop     de                              ; d1
  pop     hl                              ; e1
  pop     af                              ; f1
  exx                                     ; d9
  ex      af,af'                          ; 08
  pop     iy                              ; fd e1
  pop     ix                              ; dd e1
  pop     bc                              ; c1
  pop     de                              ; d1
  pop     hl                              ; e1
  pop     af                              ; f1
  ld      sp,(0xb0c3)                     ; ed 7b c3 b0
  jp      0xac60                          ; c3 60 ac
  ld      (0xb0c3),sp                     ; ed 73 c3 b0
  ld      sp,0xac60                       ; 31 60 ac
  push    af                              ; f5
  ld      a,i                             ; ed 57
  push    af                              ; f5
  ld      a,r                             ; ed 5f
  di                                      ; f3
  push    af                              ; f5
  pop     af                              ; f1
  pop     af                              ; f1
  pop     af                              ; f1
  ld      sp,0xb0c3                       ; 31 c3 b0
  push    af                              ; f5
  push    hl                              ; e5
  push    de                              ; d5
  ld      a,0x01                          ; 3e 01
  ld      de,0x0000                       ; 11 00 00
  ld      hl,0x0000                       ; 21 00 00
  jr      L1504                           ; 18 22
  nop                                     ; 00
  ld      (0xb0c3),sp                     ; ed 73 c3 b0
  ld      sp,0xac60                       ; 31 60 ac
  push    af                              ; f5
  ld      a,i                             ; ed 57
  push    af                              ; f5
  ld      a,r                             ; ed 5f
  di                                      ; f3
  push    af                              ; f5
  pop     af                              ; f1
  pop     af                              ; f1
  pop     af                              ; f1
  ld      sp,0xb0c3                       ; 31 c3 b0
  push    af                              ; f5
  push    hl                              ; e5
  push    de                              ; d5
  ld      a,0x00                          ; 3e 00
  ld      de,0x0000                       ; 11 00 00
  ld      hl,0x0000                       ; 21 00 00
  nop                                     ; 00
L1504:
  push    bc                              ; c5
  push    ix                              ; dd e5
  push    iy                              ; fd e5
  exx                                     ; d9
  ex      af,af'                          ; 08
  push    af                              ; f5
  push    hl                              ; e5
  push    de                              ; d5
  push    bc                              ; c5
  ld      a,i                             ; ed 57
  ld      h,a                             ; 67
  ld      a,r                             ; ed 5f
  ld      l,a                             ; 6f
  push    hl                              ; e5
  ld      sp,0x0000                       ; 31 00 00
  call    0xb166                          ; cd 66 b1
  ld      a,0xdb                          ; 3e db
  call    0xb820                          ; cd 20 b8
  ld      hl,0xac5c                       ; 21 5c ac
  ld      a,(hl)                          ; 7e
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  or      (hl)                            ; b6
  and     0x04                            ; e6 04
  rrca                                    ; 0f
  rrca                                    ; 0f
  ld      (0xc368),a                      ; 32 68 c3
  ret                                     ; c9
  ld      de,0xac82                       ; 11 82 ac
  ld      a,0x01                          ; 3e 01
  or      a                               ; b7
  jp      z,0xaf25                        ; ca 25 af
  ld      hl,0xc000                       ; 21 00 c0
  ld      bc,0x0008                       ; 01 08 00
  push    hl                              ; e5
  push    bc                              ; c5
  ldir                                    ; ed b0
  ld      hl,0xad04                       ; 21 04 ad
  pop     bc                              ; c1
  pop     de                              ; d1
  ldir                                    ; ed b0
  xor     a                               ; af
L154B:
  ld      bc,0x7ffd                       ; 01 fd 7f
  ld      e,a                             ; 5f
  or      0x10                            ; f6 10
  out     (c),a                           ; ed 79
  ld      c,e                             ; 4b
  ld      hl,0xad04                       ; 21 04 ad
  ld      de,0xc000                       ; 11 00 c0
  ld      b,0x08                          ; 06 08
L155C:
  ld      a,(de)                          ; 1a
  cp      (hl)                            ; be
  jr      nz,L1576                        ; 20 16
  inc     l                               ; 2c
  inc     e                               ; 1c
  djnz    L155C                           ; 10 f8
  ld      a,c                             ; 79
  ld      (0xb1c2),a                      ; 32 c2 b1
  ld      hl,0xac82                       ; 21 82 ac
  ld      de,0xc000                       ; 11 00 c0
  ld      bc,0x0008                       ; 01 08 00
  ldir                                    ; ed b0
  jp      0xaf25                          ; c3 25 af
L1576:
  ld      a,c                             ; 79
  call    0xb1b5                          ; cd b5 b1
  jr      nz,L154B                        ; 20 cf
  jp      0xaf25                          ; c3 25 af
L157F:
  inc     a                               ; 3c
  cp      0x02                            ; fe 02
  jr      z,L157F                         ; 28 fb
  cp      0x05                            ; fe 05
  jr      z,L157F                         ; 28 f7
  cp      0x08                            ; fe 08
  ret                                     ; c9
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  ret     z                               ; c8
  push    bc                              ; c5
  ld      bc,0x7ffd                       ; 01 fd 7f
  or      0x10                            ; f6 10
  out     (c),a                           ; ed 79
  pop     bc                              ; c1
  ret                                     ; c9
  call    0xb1c1                          ; cd c1 b1
  ld      a,(hl)                          ; 7e
L159D:
  jp      0xaf25                          ; c3 25 af
  push    af                              ; f5
  call    0xb1c1                          ; cd c1 b1
  pop     af                              ; f1
  ld      (hl),a                          ; 77
  jr      L159D                           ; 18 f5
  push    af                              ; f5
  call    0xb1c1                          ; cd c1 b1
  pop     af                              ; f1
  ld      (hl),a                          ; 77
  ldir                                    ; ed b0
  jr      L159D                           ; 18 eb
  call    0xb1c1                          ; cd c1 b1
  call    0xb1f0                          ; cd f0 b1
  jr      L159D                           ; 18 e3
  ld      a,b                             ; 78
  or      c                               ; b1
  ret     z                               ; c8
  call    0xad77                          ; cd 77 ad
  jr      c,L15C5                         ; 38 03
  ldir                                    ; ed b0
  ret                                     ; c9
L15C5:
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  ex      de,hl                           ; eb
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  ex      de,hl                           ; eb
  lddr                                    ; ed b8
  ret                                     ; c9
  call    0xb1c1                          ; cd c1 b1
  ld      bc,0x0003                       ; 01 03 00
  ldir                                    ; ed b0
  jp      0xaf25                          ; c3 25 af
  push    af                              ; f5
  call    0xb1c1                          ; cd c1 b1
  pop     af                              ; f1
  call    0x04c6                          ; cd c6 04
  jp      0xaf25                          ; c3 25 af
  push    af                              ; f5
  call    0xb1c1                          ; cd c1 b1
  pop     af                              ; f1
  call    0xb094                          ; cd 94 b0
  jp      0xaf25                          ; c3 25 af
  ld      hl,(0xb137)                     ; 2a 37 b1
  call    0xbd66                          ; cd 66 bd
  call    0xbd6c                          ; cd 6c bd
  ex      de,hl                           ; eb
  call    0xb1c1                          ; cd c1 b1
  ldir                                    ; ed b0
  call    0xaf25                          ; cd 25 af
  ex      de,hl                           ; eb
  ld      de,0xb119                       ; 11 19 b1
  call    0xb241                          ; cd 41 b2
  ld      de,0xb0f6                       ; 11 f6 b0
  ld      (hl),0xc3                       ; 36 c3
  inc     hl                              ; 23
  ld      (hl),e                          ; 73
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
  inc     hl                              ; 23
  ret                                     ; c9
  ret     po                              ; e0
  ld      d,b                             ; 50
  push    bc                              ; c5
  inc     bc                              ; 03
  ld      bc,0x0000                       ; 01 00 00
  nop                                     ; 00
  ld      b,b                             ; 40
  and     b                               ; a0
  inc     bc                              ; 03
  adc     a,e                             ; 8b
  nop                                     ; 00
  nop                                     ; 00
  and     b                               ; a0
  ld      c,b                             ; 48
  call    nz,0x8203                       ; c4 03 82
  nop                                     ; 00
  nop                                     ; 00
  ld      (de),a                          ; 12
  ld      d,b                             ; 50
  and     e                               ; a3
  inc     bc                              ; 03
  ld      bc,0x0000                       ; 01 00 00
  nop                                     ; 00
  ld      d,b                             ; 50
  pop     bc                              ; c1
  or      d                               ; b2
  ld      bc,0xb0c2                       ; 01 c2 b0
  jr      nz,L1688                        ; 20 50
  jp      nz,0x0192                       ; c2 92 01
  cp      h                               ; bc
  or      b                               ; b0
  ld      b,b                             ; 40
  ld      d,b                             ; 50
  jp      0x0192                          ; c3 92 01
  cp      e                               ; bb
  or      b                               ; b0
  ld      h,b                             ; 60
  ld      d,b                             ; 50
  call    nz,0x0192                       ; c4 92 01
  cp      (hl)                            ; be
  or      b                               ; b0
  add     a,b                             ; 80
  ld      d,b                             ; 50
  push    bc                              ; c5
  sub     d                               ; 92
  ld      bc,0xb0bd                       ; 01 bd b0
  and     b                               ; a0
  ld      d,b                             ; 50
  ret     z                               ; c8
  sub     d                               ; 92
  ld      bc,0xb0c0                       ; 01 c0 b0
  ret     nz                              ; c0
  ld      d,b                             ; 50
  call    z,0x0192                        ; cc 92 01
  cp      a                               ; bf
  or      b                               ; b0
  add     a,b                             ; 80
  ld      c,b                             ; 48
  ret                                     ; c9
  add     a,d                             ; 82
  nop                                     ; 00
  xor     (hl)                            ; ae
  or      b                               ; b0
  ret     z                               ; c8
  ld      d,b                             ; 50
  jp      nc,0x0182                       ; d2 82 01
  xor     l                               ; ad
  or      b                               ; b0
  nop                                     ; 00
  ld      c,b                             ; 48
  add     hl,de                           ; 19
  add     a,d                             ; 82
  nop                                     ; 00
  cp      d                               ; ba
  or      b                               ; b0
  jr      nz,L16BF                        ; 20 48
  dec     e                               ; 1d
  add     a,d                             ; 82
  nop                                     ; 00
  cp      c                               ; b9
  or      b                               ; b0
  ld      b,b                             ; 40
  ld      c,b                             ; 48
  ld      a,(de)                          ; 1a
  add     a,d                             ; 82
  nop                                     ; 00
  cp      b                               ; b8
  or      b                               ; b0
  ld      h,b                             ; 60
  ld      c,b                             ; 48
  ld      e,0x82                          ; 1e 82
  nop                                     ; 00
L1688:
  or      a                               ; b7
  or      b                               ; b0
  adc     a,0x50                          ; ce 50
  add     a,0x00                          ; c6 00
  ld      bc,0xb0c1                       ; 01 c1 b0
  ret     po                              ; e0
  ld      b,b                             ; 40
  dec     d                               ; 15
  adc     a,d                             ; 8a
  nop                                     ; 00
  pop     bc                              ; c1
  or      b                               ; b0
  ld      c,c                             ; 49
  ld      d,b                             ; 50
  ld      d,0x8a                          ; 16 8a
  ld      bc,0xb0bb                       ; 01 bb b0
  ld      l,c                             ; 69
  ld      d,b                             ; 50
  rla                                     ; 17
  adc     a,d                             ; 8a
  ld      bc,0xb0bd                       ; 01 bd b0
  adc     a,c                             ; 89
  ld      d,b                             ; 50
  defb    0x18, 0x8a
  ld      bc,0xb0bf                       ; 01 bf b0
  ld      d,d                             ; 52
  ld      d,b                             ; 50
  inc     hl                              ; 23
  adc     a,d                             ; 8a
  ld      bc,0xb0c3                       ; 01 c3 b0
  ld      (hl),d                          ; 72
  ld      d,b                             ; 50
  dec     de                              ; 1b
  adc     a,d                             ; 8a
  ld      bc,0xb0b9                       ; 01 b9 b0
  sub     d                               ; 92
  ld      d,b                             ; 50
  inc     e                               ; 1c
  adc     a,d                             ; 8a
L16BF:
  ld      bc,0xb0b7                       ; 01 b7 b0
  exx                                     ; d9
  ld      d,b                             ; 50
  call    nc,0x018a                       ; d4 8a 01
  push    bc                              ; c5
  or      b                               ; b0
  and     b                               ; a0
  ld      c,b                             ; 48
  ret     c                               ; d8
  add     a,c                             ; 81
  ret     po                              ; e0
  rst     0x00                            ; c7
  or      b                               ; b0
  or      c                               ; b1
  ld      c,b                             ; 48
  exx                                     ; d9
  add     a,c                             ; 81
  ret     po                              ; e0
  ret                                     ; c9
  or      b                               ; b0
  ex      af,af'                          ; 08
  ld      c,b                             ; 48
  ld      h,0x81                          ; 26 81
  ret     po                              ; e0
  cp      e                               ; bb
  or      b                               ; b0
  jr      z,L1728                         ; 28 48
  daa                                     ; 27
  add     a,c                             ; 81
  ret     po                              ; e0
  cp      l                               ; bd
  or      b                               ; b0
  ld      c,b                             ; 48
  ld      c,b                             ; 48
  defb    0x28, 0x81
  ret     po                              ; e0
  cp      a                               ; bf
  or      b                               ; b0
  ld      d,0x50                          ; 16 50
  dec     hl                              ; 2b
  adc     a,l                             ; 8d
  push    hl                              ; e5
  jp      0x68b0                          ; c3 b0 68
  ld      c,b                             ; 48
  add     hl,hl                           ; 29
  add     a,c                             ; 81
  ret     po                              ; e0
  cp      c                               ; b9
  or      b                               ; b0
  adc     a,b                             ; 88
  ld      c,b                             ; 48
  ld      hl,(0xe081)                     ; 2a 81 e0
  or      a                               ; b7
  or      b                               ; b0
  call    nc,0x0002                       ; d4 02 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  push    de                              ; d5
  ld      (bc),a                          ; 02
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L1728:
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  out     (0x02),a                        ; d3 02
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  jp      nc,0x0002                       ; d2 02 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  pop     de                              ; d1
  ld      (bc),a                          ; 02
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  call    z,0x0001                        ; cc 01 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  call    0xc146                          ; cd 46 c1
  xor     a                               ; af
  in      a,(0xfe)                        ; db fe
  cpl                                     ; 2f
  and     0x1f                            ; e6 1f
  ret     nz                              ; c0
  call    0xddd2                          ; cd d2 dd
  cp      0x04                            ; fe 04
  ret     nz                              ; c0
  di                                      ; f3
  call    0xcec2                          ; cd c2 ce
  ld      sp,0xad04                       ; 31 04 ad
  call    0xbb86                          ; cd 86 bb
  ld      hl,0xac3e                       ; 21 3e ac
  ld      a,(0xb16a)                      ; 3a 6a b1
  or      a                               ; b7
  jr      z,L17FD                         ; 28 0e
  ld      (hl),0xdc                       ; 36 dc
  inc     hl                              ; 23
  ld      a,(0xb1c2)                      ; 3a c2 b1
  add     a,0x30                          ; c6 30
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),0xdb                       ; 36 db
  jr      L17FF                           ; 18 02
L17FD:
  ld      (hl),0xc6                       ; 36 c6
L17FF:
  inc     hl                              ; 23
  ld      a,(0xbd8b)                      ; 3a 8b bd
  add     a,0xc7                          ; c6 c7
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),0xcc                       ; 36 cc
  inc     hl                              ; 23
  ld      a,(0xbcec)                      ; 3a ec bc
  or      a                               ; b7
  jr      z,L1812                         ; 28 02
  sub     0xc7                            ; d6 c7
L1812:
  add     a,0xc9                          ; c6 c9
  ld      (hl),a                          ; 77
  call    0xbb95                          ; cd 95 bb
  ld      a,0x80                          ; 3e 80
  ld      (0xac3e),a                      ; 32 3e ac
  ld      hl,0xe351                       ; 21 51 e3
  ld      (0xdf1c),hl                     ; 22 1c df
  ld      hl,0xe1f5                       ; 21 f5 e1
  ld      (0xd81c),hl                     ; 22 1c d8
  ld      hl,0xdaa5                       ; 21 a5 da
  ld      (0xd81f),hl                     ; 22 1f d8
  ld      hl,0xd440                       ; 21 40 d4
  ld      (0xd5ae),hl                     ; 22 ae d5
  ld      hl,0xb412                       ; 21 12 b4
  push    hl                              ; e5
  call    0xc275                          ; cd 75 c2
  call    0xddd2                          ; cd d2 dd
  call    0xb5f8                          ; cd f8 b5
  call    0xddc2                          ; cd c2 dd
  ld      hl,(0xb4ed)                     ; 2a ed b4
  ld      e,0x20                          ; 1e 20
  cp      0x71                            ; fe 71
  jp      z,0xd43a                        ; ca 3a d4
  cp      0x14                            ; fe 14
  jp      z,0xc17f                        ; ca 7f c1
  cp      0x23                            ; fe 23
  jp      z,0xd38c                        ; ca 8c d3
  cp      0x3a                            ; fe 3a
  jp      z,0xbc16                        ; ca 16 bc
  cp      0x2c                            ; fe 2c
  jp      z,0xba22                        ; ca 22 ba
  cp      0x03                            ; fe 03
  jp      z,0xd40f                        ; ca 0f d4
  ld      c,a                             ; 4f
  ld      b,0x2b                          ; 06 2b
  ld      hl,0xb4bc                       ; 21 bc b4
  ld      de,0xb53a                       ; 11 3a b5
L1871:
  ld      a,(de)                          ; 1a
  inc     de                              ; 13
  call    0xc05d                          ; cd 5d c0
  ld      a,(de)                          ; 1a
  cp      c                               ; b9
  inc     de                              ; 13
  jr      z,L1881                         ; 28 06
  djnz    L1871                           ; 10 f4
  ld      a,c                             ; 79
  jp      0xb99f                          ; c3 9f b9
L1881:
  push    hl                              ; e5
  ld      hl,(0xb4ed)                     ; 2a ed b4
  ret                                     ; c9
  call    0xb5a0                          ; cd a0 b5
  call    nz,0x2b23                       ; c4 23 2b
  dec     hl                              ; 2b
  inc     hl                              ; 23
L188E:
  ld      (0xb4ed),hl                     ; 22 ed b4
  ret                                     ; c9
  ld      hl,0xb373                       ; 21 73 b3
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  ret     z                               ; c8
  dec     (hl)                            ; 35
  add     a,a                             ; 87
  call    0xc05d                          ; cd 5d c0
  ld      a,(hl)                          ; 7e
  dec     hl                              ; 2b
  ld      l,(hl)                          ; 6e
  ld      h,a                             ; 67
  jr      L188E                           ; 18 eb
  ld      hl,0xb373                       ; 21 73 b3
  ld      a,(hl)                          ; 7e
  cp      0x0a                            ; fe 0a
  ret     nc                              ; d0
  push    hl                              ; e5
  call    0xb5a0                          ; cd a0 b5
  call    nz,0x34e3                       ; c4 e3 34
  ld      a,(hl)                          ; 7e
  add     a,a                             ; 87
  call    0xc05d                          ; cd 5d c0
  ld      de,0x0000                       ; 11 00 00
  ld      (hl),d                          ; 72
  dec     hl                              ; 2b
  ld      (hl),e                          ; 73
  pop     hl                              ; e1
  jr      L188E                           ; 18 cf
  ld      hl,0xb373                       ; 21 73 b3
  ld      a,(hl)                          ; 7e
  cp      0x0a                            ; fe 0a
  ret     nc                              ; d0
  push    hl                              ; e5
  ld      hl,(0xb4ed)                     ; 2a ed b4
  call    0xb1cf                          ; cd cf b1
  inc     hl                              ; 23
  cp      0xdd                            ; fe dd
  jr      z,L18D6                         ; 28 04
  cp      0xfd                            ; fe fd
  jr      nz,L18D7                        ; 20 01
L18D6:
  inc     hl                              ; 23
L18D7:
  call    0xb1cf                          ; cd cf b1
  push    af                              ; f5
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      h,a                             ; 67
  pop     af                              ; f1
  ld      l,a                             ; 6f
  defb    0x18, 0xcb
  call    0xbfc6                          ; cd c6 bf
  jr      L188E                           ; 18 a5
  call    0xb5a0                          ; cd a0 b5
  jp      nz,0x43cd                       ; c2 cd 43
  pop     bc                              ; c1
L18F0:
  call    0xbeaf                          ; cd af be
  call    0xb402                          ; cd 02 b4
  jr      L18F0                           ; 18 f8
  ld      ix,0xb250                       ; dd 21 50 b2
  ld      a,(ix+4)                        ; dd 7e 04
  and     0x1f                            ; e6 1f
  jp      0xc348                          ; c3 48 c3
  nop                                     ; 00
  ld      l,l                             ; 6d
  dec     b                               ; 05
  ld      a,(bc)                          ; 0a
  ld      (bc),a                          ; 02
  dec     c                               ; 0d
  dec     b                               ; 05
  ex      af,af'                          ; 08
  ld      de,0x1c0b                       ; 11 0b 1c
  inc     c                               ; 0c
  dec     h                               ; 25
  add     hl,bc                           ; 09
  dec     b                               ; 05
  halt                                    ; 76
  inc     b                               ; 04
  inc     h                               ; 24
  dec     bc                              ; 0b
  dec     b                               ; 05
  ld      h,d                             ; 62
  defb    0x20, 0x87
  ld      h,l                             ; 65
  ld      c,0x60                          ; 0e 60
  ld      b,0x78                          ; 06 78
  ld      de,0x0563                       ; 11 63 05
  ccf                                     ; 3f
  ld      c,0x74                          ; 0e 74
  inc     d                               ; 14
  ld      a,0x1e                          ; 3e 1e
  ld      l,0x05                          ; 2e 05
  ld      (hl),e                          ; 73
  dec     b                               ; 05
  ld      a,h                             ; 7c
  ld      c,d                             ; 4a
  ld      l,d                             ; 6a
  dec     b                               ; 05
  dec     l                               ; 2d
  ld      a,(de)                          ; 1a
  ld      a,c                             ; 79
  ld      l,c                             ; 69
  ld      hl,(0x6412)                     ; 2a 12 64
  ld      b,c                             ; 41
  ld      e,h                             ; 5c
  ld      hl,(0x0e77)                     ; 2a 77 0e
  ld      e,l                             ; 5d
  ld      b,l                             ; 45
  ld      e,(hl)                          ; 5e
  ld      d,0x69                          ; 16 69
  dec     b                               ; 05
  ld      a,a                             ; 7f
  ld      hl,0x0570                       ; 21 70 05
  ld      (0x3d1a),hl                     ; 22 1a 3d
  inc     b                               ; 04
  ld      l,h                             ; 6c
  ld      b,h                             ; 44
  dec     sp                              ; 3b
  inc     b                               ; 04
  ld      l,a                             ; 6f
  ld      (0x2336),a                      ; 32 36 23
  ld      h,(hl)                          ; 66
  inc     h                               ; 24
  ld      l,(hl)                          ; 6e
  dec     e                               ; 1d
  ld      h,d                             ; 62
  dec     bc                              ; 0b
  ld      h,c                             ; 61
  ld      (0xbb71),hl                     ; 22 71 bb
  ld      a,0x21                          ; 3e 21
  ld      de,0x0001                       ; 11 01 00
  ld      hl,(0xda17)                     ; 2a 17 da
  ld      (0xd115),hl                     ; 22 15 d1
  jr      L1972                           ; 18 08
  pop     hl                              ; e1
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  push    hl                              ; e5
  ld      d,0x01                          ; 16 01
  ld      a,0xc3                          ; 3e c3
L1972:
  ld      (0xb5ce),a                      ; 32 ce b5
  call    0xbb86                          ; cd 86 bb
  ld      (0xac3e),de                     ; ed 53 3e ac
  ld      (0xb5b7),sp                     ; ed 73 b7 b5
L1980:
  ld      sp,0x0000                       ; 31 00 00
  call    0xdaa5                          ; cd a5 da
  ld      hl,0xb612                       ; 21 12 b6
  ld      (0xd81c),hl                     ; 22 1c d8
  call    0xbba1                          ; cd a1 bb
  ld      hl,0xac3f                       ; 21 3f ac
  call    0xdd78                          ; cd 78 dd
  cp      0x3a                            ; fe 3a
  ret     z                               ; c8
  jp      0xc770                          ; c3 70 c7
  ld      hl,0xac3e                       ; 21 3e ac
  call    0xdd78                          ; cd 78 dd
  ld      c,0x09                          ; 0e 09
  call    0xd65c                          ; cd 5c d6
  call    0xbb70                          ; cd 70 bb
  call    0xd0fd                          ; cd fd d0
  call    0xbb70                          ; cd 70 bb
  call    0xcff2                          ; cd f2 cf
  ld      hl,(0xaf3b)                     ; 2a 3b af
  ld      (0xbb71),hl                     ; 22 71 bb
  ld      a,(0xaf63)                      ; 3a 63 af
  and     0x07                            ; e6 07
  ld      (0xb1c2),a                      ; 32 c2 b1
  xor     a                               ; af
  ret                                     ; c9
  ld      hl,(0xb249)                     ; 2a 49 b2
  push    af                              ; f5
  ld      a,l                             ; 7d
  and     0xe0                            ; e6 e0
  ld      l,a                             ; 6f
  pop     af                              ; f1
  ret                                     ; c9
  call    0xb5f8                          ; cd f8 b5
  call    0xd833                          ; cd 33 d8
  ld      h,0x01                          ; 26 01
L19D4:
  inc     hl                              ; 23
  ex      (sp),hl                         ; e3
  ex      (sp),hl                         ; e3
  inc     h                               ; 24
  dec     h                               ; 25
  jr      nz,L19D4                        ; 20 f9
  ret                                     ; c9
  call    0xb602                          ; cd 02 b6
  jr      L1980                           ; 18 9f
  call    0xb590                          ; cd 90 b5
L19E4:
  ld      hl,(0xbb71)                     ; 2a 71 bb
  call    0xc278                          ; cd 78 c2
  call    0xb593                          ; cd 93 b5
  jr      L19E4                           ; 18 f5
  ld      hl,0xbd8b                       ; 21 8b bd
L19F2:
  jp      0xd394                          ; c3 94 d3
  ld      hl,0xbcec                       ; 21 ec bc
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  jr      nz,L19FE                        ; 20 02
  ld      a,0xc7                          ; 3e c7
L19FE:
  inc     a                               ; 3c
  cp      0xca                            ; fe ca
  jr      nz,L1A04                        ; 20 01
  xor     a                               ; af
L1A04:
  ld      (hl),a                          ; 77
  ret                                     ; c9
  ld      hl,0xbfa0                       ; 21 a0 bf
  jr      L19F2                           ; 18 e7
  ld      hl,0xbf36                       ; 21 36 bf
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  jr      nz,L1A14                        ; 20 02
  ld      a,0x03                          ; 3e 03
L1A14:
  dec     a                               ; 3d
  ld      (hl),a                          ; 77
  out     (0xfe),a                        ; d3 fe
  ret                                     ; c9
L1A19:
  call    0xbc13                          ; cd 13 bc
  call    c,0xc275                        ; dc 75 c2
  call    0x1f54                          ; cd 54 1f
  jr      c,L1A19                         ; 38 f5
L1A24:
  xor     a                               ; af
  in      a,(0xfe)                        ; db fe
  cpl                                     ; 2f
  and     0x1f                            ; e6 1f
  jr      nz,L1A24                        ; 20 f8
  ret                                     ; c9
  call    0xb5a0                          ; cd a0 b5
  jp      0x7422                          ; c3 22 74
  or      (hl)                            ; b6
L1A34:
  call    0xbc13                          ; cd 13 bc
  call    nc,0xc275                       ; d4 75 c2
  ld      hl,(0xb4ed)                     ; 2a ed b4
  ld      de,0x0000                       ; 11 00 00
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  ret     z                               ; c8
  call    0x1f54                          ; cd 54 1f
  jr      nc,L1A24                        ; 30 db
  jr      L1A34                           ; 18 e9
  ld      hl,0xc368                       ; 21 68 c3
  jr      L19F2                           ; 18 a2
  call    0xbbd4                          ; cd d4 bb
  jr      L1A58                           ; 18 03
  call    0xbbc7                          ; cd c7 bb
L1A58:
  push    hl                              ; e5
  push    de                              ; d5
  call    0xb5a0                          ; cd a0 b5
  exx                                     ; d9
  xor     0x3a                            ; ee 3a
  jr      nz,L1A8B                        ; 20 29
  ld      ix,0xac10                       ; dd 21 10 ac
  ld      (ix+0),0x03                     ; dd 36 00 03
  ld      de,0xac11                       ; 11 11 ac
  inc     hl                              ; 23
  call    0xcd5f                          ; cd 5f cd
  pop     de                              ; d1
  pop     hl                              ; e1
  push    hl                              ; e5
  push    de                              ; d5
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  inc     hl                              ; 23
  ld      (0xac1d),de                     ; ed 53 1d ac
  ld      (0xac1b),hl                     ; 22 1b ac
  call    0xcea6                          ; cd a6 ce
  jp      nz,0xf653                       ; c2 53 f6
  call    0xcd3a                          ; cd 3a cd
  ld      l,0xff                          ; 2e ff
L1A8B:
  call    0xb6c7                          ; cd c7 b6
  jp      0xb20f                          ; c3 0f b2
  ld      a,l                             ; 7d
  pop     bc                              ; c1
  pop     de                              ; d1
  pop     hl                              ; e1
  push    bc                              ; c5
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  inc     hl                              ; 23
  ex      de,hl                           ; eb
  push    hl                              ; e5
  pop     ix                              ; dd e1
  ret                                     ; c9
  call    0xbbd4                          ; cd d4 bb
  jr      L1AA7                           ; 18 03
  call    0xbbc7                          ; cd c7 bb
L1AA7:
  call    0xbbdf                          ; cd df bb
  call    0xb5a0                          ; cd a0 b5
  exx                                     ; d9
  xor     0x3a                            ; ee 3a
  jp      z,0xf674                        ; ca 74 f6
L1AB3:
  call    0xb6c7                          ; cd c7 b6
  scf                                     ; 37
  call    0xb21a                          ; cd 1a b2
  ret     c                               ; d8
  jp      0xbbf0                          ; c3 f0 bb
  call    0xc143                          ; cd 43 c1
  ld      ix,0xac3e                       ; dd 21 3e ac
  ld      de,0x0012                       ; 11 12 00
  xor     a                               ; af
  scf                                     ; 37
  ex      af,af'                          ; 08
  ld      a,0x0f                          ; 3e 0f
  out     (0xfe),a                        ; d3 fe
  call    0x0562                          ; cd 62 05
  ld      ix,0xabe7                       ; dd 21 e7 ab
  jr      c,L1AE3                         ; 38 0b
  ld      hl,(0xac3e)                     ; 2a 3e ac
  ld      h,0x00                          ; 26 00
  call    0xbfb4                          ; cd b4 bf
  jp      0xc146                          ; c3 46 c1
L1AE3:
  ld      hl,0xac3f                       ; 21 3f ac
  ld      a,(hl)                          ; 7e
  add     a,0x30                          ; c6 30
  ld      (ix-3),a                        ; dd 77 fd
  ld      b,0x0a                          ; 06 0a
L1AEE:
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  cp      0x20                            ; fe 20
  jr      nc,L1AF6                        ; 30 02
  ld      a,0x3f                          ; 3e 3f
L1AF6:
  ld      (ix+0),a                        ; dd 77 00
  inc     ix                              ; dd 23
  djnz    L1AEE                           ; 10 f1
  inc     ix                              ; dd 23
  ld      hl,(0xac4c)                     ; 2a 4c ac
  push    hl                              ; e5
  call    0xbfae                          ; cd ae bf
  ld      hl,(0xac4a)                     ; 2a 4a ac
  push    hl                              ; e5
  call    0xbfae                          ; cd ae bf
  ld      hl,(0xac4e)                     ; 2a 4e ac
  call    0xbfae                          ; cd ae bf
  call    0xc146                          ; cd 46 c1
  call    0xddd2                          ; cd d2 dd
  pop     hl                              ; e1
  pop     de                              ; d1
  cp      0x6a                            ; fe 6a
  ret     nz                              ; c0
  add     hl,de                           ; 19
  dec     hl                              ; 2b
  call    0xbbdf                          ; cd df bb
  ld      l,0xff                          ; 2e ff
  jr      L1AB3                           ; 18 8c
  ld      b,0x08                          ; 06 08
  ld      hl,0xb0bb                       ; 21 bb b0
  ld      de,0xb0af                       ; 11 af b0
L1B2F:
  ld      c,(hl)                          ; 4e
  ld      a,(de)                          ; 1a
  ld      (hl),a                          ; 77
  ld      a,c                             ; 79
  ld      (de),a                          ; 12
  inc     hl                              ; 23
  inc     de                              ; 13
  djnz    L1B2F                           ; 10 f7
  ret                                     ; c9
  ld      hl,0xc91c                       ; 21 1c c9
L1B3C:
  ld      (0xb794),hl                     ; 22 94 b7
  ld      hl,0xb7a4                       ; 21 a4 b7
  ld      (0xd5ae),hl                     ; 22 ae d5
  call    0xbbd4                          ; cd d4 bb
  push    hl                              ; e5
  ld      hl,0xb7a5                       ; 21 a5 b7
  ld      (0xd81c),hl                     ; 22 1c d8
  pop     hl                              ; e1
  ex      de,hl                           ; eb
L1B51:
  push    de                              ; d5
  call    0xbeaf                          ; cd af be
  call    0xc146                          ; cd 46 c1
  push    hl                              ; e5
  ld      (0xb7a6),sp                     ; ed 73 a6 b7
  call    0x0052                          ; cd 52 00
  di                                      ; f3
L1B61:
  pop     hl                              ; e1
  pop     de                              ; d1
  call    0xbc89                          ; cd 89 bc
  jp      nc,0xb65a                       ; d2 5a b6
  call    0xad77                          ; cd 77 ad
  jr      c,L1B51                         ; 38 e3
  ret                                     ; c9
  ld      sp,0x0000                       ; 31 00 00
  call    0xbba1                          ; cd a1 bb
  call    0xb7ca                          ; cd ca b7
  jr      L1B61                           ; 18 e7
  ld      hl,0xb7a4                       ; 21 a4 b7
  ld      (0xd5ae),hl                     ; 22 ae d5
  xor     a                               ; af
  ld      (0xbfa0),a                      ; 32 a0 bf
  ld      hl,0xb7bf                       ; 21 bf b7
  jr      L1B3C                           ; 18 b3
  ld      hl,0xabe4                       ; 21 e4 ab
  ld      de,0xac3e                       ; 11 3e ac
  ld      bc,0x0020                       ; 01 20 00
  ldir                                    ; ed b0
  call    0xdaa5                          ; cd a5 da
  ld      hl,0xac3e                       ; 21 3e ac
  call    0xdd78                          ; cd 78 dd
  ld      d,0x00                          ; 16 00
  ld      c,0x09                          ; 0e 09
  jp      0xd57c                          ; c3 7c d5
  cp      0x77                            ; fe 77
  jr      nz,L1BB2                        ; 20 0a
  ld      (0xb807),hl                     ; 22 07 b8
  ld      a,(0xb1c2)                      ; 3a c2 b1
  ld      (0xb80e),a                      ; 32 0e b8
  ret                                     ; c9
L1BB2:
  push    hl                              ; e5
  ld      (0xaf47),hl                     ; 22 47 af
  ld      de,0xb82a                       ; 11 2a b8
  push    de                              ; d5
  call    0xb204                          ; cd 04 b2
  ld      hl,0xb412                       ; 21 12 b4
  ld      (0xd81c),hl                     ; 22 1c d8
  ld      a,0xc3                          ; 3e c3
  call    0xd043                          ; cd 43 d0
  ld      bc,0xb118                       ; 01 18 b1
  call    0xd0ae                          ; cd ae d0
  ld      c,0xc3                          ; 0e c3
  ld      de,0xb118                       ; 11 18 b1
  ld      a,(0xb1c2)                      ; 3a c2 b1
  push    af                              ; f5
  ld      a,0x00                          ; 3e 00
  ld      (0xb1c2),a                      ; 32 c2 b1
  call    0xb834                          ; cd 34 b8
  pop     af                              ; f1
  ld      (0xb1c2),a                      ; 32 c2 b1
  pop     hl                              ; e1
  pop     de                              ; d1
  call    0xb204                          ; cd 04 b2
  ld      a,0xff                          ; 3e ff
  ld      hl,0xb0ad                       ; 21 ad b0
  add     a,(hl)                          ; 86
  xor     (hl)                            ; ae
  and     0x7f                            ; e6 7f
  xor     (hl)                            ; ae
  ld      (hl),a                          ; 77
  ret                                     ; c9
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  call    0xb5a0                          ; cd a0 b5
  call    z,0x0eeb                        ; cc eb 0e
  call    0x6ccd                          ; cd cd 6c
  cp      l                               ; bd
  ld      (hl),c                          ; 71
  inc     hl                              ; 23
  ld      (hl),e                          ; 73
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
  inc     hl                              ; 23
  call    0xb238                          ; cd 38 b2
  jp      0xb0cb                          ; c3 cb b0
  call    0xbbd4                          ; cd d4 bb
  jr      L1C15                           ; 18 03
  call    0xbbc7                          ; cd c7 bb
L1C15:
  push    hl                              ; e5
  push    de                              ; d5
  call    0xb5a0                          ; cd a0 b5
  ret     c                               ; d8
  pop     de                              ; d1
  pop     bc                              ; c1
  push    de                              ; d5
  push    hl                              ; e5
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  add     hl,bc                           ; 09
  pop     bc                              ; c1
  call    0xbbe5                          ; cd e5 bb
  ex      de,hl                           ; eb
  sbc     hl,bc                           ; ed 42
  inc     hl                              ; 23
  ld      d,b                             ; 50
  ld      e,c                             ; 59
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  pop     hl                              ; e1
  jp      0xb1e8                          ; c3 e8 b1
  call    0xbbd4                          ; cd d4 bb
  jr      L1C3B                           ; 18 03
  call    0xbbc7                          ; cd c7 bb
L1C3B:
  call    0xbbdf                          ; cd df bb
  call    0xb5a0                          ; cd a0 b5
  rst     0x10                            ; d7
  ld      a,l                             ; 7d
  pop     de                              ; d1
  pop     hl                              ; e1
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  ret     z                               ; c8
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  ex      de,hl                           ; eb
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  inc     de                              ; 13
  jp      0xb1de                          ; c3 de b1
  call    0xb5a0                          ; cd a0 b5
  jp      nz,0x43cd                       ; c2 cd 43
  pop     bc                              ; c1
L1C59:
  ld      ix,0xabe4                       ; dd 21 e4 ab
  push    hl                              ; e5
  call    0xe0d6                          ; cd d6 e0
  pop     hl                              ; e1
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
  push    hl                              ; e5
  ld      bc,0x0500                       ; 01 00 05
L1C6A:
  push    hl                              ; e5
  call    0xb1cf                          ; cd cf b1
  ld      l,a                             ; 6f
  ld      h,0x00                          ; 26 00
  ld      a,(0xe0cd)                      ; 3a cd e0
  push    bc                              ; c5
  or      a                               ; b7
  jr      z,L1C83                         ; 28 0b
  ld      (ix+0),0x23                     ; dd 36 00 23
  inc     ix                              ; dd 23
  call    0xe0ec                          ; cd ec e0
  jr      L1C86                           ; 18 03
L1C83:
  call    0xe100                          ; cd 00 e1
L1C86:
  pop     bc                              ; c1
  inc     ix                              ; dd 23
  pop     hl                              ; e1
  inc     hl                              ; 23
  djnz    L1C6A                           ; 10 dd
  pop     hl                              ; e1
  ld      b,0x05                          ; 06 05
L1C90:
  call    0xb8f0                          ; cd f0 b8
  djnz    L1C90                           ; 10 fb
  call    0xb402                          ; cd 02 b4
  jr      L1C59                           ; 18 bf
  call    0xb5a0                          ; cd a0 b5
  jp      nz,0x43cd                       ; c2 cd 43
  pop     bc                              ; c1
L1CA1:
  ld      ix,0xabe4                       ; dd 21 e4 ab
  push    hl                              ; e5
  call    0xbfb0                          ; cd b0 bf
  pop     hl                              ; e1
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
  ld      b,0x19                          ; 06 19
L1CB0:
  call    0xb8f0                          ; cd f0 b8
  djnz    L1CB0                           ; 10 fb
  call    0xb402                          ; cd 02 b4
  jr      L1CA1                           ; 18 e7
  call    0xb1cf                          ; cd cf b1
  ld      d,a                             ; 57
  and     0x7f                            ; e6 7f
  cp      0x20                            ; fe 20
  ld      a,d                             ; 7a
  inc     hl                              ; 23
  jr      nc,L1CCA                        ; 30 04
  and     0x80                            ; e6 80
  or      0x2e                            ; f6 2e
L1CCA:
  ld      (ix+0),a                        ; dd 77 00
  inc     ix                              ; dd 23
  ret                                     ; c9
  ld      hl,0xb3eb                       ; 21 eb b3
L1CD3:
  push    hl                              ; e5
  call    0xbae5                          ; cd e5 ba
  pop     hl                              ; e1
  jr      nz,L1D4A                        ; 20 70
  ld      a,(hl)                          ; 7e
  cp      0x0b                            ; fe 0b
  ret     nc                              ; d0
  push    hl                              ; e5
  dec     a                               ; 3d
  add     a,a                             ; 87
  call    0xc05d                          ; cd 5d c0
  inc     hl                              ; 23
  push    hl                              ; e5
  call    0xb5a0                          ; cd a0 b5
  call    z,0xe1eb                        ; cc eb e1
  ld      (hl),e                          ; 73
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
  pop     hl                              ; e1
  inc     (hl)                            ; 34
  jr      L1CD3                           ; 18 e0
  ld      a,0x31                          ; 3e 31
  ld      (0xc635),a                      ; 32 35 c6
  ld      b,0x05                          ; 06 05
  ld      hl,0xb9f0                       ; 21 f0 b9
L1CFD:
  push    bc                              ; c5
  push    hl                              ; e5
  call    0xb5a0                          ; cd a0 b5
  jp      c,0x3aee                        ; da ee 3a
  ld      c,0x00                          ; 0e 00
  jr      z,L1D0A                         ; 28 01
  dec     c                               ; 0d
L1D0A:
  ld      b,l                             ; 45
  ld      hl,0xc635                       ; 21 35 c6
  inc     (hl)                            ; 34
  pop     hl                              ; e1
  ld      (hl),b                          ; 70
  inc     hl                              ; 23
  ld      (hl),c                          ; 71
  inc     hl                              ; 23
  pop     bc                              ; c1
  djnz    L1CFD                           ; 10 e6
  ld      de,(0xb4ed)                     ; ed 5b ed b4
  inc     de                              ; 13
  push    de                              ; d5
  ld      hl,0xb9f0                       ; 21 f0 b9
  ld      b,0x05                          ; 06 05
L1D22:
  ex      de,hl                           ; eb
  call    0xb1cf                          ; cd cf b1
  ex      de,hl                           ; eb
  inc     de                              ; 13
  xor     (hl)                            ; ae
  inc     hl                              ; 23
  and     (hl)                            ; a6
  inc     hl                              ; 23
  jr      nz,L1DA8                        ; 20 7a
  djnz    L1D22                           ; 10 f2
  pop     hl                              ; e1
  jp      0xb4c4                          ; c3 c4 b4
  ld      hl,0xb16a                       ; 21 6a b1
  call    0xd394                          ; cd 94 d3
  ret     nz                              ; c0
  ld      (0xb1c2),a                      ; 32 c2 b1
  ret                                     ; c9
  ld      hl,0xb1c2                       ; 21 c2 b1
  ld      a,(hl)                          ; 7e
  call    0xb1b5                          ; cd b5 b1
  and     0x07                            ; e6 07
  ld      (hl),a                          ; 77
  ret                                     ; c9
L1D4A:
  sub     0x2f                            ; d6 2f
  cp      (hl)                            ; be
  jr      nc,L1CD3                        ; 30 84
  dec     a                               ; 3d
  add     a,a                             ; 87
  ld      b,a                             ; 47
  ld      a,0x15                          ; 3e 15
  sub     b                               ; 90
  ld      c,a                             ; 4f
  ld      a,b                             ; 78
  ld      b,0x00                          ; 06 00
  push    hl                              ; e5
  call    0xc05d                          ; cd 5d c0
  inc     hl                              ; 23
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  inc     hl                              ; 23
  inc     hl                              ; 23
  ldir                                    ; ed b0
  pop     hl                              ; e1
L1D65:
  dec     (hl)                            ; 35
  jp      0xb909                          ; c3 09 b9
  cp      0x31                            ; fe 31
  ret     c                               ; d8
  cp      0x36                            ; fe 36
  ret     nc                              ; d0
  sub     0x31                            ; d6 31
  add     a,a                             ; 87
  ld      hl,0xb9e6                       ; 21 e6 b9
  call    0xc05d                          ; cd 5d c0
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ex      de,hl                           ; eb
L1D7C:
  push    hl                              ; e5
  call    0xbadf                          ; cd df ba
  pop     hl                              ; e1
  jr      nz,L1DC4                        ; 20 41
  ld      a,(hl)                          ; 7e
  cp      0x07                            ; fe 07
  ret     nc                              ; d0
  push    hl                              ; e5
  dec     a                               ; 3d
  add     a,a                             ; 87
  add     a,a                             ; 87
  add     a,0x04                          ; c6 04
  call    0xc05d                          ; cd 5d c0
  inc     hl                              ; 23
  push    hl                              ; e5
  call    0xbbd4                          ; cd d4 bb
  push    hl                              ; e5
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  pop     bc                              ; c1
  pop     hl                              ; e1
  ld      (hl),e                          ; 73
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
  inc     hl                              ; 23
  ld      (hl),c                          ; 71
  inc     hl                              ; 23
  ld      (hl),b                          ; 70
  pop     hl                              ; e1
  jr      c,L1D7C                         ; 38 d7
  inc     (hl)                            ; 34
  jr      L1D7C                           ; 18 d4
L1DA8:
  pop     de                              ; d1
  inc     de                              ; 13
  ld      a,d                             ; 7a
  or      e                               ; b3
  ret     z                               ; c8
  jp      0xb952                          ; c3 52 b9
  jr      c,L1D65                         ; 38 b3
  ld      d,(hl)                          ; 56
  or      e                               ; b3
  sub     c                               ; 91
  or      e                               ; b3
  xor     a                               ; af
  or      e                               ; b3
  call    0x00b3                          ; cd b3 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
L1DC4:
  sub     0x2e                            ; d6 2e
  cp      (hl)                            ; be
  jr      nc,L1D7C                        ; 30 b3
  dec     a                               ; 3d
  add     a,a                             ; 87
  add     a,a                             ; 87
  ld      b,a                             ; 47
  ld      a,0x15                          ; 3e 15
  sub     b                               ; 90
  ld      c,a                             ; 4f
  ld      a,b                             ; 78
  add     a,0x04                          ; c6 04
  ld      b,0x00                          ; 06 00
  push    hl                              ; e5
  call    0xc05d                          ; cd 5d c0
  inc     hl                              ; 23
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  inc     hl                              ; 23
  inc     hl                              ; 23
  inc     hl                              ; 23
  inc     hl                              ; 23
  ldir                                    ; ed b0
  pop     hl                              ; e1
  dec     (hl)                            ; 35
  jr      L1D7C                           ; 18 95
  call    0xb602                          ; cd 02 b6
  jr      L1DFF                           ; 18 13
  call    0xbb86                          ; cd 86 bb
  ld      hl,0x01c5                       ; 21 c5 01
  ld      (0xac3e),hl                     ; 22 3e ac
  ld      hl,0xba1d                       ; 21 1d ba
  ld      (0xd81c),hl                     ; 22 1c d8
  ld      (0xba36),sp                     ; ed 73 36 ba
L1DFF:
  ld      sp,0x0000                       ; 31 00 00
  call    0xdaa5                          ; cd a5 da
  call    0xbba1                          ; cd a1 bb
  ld      b,0x18                          ; 06 18
  ld      ix,0xb265                       ; dd 21 65 b2
L1E0E:
  ld      hl,0xac3f                       ; 21 3f ac
  call    0xdd78                          ; cd 78 dd
  ld      a,(ix+2)                        ; dd 7e 02
  bit     7,a                             ; cb 7f
  jr      nz,L1E2D                        ; 20 12
  ld      de,0xe5f0                       ; 11 f0 e5
  call    0xda73                          ; cd 73 da
  ld      a,(de)                          ; 1a
  xor     (hl)                            ; ae
  and     0x5f                            ; e6 5f
  jr      nz,L1E3A                        ; 20 13
  inc     de                              ; 13
  inc     hl                              ; 23
  call    0xdd78                          ; cd 78 dd
  ld      a,(de)                          ; 1a
L1E2D:
  xor     (hl)                            ; ae
  and     0x5f                            ; e6 5f
  jr      nz,L1E3A                        ; 20 08
  inc     hl                              ; 23
  call    0xdd78                          ; cd 78 dd
  cp      0x41                            ; fe 41
  jr      c,L1E69                         ; 38 2f
L1E3A:
  ld      de,0x0007                       ; 11 07 00
  add     ix,de                           ; dd 19
  djnz    L1E0E                           ; 10 cd
  jp      0xd7fa                          ; c3 fa d7
L1E44:
  call    0xdd78                          ; cd 78 dd
  or      0x20                            ; f6 20
  push    hl                              ; e5
  ld      hl,0xba8f                       ; 21 8f ba
  ld      b,0x04                          ; 06 04
L1E4F:
  cp      (hl)                            ; be
  inc     hl                              ; 23
  defb    0x28, 0x0e
  inc     hl                              ; 23
  djnz    L1E4F                           ; 10 f9
  pop     hl                              ; e1
  jr      L1E71                           ; 18 18
  ld      (hl),e                          ; 73
  add     a,b                             ; 80
  ld      a,d                             ; 7a
  ld      b,b                             ; 40
  ld      (hl),b                          ; 70
  inc     b                               ; 04
  ld      h,e                             ; 63
  ld      bc,0xc111                       ; 01 11 c1
  or      b                               ; b0
  ld      a,(de)                          ; 1a
  xor     (hl)                            ; ae
  ld      (de),a                          ; 12
  pop     hl                              ; e1
  ret                                     ; c9
L1E69:
  inc     hl                              ; 23
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0xc6                            ; fe c6
  jr      z,L1E44                         ; 28 d3
L1E71:
  push    ix                              ; dd e5
  call    0xc773                          ; cd 73 c7
  pop     ix                              ; dd e1
  ex      de,hl                           ; eb
  ld      l,(ix+5)                        ; dd 6e 05
  ld      h,(ix+6)                        ; dd 66 06
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0xd8                            ; fe d8
  jr      nc,L1E8C                        ; 30 06
  bit     3,(ix+3)                        ; dd cb 03 5e
  jr      z,L1E8F                         ; 28 03
L1E8C:
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
  dec     hl                              ; 2b
L1E8F:
  ld      (hl),e                          ; 73
  ret                                     ; c9
  ld      b,0x00                          ; 06 00
  push    hl                              ; e5
  ld      hl,0xc4d0                       ; 21 d0 c4
  add     hl,bc                           ; 09
  ld      c,(hl)                          ; 4e
  add     hl,bc                           ; 09
L1E9A:
  ld      a,(hl)                          ; 7e
  cp      0x80                            ; fe 80
  res     7,a                             ; cb bf
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  jr      c,L1E9A                         ; 38 f6
  xor     a                               ; af
  ld      (de),a                          ; 12
  inc     de                              ; 13
  pop     hl                              ; e1
  ret                                     ; c9
  ld      a,0x37                          ; 3e 37
  ld      c,0x35                          ; 0e 35
  jr      L1EB3                           ; 18 04
  ld      a,0xb7                          ; 3e b7
  ld      c,0x39                          ; 0e 39
L1EB3:
  ld      (0xbb02),a                      ; 32 02 bb
  ld      (0xbb11),a                      ; 32 11 bb
  ld      (0xbb2c),a                      ; 32 2c bb
  ld      a,c                             ; 79
  ld      (0xbb41),a                      ; 32 41 bb
  call    0xc143                          ; cd 43 c1
  dec     hl                              ; 2b
  ld      c,(hl)                          ; 4e
  inc     hl                              ; 23
  ld      de,0xabe4                       ; 11 e4 ab
  call    0xbac7                          ; cd c7 ba
  scf                                     ; 37
  ld      c,0xd6                          ; 0e d6
  call    c,0xbac7                        ; dc c7 ba
  call    0xc146                          ; cd 46 c1
  ld      a,0x2f                          ; 3e 2f
  ld      (0xabe4),a                      ; 32 e4 ab
  ld      a,(hl)                          ; 7e
  scf                                     ; 37
  jr      nc,L1EE3                        ; 30 05
  dec     a                               ; 3d
  ld      bc,0x0008                       ; 01 08 00
  add     hl,bc                           ; 09
L1EE3:
  inc     hl                              ; 23
L1EE4:
  ld      ix,0xabe6                       ; dd 21 e6 ab
  dec     a                               ; 3d
  jr      z,L1F00                         ; 28 15
  push    af                              ; f5
  inc     (ix-2)                          ; dd 34 fe
  ld      (ix-1),0x3a                     ; dd 36 ff 3a
  call    0xbb46                          ; cd 46 bb
  scf                                     ; 37
  call    c,0xbb46                        ; dc 46 bb
  call    0xc146                          ; cd 46 c1
  pop     af                              ; f1
  jr      L1EE4                           ; 18 e4
L1F00:
  call    0xddd2                          ; cd d2 dd
  cp      0x69                            ; fe 69
  ret     z                               ; c8
  cp      0x30                            ; fe 30
  jr      c,L1F0D                         ; 38 03
  cp      0x35                            ; fe 35
  ret     c                               ; d8
L1F0D:
  jp      0xb412                          ; c3 12 b4
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  inc     hl                              ; 23
  push    hl                              ; e5
  ex      de,hl                           ; eb
  push    hl                              ; e5
  call    0xbfb0                          ; cd b0 bf
  pop     de                              ; d1
  call    0xb025                          ; cd 25 b0
  push    ix                              ; dd e5
  ld      b,0x0a                          ; 06 0a
L1F22:
  ld      (ix+0),0x20                     ; dd 36 00 20
  inc     ix                              ; dd 23
  djnz    L1F22                           ; 10 f8
  pop     hl                              ; e1
  jr      c,L1F38                         ; 38 0b
  push    hl                              ; e5
  call    0xd8a5                          ; cd a5 d8
  pop     hl                              ; e1
  inc     hl                              ; 23
  ld      b,0x09                          ; 06 09
  call    0xda99                          ; cd 99 da
L1F38:
  pop     hl                              ; e1
  ret                                     ; c9
  ld      hl,0x0000                       ; 21 00 00
  ld      (0xaf3b),hl                     ; 22 3b af
  ld      (0xaf47),hl                     ; 22 47 af
  ld      a,(0xb1c2)                      ; 3a c2 b1
  or      0x10                            ; f6 10
  ld      (0xaf63),a                      ; 32 63 af
  ld      ix,0xac61                       ; dd 21 61 ac
  ret                                     ; c9
  ld      hl,0xac3d                       ; 21 3d ac
  ld      (hl),0x80                       ; 36 80
  inc     hl                              ; 23
  ld      (hl),0x01                       ; 36 01
  inc     hl                              ; 23
  ld      bc,0x2000                       ; 01 00 20
  jp      0xdaab                          ; c3 ab da
  ld      hl,0xc4d0                       ; 21 d0 c4
  ld      (0xdf1c),hl                     ; 22 1c df
  call    0xb5f8                          ; cd f8 b5
  jp      0xdd91                          ; c3 91 dd
L1F6B:
  call    0xbb95                          ; cd 95 bb
  call    0xde03                          ; cd 03 de
  cp      0x80                            ; fe 80
  jr      nc,L1F6B                        ; 30 f6
  cp      0x04                            ; fe 04
  jp      z,0xb412                        ; ca 12 b4
  cp      0x03                            ; fe 03
  jr      nz,L1F86                        ; 20 08
  ld      hl,(0xd5b1)                     ; 2a b1 d5
  dec     hl                              ; 2b
  bit     7,(hl)                          ; cb 7e
  jr      nz,L1F6B                        ; 20 e5
L1F86:
  call    0xd5b0                          ; cd b0 d5
  jr      nz,L1F6B                        ; 20 e0
  call    0xb5f8                          ; cd f8 b5
  jp      0xddc2                          ; c3 c2 dd
  call    0xb5a0                          ; cd a0 b5
  jp      nz,0xcde5                       ; c2 e5 cd
  and     b                               ; a0
  or      l                               ; b5
  pop     bc                              ; c1
  pop     de                              ; d1
  add     hl,de                           ; 19
  dec     hl                              ; 2b
  ret                                     ; c9
  call    0xb5a0                          ; cd a0 b5
  jp      nz,0xcde5                       ; c2 e5 cd
  and     b                               ; a0
  or      l                               ; b5
  jp      0xc9d1                          ; c3 d1 c9
  pop     af                              ; f1
  push    hl                              ; e5
  push    de                              ; d5
  push    af                              ; f5
  ld      b,d                             ; 42
  ld      c,e                             ; 4b
  ex      de,hl                           ; eb
  call    0xc062                          ; cd 62 c0
  ld      hl,0xbc04                       ; 21 04 bc
  ld      (0xd81f),hl                     ; 22 1f d8
  ret     nc                              ; d0
  ld      a,0xcd                          ; 3e cd
  call    0xbb86                          ; cd 86 bb
  ld      hl,0xac3e                       ; 21 3e ac
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),0xd0                       ; 36 d0
  call    0xbb95                          ; cd 95 bb
  ld      a,0x00                          ; 3e 00
  ld      (0xb0ad),a                      ; 32 ad b0
  call    0xc275                          ; cd 75 c2
  call    0xdede                          ; cd de de
  call    0xde03                          ; cd 03 de
  call    0xb65a                          ; cd 5a b6
  jp      0xb412                          ; c3 12 b4
  ld      hl,(0xb4ed)                     ; 2a ed b4
  push    hl                              ; e5
  call    0xbfc6                          ; cd c6 bf
  ex      af,af'                          ; 08
  jp      nz,0xb412                       ; c2 12 b4
  ld      (0xb137),hl                     ; 22 37 b1
  ld      (0xb114),hl                     ; 22 14 b1
  ld      (0xbe8b),de                     ; ed 53 8b be
  push    bc                              ; c5
  ld      a,(0xb0ad)                      ; 3a ad b0
  ld      (0xbc00),a                      ; 32 00 bc
  call    0xbd7a                          ; cd 7a bd
  pop     bc                              ; c1
  pop     de                              ; d1
  push    bc                              ; c5
  call    0xb225                          ; cd 25 b2
  pop     bc                              ; c1
  ld      hl,0xc566                       ; 21 66 c5
  call    0xbe2a                          ; cd 2a be
  jr      c,L202B                         ; 38 20
  ld      hl,0xbcaa                       ; 21 aa bc
  call    0xc05d                          ; cd 5d c0
  ld      a,(hl)                          ; 7e
  ld      hl,0xbcb2                       ; 21 b2 bc
  call    0xc05d                          ; cd 5d c0
  ld      bc,0xbca9                       ; 01 a9 bc
  ld      a,(0xb134)                      ; 3a 34 b1
  call    0xbef8                          ; cd f8 be
  ld      (0xb114),hl                     ; 22 14 b1
  ld      (0xbc7c),bc                     ; ed 43 7c bc
  ld      (0xb111),a                      ; 32 11 b1
L202B:
  call    0xb0cb                          ; cd cb b0
  ex      af,af'                          ; 08
  push    af                              ; f5
  exx                                     ; d9
  push    hl                              ; e5
  exx                                     ; d9
  pop     de                              ; d1
  ld      hl,0xb3cd                       ; 21 cd b3
  ld      a,(0xbd8b)                      ; 3a 8b bd
  or      a                               ; b7
  call    z,0xc11c                        ; cc 1c c1
  ld      a,0xce                          ; 3e ce
  jp      c,0xbbf2                        ; da f2 bb
  pop     af                              ; f1
  or      a                               ; b7
  call    nz,0xbca9                       ; c4 a9 bc
  exx                                     ; d9
  ld      (0xb4ed),hl                     ; 22 ed b4
  ld      hl,(0xb0c5)                     ; 2a c5 b0
  add     hl,de                           ; 19
  ld      (0xb0c5),hl                     ; 22 c5 b0
  ld      a,0xbf                          ; 3e bf
  jp      0x1f56                          ; c3 56 1f
  ld      hl,(0xb0c3)                     ; 2a c3 b0
  ld      de,(0xb137)                     ; ed 5b 37 b1
  push    af                              ; f5
  ld      a,e                             ; 7b
  call    0xb1d6                          ; cd d6 b1
  inc     hl                              ; 23
  ld      a,d                             ; 7a
  call    0xb1d6                          ; cd d6 b1
  pop     af                              ; f1
  ret                                     ; c9
  ld      hl,(0xb0c3)                     ; 2a c3 b0
  inc     hl                              ; 23
  inc     hl                              ; 23
  ld      (0xb0c3),hl                     ; 22 c3 b0
  ret                                     ; c9
  nop                                     ; 00
  add     hl,de                           ; 19
  ld      c,a                             ; 4f
  ld      (hl),d                          ; 72
  add     a,a                             ; 87
  adc     a,h                             ; 8c
  sub     c                               ; 91
  and     b                               ; a0
  ld      hl,0xac62                       ; 21 62 ac
  push    af                              ; f5
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  pop     af                              ; f1
  ld      (hl),0x03                       ; 36 03
  ld      hl,(0xb137)                     ; 2a 37 b1
  ld      d,0x00                          ; 16 00
  bit     7,e                             ; cb 7b
  jr      z,L2091                         ; 28 01
  dec     d                               ; 15
L2091:
  add     hl,de                           ; 19
  add     a,0x05                          ; c6 05
  ret                                     ; c9
L2095:
  cp      0x0a                            ; fe 0a
  jr      z,L20C0                         ; 28 27
  exx                                     ; d9
  ld      de,(0xac62)                     ; ed 5b 62 ac
  ld      (0xbce9),sp                     ; ed 73 e9 bc
  ld      hl,0xb3eb                       ; 21 eb b3
  ld      b,(hl)                          ; 46
  inc     hl                              ; 23
  ld      sp,hl                           ; f9
L20A8:
  djnz    L20AC                           ; 10 02
  jr      L20B2                           ; 18 06
L20AC:
  pop     hl                              ; e1
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  jr      nz,L20A8                        ; 20 f6
L20B2:
  ld      sp,0x0000                       ; 31 00 00
  exx                                     ; d9
  nop                                     ; 00
  add     a,0x08                          ; c6 08
  ld      hl,0xb134                       ; 21 34 b1
  inc     (hl)                            ; 34
  ld      bc,0xbc8e                       ; 01 8e bc
L20C0:
  ld      hl,(0xac62)                     ; 2a 62 ac
  ld      de,0xac67                       ; 11 67 ac
  ld      (0xac62),de                     ; ed 53 62 ac
  ret                                     ; c9
  ld      hl,(0xb0c3)                     ; 2a c3 b0
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      d,a                             ; 57
  ld      hl,0xac61                       ; 21 61 ac
  ld      a,(hl)                          ; 7e
  add     a,0x02                          ; c6 02
  cp      0xcb                            ; fe cb
  jr      nz,L20E3                        ; 20 02
  sub     0x08                            ; d6 08
L20E3:
  ld      (hl),a                          ; 77
  call    0xb243                          ; cd 43 b2
  ld      a,0x0a                          ; 3e 0a
  ld      bc,0xbca1                       ; 01 a1 bc
  jr      L20FE                           ; 18 10
  ld      hl,0xac61                       ; 21 61 ac
  ld      a,(hl)                          ; 7e
  and     0x38                            ; e6 38
  ld      (hl),0xcd                       ; 36 cd
  inc     hl                              ; 23
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),0x00                       ; 36 00
  inc     hl                              ; 23
  ld      a,0x03                          ; 3e 03
L20FE:
  call    0xb238                          ; cd 38 b2
  jr      L2095                           ; 18 92
  ld      hl,(0xb0bf)                     ; 2a bf b0
  jr      L2114                           ; 18 0c
  ld      hl,(0xb0b9)                     ; 2a b9 b0
  jr      L2110                           ; 18 03
  ld      hl,(0xb0b7)                     ; 2a b7 b0
L2110:
  xor     a                               ; af
  ld      (0xac62),a                      ; 32 62 ac
L2114:
  xor     a                               ; af
  ld      (0xac61),a                      ; 32 61 ac
  ld      (0xb137),hl                     ; 22 37 b1
  ret                                     ; c9
  ld      bc,0xbca1                       ; 01 a1 bc
  ld      hl,(0xb0c3)                     ; 2a c3 b0
  push    af                              ; f5
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      d,a                             ; 57
  ex      de,hl                           ; eb
  pop     af                              ; f1
  jr      L2110                           ; 18 e0
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  ret                                     ; c9
  ld      hl,0xac60                       ; 21 60 ac
  ld      a,(0xc368)                      ; 3a 68 c3
  add     a,a                             ; 87
  add     a,a                             ; 87
  add     a,a                             ; 87
  add     a,0xf3                          ; c6 f3
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ret                                     ; c9
  ld      a,b                             ; 78
  sub     0x76                            ; d6 76
  or      c                               ; b1
  jr      nz,L2154                        ; 20 0a
  ld      a,(0xc368)                      ; 3a 68 c3
  or      a                               ; b7
  ret     nz                              ; c0
  ld      a,0xcf                          ; 3e cf
  jp      0xbbf2                          ; c3 f2 bb
L2154:
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  ret     nz                              ; c0
  ld      a,c                             ; 79
  and     0x40                            ; e6 40
  jr      z,L21B4                         ; 28 57
  ld      a,b                             ; 78
  exx                                     ; d9
  cp      0xb0                            ; fe b0
  ld      bc,(0xb0bb)                     ; ed 4b bb b0
  ld      de,(0xb0bd)                     ; ed 5b bd b0
  ld      hl,(0xb0bf)                     ; 2a bf b0
  jr      nz,L2178                        ; 20 0a
  push    hl                              ; e5
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  push    hl                              ; e5
  ex      de,hl                           ; eb
  push    hl                              ; e5
  add     hl,bc                           ; 09
  dec     hl                              ; 2b
  jr      L218A                           ; 18 12
L2178:
  cp      0xb8                            ; fe b8
  jr      nz,L21B3                        ; 20 37
  push    hl                              ; e5
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
  inc     hl                              ; 23
  ex      (sp),hl                         ; e3
  push    hl                              ; e5
  ex      de,hl                           ; eb
  push    hl                              ; e5
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
  inc     hl                              ; 23
  ex      (sp),hl                         ; e3
L218A:
  push    hl                              ; e5
  ld      h,b                             ; 60
  ld      l,c                             ; 69
  ld      de,0x0015                       ; 11 15 00
  call    0xd2a2                          ; cd a2 d2
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ld      (0xb134),hl                     ; 22 34 b1
  ld      hl,0xb3af                       ; 21 af b3
  pop     de                              ; d1
  pop     bc                              ; c1
  call    0xc072                          ; cd 72 c0
  jp      c,0xbbf0                        ; da f0 bb
  ld      hl,0xb391                       ; 21 91 b3
  pop     de                              ; d1
  pop     bc                              ; c1
  call    0xc072                          ; cd 72 c0
  jp      c,0xbbf0                        ; da f0 bb
  exx                                     ; d9
  ret                                     ; c9
L21B3:
  exx                                     ; d9
L21B4:
  ld      hl,0xc4b9                       ; 21 b9 c4
  push    de                              ; d5
  call    0xbe2a                          ; cd 2a be
  ld      hl,0xb391                       ; 21 91 b3
  call    0xbe01                          ; cd 01 be
  ld      hl,0xc50b                       ; 21 0b c5
  pop     de                              ; d1
  call    0xbe2a                          ; cd 2a be
  ld      hl,0xb3af                       ; 21 af b3
  ret     c                               ; d8
  push    hl                              ; e5
  push    af                              ; f5
  ld      hl,0xbe5b                       ; 21 5b be
  call    0xc05d                          ; cd 5d c0
  ld      a,(hl)                          ; 7e
  ld      hl,0xbe63                       ; 21 63 be
  call    0xc05d                          ; cd 5d c0
  call    0xbef8                          ; cd f8 be
  pop     af                              ; f1
  ex      (sp),hl                         ; e3
  pop     de                              ; d1
  push    af                              ; f5
  push    hl                              ; e5
  call    0xc11c                          ; cd 1c c1
  pop     hl                              ; e1
  jp      c,0xbbf0                        ; da f0 bb
  pop     af                              ; f1
  ret     z                               ; c8
  inc     de                              ; 13
  call    0xc11c                          ; cd 1c c1
  jp      c,0xbbf0                        ; da f0 bb
  ret                                     ; c9
  ld      a,c                             ; 79
  and     0xf0                            ; e6 f0
  ld      c,a                             ; 4f
  ld      d,(hl)                          ; 56
  inc     hl                              ; 23
L21FA:
  ld      a,b                             ; 78
  and     (hl)                            ; a6
  inc     hl                              ; 23
  cp      (hl)                            ; be
  inc     hl                              ; 23
  jr      z,L2207                         ; 28 06
L2201:
  inc     hl                              ; 23
  dec     d                               ; 15
  jr      nz,L21FA                        ; 20 f5
  scf                                     ; 37
  ret                                     ; c9
L2207:
  ld      a,(hl)                          ; 7e
  and     0xf0                            ; e6 f0
  cp      c                               ; b9
  jr      nz,L2201                        ; 20 f4
  ld      a,(hl)                          ; 7e
  and     0x0f                            ; e6 0f
  bit     3,a                             ; cb 5f
  res     3,a                             ; cb 9f
  ret                                     ; c9
  ld      hl,0xbe5b                       ; 21 5b be
  call    0xc05d                          ; cd 5d c0
  ld      a,(hl)                          ; 7e
  ld      hl,0xbe63                       ; 21 63 be
  call    0xc05d                          ; cd 5d c0
  call    0xbef8                          ; cd f8 be
  nop                                     ; 00
  inc     b                               ; 04
  ex      af,af'                          ; 08
  inc     c                               ; 0c
  ld      de,0x211d                       ; 11 1d 21
  daa                                     ; 27
  ld      hl,(0xb0bb)                     ; 2a bb b0
  ret                                     ; c9
  ld      hl,(0xb0bd)                     ; 2a bd b0
  ret                                     ; c9
  ld      hl,(0xb0bf)                     ; 2a bf b0
  ret                                     ; c9
  ld      hl,(0xb0b9)                     ; 2a b9 b0
  jr      L2241                           ; 18 03
  ld      hl,(0xb0b7)                     ; 2a b7 b0
L2241:
  bit     7,e                             ; cb 7b
  ld      d,0x00                          ; 16 00
  jr      z,L2248                         ; 28 01
  dec     d                               ; 15
L2248:
  add     hl,de                           ; 19
  ret                                     ; c9
  ld      hl,(0xb0c3)                     ; 2a c3 b0
  ret                                     ; c9
  ld      hl,(0xb0c3)                     ; 2a c3 b0
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ret                                     ; c9
  ld      hl,0x0000                       ; 21 00 00
  ret                                     ; c9
L2258:
  push    af                              ; f5
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      d,a                             ; 57
  pop     af                              ; f1
  ld      bc,0x0937                       ; 01 37 09
  jr      L2276                           ; 18 0e
L2268:
  ld      hl,(0xbf2f)                     ; 2a 2f bf
  push    af                              ; f5
  ld      d,0x00                          ; 16 00
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  pop     af                              ; f1
  ld      bc,0x0637                       ; 01 37 06
L2276:
  inc     hl                              ; 23
  jr      L22A8                           ; 18 2f
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  jr      z,L228D                         ; 28 0f
  ld      a,0x20                          ; 3e 20
  ld      b,a                             ; 47
  ld      de,0xabe4                       ; 11 e4 ab
L2284:
  ld      (de),a                          ; 12
  inc     de                              ; 13
  djnz    L2284                           ; 10 fc
  xor     a                               ; af
  ld      (0xbeb0),a                      ; 32 b0 be
  ret                                     ; c9
L228D:
  ld      (0xbf2f),hl                     ; 22 2f bf
  ex      de,hl                           ; eb
  ld      hl,0xb338                       ; 21 38 b3
  call    0xc11c                          ; cd 1c c1
  jr      c,L2268                         ; 38 cf
  ld      hl,0xb356                       ; 21 56 b3
  call    0xc11c                          ; cd 1c c1
  ex      de,hl                           ; eb
  jr      c,L2258                         ; 38 b6
  call    0xbfc6                          ; cd c6 bf
  ex      af,af'                          ; 08
  jr      nz,L2268                        ; 20 c0
L22A8:
  push    hl                              ; e5
  ld      ix,0xac62                       ; dd 21 62 ac
  ld      (ix-1),c                        ; dd 71 ff
  ld      (ix-2),b                        ; dd 70 fe
  ld      a,c                             ; 79
  and     0x07                            ; e6 07
  ld      c,a                             ; 4f
  ld      b,0x00                          ; 06 00
  ld      hl,0xbef9                       ; 21 f9 be
  add     hl,bc                           ; 09
  ld      c,(hl)                          ; 4e
  ld      hl,0xbf0e                       ; 21 0e bf
  add     hl,bc                           ; 09
  jp      (hl)                            ; e9
  ld      e,e                             ; 5b
  ld      d,l                             ; 55
  daa                                     ; 27
  add     hl,de                           ; 19
  nop                                     ; 00
  dec     b                               ; 05
  ld      c,h                             ; 4c
  daa                                     ; 27
  bit     7,e                             ; cb 7b
  ret     z                               ; c8
  ld      (ix+0),0x2d                     ; dd 36 00 2d
  inc     ix                              ; dd 23
  xor     a                               ; af
  sub     e                               ; 93
  ld      e,a                             ; 5f
  ret                                     ; c9
  call    0xbf01                          ; cd 01 bf
  jr      L232D                           ; 18 50
  call    0xbf01                          ; cd 01 bf
  ld      h,0x00                          ; 26 00
  ld      l,e                             ; 6b
  push    de                              ; d5
  call    0xbfb4                          ; cd b4 bf
  pop     de                              ; d1
  ld      e,d                             ; 5a
  ld      (ix+0),0x1f                     ; dd 36 00 1f
  inc     ix                              ; dd 23
  jr      L232D                           ; 18 3c
  ld      d,0x00                          ; 16 00
  bit     7,e                             ; cb 7b
  jr      z,L22F8                         ; 28 01
  dec     d                               ; 15
L22F8:
  ld      hl,0x0000                       ; 21 00 00
  inc     hl                              ; 23
  inc     hl                              ; 23
  add     hl,de                           ; 19
  ex      de,hl                           ; eb
  ld      c,0x00                          ; 0e 00
  dec     c                               ; 0d
  jr      z,L232F                         ; 28 2b
  call    0xb025                          ; cd 25 b0
  jr      c,L230E                         ; 38 05
  call    0xbfb9                          ; cd b9 bf
  jr      L2333                           ; 18 25
L230E:
  dec     c                               ; 0d
  jr      z,L232F                         ; 28 1e
  dec     de                              ; 1b
  call    0xb025                          ; cd 25 b0
  inc     de                              ; 13
  jr      c,L232F                         ; 38 17
  dec     de                              ; 1b
  call    0xbfb9                          ; cd b9 bf
  ld      de,0x2b31                       ; 11 31 2b
  call    0xbfbb                          ; cd bb bf
  jr      L2333                           ; 18 0f
  ld      hl,(0xbf2f)                     ; 2a 2f bf
  call    0xb1cf                          ; cd cf b1
  and     0x38                            ; e6 38
  ld      e,a                             ; 5f
L232D:
  ld      d,0x00                          ; 16 00
L232F:
  ex      de,hl                           ; eb
  call    0xbfb4                          ; cd b4 bf
L2333:
  ld      (ix+0),0xc0                     ; dd 36 00 c0
  ld      hl,0xabe4                       ; 21 e4 ab
  push    hl                              ; e5
  ld      bc,0x2000                       ; 01 00 20
  call    0xdaab                          ; cd ab da
  pop     hl                              ; e1
  ld      ix,0xac60                       ; dd 21 60 ac
  call    0xd8e4                          ; cd e4 d8
  ld      ix,0xabe4                       ; dd 21 e4 ab
  ld      de,(0xbf2f)                     ; ed 5b 2f bf
  ld      a,(0xbf36)                      ; 3a 36 bf
  dec     a                               ; 3d
  jr      z,L2369                         ; 28 12
  call    0xb025                          ; cd 25 b0
  jr      c,L2369                         ; 38 0d
  call    0xd8a5                          ; cd a5 d8
  ld      b,0x09                          ; 06 09
  push    ix                              ; dd e5
  pop     hl                              ; e1
  call    0xda99                          ; cd 99 da
  jr      L2376                           ; 18 0d
L2369:
  ld      a,0x01                          ; 3e 01
  dec     a                               ; 3d
  jr      nz,L2376                        ; 20 08
  ex      de,hl                           ; eb
  call    0xbfb0                          ; cd b0 bf
  ld      (ix+0),0x20                     ; dd 36 00 20
L2376:
  pop     hl                              ; e1
  ret                                     ; c9
  inc     ix                              ; dd 23
  ld      c,0x00                          ; 0e 00
  jr      L2380                           ; 18 02
  ld      c,0x01                          ; 0e 01
L2380:
  jp      0xe0d6                          ; c3 d6 e0
  set     7,d                             ; cb fa
  ld      (ix+0),d                        ; dd 72 00
  inc     ix                              ; dd 23
  ld      (ix+0),e                        ; dd 73 00
  inc     ix                              ; dd 23
  ret                                     ; c9
  call    0xb1cf                          ; cd cf b1
  and     0xc7                            ; e6 c7
  cp      0xc7                            ; fe c7
  ld      b,a                             ; 47
  ld      c,0x00                          ; 0e 00
  jr      z,L23D7                         ; 28 3b
  call    0xb1cf                          ; cd cf b1
  ld      c,0x40                          ; 0e 40
  cp      0xed                            ; fe ed
  jr      z,L23D2                         ; 28 2d
  ld      c,0x00                          ; 0e 00
  cp      0xdd                            ; fe dd
  jr      nz,L23AF                        ; 20 04
  set     5,c                             ; cb e9
  jr      L23B5                           ; 18 06
L23AF:
  cp      0xfd                            ; fe fd
  jr      nz,L23CC                        ; 20 19
  set     4,c                             ; cb e1
L23B5:
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  cp      0xcb                            ; fe cb
  jr      nz,L23D3                        ; 20 16
  set     7,c                             ; cb f9
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      b,a                             ; 47
  push    hl                              ; e5
  jr      L23E2                           ; 18 16
L23CC:
  cp      0xcb                            ; fe cb
  jr      nz,L23D3                        ; 20 03
  set     7,c                             ; cb f9
L23D2:
  inc     hl                              ; 23
L23D3:
  call    0xb1cf                          ; cd cf b1
  ld      b,a                             ; 47
L23D7:
  inc     hl                              ; 23
  push    hl                              ; e5
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      d,a                             ; 57
L23E2:
  push    de                              ; d5
  ld      a,c                             ; 79
  cp      0x3f                            ; fe 3f
  jr      nc,L23FB                        ; 30 13
  cp      0x10                            ; fe 10
  ld      a,b                             ; 78
  jr      nc,L23F9                        ; 30 0c
  cp      0x18                            ; fe 18
  jr      z,L23FF                         ; 28 0e
  cp      0xc9                            ; fe c9
  jr      z,L23FF                         ; 28 0a
  cp      0xc3                            ; fe c3
  jr      z,L23FF                         ; 28 06
L23F9:
  cp      0xe9                            ; fe e9
L23FB:
  ld      a,0x00                          ; 3e 00
  jr      nz,L2401                        ; 20 02
L23FF:
  ld      a,0x01                          ; 3e 01
L2401:
  ld      (0xbeb0),a                      ; 32 b0 be
  push    bc                              ; c5
  call    0xdae6                          ; cd e6 da
  ex      af,af'                          ; 08
  pop     bc                              ; c1
  ld      a,(hl)                          ; 7e
  and     0x1f                            ; e6 1f
  ld      (0xb134),a                      ; 32 34 b1
  xor     a                               ; af
  ld      (0xb135),a                      ; 32 35 b1
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ld      a,(hl)                          ; 7e
  and     0x07                            ; e6 07
  or      c                               ; b1
  ld      c,a                             ; 4f
  pop     de                              ; d1
  and     0x07                            ; e6 07
  ld      hl,0xd155                       ; 21 55 d1
  call    0xc05d                          ; cd 5d c0
  ld      a,(hl)                          ; 7e
  pop     hl                              ; e1
  add     a,l                             ; 85
  ld      l,a                             ; 6f
  ret     nc                              ; d0
  inc     h                               ; 24
  ret                                     ; c9
  exx                                     ; d9
  push    bc                              ; c5
  push    de                              ; d5
  push    hl                              ; e5
  exx                                     ; d9
  ld      (0xc0a8),sp                     ; ed 73 a8 c0
  ld      a,0x02                          ; 3e 02
  ld      sp,0xb3b0                       ; 31 b0 b3
  jr      L2448                           ; 18 0c
  exx                                     ; d9
  push    bc                              ; c5
  push    de                              ; d5
  push    hl                              ; e5
  exx                                     ; d9
  ld      (0xc0a8),sp                     ; ed 73 a8 c0
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  ld      sp,hl                           ; f9
L2448:
  ld      hl,0xc084                       ; 21 84 c0
  jp      0xc0b0                          ; c3 b0 c0
L244E:
  and     a                               ; a7
  dec     a                               ; 3d
  jr      z,L2471                         ; 28 1f
  ex      af,af'                          ; 08
  xor     a                               ; af
  ld      h,d                             ; 62
  ld      l,e                             ; 6b
  sbc     hl,bc                           ; ed 42
  ccf                                     ; 3f
  adc     a,0x00                          ; ce 00
  pop     hl                              ; e1
  sbc     hl,de                           ; ed 52
  jr      z,L2463                         ; 28 03
  ccf                                     ; 3f
  adc     a,0x00                          ; ce 00
L2463:
  pop     hl                              ; e1
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
  adc     a,0x00                          ; ce 00
  cp      0x02                            ; fe 02
  scf                                     ; 37
  jr      nz,L2471                        ; 20 03
  ex      af,af'                          ; 08
  jr      L244E                           ; 18 dd
L2471:
  ld      sp,0x0000                       ; 31 00 00
  exx                                     ; d9
  pop     hl                              ; e1
  pop     de                              ; d1
  pop     bc                              ; c1
  exx                                     ; d9
  ret                                     ; c9
  exx                                     ; d9
  ex      af,af'                          ; 08
  pop     de                              ; d1
  pop     de                              ; d1
  pop     de                              ; d1
  pop     de                              ; d1
  ld      de,(0xd098)                     ; ed 5b 98 d0
  ld      bc,0xabe0                       ; 01 e0 ab
  ld      a,(0xb1c2)                      ; 3a c2 b1
  and     0x07                            ; e6 07
  jr      z,L24E1                         ; 28 53
  cp      0x07                            ; fe 07
  jr      nz,L249C                        ; 20 0a
  ld      a,d                             ; 7a
  cp      0xc0                            ; fe c0
  jr      c,L24E1                         ; 38 4a
  ld      de,0xbfff                       ; 11 ff bf
  jr      L24E1                           ; 18 45
L249C:
  push    de                              ; d5
  push    bc                              ; c5
  ld      hl,0x3f00                       ; 21 00 3f
  dec     a                               ; 3d
  jr      z,L24B4                         ; 28 10
  ld      hl,0x7f40                       ; 21 40 7f
  sub     0x02                            ; d6 02
  jr      z,L24B4                         ; 28 09
  ld      hl,0xbf80                       ; 21 80 bf
  dec     a                               ; 3d
  jr      z,L24B4                         ; 28 03
  ld      hl,0xffc0                       ; 21 c0 ff
L24B4:
  ld      bc,(0xc712)                     ; ed 4b 12 c7
  ld      de,(0xe037)                     ; ed 5b 37 e0
  ld      a,d                             ; 7a
  cp      l                               ; bd
  jr      c,L24E3                         ; 38 23
  ld      a,h                             ; 7c
  cp      b                               ; b8
  jr      c,L24E3                         ; 38 1f
  ld      a,b                             ; 78
  xor     l                               ; ad
  and     0xc0                            ; e6 c0
  jr      z,L24CD                         ; 28 03
  ld      bc,0xc000                       ; 01 00 c0
L24CD:
  ld      a,d                             ; 7a
  xor     h                               ; ac
  and     0xc0                            ; e6 c0
  jr      z,L24D6                         ; 28 03
  ld      de,0xffff                       ; 11 ff ff
L24D6:
  set     6,b                             ; cb f0
  set     7,b                             ; cb f8
  set     6,d                             ; cb f2
  set     7,d                             ; cb fa
  ex      af,af'                          ; 08
  inc     a                               ; 3c
  ex      af,af'                          ; 08
L24E1:
  push    de                              ; d5
  push    bc                              ; c5
L24E3:
  ex      af,af'                          ; 08
  exx                                     ; d9
  jp      (hl)                            ; e9
  exx                                     ; d9
  push    bc                              ; c5
  push    de                              ; d5
  push    hl                              ; e5
  exx                                     ; d9
  ld      (0xc0a8),sp                     ; ed 73 a8 c0
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  ld      sp,hl                           ; f9
  ld      hl,0xc12e                       ; 21 2e c1
  jp      0xc0b0                          ; c3 b0 c0
L24F8:
  dec     a                               ; 3d
  jr      z,L250A                         ; 28 0f
  pop     hl                              ; e1
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  pop     hl                              ; e1
  jr      z,L2504                         ; 28 02
  jr      nc,L24F8                        ; 30 f4
L2504:
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  ccf                                     ; 3f
  jr      nc,L24F8                        ; 30 ee
L250A:
  jp      0xc0a7                          ; c3 a7 c0
  call    0xbeb4                          ; cd b4 be
  push    hl                              ; e5
  ld      hl,(0xb250)                     ; 2a 50 b2
  ld      a,l                             ; 7d
  and     0xe0                            ; e6 e0
  ld      l,a                             ; 6f
  ld      a,(0xb254)                      ; 3a 54 b2
  and     0x1f                            ; e6 1f
  jp      z,0xb412                        ; ca 12 b4
L2520:
  dec     a                               ; 3d
  jr      z,L252F                         ; 28 0c
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  ex      af,af'                          ; 08
  call    0xc4b2                          ; cd b2 c4
  call    0xd3da                          ; cd da d3
  ex      af,af'                          ; 08
  jr      L2520                           ; 18 f1
L252F:
  ld      (0xdf57),hl                     ; 22 57 df
  pop     hl                              ; e1
  push    hl                              ; e5
  ld      b,0x20                          ; 06 20
  ld      hl,0xabe3                       ; 21 e3 ab
L2539:
  call    0xdd77                          ; cd 77 dd
  cp      0x20                            ; fe 20
  jr      nc,L2542                        ; 30 02
  ld      a,0x20                          ; 3e 20
L2542:
  call    0xdf38                          ; cd 38 df
  djnz    L2539                           ; 10 f2
  pop     hl                              ; e1
  ret                                     ; c9
  ld      hl,0x5800                       ; 21 00 58
  ld      bc,0x0003                       ; 01 03 00
  push    hl                              ; e5
  push    bc                              ; c5
L2551:
  ld      (hl),0x39                       ; 36 39
  inc     hl                              ; 23
  djnz    L2551                           ; 10 fb
  dec     c                               ; 0d
  jr      nz,L2551                        ; 20 f8
  call    0xc280                          ; cd 80 c2
  pop     bc                              ; c1
  pop     hl                              ; e1
L255E:
  ld      a,(hl)                          ; 7e
  cp      0x39                            ; fe 39
  jr      nz,L2579                        ; 20 16
  push    hl                              ; e5
  ld      a,h                             ; 7c
  sub     0x0a                            ; d6 0a
L2567:
  ld      h,a                             ; 67
  and     0x07                            ; e6 07
  jr      z,L2571                         ; 28 05
  ld      a,h                             ; 7c
  sub     0x07                            ; d6 07
  jr      L2567                           ; 18 f6
L2571:
  ld      e,0x08                          ; 1e 08
L2573:
  ld      (hl),a                          ; 77
  inc     h                               ; 24
  dec     e                               ; 1d
  jr      nz,L2573                        ; 20 fb
  pop     hl                              ; e1
L2579:
  inc     hl                              ; 23
  djnz    L255E                           ; 10 e2
  dec     c                               ; 0d
  jr      nz,L255E                        ; 20 df
  ld      bc,0x0000                       ; 01 00 00
  ld      ix,0xb249                       ; dd 21 49 b2
  add     ix,bc                           ; dd 09
  push    bc                              ; c5
  ld      a,0x28                          ; 3e 28
  ld      (0xdf4b),a                      ; 32 4b df
  call    0xc2ad                          ; cd ad c2
  ld      a,0x38                          ; 3e 38
  ld      (0xdf4b),a                      ; 32 4b df
  call    0xddd2                          ; cd d2 dd
  pop     bc                              ; c1
  cp      0x04                            ; fe 04
  ret     z                               ; c8
  ld      hl,0xc17f                       ; 21 7f c1
  push    hl                              ; e5
  ld      b,0x07                          ; 06 07
  cp      0x34                            ; fe 34
  jr      z,L25AD                         ; 28 06
  ld      b,0xf9                          ; 06 f9
  cp      0x33                            ; fe 33
  jr      nz,L25BE                        ; 20 11
L25AD:
  ld      a,c                             ; 79
  add     a,b                             ; 80
  cp      0xf9                            ; fe f9
  jr      nz,L25B5                        ; 20 02
  ld      a,0xe7                          ; 3e e7
L25B5:
  cp      0xee                            ; fe ee
  jr      c,L25BA                         ; 38 01
  xor     a                               ; af
L25BA:
  ld      (0xc1b6),a                      ; 32 b6 c1
  ret                                     ; c9
L25BE:
  ld      h,(ix+1)                        ; dd 66 01
  ld      l,(ix+0)                        ; dd 6e 00
  ld      b,0x01                          ; 06 01
  cp      0x38                            ; fe 38
  jr      z,L25E8                         ; 28 1e
  cp      0x36                            ; fe 36
  jr      z,L25D4                         ; 28 06
  cp      0x37                            ; fe 37
  jr      nz,L25DB                        ; 20 09
L25D2:
  ld      b,0x17                          ; 06 17
L25D4:
  call    0xc4b2                          ; cd b2 c4
  djnz    L25D4                           ; 10 fb
  jr      L25EB                           ; 18 10
L25DB:
  cp      0x35                            ; fe 35
  jr      nz,L25F2                        ; 20 13
  ld      b,0x1f                          ; 06 1f
L25E1:
  call    0xc4a6                          ; cd a6 c4
  djnz    L25E1                           ; 10 fb
  jr      L25D2                           ; 18 ea
L25E8:
  call    0xc4a6                          ; cd a6 c4
L25EB:
  ld      (ix+1),h                        ; dd 74 01
  ld      (ix+0),l                        ; dd 75 00
  ret                                     ; c9
L25F2:
  cp      0x61                            ; fe 61
  jr      c,L260F                         ; 38 19
  cp      0x7b                            ; fe 7b
  jr      nc,L260F                        ; 30 15
  sub     0x61                            ; d6 61
  ld      b,a                             ; 47
  ld      a,(ix+4)                        ; dd 7e 04
  ld      c,a                             ; 4f
  and     0x1f                            ; e6 1f
  xor     b                               ; a8
  xor     c                               ; a9
  bit     7,c                             ; cb 79
  jr      nz,L260B                        ; 20 02
  and     0xe1                            ; e6 e1
L260B:
  ld      (ix+4),a                        ; dd 77 04
  ret                                     ; c9
L260F:
  ld      d,(ix+3)                        ; dd 56 03
  ld      e,(ix+4)                        ; dd 5e 04
  ld      hl,0xc263                       ; 21 63 c2
  ld      b,0x06                          ; 06 06
L261A:
  cp      (hl)                            ; be
  inc     hl                              ; 23
  jr      z,L2623                         ; 28 05
  inc     hl                              ; 23
  inc     hl                              ; 23
  djnz    L261A                           ; 10 f8
  ret                                     ; c9
L2623:
  ld      a,(hl)                          ; 7e
  and     e                               ; a3
  ret     z                               ; c8
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  xor     d                               ; aa
  ld      (ix+3),a                        ; dd 77 03
  ret                                     ; c9
  ld      e,h                             ; 5c
  rst     0x38                            ; ff
  add     a,b                             ; 80
  ld      e,(hl)                          ; 5e
  rst     0x38                            ; ff
  ld      b,b                             ; 40
  ld      hl,(0x20ff)                     ; 2a ff 20
  ccf                                     ; 3f
  rst     0x38                            ; ff
  djnz    L2678                           ; 10 3e
  ld      b,b                             ; 40
  ex      af,af'                          ; 08
  ld      a,h                             ; 7c
  defb    0x20, 0x04
  ld      hl,(0xb4ed)                     ; 2a ed b4
  ld      ix,0xb257                       ; dd 21 57 b2
  ld      b,0x20                          ; 06 20
  jr      L2650                           ; 18 06
  ld      ix,0xb249                       ; dd 21 49 b2
  ld      b,0x22                          ; 06 22
L2650:
  ld      (0xc37b),hl                     ; 22 7b c3
L2653:
  push    bc                              ; c5
  call    0xc2a7                          ; cd a7 c2
  ld      bc,0x0007                       ; 01 07 00
  add     ix,bc                           ; dd 09
  pop     bc                              ; c1
  djnz    L2653                           ; 10 f4
  ret                                     ; c9
L2660:
  ld      a,0x28                          ; 3e 28
  call    0xdf38                          ; cd 38 df
  pop     hl                              ; e1
  push    hl                              ; e5
  call    0xc47b                          ; cd 7b c4
  ld      a,0x29                          ; 3e 29
L266C:
  call    0xdf36                          ; cd 36 df
  jr      L269F                           ; 18 2e
  ld      a,(ix+4)                        ; dd 7e 04
  and     0x1f                            ; e6 1f
  ret     z                               ; c8
  xor     a                               ; af
L2678:
  ld      (0xc3f7),a                      ; 32 f7 c3
  call    0xc38c                          ; cd 8c c3
  ld      l,(ix+5)                        ; dd 6e 05
  ld      h,(ix+6)                        ; dd 66 06
  ld      a,(ix+3)                        ; dd 7e 03
  and     0x03                            ; e6 03
  dec     a                               ; 3d
  jr      nz,L2690                        ; 20 04
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ex      de,hl                           ; eb
L2690:
  push    hl                              ; e5
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0xd8                            ; fe d8
  jr      nc,L2660                        ; 30 c8
  cp      0x80                            ; fe 80
  jr      nc,L266C                        ; 30 d0
  call    0xc48d                          ; cd 8d c4
L269F:
  ld      a,0x3a                          ; 3e 3a
  call    0xdf38                          ; cd 38 df
  pop     de                              ; d1
  ld      a,(ix+4)                        ; dd 7e 04
  and     0x1f                            ; e6 1f
  ld      hl,(0xdf57)                     ; 2a 57 df
L26AD:
  ld      bc,0xc3ee                       ; 01 ee c3
  or      a                               ; b7
  ret     z                               ; c8
  push    af                              ; f5
  push    hl                              ; e5
  ex      de,hl                           ; eb
  call    0xb1cf                          ; cd cf b1
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xb1cf                          ; cd cf b1
  ld      d,a                             ; 57
  ex      de,hl                           ; eb
  ld      a,(ix+3)                        ; dd 7e 03
  bit     3,a                             ; cb 5f
  jr      z,L26C7                         ; 28 01
  inc     de                              ; 13
L26C7:
  push    de                              ; d5
  ld      e,a                             ; 5f
  and     0x03                            ; e6 03
  jp      z,0xc39e                        ; ca 9e c3
  cp      0x03                            ; fe 03
  jr      nc,L270F                        ; 30 3d
  ld      d,0x04                          ; 16 04
L26D4:
  bit     3,(ix+3)                        ; dd cb 03 5e
  push    bc                              ; c5
  jr      z,L26DC                         ; 28 01
  inc     bc                              ; 03
L26DC:
  push    ix                              ; dd e5
  ld      ix,0xc433                       ; dd 21 33 c4
  ld      a,(bc)                          ; 0a
  ld      b,0x00                          ; 06 00
  ld      c,a                             ; 4f
  add     ix,bc                           ; dd 09
  rl      e                               ; cb 13
  push    de                              ; d5
  push    hl                              ; e5
  call    c,0xc3f6                        ; dc f6 c3
  pop     hl                              ; e1
  pop     de                              ; d1
  pop     ix                              ; dd e1
  pop     bc                              ; c1
  inc     bc                              ; 03
  inc     bc                              ; 03
  dec     d                               ; 15
  jr      nz,L26D4                        ; 20 db
  pop     de                              ; d1
  pop     hl                              ; e1
  bit     2,(ix+3)                        ; dd cb 03 56
  jr      z,L270B                         ; 28 0a
  call    0xc4b2                          ; cd b2 c4
  ld      (0xdf57),hl                     ; 22 57 df
  xor     a                               ; af
  ld      (0xc3f7),a                      ; 32 f7 c3
L270B:
  pop     af                              ; f1
  dec     a                               ; 3d
  jr      L26AD                           ; 18 9e
L270F:
  pop     de                              ; d1
  pop     hl                              ; e1
  pop     af                              ; f1
  call    0xc38c                          ; cd 8c c3
  rlca                                    ; 07
  rlca                                    ; 07
  rlca                                    ; 07
  ld      l,a                             ; 6f
  ld      h,0x00                          ; 26 00
  add     hl,hl                           ; 29
  add     hl,hl                           ; 29
L271D:
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0xc4                            ; fe c4
  jr      z,L273B                         ; 28 17
  cp      0xa3                            ; fe a3
  jr      z,L2731                         ; 28 09
  call    0xdf36                          ; cd 36 df
  dec     hl                              ; 2b
  ld      a,h                             ; 7c
  or      l                               ; b5
  jr      nz,L271D                        ; 20 ed
  ret                                     ; c9
L2731:
  ld      a,0x00                          ; 3e 00
  add     a,0x03                          ; c6 03
  ld      de,0xe4b2                       ; 11 b2 e4
  jp      0xc490                          ; c3 90 c4
L273B:
  ld      a,(ix+4)                        ; dd 7e 04
  and     0x1f                            ; e6 1f
  ld      b,a                             ; 47
  call    0xbebe                          ; cd be be
  ld      hl,0x0000                       ; 21 00 00
  push    ix                              ; dd e5
L2749:
  push    bc                              ; c5
  call    0xbeaf                          ; cd af be
  call    0xc169                          ; cd 69 c1
  pop     bc                              ; c1
  djnz    L2749                           ; 10 f6
  pop     ix                              ; dd e1
  ret                                     ; c9
  ld      l,(ix+0)                        ; dd 6e 00
  ld      h,(ix+1)                        ; dd 66 01
  ld      (0xdf57),hl                     ; 22 57 df
  ret                                     ; c9
  ld      (hl),e                          ; 73
  ld      a,d                             ; 7a
  dec     l                               ; 2d
  ld      l,b                             ; 68
  dec     l                               ; 2d
  ld      (hl),b                          ; 70
  ld      l,(hl)                          ; 6e
  ex      (sp),hl                         ; e3
  pop     af                              ; f1
  pop     af                              ; f1
  ld      a,l                             ; 7d
  ex      af,af'                          ; 08
  ld      c,l                             ; 4d
  ld      b,0x04                          ; 06 04
  bit     5,e                             ; cb 6b
  call    0xc38c                          ; cd 8c c3
  push    hl                              ; e5
  ld      hl,0xc3e2                       ; 21 e2 c3
  jr      z,L2790                         ; 28 16
  ld      de,0xc396                       ; 11 96 c3
  call    0xc493                          ; cd 93 c4
  pop     hl                              ; e1
  call    0xc4b2                          ; cd b2 c4
  ld      (0xdf57),hl                     ; 22 57 df
  ex      af,af'                          ; 08
  call    0xc454                          ; cd 54 c4
  pop     hl                              ; e1
  ret                                     ; c9
L278D:
  call    0xdf34                          ; cd 34 df
L2790:
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  and     c                               ; a1
  jr      nz,L2799                        ; 20 04
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  jr      L279B                           ; 18 02
L2799:
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
L279B:
  inc     hl                              ; 23
  push    af                              ; f5
  rlca                                    ; 07
  call    c,0xdf34                        ; dc 34 df
  pop     af                              ; f1
  and     0x7f                            ; e6 7f
  call    0xc48d                          ; cd 8d c4
  djnz    L278D                           ; 10 e4
  pop     de                              ; d1
  pop     hl                              ; e1
  ret                                     ; c9
  ld      b,b                             ; 40
  sub     h                               ; 94
  jr      nz,L27B1                        ; 20 01
  adc     a,e                             ; 8b
L27B1:
  rra                                     ; 1f
  inc     b                               ; 04
  ld      hl,0x8022                       ; 21 22 80
  ld      de,0x0012                       ; 11 12 00
  rlca                                    ; 07
  ld      c,0x15                          ; 0e 15
  defb    0x20, 0x1c
  inc     sp                              ; 33
  cpl                                     ; 2f
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  call    nz,0xdf34                       ; c4 34 df
  ld      a,0x01                          ; 3e 01
  ld      (0xc3f7),a                      ; 32 f7 c3
  jp      (ix)                            ; dd e9
L27CD:
  call    0xc484                          ; cd 84 c4
  call    0xe100                          ; cd 00 e1
  jr      L27F1                           ; 18 1c
L27D5:
  call    0xc486                          ; cd 86 c4
  call    0xe0f4                          ; cd f4 e0
  jr      L27F1                           ; 18 14
L27DD:
  call    0xc484                          ; cd 84 c4
  ld      (ix+0),0x23                     ; dd 36 00 23
  inc     ix                              ; dd 23
  call    0xe0ec                          ; cd ec e0
  jr      L27F1                           ; 18 06
L27EB:
  call    0xc486                          ; cd 86 c4
  call    0xe0db                          ; cd db e0
L27F1:
  ld      hl,0xac06                       ; 21 06 ac
L27F4:
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  ret     z                               ; c8
  call    0xdf38                          ; cd 38 df
  inc     hl                              ; 23
  jr      L27F4                           ; 18 f7
  call    0xe0cc                          ; cd cc e0
  jr      z,L27CD                         ; 28 cb
  jr      L27DD                           ; 18 d9
  call    0xe0cc                          ; cd cc e0
  jr      z,L27D5                         ; 28 cc
  jr      L27EB                           ; 18 e0
  call    0xe0cc                          ; cd cc e0
  jr      nz,L27CD                        ; 20 bd
  jr      L27DD                           ; 18 cb
  call    0xe0cc                          ; cd cc e0
  jr      nz,L27D5                        ; 20 be
  jr      L27EB                           ; 18 d2
  ld      a,h                             ; 7c
  call    0xc454                          ; cd 54 c4
  ld      a,l                             ; 7d
  ld      c,a                             ; 4f
  ld      b,0x08                          ; 06 08
L2821:
  xor     a                               ; af
  rl      c                               ; cb 11
  adc     a,0x30                          ; ce 30
  call    0xdf38                          ; cd 38 df
  djnz    L2821                           ; 10 f6
  ret                                     ; c9
  ld      a,h                             ; 7c
  call    0xc46c                          ; cd 6c c4
  xor     a                               ; af
  ld      h,l                             ; 65
  ld      (0xc3f7),a                      ; 32 f7 c3
  ld      a,h                             ; 7c
  ld      l,a                             ; 6f
  and     0x7f                            ; e6 7f
  cp      0x20                            ; fe 20
  ld      a,l                             ; 7d
  jr      nc,L2842                        ; 30 04
  and     0x80                            ; e6 80
  or      0x2e                            ; f6 2e
L2842:
  jp      0xdf38                          ; c3 38 df
  push    ix                              ; dd e5
  call    0xe0d0                          ; cd d0 e0
  pop     ix                              ; dd e1
  jr      L27F1                           ; 18 a3
  ld      h,0x00                          ; 26 00
  ld      ix,0xac06                       ; dd 21 06 ac
  ld      c,0x00                          ; 0e 00
  ret                                     ; c9
  ld      de,0xe5f0                       ; 11 f0 e5
  call    0xda73                          ; cd 73 da
L285D:
  ld      a,(de)                          ; 1a
  res     7,a                             ; cb bf
  call    0xdef9                          ; cd f9 de
  jr      nz,L2867                        ; 20 02
  sub     0x20                            ; d6 20
L2867:
  call    0xdf36                          ; cd 36 df
  ld      a,(de)                          ; 1a
  inc     de                              ; 13
  rla                                     ; 17
  jr      nc,L285D                        ; 30 ee
  ret                                     ; c9
  inc     l                               ; 2c
  ret     nz                              ; c0
L2872:
  ld      a,h                             ; 7c
  add     a,0x08                          ; c6 08
  cp      0x58                            ; fe 58
  ld      h,a                             ; 67
  ret     nz                              ; c0
  ld      h,0x40                          ; 26 40
  ret                                     ; c9
  ld      a,l                             ; 7d
  add     a,0x20                          ; c6 20
  ld      l,a                             ; 6f
  ret     nc                              ; d0
  jr      L2872                           ; 18 ef
  dec     de                              ; 1b
  rst     0x38                            ; ff
  ex      (sp),hl                         ; e3
  dec     c                               ; 0d
  rst     0x38                            ; ff
  ex      (sp),hl                         ; e3
  dec     e                               ; 1d
  rst     0x38                            ; ff
  ex      (sp),hl                         ; e3
  dec     l                               ; 2d
  rst     0x38                            ; ff
  ret                                     ; c9
  dec     c                               ; 0d
  rst     0x08                            ; cf
  pop     bc                              ; c1
  dec     c                               ; 0d
  rst     0x00                            ; c7
  ret     nz                              ; c0
  dec     c                               ; 0d
  rst     0x30                            ; f7
  and     b                               ; a0
  ld      b,d                             ; 42
  rst     0x00                            ; c7
  add     a,(hl)                          ; 86
  inc     d                               ; 14
  rst     0x00                            ; c7
  add     a,(hl)                          ; 86
  inc     hl                              ; 23
  rst     0x00                            ; c7
  add     a,(hl)                          ; 86
  ld      (bc),a                          ; 02
  rst     0x08                            ; cf
  ld      c,e                             ; 4b
  ld      c,a                             ; 4f
  rst     0x00                            ; c7
  ld      b,(hl)                          ; 46
  inc     d                               ; 14
  rst     0x00                            ; c7
  ld      b,(hl)                          ; 46
  inc     hl                              ; 23
  rst     0x00                            ; c7
  ld      b,(hl)                          ; 46
  ld      (bc),a                          ; 02
  rst     0x30                            ; f7
  ld      b,l                             ; 45
  ld      b,l                             ; 45
  rst     0x38                            ; ff
  ld      a,(0xfe07)                      ; 3a 07 fe
  inc     (hl)                            ; 34
  inc     d                               ; 14
  cp      0x34                            ; fe 34
  inc     hl                              ; 23
  cp      0x34                            ; fe 34
  ld      (bc),a                          ; 02
  rst     0x38                            ; ff
  ld      hl,(0xff0f)                     ; 2a 0f ff
  ld      hl,(0xff1f)                     ; 2a 1f ff
  ld      hl,(0xff2f)                     ; 2a 2f ff
  ld      a,(de)                          ; 1a
  ld      bc,0x0aff                       ; 01 ff 0a
  nop                                     ; 00
  add     a,a                             ; 87
  ld      b,0x94                          ; 06 94
  add     a,a                             ; 87
  ld      b,0xa3                          ; 06 a3
  add     a,a                             ; 87
  ld      b,0x82                          ; 06 82
  ld      e,0xff                          ; 1e ff
  ex      (sp),hl                         ; e3
  dec     c                               ; 0d
  rst     0x38                            ; ff
  ex      (sp),hl                         ; e3
  dec     e                               ; 1d
  rst     0x38                            ; ff
  ex      (sp),hl                         ; e3
  dec     l                               ; 2d
  rst     0x38                            ; ff
  call    0xc70e                          ; cd 0e c7
  rst     0x00                            ; c7
  ld      c,0xcf                          ; 0e cf
  push    bc                              ; c5
  ld      c,0xc7                          ; 0e c7
  call    nz,0xf70e                       ; c4 0e f7
  and     b                               ; a0
  ld      b,c                             ; 41
  add     a,a                             ; 87
  add     a,(hl)                          ; 86
  sub     h                               ; 94
  add     a,a                             ; 87
  add     a,(hl)                          ; 86
  and     e                               ; a3
  add     a,a                             ; 87
  add     a,(hl)                          ; 86
  add     a,d                             ; 82
  ret     m                               ; f8
  ld      (hl),b                          ; 70
  inc     d                               ; 14
  ret     m                               ; f8
  ld      (hl),b                          ; 70
  inc     hl                              ; 23
  ret     m                               ; f8
  ld      (hl),b                          ; 70
  ld      (bc),a                          ; 02
  rst     0x08                            ; cf
  ld      b,e                             ; 43
  ld      c,a                             ; 4f
  rst     0x38                            ; ff
  ld      (hl),0x14                       ; 36 14
  rst     0x38                            ; ff
  ld      (hl),0x23                       ; 36 23
  rst     0x38                            ; ff
  ld      (hl),0x02                       ; 36 02
  cp      0x34                            ; fe 34
  inc     d                               ; 14
  cp      0x34                            ; fe 34
  inc     hl                              ; 23
  cp      0x34                            ; fe 34
  ld      (bc),a                          ; 02
  rst     0x38                            ; ff
  ld      (0xff07),a                      ; 32 07 ff
  ld      (0xff0f),hl                     ; 22 0f ff
  ld      (0xff1f),hl                     ; 22 1f ff
  ld      (0xff2f),hl                     ; 22 2f ff
  ld      (de),a                          ; 12
  ld      bc,0x06c7                       ; 01 c7 06
  sub     h                               ; 94
  rst     0x00                            ; c7
  ld      b,0xa3                          ; 06 a3
  rst     0x00                            ; c7
  ld      b,0x82                          ; 06 82
  rst     0x38                            ; ff
  ld      (bc),a                          ; 02
  nop                                     ; 00
  ld      c,0xff                          ; 0e ff
  jp      (hl)                            ; e9
  ld      d,0xff                          ; 16 ff
  jp      (hl)                            ; e9
  dec     h                               ; 25
  rst     0x38                            ; ff
  jp      (hl)                            ; e9
  inc     b                               ; 04
  rst     0x38                            ; ff
  call    0xff01                          ; cd 01 ff
  ret                                     ; c9
  ld      (bc),a                          ; 02
  rst     0x00                            ; c7
  rst     0x00                            ; c7
  inc     bc                              ; 03
  rst     0x00                            ; c7
  call    nz,0xff01                       ; c4 01 ff
  jp      0xc701                          ; c3 01 c7
  jp      nz,0xc701                       ; c2 01 c7
  ret     nz                              ; c0
  ld      (bc),a                          ; 02
  rst     0x30                            ; f7
  ld      b,l                             ; 45
  ld      b,a                             ; 47
  rst     0x20                            ; e7
  jr      nz,L2955                        ; 20 00
L2955:
  rst     0x38                            ; ff
  jr      L2958                           ; 18 00
L2958:
  rst     0x38                            ; ff
  djnz    L295B                           ; 10 00
L295B:
  inc     e                               ; 1c
  ld      hl,0x2825                       ; 21 25 28
  dec     l                               ; 2d
  ld      l,0x3f                          ; 2e 3f
  ld      b,c                             ; 41
  ld      b,e                             ; 43
  ld      b,l                             ; 45
  ld      b,a                             ; 47
  ld      c,c                             ; 49
  ld      c,h                             ; 4c
  ld      d,l                             ; 55
  ld      d,a                             ; 57
  ld      e,a                             ; 5f
  ld      h,e                             ; 63
  ld      l,b                             ; 68
  ld      l,a                             ; 6f
  ld      (hl),l                          ; 75
  ld      a,b                             ; 78
  ld      a,e                             ; 7b
  add     a,d                             ; 82
  add     a,l                             ; 85
  add     a,(hl)                          ; 86
  adc     a,e                             ; 8b
  inc     hl                              ; 23
  sub     c                               ; 91

.ascii "Lengh"
.byte 't'+0x80

.ascii "Firs"
.byte 't'+0x80

.ascii "Las"
.byte 't'+0x80

.ascii "Memor"
.byte 'y'+0x80

.ascii "l"
.byte 'd'+0x80

.ascii " UNIVERSUM Contro"
.byte 'l'+0x80

.ascii "ON"
.byte ' '+0x80

.ascii "OF"
.byte 'F'+0x80

.ascii "NO"
.byte 'N'+0x80

.ascii "DE"
.byte 'F'+0x80

.ascii "AL"
.byte 'L'+0x80

.ascii "Cal"
.byte 'l'+0x80

.ascii "Read/Writ"
.byte 'e'+0x80

.ascii "Ru"
.byte 'n'+0x80

.ascii "Interrup"
.byte 't'+0x80

.ascii "ERRO"
.byte 'R'+0x80

.ascii "No ru"
.byte 'n'+0x80

.ascii "No writ"
.byte 'e'+0x80

.ascii "No rea"
.byte 'd'+0x80

.ascii "Def"
.byte 'b'+0x80

.ascii "Def"
.byte 'w'+0x80

.ascii "windows"
.byte ':'+0x80

.ascii "Wit"
.byte 'h'+0x80

.ascii "T"
.byte 'o'+0x80

.ascii "Leade"
.byte 'r'+0x80

.ascii "1. byte"
.byte ':'+0x80

.ascii " MemPage"
.byte ':'+0x80

  ld      d,e                             ; 53
  rst     0x08                            ; cf
  sbc     a,c                             ; 99
  out     (0x3e),a                        ; d3 3e
  jp      po,0xc92d                       ; e2 2d c9
  ld      e,c                             ; 59
  rst     0x00                            ; c7
  add     a,b                             ; 80
  ret     z                               ; c8
  ld      d,b                             ; 50
  adc     a,0x8c                          ; ce 8c
  out     (0x7a),a                        ; d3 7a
  add     a,0xb7                          ; c6 b7
  add     a,0x52                          ; c6 52
  rst     0x00                            ; c7
  xor     l                               ; ad
  call    0xd319                          ; cd 19 d3
  or      a                               ; b7
  ld      de,0x11b7                       ; 11 b7 11
  ld      bc,0x27c9                       ; 01 c9 27
  out     (0x21),a                        ; d3 21
  call    nc,0xcc7a                       ; d4 7a cc
  exx                                     ; d9
  jp      z,0xc769                        ; ca 69 c7
  add     a,l                             ; 85
  call    0xd391                          ; cd 91 d3
  ld      a,(bc)                          ; 0a
  set     6,b                             ; cb f0
  add     a,0x10                          ; c6 10
  ret     z                               ; c8
L2A44:
  call    0xc770                          ; cd 70 c7
  ex      de,hl                           ; eb
  ld      hl,(0xe037)                     ; 2a 37 e0
  ld      bc,(0xc712)                     ; ed 4b 12 c7
L2A4F:
  or      a                               ; b7
  sbc     hl,bc                           ; ed 42
L2A52:
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  add     hl,de                           ; 19
  jp      c,0xd7ee                        ; da ee d7
  push    de                              ; d5
  ex      de,hl                           ; eb
  ld      hl,(0xce95)                     ; 2a 95 ce
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  jp      c,0xd7ee                        ; da ee d7
  pop     de                              ; d1
  ld      hl,(0xc712)                     ; 2a 12 c7
  push    hl                              ; e5
  push    de                              ; d5
  call    0xad7c                          ; cd 7c ad
  pop     hl                              ; e1
  ld      (0xc712),hl                     ; 22 12 c7
  push    hl                              ; e5
  ld      bc,0x001a                       ; 01 1a 00
  add     hl,bc                           ; 09
  call    0xc734                          ; cd 34 c7
  pop     hl                              ; e1
  pop     de                              ; d1
  ex      de,hl                           ; eb
  call    0xbd66                          ; cd 66 bd
  jp      0xe19b                          ; c3 9b e1
  ld      b,0x00                          ; 06 00
  call    0xd37f                          ; cd 7f d3
  jr      z,L2A99                         ; 28 11
  call    0xc770                          ; cd 70 c7
  ld      de,(0xe037)                     ; ed 5b 37 e0
  call    0xad77                          ; cd 77 ad
  jp      c,0xd7ee                        ; da ee d7
  ld      (0xce95),hl                     ; 22 95 ce
  ret                                     ; c9
L2A99:
  ld      hl,0x4000                       ; 21 00 40
  call    0xddbf                          ; cd bf dd
  ld      hl,0xe495                       ; 21 95 e4
  call    0xd868                          ; cd 68 d8
  ld      hl,(0xc712)                     ; 2a 12 c7
  call    0xe216                          ; cd 16 e2
  ld      hl,0xe4a2                       ; 21 a2 e4
  call    0xd868                          ; cd 68 d8
  ld      hl,(0xce95)                     ; 2a 95 ce
L2AB4:
  call    0xe216                          ; cd 16 e2
  jp      0xd44e                          ; c3 4e d4
  call    0xc770                          ; cd 70 c7
  push    hl                              ; e5
  ld      hl,0x4000                       ; 21 00 40
  call    0xddbf                          ; cd bf dd
  ld      hl,0xe4ab                       ; 21 ab e4
  call    0xd868                          ; cd 68 d8
  call    0xd38c                          ; cd 8c d3
  pop     hl                              ; e1
  push    hl                              ; e5
  call    0xe216                          ; cd 16 e2
  call    0xdf08                          ; cd 08 df
  call    0xd38c                          ; cd 8c d3
  pop     hl                              ; e1
  jr      L2AB4                           ; 18 d9
  ld      hl,0xc000                       ; 21 00 c0
  ld      b,0x0d                          ; 06 0d
  call    0xc744                          ; cd 44 c7
  call    0xc734                          ; cd 34 c7
  ld      b,0x07                          ; 06 07
  call    0xc744                          ; cd 44 c7
  ld      (0xdfa6),hl                     ; 22 a6 df
  call    0xc72a                          ; cd 2a c7
  ld      (0xe037),hl                     ; 22 37 e0
  xor     a                               ; af
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  ret                                     ; c9
  ld      (0xe227),hl                     ; 22 27 e2
  ld      (0xd879),hl                     ; 22 79 d8
  ld      (0xd87c),hl                     ; 22 7c d8
  ld      (0xda17),hl                     ; 22 17 da
  ld      (0xc8c0),hl                     ; 22 c0 c8
  ret                                     ; c9
L2B0E:
  xor     a                               ; af
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  ld      a,0x30                          ; 3e 30
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  djnz    L2B0E                           ; 10 f3
  ret                                     ; c9
  ld      hl,(0xe227)                     ; 2a 27 e2
L2B1F:
  ld      (0xda17),hl                     ; 22 17 da
  ret                                     ; c9
  call    0xc761                          ; cd 61 c7
  call    0xd9d9                          ; cd d9 d9
  jr      L2B1F                           ; 18 f4
  ld      hl,(0xdfa6)                     ; 2a a6 df
  ld      de,0xfff4                       ; 11 f4 ff
  add     hl,de                           ; 19
  ret                                     ; c9
  call    0xc770                          ; cd 70 c7
  ld      (0xd09f),hl                     ; 22 9f d0
  ret                                     ; c9
  ld      hl,0xac3f                       ; 21 3f ac
  ld      de,0xac10                       ; 11 10 ac
  push    de                              ; d5
  ld      c,0x1e                          ; 0e 1e
  call    0xdd41                          ; cd 41 dd
  pop     de                              ; d1
  ld      hl,0x0000                       ; 21 00 00
  ld      a,0x2b                          ; 3e 2b
  ld      ix,0xabe4                       ; dd 21 e4 ab
L2B50:
  push    hl                              ; e5
  push    af                              ; f5
  call    0xdc5c                          ; cd 5c dc
  jp      c,0xd802                        ; da 02 d8
  cp      0x2b                            ; fe 2b
  jr      z,L2B63                         ; 28 07
  ld      (0xc7e4),a                      ; 32 e4 c7
  cp      0x2d                            ; fe 2d
  jr      nz,L2B66                        ; 20 03
L2B63:
  call    0xdc5c                          ; cd 5c dc
L2B66:
  cp      0x24                            ; fe 24
  ld      hl,(0xaf3b)                     ; 2a 3b af
  jr      z,L2BA2                         ; 28 35
  call    0xdef9                          ; cd f9 de
  jr      nz,L2BA7                        ; 20 35
  dec     de                              ; 1b
  push    de                              ; d5
  push    ix                              ; dd e5
  ex      de,hl                           ; eb
  call    0xdf79                          ; cd 79 df
  ld      a,0x09                          ; 3e 09
  jp      c,0xd813                        ; da 13 d8
  pop     ix                              ; dd e1
  ex      de,hl                           ; eb
  call    0xd8a5                          ; cd a5 d8
  call    0xade9                          ; cd e9 ad
  and     0xc0                            ; e6 c0
  ld      a,0x09                          ; 3e 09
  jp      z,0xd813                        ; ca 13 d8
  dec     de                              ; 1b
  ex      de,hl                           ; eb
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  dec     hl                              ; 2b
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  pop     bc                              ; c1
  ld      hl,(0xac06)                     ; 2a 06 ac
  ld      h,0x00                          ; 26 00
  add     hl,bc                           ; 09
  ex      de,hl                           ; eb
L2BA2:
  call    0xdc5c                          ; cd 5c dc
  jr      L2BAA                           ; 18 03
L2BA7:
  call    0xdbe3                          ; cd e3 db
L2BAA:
  push    af                              ; f5
  push    de                              ; d5
  ex      de,hl                           ; eb
  ld      a,0x00                          ; 3e 00
  call    0xd2b8                          ; cd b8 d2
  pop     hl                              ; e1
  pop     bc                              ; c1
  pop     af                              ; f1
  ex      (sp),hl                         ; e3
  push    bc                              ; c5
  call    0xd277                          ; cd 77 d2
L2BBA:
  pop     af                              ; f1
  pop     de                              ; d1
  ret     c                               ; d8
  jr      L2B50                           ; 18 91
  push    hl                              ; e5
  call    0xe160                          ; cd 60 e1
L2BC3:
  ld      hl,(0xe227)                     ; 2a 27 e2
  call    0xe22e                          ; cd 2e e2
  defb    0x38, 0x0d
  ld      de,0xc80c                       ; 11 0c c8
  ld      bc,0x0002                       ; 01 02 00
  call    0xe28d                          ; cd 8d e2
  jr      L2BC3                           ; 18 ed
  nop                                     ; 00
  jr      nc,L2BBA                        ; 30 e1
  ret                                     ; c9
  ld      b,0x3a                          ; 06 3a
  call    0xd37f                          ; cd 7f d3
  ld      de,0xc995                       ; 11 95 c9
  call    z,0xc8ec                        ; cc ec c8
  ld      ix,(0xda17)                     ; dd 2a 17 da
  ld      (0xc8c0),ix                     ; dd 22 c0 c8
  call    0xd8cf                          ; cd cf d8
  ld      hl,0xabe4                       ; 21 e4 ab
  ld      de,0xac3e                       ; 11 3e ac
  ld      a,0x01                          ; 3e 01
  ld      (de),a                          ; 12
  inc     de                              ; 13
  ld      c,0x1f                          ; 0e 1f
L2BFC:
  push    hl                              ; e5
  push    de                              ; d5
  ex      de,hl                           ; eb
  call    0xc965                          ; cd 65 c9
  pop     de                              ; d1
  jr      nc,L2C1D                        ; 30 18
  ld      hl,0xc994                       ; 21 94 c9
  ld      b,(hl)                          ; 46
L2C09:
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  call    0xd3f2                          ; cd f2 d3
  djnz    L2C09                           ; 10 f9
  pop     hl                              ; e1
  ld      a,(0xc979)                      ; 3a 79 c9
  ld      b,a                             ; 47
L2C15:
  call    0xdd78                          ; cd 78 dd
  inc     hl                              ; 23
  djnz    L2C15                           ; 10 fa
  jr      L2BFC                           ; 18 df
L2C1D:
  pop     hl                              ; e1
  call    0xdd78                          ; cd 78 dd
  inc     hl                              ; 23
  or      a                               ; b7
  jr      z,L2C2A                         ; 28 05
  call    0xd3f2                          ; cd f2 d3
  jr      L2BFC                           ; 18 d2
L2C2A:
  inc     a                               ; 3c
  ld      (de),a                          ; 12
  ld      (0xd594),a                      ; 32 94 d5
  dec     a                               ; 3d
  inc     c                               ; 0c
L2C31:
  ld      (de),a                          ; 12
  dec     c                               ; 0d
  jr      nz,L2C31                        ; 20 fc
  ld      hl,0xc874                       ; 21 74 c8
  ld      (0xd5ae),hl                     ; 22 ae d5
  jp      0xd552                          ; c3 52 d5
  ld      hl,0xd440                       ; 21 40 d4
  ld      (0xd5ae),hl                     ; 22 ae d5
  call    0xc8b6                          ; cd b6 c8
  jp      0xd5a9                          ; c3 a9 d5
  ld      hl,(0xda17)                     ; 2a 17 da
  ld      (0xc8c0),hl                     ; 22 c0 c8
  ld      b,0x53                          ; 06 53
  call    0xd37f                          ; cd 7f d3
  jr      nz,L2C6A                        ; 20 13
  xor     a                               ; af
L2C58:
  ld      de,(0xe227)                     ; ed 5b 27 e2
  dec     de                              ; 1b
  dec     de                              ; 1b
  ld      (0xc8c0),de                     ; ed 53 c0 c8
  ld      (0xc8d6),a                      ; 32 d6 c8
  call    0xd382                          ; cd 82 d3
  jr      L2C75                           ; 18 0b
L2C6A:
  ld      b,0x42                          ; 06 42
  call    0xd386                          ; cd 86 d3
  jr      nz,L2C75                        ; 20 04
  ld      a,0x01                          ; 3e 01
  jr      L2C58                           ; 18 e3
L2C75:
  ld      b,0x3a                          ; 06 3a
  call    0xd386                          ; cd 86 d3
  ld      de,0xc97a                       ; 11 7a c9
  call    z,0xc8ec                        ; cc ec c8
  call    0xe1f3                          ; cd f3 e1
  ld      hl,0xc958                       ; 21 58 c9
L2C86:
  ld      (0xc8e3),hl                     ; 22 e3 c8
L2C89:
  ld      hl,0x0000                       ; 21 00 00
  call    0xd9ee                          ; cd ee d9
  ld      (0xc8c0),hl                     ; 22 c0 c8
  call    0x1f54                          ; cd 54 1f
  jp      nc,0xd45f                       ; d2 5f d4
  call    0xe22e                          ; cd 2e e2
  ret     nc                              ; d0
  push    hl                              ; e5
  pop     ix                              ; dd e1
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  jr      z,L2CA9                         ; 28 05
  call    0xd884                          ; cd 84 d8
  jr      c,L2CB4                         ; 38 0b
L2CA9:
  call    0xd8cf                          ; cd cf d8
  call    0xc958                          ; cd 58 c9
  ld      hl,(0xc8c0)                     ; 2a c0 c8
  jr      c,L2D03                         ; 38 4f
L2CB4:
  jr      L2C89                           ; 18 d3
  ld      b,0x00                          ; 06 00
  push    de                              ; d5
L2CB9:
  call    0xdd78                          ; cd 78 dd
  inc     hl                              ; 23
  or      a                               ; b7
  jr      z,L2CC7                         ; 28 07
  or      0x20                            ; f6 20
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     b                               ; 04
  jr      L2CB9                           ; 18 f2
L2CC7:
  pop     hl                              ; e1
  dec     hl                              ; 2b
  ld      (hl),b                          ; 70
  ret                                     ; c9
  call    0xd37d                          ; cd 7d d3
  ld      a,0x00                          ; 3e 00
  jr      nz,L2CD3                        ; 20 01
  inc     a                               ; 3c
L2CD3:
  ld      (0xc8d6),a                      ; 32 d6 c8
  ld      hl,(0xe227)                     ; 2a 27 e2
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ld      (0xc8c0),hl                     ; 22 c0 c8
  ld      hl,0xc919                       ; 21 19 c9
  jr      L2C86                           ; 18 a3
  call    0xb0a2                          ; cd a2 b0
  ld      a,0x03                          ; 3e 03
  call    0x1601                          ; cd 01 16
  ei                                      ; fb
  ld      hl,0x0010                       ; 21 10 00
  call    0xda4d                          ; cd 4d da
  ld      a,0x0d                          ; 3e 0d
  rst     0x10                            ; d7
  xor     a                               ; af
  ret                                     ; c9
  call    0xd878                          ; cd 78 d8
  call    0xc93d                          ; cd 3d c9
  ld      (0xd879),hl                     ; 22 79 d8
  ld      (0xd87c),hl                     ; 22 7c d8
L2D03:
  ld      (0xda17),hl                     ; 22 17 da
  ret                                     ; c9
  ld      bc,0x0001                       ; 01 01 00
L2D0A:
  call    0xad77                          ; cd 77 ad
  jr      nc,L2D15                        ; 30 06
  inc     bc                              ; 03
  call    0xd9ee                          ; cd ee d9
  jr      L2D0A                           ; 18 f5
L2D15:
  call    0xd878                          ; cd 78 d8
  call    0xc7f5                          ; cd f5 c7
  call    0xe22e                          ; cd 2e e2
  call    z,0xd9d9                        ; cc d9 d9
  ret                                     ; c9
  ld      de,0xabe4                       ; 11 e4 ab
L2D25:
  push    de                              ; d5
  call    0xc965                          ; cd 65 c9
  pop     de                              ; d1
  ret     c                               ; d8
  inc     de                              ; 13
  jr      nz,L2D25                        ; 20 f7
  ret                                     ; c9
  ld      hl,0xc979                       ; 21 79 c9
  ld      b,(hl)                          ; 46
L2D33:
  inc     hl                              ; 23
L2D34:
  ld      a,(de)                          ; 1a
  inc     de                              ; 13
  dec     a                               ; 3d
  jr      z,L2D34                         ; 28 fb
  inc     a                               ; 3c
  ret     z                               ; c8
  xor     (hl)                            ; ae
  and     0xdf                            ; e6 df
  ret     nz                              ; c0
  djnz    L2D33                           ; 10 f2
  scf                                     ; 37
  ret                                     ; c9
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  ld      (0xc9be),a                      ; 32 be c9
  ld      a,0x10                          ; 3e 10
  push    af                              ; f5
  ex      af,af'                          ; 08
  ld      a,b                             ; 78
  or      c                               ; b1
  jp      z,0xd437                        ; ca 37 d4
  ex      af,af'                          ; 08
  push    bc                              ; c5
  push    hl                              ; e5
  ld      c,0x00                          ; 0e 00
  call    0x22b0                          ; cd b0 22
  ld      (0xdf57),hl                     ; 22 57 df
  pop     hl                              ; e1
  push    hl                              ; e5
  ld      de,0x0000                       ; 11 00 00
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  ex      de,hl                           ; eb
  call    0xca48                          ; cd 48 ca
  dec     hl                              ; 2b
L2D9C:
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  push    hl                              ; e5
  push    af                              ; f5
  call    0xade9                          ; cd e9 ad
  ld      h,a                             ; 67
  pop     af                              ; f1
  ld      l,a                             ; 6f
  ld      a,h                             ; 7c
  and     0x3f                            ; e6 3f
  ld      h,a                             ; 67
  sbc     hl,de                           ; ed 52
  pop     hl                              ; e1
  jr      z,L2DBC                         ; 28 0a
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L2D9C                        ; 20 e5
  ld      a,0x10                          ; 3e 10
  jp      0xd813                          ; c3 13 d8
L2DBC:
  call    0xade9                          ; cd e9 ad
  ld      c,a                             ; 4f
  pop     hl                              ; e1
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  inc     hl                              ; 23
  push    de                              ; d5
  ex      de,hl                           ; eb
  ld      hl,0xabe4                       ; 21 e4 ab
  ld      (hl),0x20                       ; 36 20
  bit     7,c                             ; cb 79
  jr      z,L2DD8                         ; 28 02
  ld      (hl),0x2a                       ; 36 2a
L2DD8:
  inc     hl                              ; 23
  push    bc                              ; c5
  ld      b,0x09                          ; 06 09
  call    0xda99                          ; cd 99 da
  pop     bc                              ; c1
  ex      de,hl                           ; eb
  ex      (sp),hl                         ; e3
  ex      de,hl                           ; eb
  ld      a,c                             ; 79
  and     0xc0                            ; e6 c0
  jr      nz,L2DF1                        ; 20 09
  ld      bc,0x052e                       ; 01 2e 05
  call    0xdaab                          ; cd ab da
  ld      (hl),b                          ; 70
  jr      L2DFA                           ; 18 09
L2DF1:
  push    hl                              ; e5
  pop     ix                              ; dd e1
  ex      de,hl                           ; eb
  ld      c,0x00                          ; 0e 00
  call    0xe0d6                          ; cd d6 e0
L2DFA:
  ld      hl,0xabe4                       ; 21 e4 ab
  call    0xe21c                          ; cd 1c e2
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  call    nz,0xc919                       ; c4 19 c9
  pop     hl                              ; e1
  pop     bc                              ; c1
  dec     bc                              ; 0b
  pop     af                              ; f1
  add     a,0x08                          ; c6 08
  cp      0xa9                            ; fe a9
  jp      c,0xc9b3                        ; da b3 c9
  ret                                     ; c9
  ld      hl,(0xdfa6)                     ; 2a a6 df
  call    0xade9                          ; cd e9 ad
  ld      c,a                             ; 4f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      b,a                             ; 47
  inc     hl                              ; 23
  ret                                     ; c9
  ld      b,0x50                          ; 06 50
  call    0xd386                          ; cd 86 d3
  push    af                              ; f5
  ld      a,0x01                          ; 3e 01
  jr      z,L2E2B                         ; 28 01
  dec     a                               ; 3d
L2E2B:
  ld      (0xca37),a                      ; 32 37 ca
  ld      de,0xac07                       ; 11 07 ac
  ld      a,0x20                          ; 3e 20
  ld      (de),a                          ; 12
  ld      (0xac0f),a                      ; 32 0f ac
  pop     af                              ; f1
  ld      b,0x3a                          ; 06 3a
  cp      b                               ; b8
  call    nz,0xd382                       ; c4 82 d3
  jr      nz,L2E53                        ; 20 13
  ld      bc,0x08df                       ; 01 df 08
  call    0xcd62                          ; cd 62 cd
  ld      hl,0xac07                       ; 21 07 ac
L2E49:
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  cp      0x20                            ; fe 20
  jr      nz,L2E49                        ; 20 fa
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  set     7,(hl)                          ; cb fe
L2E53:
  ld      hl,0x5840                       ; 21 40 58
  ld      a,0x38                          ; 3e 38
  ex      af,af'                          ; 08
  ld      a,0x30                          ; 3e 30
  ld      c,0x14                          ; 0e 14
L2E5D:
  ld      b,0x20                          ; 06 20
L2E5F:
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  djnz    L2E5F                           ; 10 fc
  ex      af,af'                          ; 08
  dec     c                               ; 0d
  jr      nz,L2E5D                        ; 20 f6
  call    0xca48                          ; cd 48 ca
  add     hl,bc                           ; 09
  add     hl,bc                           ; 09
  ld      (0xc9c8),hl                     ; 22 c8 c9
  call    0xe02d                          ; cd 2d e0
  push    bc                              ; c5
  push    hl                              ; e5
  ld      a,0x0e                          ; 3e 0e
  call    0xe1f5                          ; cd f5 e1
  pop     hl                              ; e1
  pop     bc                              ; c1
L2E7B:
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      z,L2E9D                         ; 28 1e
  exx                                     ; d9
  ld      a,0x10                          ; 3e 10
L2E82:
  push    af                              ; f5
  call    0xddba                          ; cd ba dd
  pop     af                              ; f1
  add     a,0x08                          ; c6 08
  cp      0xa9                            ; fe a9
  jr      c,L2E82                         ; 38 f5
  exx                                     ; d9
  xor     a                               ; af
  call    0xc9ae                          ; cd ae c9
  ld      a,0x88                          ; 3e 88
  call    0xc9ae                          ; cd ae c9
  exx                                     ; d9
  call    0xde03                          ; cd 03 de
  cp      0x20                            ; fe 20
L2E9D:
  jp      z,0xd43a                        ; ca 3a d4
  exx                                     ; d9
  jr      L2E7B                           ; 18 d8
  ld      b,0x43                          ; 06 43
  call    0xd37f                          ; cd 7f d3
  jr      z,L2EF3                         ; 28 49
  ld      b,0x4c                          ; 06 4c
  call    0xd386                          ; cd 86 d3
  ld      c,0xff                          ; 0e ff
  jr      z,L2EBD                         ; 28 0a
  ld      b,0x55                          ; 06 55
  call    0xd386                          ; cd 86 d3
  jp      nz,0xca56                       ; c2 56 ca
  ld      c,0xbf                          ; 0e bf
L2EBD:
  ld      a,c                             ; 79
  ld      (0xcb02),a                      ; 32 02 cb
  call    0xca48                          ; cd 48 ca
L2EC4:
  ld      a,b                             ; 78
  or      c                               ; b1
  ret     z                               ; c8
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  set     7,a                             ; cb ff
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  dec     bc                              ; 0b
  jr      L2EC4                           ; 18 f0
  ld      b,0x79                          ; 06 79
  call    0xd37f                          ; cd 7f d3
  jr      z,L2EE4                         ; 28 09
  ld      b,0x66                          ; 06 66
  call    0xd386                          ; cd 86 d3
  jp      z,0xd41c                        ; ca 1c d4
  ret                                     ; c9
L2EE4:
  ld      hl,(0xe227)                     ; 2a 27 e2
  ld      (0xd879),hl                     ; 22 79 d8
  call    0xc761                          ; cd 61 c7
  ld      (0xd87c),hl                     ; 22 7c d8
  call    0xc92d                          ; cd 2d c9
L2EF3:
  call    0xe1f3                          ; cd f3 e1
  call    0xcb67                          ; cd 67 cb
  ld      hl,(0xe227)                     ; 2a 27 e2
  call    0xcc43                          ; cd 43 cc
L2EFF:
  jr      nc,L2F23                        ; 30 22
  push    hl                              ; e5
  push    af                              ; f5
  call    0xade9                          ; cd e9 ad
  ld      l,a                             ; 6f
  pop     af                              ; f1
  and     0x7f                            ; e6 7f
  ld      h,a                             ; 67
  add     hl,hl                           ; 29
  ld      de,(0xdfa6)                     ; ed 5b a6 df
  add     hl,de                           ; 19
  inc     hl                              ; 23
  push    af                              ; f5
  call    0xade9                          ; cd e9 ad
  set     6,a                             ; cb f7
  call    0xae29                          ; cd 29 ae
  pop     af                              ; f1
  pop     hl                              ; e1
  inc     hl                              ; 23
  call    0xcc54                          ; cd 54 cc
  jr      L2EFF                           ; 18 dc
L2F23:
  call    0xca48                          ; cd 48 ca
  push    hl                              ; e5
  add     hl,bc                           ; 09
  add     hl,bc                           ; 09
  ld      (0xcb85),hl                     ; 22 85 cb
  pop     hl                              ; e1
L2F2D:
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L2F36                        ; 20 05
  ld      c,0xb7                          ; 0e b7
  jp      0xcaf3                          ; c3 f3 ca
L2F36:
  dec     bc                              ; 0b
  ld      (0xcc28),hl                     ; 22 28 cc
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  and     0xc0                            ; e6 c0
  ld      a,d                             ; 7a
  inc     hl                              ; 23
  jr      nz,L2F2D                        ; 20 e4
  and     0x3f                            ; e6 3f
  ld      d,a                             ; 57
  push    bc                              ; c5
  push    hl                              ; e5
  ld      hl,0x0000                       ; 21 00 00
  add     hl,de                           ; 19
  ld      (0xcbd8),de                     ; ed 53 d8 cb
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  inc     de                              ; 13
  inc     de                              ; 13
  ex      de,hl                           ; eb
L2F5B:
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  rlca                                    ; 07
  jr      nc,L2F5B                        ; 30 f9
  ex      de,hl                           ; eb
  call    0xe314                          ; cd 14 e3
  call    0xbd66                          ; cd 66 bd
  ld      hl,0xe037                       ; 21 37 e0
  call    0xe1a4                          ; cd a4 e1
  pop     hl                              ; e1
  push    bc                              ; c5
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  call    0xe314                          ; cd 14 e3
  ld      bc,0x0002                       ; 01 02 00
  ld      hl,0xcb85                       ; 21 85 cb
  call    0xe1a4                          ; cd a4 e1
  ld      hl,0xe037                       ; 21 37 e0
  call    0xe1a4                          ; cd a4 e1
  pop     bc                              ; c1
  push    bc                              ; c5
  inc     bc                              ; 03
  inc     bc                              ; 03
  call    0xe1ce                          ; cd ce e1
  ld      hl,(0xdfa6)                     ; 2a a6 df
  push    hl                              ; e5
  inc     bc                              ; 03
  call    0xe137                          ; cd 37 e1
  pop     ix                              ; dd e1
  pop     bc                              ; c1
L2F99:
  ld      a,d                             ; 7a
  or      e                               ; b3
  jr      z,L2FB3                         ; 28 16
  push    de                              ; d5
  call    0xcc2e                          ; cd 2e cc
  ld      de,0x0000                       ; 11 00 00
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  jr      c,L2FAF                         ; 38 06
  push    ix                              ; dd e5
  pop     hl                              ; e1
  call    0xe137                          ; cd 37 e1
L2FAF:
  pop     de                              ; d1
  dec     de                              ; 1b
  jr      L2F99                           ; 18 e6
L2FB3:
  ld      hl,(0xcc28)                     ; 2a 28 cc
  ld      de,(0xdfa6)                     ; ed 5b a6 df
  sbc     hl,de                           ; ed 52
  ex      de,hl                           ; eb
  srl     d                               ; cb 3a
  rr      e                               ; cb 1b
  ld      hl,(0xe227)                     ; 2a 27 e2
  call    0xcc43                          ; cd 43 cc
L2FC7:
  jr      nc,L2FF1                        ; 30 28
  push    hl                              ; e5
  push    af                              ; f5
  call    0xade9                          ; cd e9 ad
  ld      l,a                             ; 6f
  pop     af                              ; f1
  ld      h,a                             ; 67
  push    hl                              ; e5
  res     7,h                             ; cb bc
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  pop     hl                              ; e1
  jr      nc,L2FE1                        ; 30 07
  pop     hl                              ; e1
L2FDB:
  inc     hl                              ; 23
  call    0xcc54                          ; cd 54 cc
  jr      L2FC7                           ; 18 e6
L2FE1:
  dec     hl                              ; 2b
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  pop     hl                              ; e1
  ld      a,c                             ; 79
  call    0xae29                          ; cd 29 ae
  dec     hl                              ; 2b
  ld      a,b                             ; 78
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  jr      L2FDB                           ; 18 ea
L2FF1:
  ld      hl,0x0000                       ; 21 00 00
  pop     bc                              ; c1
  jp      0xcb63                          ; c3 63 cb
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
  push    ix                              ; dd e5
  pop     hl                              ; e1
  call    0xade9                          ; cd e9 ad
  push    af                              ; f5
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  and     0x3f                            ; e6 3f
  ld      h,a                             ; 67
  pop     af                              ; f1
  ld      l,a                             ; 6f
  ret                                     ; c9
L300D:
  call    0xe22e                          ; cd 2e e2
  ret     nc                              ; d0
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  and     0x0f                            ; e6 0f
  inc     hl                              ; 23
  jr      z,L300D                         ; 28 f3
  and     0x08                            ; e6 08
  jr      nz,L302B                        ; 20 0d
L301E:
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  cp      0xc0                            ; fe c0
  jr      nc,L300D                        ; 30 e7
  cp      0x80                            ; fe 80
  jr      c,L301E                         ; 38 f4
  dec     hl                              ; 2b
L302B:
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  scf                                     ; 37
  ret                                     ; c9
L3031:
  ld      a,0x61                          ; 3e 61
  xor     0x03                            ; ee 03
  ld      (0xcc68),a                      ; 32 68 cc
  ld      (0xf3f5),a                      ; 32 f5 f3
  jp      0xf44f                          ; c3 4f f4
L303E:
  ld      hl,0xcea7                       ; 21 a7 ce
  ld      (hl),c                          ; 71
  pop     af                              ; f1
  ret                                     ; c9
  ld      ix,0xac82                       ; dd 21 82 ac
  ld      (ix+0),0x03                     ; dd 36 00 03
  call    0xd37d                          ; cd 7d d3
  push    af                              ; f5
  ld      b,0x41                          ; 06 41
  call    0xd386                          ; cd 86 d3
  jr      z,L3031                         ; 28 da
  ld      c,0x01                          ; 0e 01
  ld      b,0x44                          ; 06 44
  call    0xd386                          ; cd 86 d3
  jr      z,L303E                         ; 28 de
  dec     c                               ; 0d
  ld      b,0x54                          ; 06 54
  call    0xd386                          ; cd 86 d3
  jr      z,L303E                         ; 28 d6
  dec     c                               ; 0d
  ld      b,0x3a                          ; 06 3a
  cp      b                               ; b8
  jr      z,L3071                         ; 28 03
  call    0xd382                          ; cd 82 d3
L3071:
  jr      nz,L3076                        ; 20 03
  call    0xcd5c                          ; cd 5c cd
L3076:
  ld      hl,0xcd7b                       ; 21 7b cd
  ld      de,0xac83                       ; 11 83 ac
  ld      bc,0x000a                       ; 01 0a 00
  ldir                                    ; ed b0
  pop     af                              ; f1
  jr      z,L3091                         ; 28 0d
  ld      hl,(0xdfa6)                     ; 2a a6 df
  ld      de,0xfff4                       ; 11 f4 ff
  add     hl,de                           ; 19
  ld      de,(0xe227)                     ; ed 5b 27 e2
  jr      L3098                           ; 18 07
L3091:
  call    0xd878                          ; cd 78 d8
  ex      de,hl                           ; eb
  call    0xd9ee                          ; cd ee d9
L3098:
  push    de                              ; d5
  ld      (0xcd91),de                     ; ed 53 91 cd
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  push    hl                              ; e5
  ld      (0xcd94),hl                     ; 22 94 cd
  ld      (0xac91),hl                     ; 22 91 ac
  ld      hl,(0xe037)                     ; 2a 37 e0
  ld      de,(0xdfa6)                     ; ed 5b a6 df
  and     a                               ; a7
  dec     de                              ; 1b
  sbc     hl,de                           ; ed 52
  ld      (0xafcd),hl                     ; 22 cd af
  push    de                              ; d5
  pop     ix                              ; dd e1
  push    hl                              ; e5
  push    ix                              ; dd e5
  call    0xae50                          ; cd 50 ae
  ld      (0xafc5),hl                     ; 22 c5 af
  ld      a,d                             ; 7a
  ld      (0xafc8),a                      ; 32 c8 af
  pop     ix                              ; dd e1
  inc     ix                              ; dd 23
  call    0xae50                          ; cd 50 ae
  ld      (0xaed9),hl                     ; 22 d9 ae
  ld      a,d                             ; 7a
  ld      (0xaedc),a                      ; 32 dc ae
  pop     hl                              ; e1
  dec     hl                              ; 2b
  pop     de                              ; d1
  push    de                              ; d5
  add     hl,de                           ; 19
  inc     hl                              ; 23
  inc     hl                              ; 23
  ld      (0xac8d),hl                     ; 22 8d ac
  call    0xcea6                          ; cd a6 ce
  jp      nz,0xf552                       ; c2 52 f5
  ld      a,0x0c                          ; 3e 0c
  call    0xe1f5                          ; cd f5 e1
  ld      ix,0xac82                       ; dd 21 82 ac
  call    0xcd3a                          ; cd 3a cd
  pop     de                              ; d1
  pop     ix                              ; dd e1
  dec     ix                              ; dd 2b
  exx                                     ; d9
  call    0xae50                          ; cd 50 ae
  exx                                     ; d9
  ld      a,0xff                          ; 3e ff
  call    0xaf76                          ; cd 76 af
  call    0xafc3                          ; cd c3 af
  jp      0xb0a2                          ; c3 a2 b0
  ld      h,0x01                          ; 26 01
L3106:
  inc     hl                              ; 23
  inc     h                               ; 24
  dec     h                               ; 25
  jr      nz,L3106                        ; 20 fb
L310B:
  xor     a                               ; af
  in      a,(0xfe)                        ; db fe
  cpl                                     ; 2f
  and     0x1f                            ; e6 1f
  jr      z,L310B                         ; 28 f8
  ld      de,0x0011                       ; 11 11 00
  xor     a                               ; af
  call    0x04c6                          ; cd c6 04
L311A:
  dec     de                              ; 1b
  dec     d                               ; 15
  inc     d                               ; 14
  jr      nz,L311A                        ; 20 fb
  ret                                     ; c9
  ld      b,0x3a                          ; 06 3a
  call    0xd37f                          ; cd 7f d3
  ret     nz                              ; c0
  ld      de,0xcd7b                       ; 11 7b cd
  ld      bc,0x0aff                       ; 01 ff 0a
L312C:
  call    0xdd78                          ; cd 78 dd
  inc     hl                              ; 23
  or      a                               ; b7
  jr      z,L313E                         ; 28 0b
  cp      0x40                            ; fe 40
  jr      c,L3138                         ; 38 01
  and     c                               ; a1
L3138:
  ld      (de),a                          ; 12
  inc     de                              ; 13
  dec     b                               ; 05
  jr      nz,L312C                        ; 20 ef
  ret                                     ; c9
L313E:
  ld      a,0x20                          ; 3e 20
L3140:
  ld      (de),a                          ; 12
  inc     de                              ; 13
  djnz    L3140                           ; 10 fc
  ret                                     ; c9
  ld      (hl),b                          ; 70
  ld      (hl),d                          ; 72
  ld      l,a                             ; 6f
  ld      l,l                             ; 6d
  ld      h,l                             ; 65
  ld      (hl),h                          ; 74
  ld      l,b                             ; 68
  ld      h,l                             ; 65
  ld      (hl),l                          ; 75
  ld      (hl),e                          ; 73
L314F:
  call    0xd32f                          ; cd 2f d3
  call    0xd36d                          ; cd 6d d3
  jr      nz,L314F                        ; 20 f8
  xor     a                               ; af
  dec     a                               ; 3d
  ld      ix,0x0000                       ; dd 21 00 00
  ld      de,0x0000                       ; 11 00 00
  call    0xcda1                          ; cd a1 cd
  call    0xaed7                          ; cd d7 ae
  call    0xb0a2                          ; cd a2 b0
  jr      L316E                           ; 18 03
  call    0xb08f                          ; cd 8f b0
L316E:
  ret     c                               ; d8
  ld      a,0x0d                          ; 3e 0d
L3171:
  call    0xe1f5                          ; cd f5 e1
  jp      0xd81e                          ; c3 1e d8
  call    0xe1e9                          ; cd e9 e1
  call    0xca48                          ; cd 48 ca
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      z,L31E3                         ; 28 62
  ld      hl,0xcdfe                       ; 21 fe cd
  ld      (0xd5ae),hl                     ; 22 ae d5
L3187:
  ld      hl,0x0000                       ; 21 00 00
  push    hl                              ; e5
  push    hl                              ; e5
  pop     ix                              ; dd e1
  call    0xd9ee                          ; cd ee d9
  ld      (0xcdbe),hl                     ; 22 be cd
  pop     hl                              ; e1
  ld      de,0x0000                       ; 11 00 00
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  jr      nc,L31DC                        ; 30 3f
  ld      a,0x21                          ; 3e 21
  ld      hl,0x0000                       ; 21 00 00
  call    0xce9f                          ; cd 9f ce
  call    0xd8cf                          ; cd cf d8
  ld      a,0x2a                          ; 3e 2a
  ld      hl,0xdfa6                       ; 21 a6 df
  call    0xce9f                          ; cd 9f ce
  ld      a,(0xd473)                      ; 3a 73 d4
  cp      0x10                            ; fe 10
  jr      z,L3171                         ; 28 ba
  ld      hl,0xabe4                       ; 21 e4 ab
  ld      de,0xac3e                       ; 11 3e ac
  ld      bc,0x0020                       ; 01 20 00
  ldir                                    ; ed b0
  call    0xdaa5                          ; cd a5 da
  jp      0xd552                          ; c3 52 d5
  call    0xda0c                          ; cd 0c da
  ld      de,(0xcdbe)                     ; ed 5b be cd
  ld      hl,(0xe037)                     ; 2a 37 e0
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  jr      c,L3187                         ; 38 b0
  ld      a,0x07                          ; 3e 07
  jp      0xd813                          ; c3 13 d8
L31DC:
  ld      hl,0xd440                       ; 21 40 d4
  ld      (0xd5ae),hl                     ; 22 ae d5
  jp      (hl)                            ; e9
L31E3:
  ld      de,(0xcdbe)                     ; ed 5b be cd
  ld      hl,(0xcdd6)                     ; 2a d6 cd
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  call    0xbd66                          ; cd 66 bd
  ex      de,hl                           ; eb
  ld      de,(0xe227)                     ; ed 5b 27 e2
  ex      de,hl                           ; eb
  call    0xc734                          ; cd 34 c7
  ex      de,hl                           ; eb
  call    0xad7c                          ; cd 7c ad
  ex      de,hl                           ; eb
  ld      b,0x06                          ; 06 06
  call    0xc744                          ; cd 44 c7
  ld      (0xdfa6),hl                     ; 22 a6 df
  push    hl                              ; e5
  inc     de                              ; 13
  inc     de                              ; 13
  ld      hl,(0xce95)                     ; 2a 95 ce
  call    0xbd66                          ; cd 66 bd
  ex      de,hl                           ; eb
  pop     de                              ; d1
  call    0xad7c                          ; cd 7c ad
  ld      (0xe037),de                     ; ed 53 37 e0
  jp      0xd440                          ; c3 40 d4
  call    0xe1e9                          ; cd e9 e1
  ld      hl,0xce8e                       ; 21 8e ce
  ld      (0xd5ae),hl                     ; 22 ae d5
L3223:
  ld      b,0x01                          ; 06 01
  ld      de,0xac3e                       ; 11 3e ac
  ld      hl,(0xcdbe)                     ; 2a be cd
  inc     hl                              ; 23
  inc     hl                              ; 23
L322D:
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  cp      0x0d                            ; fe 0d
  jr      z,L3244                         ; 28 11
  bit     5,b                             ; cb 68
  jr      nz,L322D                        ; 20 f6
  cp      0x20                            ; fe 20
  jr      nc,L323D                        ; 30 02
  ld      a,0x20                          ; 3e 20
L323D:
  and     0x7f                            ; e6 7f
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     b                               ; 04
  jr      L322D                           ; 18 e9
L3244:
  ld      (0xcdbe),hl                     ; 22 be cd
  ld      a,0x01                          ; 3e 01
  ld      (de),a                          ; 12
L324A:
  inc     de                              ; 13
  xor     a                               ; af
  ld      (de),a                          ; 12
  inc     b                               ; 04
  bit     5,b                             ; cb 68
  jr      z,L324A                         ; 28 f8
  call    0xdaa5                          ; cd a5 da
  jp      0xd552                          ; c3 52 d5
  call    0xda0c                          ; cd 0c da
  ld      hl,(0xcdbe)                     ; 2a be cd
  ld      de,0xffff                       ; 11 ff ff
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  jr      c,L3223                         ; 38 bd
  jp      0xce12                          ; c3 12 ce
  ld      (0xd8a5),a                      ; 32 a5 d8
  ld      (0xd8a6),hl                     ; 22 a6 d8
  ret                                     ; c9
  ld      a,0x01                          ; 3e 01
  or      a                               ; b7
  ret                                     ; c9
L3274:
  call    0xcea6                          ; cd a6 ce
  jp      nz,0xf461                       ; c2 61 f4
  call    0xd32f                          ; cd 2f d3
  call    0xd360                          ; cd 60 d3
  jr      nz,L3274                        ; 20 f2
  ld      ix,0xac82                       ; dd 21 82 ac
  call    0xcec7                          ; cd c7 ce
  call    0xcda1                          ; cd a1 cd
  ld      a,0x07                          ; 3e 07
  out     (0xfe),a                        ; d3 fe
  ret                                     ; c9
  ld      l,(ix+11)                       ; dd 6e 0b
  ld      h,(ix+12)                       ; dd 66 0c
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  call    0xd7dd                          ; cd dd d7
  ex      de,hl                           ; eb
  ld      hl,(0xce95)                     ; 2a 95 ce
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  push    hl                              ; e5
  ld      (0xcdbe),hl                     ; 22 be cd
  ld      c,(ix+15)                       ; dd 4e 0f
  ld      b,(ix+16)                       ; dd 46 10
  add     hl,bc                           ; 09
  ld      (0xcdcc),hl                     ; 22 cc cd
  inc     hl                              ; 23
  inc     hl                              ; 23
  ld      (0xcdd6),hl                     ; 22 d6 cd
  pop     ix                              ; dd e1
  scf                                     ; 37
  sbc     a,a                             ; 9f
  ret                                     ; c9
  call    0xe1f3                          ; cd f3 e1
  call    0xd37d                          ; cd 7d d3
  ld      a,0x00                          ; 3e 00
  jr      z,L32C6                         ; 28 01
  inc     a                               ; 3c
L32C6:
  ld      (0xcf35),a                      ; 32 35 cf
  call    0xcb67                          ; cd 67 cb
  ld      a,0x01                          ; 3e 01
  ld      (0xcf45),a                      ; 32 45 cf
  ld      a,0x10                          ; 3e 10
  ld      (0xaf63),a                      ; 32 63 af
  ld      hl,0xd0f9                       ; 21 f9 d0
  ld      (0xcf3f),hl                     ; 22 3f cf
L32DC:
  ld      hl,(0xd098)                     ; 2a 98 d0
  inc     hl                              ; 23
  ld      (0xaf3b),hl                     ; 22 3b af
  ld      (0xaf47),hl                     ; 22 47 af
  ld      hl,(0xe227)                     ; 2a 27 e2
L32E9:
  call    0xe22e                          ; cd 2e e2
  jr      nc,L330E                        ; 30 20
  ld      (0xd115),hl                     ; 22 15 d1
  call    0x1f54                          ; cd 54 1f
  jp      nc,0xd45f                       ; d2 5f d4
  push    hl                              ; e5
  call    0xe2db                          ; cd db e2
  pop     ix                              ; dd e1
  push    hl                              ; e5
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  jr      nz,L3308                        ; 20 05
  call    0xd884                          ; cd 84 d8
  jr      c,L330B                         ; 38 03
L3308:
  call    0xd0f9                          ; cd f9 d0
L330B:
  pop     hl                              ; e1
  jr      L32E9                           ; 18 db
L330E:
  ld      a,0x00                          ; 3e 00
  dec     a                               ; 3d
  ld      (0xcf45),a                      ; 32 45 cf
  ld      hl,0xcfee                       ; 21 ee cf
  ld      (0xcf3f),hl                     ; 22 3f cf
  jr      z,L32DC                         ; 28 c0
  ret                                     ; c9
  call    0xcef1                          ; cd f1 ce
  ld      a,0x0b                          ; 3e 0b
  jp      0xd44b                          ; c3 4b d4
  ld      a,(ix+0)                        ; dd 7e 00
  call    0xd15d                          ; cd 5d d1
  sub     0x02                            ; d6 02
  ret     c                               ; d8
  jr      nz,L3341                        ; 20 11
  call    0xd1f8                          ; cd f8 d1
  ld      (0xaf71),hl                     ; 22 71 af
  ld      a,(0xaf63)                      ; 3a 63 af
  ld      (0xaf6a),a                      ; 32 6a af
  ld      hl,0xd42a                       ; 21 2a d4
  dec     (hl)                            ; 35
  ret                                     ; c9
L3341:
  dec     a                               ; 3d
  ret     z                               ; c8
  dec     a                               ; 3d
  jp      z,0xd185                        ; ca 85 d1
  dec     a                               ; 3d
  jr      nz,L3369                        ; 20 1f
  call    0xd1f8                          ; cd f8 d1
  ld      a,b                             ; 78
  or      a                               ; b7
  jr      nz,L3366                        ; 20 15
  ld      a,c                             ; 79
  cp      0x08                            ; fe 08
  jr      nc,L3366                        ; 30 10
  cp      0x02                            ; fe 02
  jp      z,0xd7fa                        ; ca fa d7
  cp      0x05                            ; fe 05
  jp      z,0xd7fa                        ; ca fa d7
  add     a,0x10                          ; c6 10
  ld      (0xaf63),a                      ; 32 63 af
  ret                                     ; c9
L3366:
  jp      0xd18c                          ; c3 8c d1
L3369:
  dec     a                               ; 3d
  jr      nz,L3379                        ; 20 0d
L336C:
  call    0xd1f8                          ; cd f8 d1
  jp      c,0xd03b                        ; da 3b d0
  call    0xd03b                          ; cd 3b d0
  inc     ix                              ; dd 23
  jr      L336C                           ; 18 f3
L3379:
  dec     a                               ; 3d
  jr      nz,L33A7                        ; 20 2b
L337C:
  call    0xcfc7                          ; cd c7 cf
  jr      nz,L3386                        ; 20 05
  call    0xd043                          ; cd 43 d0
  jr      L337C                           ; 18 f6
L3386:
  ld      a,e                             ; 7b
  cp      0x27                            ; fe 27
  jr      nz,L338D                        ; 20 02
  set     7,d                             ; cb fa
L338D:
  ld      a,d                             ; 7a
  jp      0xd043                          ; c3 43 d0
  call    0xd899                          ; cd 99 d8
  bit     7,(ix+4)                        ; dd cb 04 7e
  ret     nz                              ; c0
  ld      a,d                             ; 7a
  cp      0x22                            ; fe 22
  jr      nz,L33A2                        ; 20 04
  cp      e                               ; bb
  call    z,0xd899                        ; cc 99 d8
L33A2:
  bit     7,(ix+4)                        ; dd cb 04 7e
  ret                                     ; c9
L33A7:
  dec     a                               ; 3d
  jp      z,0xd1ac                        ; ca ac d1
L33AB:
  call    0xd1f8                          ; cd f8 d1
  jp      c,0xd0ae                        ; da ae d0
  call    0xd0ae                          ; cd ae d0
  inc     ix                              ; dd 23
  jr      L33AB                           ; 18 f3
  ld      ix,0xac82                       ; dd 21 82 ac
  ld      b,(ix+1)                        ; dd 46 01
  ld      a,b                             ; 78
  and     0x30                            ; e6 30
  cp      0x30                            ; fe 30
  jp      z,0xcf5b                        ; ca 5b cf
  ld      a,b                             ; 78
  and     0xb0                            ; e6 b0
  cp      0x90                            ; fe 90
  jr      c,L33D4                         ; 38 06
  call    0xd00a                          ; cd 0a d0
  jp      0xaf43                          ; c3 43 af
L33D4:
  ld      a,0xdd                          ; 3e dd
  bit     5,b                             ; cb 68
  call    nz,0xd043                       ; c4 43 d0
  ld      a,0xfd                          ; 3e fd
  bit     4,b                             ; cb 60
  call    nz,0xd043                       ; c4 43 d0
  ld      a,0xcb                          ; 3e cb
  bit     7,b                             ; cb 78
  call    nz,0xd043                       ; c4 43 d0
  ld      a,0xed                          ; 3e ed
  bit     6,b                             ; cb 70
  call    nz,0xd043                       ; c4 43 d0
  ld      a,(ix+0)                        ; dd 7e 00
  call    0xd043                          ; cd 43 d0
  call    0xd15d                          ; cd 5d d1
  ld      a,b                             ; 78
  and     0x07                            ; e6 07
  ret     z                               ; c8
  dec     a                               ; 3d
  push    af                              ; f5
  call    0xd1f8                          ; cd f8 d1
  pop     af                              ; f1
  jr      nz,L3475                        ; 20 70
  ld      a,b                             ; 78
  inc     a                               ; 3c
  and     0xfe                            ; e6 fe
  jp      nz,0xd0d4                       ; c2 d4 d0
  ld      a,c                             ; 79
L340D:
  push    af                              ; f5
  ld      a,(0xaf48)                      ; 3a 48 af
  cp      0xc0                            ; fe c0
  jr      c,L3454                         ; 38 3f
  ld      a,(0xaf63)                      ; 3a 63 af
  and     0x07                            ; e6 07
  jr      z,L3454                         ; 28 38
  cp      0x07                            ; fe 07
  jr      z,L344C                         ; 28 2c
  ld      hl,(0xaf47)                     ; 2a 47 af
  ld      d,0xc0                          ; 16 c0
  dec     a                               ; 3d
  jr      z,L3435                         ; 28 0d
  sub     0x02                            ; d6 02
  ld      d,0x80                          ; 16 80
  jr      z,L3435                         ; 28 07
  dec     a                               ; 3d
  ld      d,0x40                          ; 16 40
  jr      z,L3435                         ; 28 02
  ld      d,0x00                          ; 16 00
L3435:
  ld      e,0x00                          ; 1e 00
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  ld      de,(0xc712)                     ; ed 5b 12 c7
  call    0xad77                          ; cd 77 ad
  jr      c,L344C                         ; 38 09
  ld      de,(0xe037)                     ; ed 5b 37 e0
  call    0xad77                          ; cd 77 ad
  jr      c,L3471                         ; 38 25
L344C:
  pop     af                              ; f1
  ld      de,(0xaf47)                     ; ed 5b 47 af
  jp      0xaf31                          ; c3 31 af
L3454:
  pop     af                              ; f1
  ld      de,0xabe0                       ; 11 e0 ab
  ld      hl,(0xaf47)                     ; 2a 47 af
  call    0xad77                          ; cd 77 ad
  ex      de,hl                           ; eb
  jr      c,L3468                         ; 38 07
  ld      hl,0xf698                       ; 21 98 f6
  sbc     hl,de                           ; ed 52
  jr      nc,L3471                        ; 30 09
L3468:
  ld      hl,0xffff                       ; 21 ff ff
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  jp      nc,0xaf31                       ; d2 31 af
L3471:
  ld      a,0x08                          ; 3e 08
  jr      L34DE                           ; 18 69
L3475:
  dec     a                               ; 3d
  jr      nz,L347F                        ; 20 07
  ld      a,c                             ; 79
  call    0xd043                          ; cd 43 d0
  ld      a,b                             ; 78
  jr      L340D                           ; 18 8e
L347F:
  dec     a                               ; 3d
  jr      nz,L34A2                        ; 20 20
  ld      hl,(0xaf3b)                     ; 2a 3b af
  inc     hl                              ; 23
  push    bc                              ; c5
  ex      (sp),hl                         ; e3
  pop     bc                              ; c1
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
L348C:
  ld      a,l                             ; 7d
  inc     h                               ; 24
  jr      z,L349A                         ; 28 0a
  dec     h                               ; 25
  jr      nz,L349E                        ; 20 0b
  cp      0x80                            ; fe 80
  jr      nc,L349E                        ; 30 07
L3497:
  jp      0xd043                          ; c3 43 d0
L349A:
  cp      0x80                            ; fe 80
  jr      nc,L3497                        ; 30 f9
L349E:
  ld      a,0x03                          ; 3e 03
  jr      L34DE                           ; 18 3c
L34A2:
  dec     a                               ; 3d
  jr      nz,L34A9                        ; 20 04
  ld      h,b                             ; 60
  ld      l,c                             ; 69
  jr      L348C                           ; 18 e3
L34A9:
  dec     a                               ; 3d
  jr      nz,L34B7                        ; 20 0b
  call    0xd0db                          ; cd db d0
  inc     ix                              ; dd 23
  call    0xd1f8                          ; cd f8 d1
  jp      0xd03b                          ; c3 3b d0
L34B7:
  ld      a,c                             ; 79
  and     0xc7                            ; e6 c7
  or      b                               ; b0
  ld      a,0x06                          ; 3e 06
  jr      nz,L34DE                        ; 20 1f
  ld      a,c                             ; 79
  jp      0xaf52                          ; c3 52 af
  ld      ix,0xac82                       ; dd 21 82 ac
  bit     3,(ix+1)                        ; dd cb 01 5e
  jr      z,L34FB                         ; 28 2e
  call    0xd8a2                          ; cd a2 d8
  ld      (0xd176),de                     ; ed 53 76 d1
  call    0xade9                          ; cd e9 ad
  ld      c,a                             ; 4f
  and     0xc0                            ; e6 c0
  jr      z,L34E7                         ; 28 0b
  ld      a,0x12                          ; 3e 12
L34DE:
  ld      hl,0x0000                       ; 21 00 00
  ld      (0xda17),hl                     ; 22 17 da
  jp      0xd813                          ; c3 13 d8
L34E7:
  ld      a,c                             ; 79
  set     6,a                             ; cb f7
  call    0xae29                          ; cd 29 ae
  ld      hl,(0xaf3b)                     ; 2a 3b af
  ex      de,hl                           ; eb
  dec     hl                              ; 2b
  ld      a,d                             ; 7a
  call    0xae29                          ; cd 29 ae
  dec     hl                              ; 2b
  ld      a,e                             ; 7b
  call    0xae29                          ; cd 29 ae
L34FB:
  ld      a,(ix+1)                        ; dd 7e 01
  and     0x30                            ; e6 30
  cp      0x30                            ; fe 30
  jr      z,L3531                         ; 28 2d
  ld      a,(ix+1)                        ; dd 7e 01
  and     0x07                            ; e6 07
  ld      c,a                             ; 4f
  ld      b,0x00                          ; 06 00
  ld      hl,0xd155                       ; 21 55 d1
  add     hl,bc                           ; 09
  ld      a,(hl)                          ; 7e
  inc     a                               ; 3c
  ld      bc,0x0400                       ; 01 00 04
  ld      d,(ix+1)                        ; dd 56 01
L3518:
  rl      d                               ; cb 12
  adc     a,c                             ; 89
  djnz    L3518                           ; 10 fb
  jr      L3591                           ; 18 72
  nop                                     ; 00
  ld      bc,0x0102                       ; 01 02 01
  ld      bc,0x0002                       ; 01 02 00
  nop                                     ; 00
  bit     3,(ix+1)                        ; dd cb 01 5e
  ret     z                               ; c8
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
  ret                                     ; c9
L3531:
  ld      a,(ix+0)                        ; dd 7e 00
  call    0xd15d                          ; cd 5d d1
  sub     0x03                            ; d6 03
  ret     c                               ; d8
  jr      nz,L354C                        ; 20 10
  call    0xd1f8                          ; cd f8 d1
  ld      hl,0x0000                       ; 21 00 00
  dec     hl                              ; 2b
  ld      a,b                             ; 78
  call    0xae29                          ; cd 29 ae
  dec     hl                              ; 2b
  ld      a,c                             ; 79
  jp      0xae29                          ; c3 29 ae
L354C:
  dec     a                               ; 3d
  jr      nz,L355B                        ; 20 0c
  call    0xd1f8                          ; cd f8 d1
  ld      (0xaf3b),bc                     ; ed 43 3b af
  ld      (0xaf47),bc                     ; ed 43 47 af
  ret                                     ; c9
L355B:
  dec     a                               ; 3d
  ret     z                               ; c8
  dec     a                               ; 3d
  jr      nz,L3566                        ; 20 06
  call    0xd1d0                          ; cd d0 d1
  ld      a,c                             ; 79
  jr      L3591                           ; 18 2b
L3566:
  dec     a                               ; 3d
  jr      nz,L3573                        ; 20 0a
  ld      c,a                             ; 4f
L356A:
  inc     c                               ; 0c
  call    0xcfc7                          ; cd c7 cf
  jr      z,L356A                         ; 28 fa
  ld      a,c                             ; 79
  jr      L3591                           ; 18 1e
L3573:
  dec     a                               ; 3d
  jr      nz,L358C                        ; 20 16
L3576:
  call    0xd1f8                          ; cd f8 d1
  push    af                              ; f5
  ld      hl,0xaf3b                       ; 21 3b af
  call    0xe1c4                          ; cd c4 e1
  ld      hl,0xaf47                       ; 21 47 af
  call    0xe1c4                          ; cd c4 e1
  pop     af                              ; f1
  inc     ix                              ; dd 23
  jr      nc,L3576                        ; 30 eb
  ret                                     ; c9
L358C:
  call    0xd1d0                          ; cd d0 d1
  ld      a,c                             ; 79
  add     a,c                             ; 81
L3591:
  ld      b,0x00                          ; 06 00
  ld      c,a                             ; 4f
  ld      hl,0xaf3b                       ; 21 3b af
  jp      0xe1c4                          ; c3 c4 e1
  ld      c,0x01                          ; 0e 01
L359C:
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x2c                            ; fe 2c
  jr      nz,L35A6                        ; 20 03
  inc     c                               ; 0c
  jr      L35B3                           ; 18 0d
L35A6:
  cp      0x22                            ; fe 22
  jr      nz,L35B7                        ; 20 0d
L35AA:
  inc     ix                              ; dd 23
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x22                            ; fe 22
  jr      nz,L35AA                        ; 20 f7
L35B3:
  inc     ix                              ; dd 23
  jr      L359C                           ; 18 e5
L35B7:
  cp      0xc0                            ; fe c0
  ret     nc                              ; d0
  cp      0x80                            ; fe 80
  jr      c,L35B3                         ; 38 f5
  inc     ix                              ; dd 23
  jr      L35B3                           ; 18 f1
  ld      hl,0x0000                       ; 21 00 00
  ld      a,0x2b                          ; 3e 2b
  push    hl                              ; e5
  push    af                              ; f5
  ld      a,(ix+2)                        ; dd 7e 02
  push    af                              ; f5
  cp      0x2d                            ; fe 2d
  jr      nz,L35D3                        ; 20 02
  inc     ix                              ; dd 23
L35D3:
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x24                            ; fe 24
  ld      de,(0xaf3b)                     ; ed 5b 3b af
  jr      z,L3607                         ; 28 29
  cp      0x80                            ; fe 80
  jp      c,0xd2c3                        ; da c3 d2
  ld      d,a                             ; 57
  ld      e,(ix+3)                        ; dd 5e 03
  inc     ix                              ; dd 23
  call    0xd8a5                          ; cd a5 d8
  call    0xade9                          ; cd e9 ad
  and     0xc0                            ; e6 c0
  jr      nz,L35FC                        ; 20 09
  ld      (0xd83c),de                     ; ed 53 3c d8
  ld      a,0x09                          ; 3e 09
  jp      0xd114                          ; c3 14 d1
L35FC:
  dec     de                              ; 1b
  ex      de,hl                           ; eb
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  dec     hl                              ; 2b
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
L3607:
  inc     ix                              ; dd 23
  jr      L3637                           ; 18 2c
  ld      a,(ix+2)                        ; dd 7e 02
  xor     0x2c                            ; ee 2c
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  ret     z                               ; c8
  xor     0x33                            ; ee 33
  ret     z                               ; c8
  cp      0xc0                            ; fe c0
  ccf                                     ; 3f
  ret     c                               ; d8
  xor     0x1f                            ; ee 1f
  inc     ix                              ; dd 23
  jp      0xd1fd                          ; c3 fd d1
L3621:
  ld      de,0x0000                       ; 11 00 00
  inc     ix                              ; dd 23
  call    0xd305                          ; cd 05 d3
  jr      c,L3635                         ; 38 0a
  ld      e,a                             ; 5f
  call    0xd305                          ; cd 05 d3
  jr      c,L3635                         ; 38 04
  ld      d,e                             ; 53
  ld      e,a                             ; 5f
  inc     ix                              ; dd 23
L3635:
  ex      de,hl                           ; eb
  ex      de,hl                           ; eb
L3637:
  pop     af                              ; f1
  call    0xd2b8                          ; cd b8 d2
  pop     af                              ; f1
  pop     hl                              ; e1
  ld      bc,0xd241                       ; 01 41 d2
  push    bc                              ; c5
  cp      0x2b                            ; fe 2b
  jr      z,L367D                         ; 28 38
  cp      0x2d                            ; fe 2d
  jr      z,L367F                         ; 28 36
  cp      0x2a                            ; fe 2a
  jr      z,L366C                         ; 28 1f
  cp      0x2f                            ; fe 2f
  jr      z,L3666                         ; 28 15
  ld      a,h                             ; 7c
  ld      c,l                             ; 4d
  ld      hl,0x0000                       ; 21 00 00
  ld      b,0x10                          ; 06 10
L3658:
  defb    0xcb, 0x31
  rla                                     ; 17
  adc     hl,hl                           ; ed 6a
  sbc     hl,de                           ; ed 52
  jr      nc,L3663                        ; 30 02
  add     hl,de                           ; 19
  dec     c                               ; 0d
L3663:
  djnz    L3658                           ; 10 f3
  ret                                     ; c9
L3666:
  call    0xd287                          ; cd 87 d2
  ld      h,a                             ; 67
  ld      l,c                             ; 69
  ret                                     ; c9
L366C:
  ld      b,0x10                          ; 06 10
  ld      a,h                             ; 7c
  ld      c,l                             ; 4d
  ld      hl,0x0000                       ; 21 00 00
L3673:
  add     hl,hl                           ; 29
  rl      c                               ; cb 11
  rla                                     ; 17
  jr      nc,L367A                        ; 30 01
  add     hl,de                           ; 19
L367A:
  djnz    L3673                           ; 10 f7
  ret                                     ; c9
L367D:
  add     hl,de                           ; 19
  ret                                     ; c9
L367F:
  or      a                               ; b7
  sbc     hl,de                           ; ed 52
  cp      0x2d                            ; fe 2d
  ret     nz                              ; c0
  ld      a,d                             ; 7a
  cpl                                     ; 2f
  ld      d,a                             ; 57
  ld      a,e                             ; 7b
  cpl                                     ; 2f
  ld      e,a                             ; 5f
  inc     de                              ; 13
  ret                                     ; c9
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x22                            ; fe 22
  jr      z,L3621                         ; 28 8d
  ld      c,0x0a                          ; 0e 0a
  cp      0x25                            ; fe 25
  jr      nz,L369E                        ; 20 04
  inc     ix                              ; dd 23
  ld      c,0x02                          ; 0e 02
L369E:
  cp      0x23                            ; fe 23
  jr      nz,L36A6                        ; 20 04
  inc     ix                              ; dd 23
  ld      c,0x10                          ; 0e 10
L36A6:
  ld      hl,0x0000                       ; 21 00 00
L36A9:
  ld      a,(ix+2)                        ; dd 7e 02
  sub     0x30                            ; d6 30
  cp      0x0a                            ; fe 0a
  jr      c,L36B9                         ; 38 07
  sub     0x07                            ; d6 07
  cp      0x0a                            ; fe 0a
  jp      c,0xd26c                        ; da 6c d2
L36B9:
  cp      c                               ; b9
  jp      nc,0xd26c                       ; d2 6c d2
  push    af                              ; f5
  ld      a,c                             ; 79
  dec     a                               ; 3d
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
L36C2:
  add     hl,de                           ; 19
  dec     a                               ; 3d
  jr      nz,L36C2                        ; 20 fc
  pop     af                              ; f1
  ld      d,0x00                          ; 16 00
  ld      e,a                             ; 5f
  add     hl,de                           ; 19
  inc     ix                              ; dd 23
  jr      L36A9                           ; 18 da
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x22                            ; fe 22
  jr      nz,L36DF                        ; 20 09
  cp      (ix+3)                          ; dd be 03
  inc     ix                              ; dd 23
  jr      z,L36DF                         ; 28 02
  scf                                     ; 37
  ret                                     ; c9
L36DF:
  inc     ix                              ; dd 23
  or      a                               ; b7
  ret                                     ; c9
  ld      b,0x61                          ; 06 61
  call    0xd37f                          ; cd 7f d3
  call    z,0xcef1                        ; cc f1 ce
  call    0xd40d                          ; cd 0d d4
  jp      0xb412                          ; c3 12 b4
  ld      b,0x79                          ; 06 79
  call    0xd37f                          ; cd 7f d3
  ret     nz                              ; c0
  rst     0x00                            ; c7
  rst     0x00                            ; c7
L36F9:
  ld      ix,0xac82                       ; dd 21 82 ac
  ld      de,0x0011                       ; 11 11 00
  xor     a                               ; af
  scf                                     ; 37
  call    0xb094                          ; cd 94 b0
  jr      nc,L36F9                        ; 30 f2
  ld      a,0x11                          ; 3e 11
  call    0xd830                          ; cd 30 d8
  ld      hl,0xac83                       ; 21 83 ac
  ld      b,0x0a                          ; 06 0a
L3711:
  ld      a,(hl)                          ; 7e
  cp      0x20                            ; fe 20
  jr      c,L371A                         ; 38 04
  cp      0x80                            ; fe 80
  jr      c,L371C                         ; 38 02
L371A:
  ld      a,0x3f                          ; 3e 3f
L371C:
  call    0xdf0f                          ; cd 0f df
  inc     hl                              ; 23
  djnz    L3711                           ; 10 ef
  ld      a,(0xac82)                      ; 3a 82 ac
  cp      0x03                            ; fe 03
  jr      nz,L36F9                        ; 20 d0
  ret                                     ; c9
  ld      b,0x0a                          ; 06 0a
  ld      hl,0xcd7b                       ; 21 7b cd
L372F:
  ld      a,(hl)                          ; 7e
  cp      0x20                            ; fe 20
  jr      nz,L3737                        ; 20 03
  djnz    L372F                           ; 10 f9
  ret                                     ; c9
L3737:
  ld      b,0x0a                          ; 06 0a
  ld      hl,0xcd7b                       ; 21 7b cd
  ld      de,0xac83                       ; 11 83 ac
L373F:
  ld      a,(de)                          ; 1a
  cp      (hl)                            ; be
  inc     hl                              ; 23
  inc     de                              ; 13
  ret     nz                              ; c0
  djnz    L373F                           ; 10 f9
  ret                                     ; c9
  ld      b,0x42                          ; 06 42
  ld      hl,0xac3f                       ; 21 3f ac
  call    0xdd78                          ; cd 78 dd
  inc     hl                              ; 23
  cp      b                               ; b8
  ret     z                               ; c8
  set     5,b                             ; cb e8
  cp      b                               ; b8
  ret                                     ; c9
  ld      hl,0xe0cd                       ; 21 cd e0
  jr      L375E                           ; 18 03
  ld      hl,0xd594                       ; 21 94 d5
L375E:
  ld      a,(hl)                          ; 7e
  xor     0x01                            ; ee 01
  ld      (hl),a                          ; 77
  ret                                     ; c9
  ld      iy,0x5c3a                       ; fd 21 3a 5c
  call    0xaf25                          ; cd 25 af
  im      1                               ; ed 56
  ei                                      ; fb
  ld      sp,(0x5c3d)                     ; ed 7b 3d 5c
  jp      0x1b76                          ; c3 76 1b
  push    af                              ; f5
  ld      c,0x00                          ; 0e 00
  call    0x22b0                          ; cd b0 22
  push    hl                              ; e5
  call    0xd3da                          ; cd da d3
  pop     de                              ; d1
  pop     af                              ; f1
  ret                                     ; c9
  push    hl                              ; e5
  pop     ix                              ; dd e1
  call    0xda39                          ; cd 39 da
  ld      a,0xef                          ; 3e ef
  in      a,(0xfe)                        ; db fe
  ret                                     ; c9
  call    0xd9d6                          ; cd d6 d9
  call    0xe225                          ; cd 25 e2
  ccf                                     ; 3f
  jr      L379B                           ; 18 06
  call    0xd9eb                          ; cd eb d9
  call    0xe22e                          ; cd 2e e2
L379B:
  pop     de                              ; d1
  jp      nc,0xd45f                       ; d2 5f d4
  push    de                              ; d5
  ld      (0xda17),hl                     ; 22 17 da
  ret                                     ; c9
  push    hl                              ; e5
  push    de                              ; d5
  ld      b,0x08                          ; 06 08
L37A8:
  push    hl                              ; e5
  push    de                              ; d5
  ld      c,0x20                          ; 0e 20
L37AC:
  ld      a,(hl)                          ; 7e
  ld      (de),a                          ; 12
  inc     l                               ; 2c
  inc     e                               ; 1c
  dec     c                               ; 0d
  jr      nz,L37AC                        ; 20 f9
  pop     de                              ; d1
  pop     hl                              ; e1
  inc     h                               ; 24
  inc     d                               ; 14
  djnz    L37A8                           ; 10 ef
  pop     de                              ; d1
  pop     hl                              ; e1
  ret                                     ; c9
  ld      (de),a                          ; 12
  inc     de                              ; 13
  dec     c                               ; 0d
  ret     nz                              ; c0
  jr      L380A                           ; 18 48
  ld      hl,0x50c0                       ; 21 c0 50
  ld      (0xdf57),hl                     ; 22 57 df
  ld      bc,0x2001                       ; 01 01 20
  ld      e,0x7e                          ; 1e 7e
  call    0xd412                          ; cd 12 d4
  ld      bc,0x2001                       ; 01 01 20
  ld      e,0x20                          ; 1e 20
  jr      L37DC                           ; 18 05
  ld      e,0x20                          ; 1e 20
  ld      bc,0x0003                       ; 01 03 00
L37DC:
  ld      a,e                             ; 7b
  call    0xdf38                          ; cd 38 df
  djnz    L37DC                           ; 10 fa
  dec     c                               ; 0d
  jr      nz,L37DC                        ; 20 f7
  ret                                     ; c9
  call    0xc711                          ; cd 11 c7
  jr      L3804                           ; 18 19
  ld      a,0x01                          ; 3e 01
  ld      (0xd42a),a                      ; 32 2a d4
  call    0xcef1                          ; cd f1 ce
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  ld      a,0x13                          ; 3e 13
  jp      nz,0xd813                       ; c2 13 d8
  call    0xd40d                          ; cd 0d d4
  call    0xaf69                          ; cd 69 af
  call    0xde03                          ; cd 03 de
L3804:
  di                                      ; f3
  ld      e,0x7e                          ; 1e 7e
  call    0xd40f                          ; cd 0f d4
L380A:
  ld      hl,0x59e0                       ; 21 e0 59
  ld      bc,0x2030                       ; 01 30 20
  call    0xdaab                          ; cd ab da
  ld      a,0x0f                          ; 3e 0f
  call    0xe1f5                          ; cd f5 e1
  ld      hl,0xabe4                       ; 21 e4 ab
  ld      bc,0x9e00                       ; 01 00 9e
  call    0xdaab                          ; cd ab da
  ld      hl,0xac3e                       ; 21 3e ac
  ld      (hl),0x01                       ; 36 01
  dec     hl                              ; 2b
  ld      (hl),0x80                       ; 36 80
L3829:
  ld      sp,0xad04                       ; 31 04 ad
  call    0xda16                          ; cd 16 da
  call    0xdd88                          ; cd 88 dd
  call    0xcec2                          ; cd c2 ce
  call    0xde03                          ; cd 03 de
  push    af                              ; f5
  call    0xaf25                          ; cd 25 af
  ld      a,0x0f                          ; 3e 0f
  call    0xe1f5                          ; cd f5 e1
  ld      a,0x0f                          ; 3e 0f
  ld      (0xd473),a                      ; 32 73 d4
  pop     af                              ; f1
  cp      0x15                            ; fe 15
  jr      z,L380A                         ; 28 bf
  cp      0x04                            ; fe 04
  jr      nz,L3868                        ; 20 19
  ld      ix,(0xda17)                     ; dd 2a 17 da
  ld      hl,0xac3e                       ; 21 3e ac
  push    hl                              ; e5
  ld      bc,0x2000                       ; 01 00 20
  call    0xdaab                          ; cd ab da
  pop     hl                              ; e1
  call    0xd8d2                          ; cd d2 d8
  ld      a,0x01                          ; 3e 01
  ld      (0xd594),a                      ; 32 94 d5
  jr      L386F                           ; 18 07
L3868:
  cp      0x14                            ; fe 14
  jr      nz,L3876                        ; 20 0a
  call    0xd391                          ; cd 91 d3
L386F:
  ld      a,0x0f                          ; 3e 0f
  call    0xe1f5                          ; cd f5 e1
  jr      L3829                           ; 18 b3
L3876:
  ld      b,0x14                          ; 06 14
  cp      0x06                            ; fe 06
  jr      nz,L3883                        ; 20 07
L387C:
  call    0xd3cb                          ; cd cb d3
  djnz    L387C                           ; 10 fb
L3881:
  jr      L3829                           ; 18 a6
L3883:
  cp      0x09                            ; fe 09
  jr      nz,L38B2                        ; 20 2b
L3887:
  call    0xd3cb                          ; cd cb d3
  ld      de,0x4040                       ; 11 40 40
  ld      a,0x18                          ; 3e 18
L388F:
  call    0xd3aa                          ; cd aa d3
  add     a,0x08                          ; c6 08
  cp      0xa9                            ; fe a9
  jr      c,L388F                         ; 38 f7
  ld      hl,0x50a0                       ; 21 a0 50
  call    0xddbf                          ; cd bf dd
  ld      b,0x06                          ; 06 06
  ld      hl,(0xda17)                     ; 2a 17 da
L38A3:
  call    0xd9ee                          ; cd ee d9
  djnz    L38A3                           ; 10 fb
  call    0xd3b7                          ; cd b7 d3
  bit     4,a                             ; cb 67
  jr      z,L3887                         ; 28 d8
L38AF:
  jp      0xd465                          ; c3 65 d4
L38B2:
  cp      0x07                            ; fe 07
  jr      nz,L38BD                        ; 20 07
L38B6:
  call    0xd3c2                          ; cd c2 d3
  djnz    L38B6                           ; 10 fb
L38BB:
  jr      L3881                           ; 18 c4
L38BD:
  cp      0x0a                            ; fe 0a
  jr      nz,L38EB                        ; 20 2a
L38C1:
  call    0xd3c2                          ; cd c2 d3
  ld      de,0x50a0                       ; 11 a0 50
  ld      a,0xa0                          ; 3e a0
L38C9:
  call    0xd3aa                          ; cd aa d3
  sub     0x08                            ; d6 08
  cp      0x10                            ; fe 10
  jr      nc,L38C9                        ; 30 f7
  ld      hl,0x4040                       ; 21 40 40
  call    0xddbf                          ; cd bf dd
  ld      b,0x0d                          ; 06 0d
  ld      hl,(0xda17)                     ; 2a 17 da
L38DD:
  call    0xd9d9                          ; cd d9 d9
  djnz    L38DD                           ; 10 fb
  call    0xd3b7                          ; cd b7 d3
  bit     3,a                             ; cb 5f
  jr      z,L38C1                         ; 28 d8
L38E9:
  jr      L38AF                           ; 18 c4
L38EB:
  cp      0x0c                            ; fe 0c
  jr      nz,L3905                        ; 20 16
  ld      bc,0x0001                       ; 01 01 00
  ld      hl,(0xda17)                     ; 2a 17 da
  call    0xc7f5                          ; cd f5 c7
  call    0xe225                          ; cd 25 e2
  jr      z,L38BB                         ; 28 be
  call    nc,0xd9d9                       ; d4 d9 d9
  ld      (0xda17),hl                     ; 22 17 da
L3903:
  jr      L38BB                           ; 18 b6
L3905:
  cp      0x0e                            ; fe 0e
  jr      nz,L3917                        ; 20 0e
  ld      hl,(0xd87c)                     ; 2a 7c d8
  ld      (0xd879),hl                     ; 22 79 d8
  ld      hl,(0xda17)                     ; 2a 17 da
  ld      (0xd87c),hl                     ; 22 7c d8
  jr      L3903                           ; 18 ec
L3917:
  call    0xd5b0                          ; cd b0 d5
  jr      nz,L38E9                        ; 20 cd
  ld      hl,0x5ae0                       ; 21 e0 5a
  ld      bc,0x203f                       ; 01 3f 20
  call    0xdaab                          ; cd ab da
  ld      hl,0xac3e                       ; 21 3e ac
  call    0xdd78                          ; cd 78 dd
  ld      d,0x00                          ; 16 00
  ld      c,0x09                          ; 0e 09
  cp      0x80                            ; fe 80
  jr      c,L3946                         ; 38 13
  ld      hl,0xd440                       ; 21 40 d4
  ld      (0xd5ae),hl                     ; 22 ae d5
  push    hl                              ; e5
  ld      h,d                             ; 62
  ld      l,a                             ; 6f
  ld      de,0xc4c4                       ; 11 c4 c4
  add     hl,hl                           ; 29
  add     hl,de                           ; 19
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  ld      h,(hl)                          ; 66
  ld      l,a                             ; 6f
  jp      (hl)                            ; e9
L3946:
  call    0xd65c                          ; cd 5c d6
  call    0xd9eb                          ; cd eb d9
  push    hl                              ; e5
  ld      (0xe1b3),hl                     ; 22 b3 e1
  ld      de,0xac60                       ; 11 60 ac
  ld      a,(de)                          ; 1a
  ld      c,a                             ; 4f
  inc     de                              ; 13
  call    0xe28d                          ; cd 8d e2
  pop     hl                              ; e1
  ld      (0xda17),hl                     ; 22 17 da
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  jr      z,L396E                         ; 28 0c
  call    0xd9d6                          ; cd d6 d9
  ld      (0xda17),hl                     ; 22 17 da
  ld      bc,0x0001                       ; 01 01 00
  call    0xe160                          ; cd 60 e1
L396E:
  ld      a,0x0f                          ; 3e 0f
  ld      (0xd473),a                      ; 32 73 d4
  xor     a                               ; af
  ld      (0xd594),a                      ; 32 94 d5
  jp      0xd440                          ; c3 40 d4
  ld      hl,0x0000                       ; 21 00 00
  cp      0x0d                            ; fe 0d
  ret     z                               ; c8
  cp      0x08                            ; fe 08
  jr      nz,L3990                        ; 20 0c
  ld      b,(hl)                          ; 46
  dec     hl                              ; 2b
  ld      a,(hl)                          ; 7e
  rlca                                    ; 07
  jr      c,L39B1                         ; 38 27
  ld      c,(hl)                          ; 4e
  ld      (hl),b                          ; 70
  inc     hl                              ; 23
  ld      (hl),c                          ; 71
  jr      L39B1                           ; 18 21
L3990:
  cp      0x0b                            ; fe 0b
  jr      nz,L399E                        ; 20 0a
  ld      b,(hl)                          ; 46
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  and     a                               ; a7
  jr      z,L39B1                         ; 28 17
  ld      (hl),b                          ; 70
  dec     hl                              ; 2b
  ld      (hl),a                          ; 77
  ret                                     ; c9
L399E:
  cp      0x03                            ; fe 03
  jr      nz,L39B3                        ; 20 11
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
  dec     hl                              ; 2b
  ld      a,(hl)                          ; 7e
  cp      0x80                            ; fe 80
  jr      z,L39B1                         ; 28 07
L39AA:
  ld      a,(de)                          ; 1a
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  inc     de                              ; 13
  or      a                               ; b7
  jr      nz,L39AA                        ; 20 f9
L39B1:
  inc     a                               ; 3c
  ret                                     ; c9
L39B3:
  cp      0x05                            ; fe 05
  jr      nz,L39C0                        ; 20 09
  ld      hl,0xde39                       ; 21 39 de
  ld      a,0xf7                          ; 3e f7
  sub     (hl)                            ; 96
  ld      (hl),a                          ; 77
  jr      L39B1                           ; 18 f1
L39C0:
  cp      0x20                            ; fe 20
  ret     c                               ; d8
  ld      b,a                             ; 47
  jr      nz,L39EB                        ; 20 25
  ld      de,0xac3e                       ; 11 3e ac
  ld      a,(de)                          ; 1a
  cp      0x3b                            ; fe 3b
  jr      z,L39EB                         ; 28 1d
  rlca                                    ; 07
  jr      c,L39EB                         ; 38 1a
  push    hl                              ; e5
  sbc     hl,de                           ; ed 52
  ld      a,0x0d                          ; 3e 0d
  sub     l                               ; 95
  pop     hl                              ; e1
  jr      c,L39EB                         ; 38 11
  cp      0x05                            ; fe 05
  jr      c,L39E0                         ; 38 02
  sub     0x05                            ; d6 05
L39E0:
  ld      b,a                             ; 47
  inc     b                               ; 04
  ld      c,0x20                          ; 0e 20
  call    0xdaab                          ; cd ab da
  ld      (hl),0x01                       ; 36 01
  jr      L39B1                           ; 18 c6
L39EB:
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  jr      z,L39B1                         ; 28 c1
  ld      a,b                             ; 78
L39F1:
  ex      af,af'                          ; 08
  ld      a,(hl)                          ; 7e
  ex      af,af'                          ; 08
  ld      (hl),a                          ; 77
  cp      0xc5                            ; fe c5
  ret     z                               ; c8
  cp      0xc8                            ; fe c8
  ret     z                               ; c8
  cp      0xcb                            ; fe cb
  ret     z                               ; c8
  cp      0xd7                            ; fe d7
  ret     z                               ; c8
  inc     hl                              ; 23
  ex      af,af'                          ; 08
  or      a                               ; b7
  jr      nz,L39F1                        ; 20 eb
  jr      L39B1                           ; 18 a9
L3A08:
  ld      ix,0xac63                       ; dd 21 63 ac
  ld      (ix-2),0x01                     ; dd 36 fe 01
  ld      (ix-1),0x37                     ; dd 36 ff 37
  ld      b,0xff                          ; 06 ff
  jr      L3A1B                           ; 18 03
L3A18:
  call    0xdd77                          ; cd 77 dd
L3A1B:
  call    0xe130                          ; cd 30 e1
  or      a                               ; b7
  jr      nz,L3A18                        ; 20 f7
  dec     ix                              ; dd 2b
  jp      0xd764                          ; c3 64 d7
  cp      0x3b                            ; fe 3b
  jr      z,L3A08                         ; 28 de
  cp      0x20                            ; fe 20
  call    nz,0xdd39                       ; c4 39 dd
  call    0xdd7f                          ; cd 7f dd
  ld      de,0xac38                       ; 11 38 ac
  ld      c,0x05                          ; 0e 05
  call    0xdd39                          ; cd 39 dd
  call    0xdd7f                          ; cd 7f dd
  ld      de,0xac24                       ; 11 24 ac
  ld      c,0x12                          ; 0e 12
  call    0xdd3d                          ; cd 3d dd
  jr      nz,L3A4B                        ; 20 04
  inc     hl                              ; 23
  ld      (0xac37),a                      ; 32 37 ac
L3A4B:
  ld      de,0xac10                       ; 11 10 ac
  ld      c,0x12                          ; 0e 12
  call    0xdd41                          ; cd 41 dd
  call    0xdb55                          ; cd 55 db
  ld      hl,0xac38                       ; 21 38 ac
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  jr      z,L3A6E                         ; 28 11
  push    hl                              ; e5
  call    0xdce9                          ; cd e9 dc
  ld      hl,0xdd0f                       ; 21 0f dd
  call    0xdd23                          ; cd 23 dd
  pop     hl                              ; e1
  call    0xdcf1                          ; cd f1 dc
  jp      c,0xd7f6                        ; da f6 d7
L3A6E:
  ld      (0xd70e),a                      ; 32 0e d7
  cp      0x3a                            ; fe 3a
  jr      c,L3A7A                         ; 38 05
  cp      0x3e                            ; fe 3e
  jp      c,0xd776                        ; da 76 d7
L3A7A:
  ld      hl,0xac24                       ; 21 24 ac
  push    hl                              ; e5
  call    0xdce9                          ; cd e9 dc
  pop     hl                              ; e1
  ld      a,b                             ; 78
  dec     a                               ; 3d
  jr      nz,L3AAE                        ; 20 28
  ld      a,(0xd70e)                      ; 3a 0e d7
  cp      0x06                            ; fe 06
  jr      nz,L3A9B                        ; 20 0e
  ld      a,(hl)                          ; 7e
  sub     0x2f                            ; d6 2f
  cp      0x04                            ; fe 04
L3A92:
  jp      nc,0xd7fa                       ; d2 fa d7
  or      a                               ; b7
  jp      z,0xd7fa                        ; ca fa d7
  jr      L3AB1                           ; 18 16
L3A9B:
  cp      0x11                            ; fe 11
  jr      z,L3AA7                         ; 28 08
  cp      0x26                            ; fe 26
  jr      z,L3AA7                         ; 28 04
  cp      0x31                            ; fe 31
  jr      nz,L3AAE                        ; 20 07
L3AA7:
  ld      a,(hl)                          ; 7e
  sub     0x2f                            ; d6 2f
  cp      0x09                            ; fe 09
  jr      L3A92                           ; 18 e4
L3AAE:
  call    0xdcaa                          ; cd aa dc
L3AB1:
  ld      (0xd700),a                      ; 32 00 d7
  ld      hl,0xac10                       ; 21 10 ac
  call    0xdcaa                          ; cd aa dc
  ld      (0xd6f8),a                      ; 32 f8 d6
  xor     a                               ; af
  ld      (0xd736),a                      ; 32 36 d7
  ld      a,0x00                          ; 3e 00
  call    0xdc8d                          ; cd 8d dc
  add     a,a                             ; 87
  add     a,a                             ; 87
  ld      e,a                             ; 5f
  ld      a,0x00                          ; 3e 00
  call    0xdc8d                          ; cd 8d dc
  ld      d,a                             ; 57
  ld      b,0x03                          ; 06 03
L3AD1:
  sla     e                               ; cb 23
  rl      d                               ; cb 12
  djnz    L3AD1                           ; 10 fa
  ld      a,0x00                          ; 3e 00
  rla                                     ; 17
  ld      hl,0xe66a                       ; 21 6a e6
  ld      bc,0x02af                       ; 01 af 02
L3AE0:
  inc     hl                              ; 23
  ex      af,af'                          ; 08
L3AE2:
  inc     hl                              ; 23
  ex      af,af'                          ; 08
  inc     hl                              ; 23
  inc     hl                              ; 23
  cpi                                     ; ed a1
  jp      po,0xd811                       ; e2 11 d8
  jr      nz,L3AE0                        ; 20 f3
  ex      af,af'                          ; 08
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  cp      d                               ; ba
  jr      nz,L3AE2                        ; 20 ef
  ld      a,(hl)                          ; 7e
  and     0xe0                            ; e6 e0
  cp      e                               ; bb
  jr      nz,L3AE2                        ; 20 e9
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ld      d,(hl)                          ; 56
  dec     hl                              ; 2b
  ld      e,(hl)                          ; 5e
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  jr      z,L3B08                         ; 28 04
  res     5,d                             ; cb aa
  set     4,d                             ; cb e2
L3B08:
  call    0xdab0                          ; cd b0 da
  ld      a,(0xd700)                      ; 3a 00 d7
  cp      0x2c                            ; fe 2c
  ld      de,0xac24                       ; 11 24 ac
  call    nc,0xdb6a                       ; d4 6a db
  ld      a,(0xd6f8)                      ; 3a f8 d6
  jr      c,L3B26                         ; 38 0b
  cp      0x2c                            ; fe 2c
  jr      c,L3B2E                         ; 38 0f
  ld      (ix+0),0x1f                     ; dd 36 00 1f
  inc     ix                              ; dd 23
  inc     b                               ; 04
L3B26:
  ld      de,0xac10                       ; 11 10 ac
  cp      0x2c                            ; fe 2c
  call    nc,0xdb6a                       ; d4 6a db
L3B2E:
  ld      a,b                             ; 78
  or      a                               ; b7
  jr      z,L3B3A                         ; 28 08
  set     7,b                             ; cb f8
  set     6,b                             ; cb f0
  ld      (ix+0),b                        ; dd 70 00
  inc     a                               ; 3c
L3B3A:
  add     a,0x02                          ; c6 02
  ld      (0xac60),a                      ; 32 60 ac
  ret                                     ; c9
  push    af                              ; f5
  sub     0x34                            ; d6 34
  ld      e,a                             ; 5f
  ld      d,0x37                          ; 16 37
  call    0xdab0                          ; cd b0 da
  push    bc                              ; c5
  ld      hl,0xac23                       ; 21 23 ac
  xor     a                               ; af
  ld      c,a                             ; 4f
L3B4F:
  inc     hl                              ; 23
  inc     c                               ; 0c
  cp      (hl)                            ; be
  jr      nz,L3B4F                        ; 20 fb
  ld      de,0xac10                       ; 11 10 ac
  ld      a,(de)                          ; 1a
  or      a                               ; b7
  jr      z,L3B5F                         ; 28 04
  ld      (hl),0x2c                       ; 36 2c
  inc     hl                              ; 23
  xor     a                               ; af
L3B5F:
  ex      de,hl                           ; eb
L3B60:
  cp      (hl)                            ; be
  jr      z,L3B69                         ; 28 06
  ldi                                     ; ed a0
  inc     c                               ; 0c
  inc     c                               ; 0c
  jr      L3B60                           ; 18 f7
L3B69:
  ld      a,0x12                          ; 3e 12
  cp      c                               ; b9
  jr      c,L3BCC                         ; 38 5e
  pop     bc                              ; c1
  pop     af                              ; f1
  cp      0x3b                            ; fe 3b
  jr      z,L3B89                         ; 28 15
  ld      de,0xac24                       ; 11 24 ac
L3B77:
  ld      a,0x2c                          ; 3e 2c
  call    0xdb6a                          ; cd 6a db
  ld      a,(de)                          ; 1a
  or      a                               ; b7
L3B7E:
  jr      z,L3B2E                         ; 28 ae
  ld      (ix+0),0x2c                     ; dd 36 00 2c
  inc     ix                              ; dd 23
  inc     b                               ; 04
  jr      L3B77                           ; 18 ee
L3B89:
  ld      hl,0xac24                       ; 21 24 ac
  call    0xd806                          ; cd 06 d8
  call    0xe130                          ; cd 30 e1
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  call    0xe130                          ; cd 30 e1
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
L3B99:
  call    0xe130                          ; cd 30 e1
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  jr      nz,L3B99                        ; 20 f8
  dec     hl                              ; 2b
  call    0xd806                          ; cd 06 d8
  jr      L3B7E                           ; 18 d7
  push    hl                              ; e5
  push    de                              ; d5
  ld      hl,(0xe037)                     ; 2a 37 e0
  add     hl,bc                           ; 09
  jr      c,L3BB8                         ; 38 09
  ld      de,(0xce95)                     ; ed 5b 95 ce
  sbc     hl,de                           ; ed 52
  pop     de                              ; d1
  pop     hl                              ; e1
  ret     c                               ; d8
L3BB8:
  xor     a                               ; af
  ld      (0xe2c3),a                      ; 32 c3 e2
  ld      a,0x07                          ; 3e 07
  jr      L3BDD                           ; 18 1d
  ld      a,0x01                          ; 3e 01
  jr      L3BDD                           ; 18 19
  ld      a,0x02                          ; 3e 02
  jr      L3BDD                           ; 18 15
  ld      a,0x03                          ; 3e 03
  jr      L3BDD                           ; 18 11
L3BCC:
  ld      a,0x04                          ; 3e 04
  jr      L3BDD                           ; 18 0d
  ld      a,(hl)                          ; 7e
  cp      0x27                            ; fe 27
  ret     z                               ; c8
  cp      0x22                            ; fe 22
  ret     z                               ; c8
  ld      a,0x05                          ; 3e 05
  jr      L3BDD                           ; 18 02
  ld      a,0x06                          ; 3e 06
L3BDD:
  ex      af,af'                          ; 08
  call    0xf4df                          ; cd df f4
  call    0xdede                          ; cd de de
  ex      af,af'                          ; 08
  call    0xe1f5                          ; cd f5 e1
  call    0xdaa5                          ; cd a5 da
  ld      hl,(0xda17)                     ; 2a 17 da
  call    0xe22e                          ; cd 2e e2
  call    z,0xd9d9                        ; cc d9 d9
  ld      (0xda17),hl                     ; 22 17 da
  jp      0xd45f                          ; c3 5f d4
  ld      hl,0x4000                       ; 21 00 40
  call    0xddbf                          ; cd bf dd
  cp      0x09                            ; fe 09
  jr      nz,L3C27                        ; 20 23
  push    af                              ; f5
  ld      hl,0xd872                       ; 21 72 d8
  ld      de,0xd872                       ; 11 72 d8
  call    0xad77                          ; cd 77 ad
  jr      z,L3C1D                         ; 28 0d
L3C10:
  call    0xade9                          ; cd e9 ad
  push    af                              ; f5
  call    0xdf36                          ; cd 36 df
  pop     af                              ; f1
  bit     7,a                             ; cb 7f
  inc     hl                              ; 23
  jr      z,L3C10                         ; 28 f3
L3C1D:
  call    z,0xd868                        ; cc 68 d8
  ld      hl,0xd872                       ; 21 72 d8
  ld      (0xd83c),hl                     ; 22 3c d8
  pop     af                              ; f1
L3C27:
  ld      hl,0xe320                       ; 21 20 e3
L3C2A:
  bit     7,(hl)                          ; cb 7e
  inc     hl                              ; 23
  jr      z,L3C2A                         ; 28 fb
  dec     a                               ; 3d
  jr      nz,L3C2A                        ; 20 f8
L3C32:
  ld      a,(hl)                          ; 7e
  call    0xdf36                          ; cd 36 df
  bit     7,(hl)                          ; cb 7e
  inc     hl                              ; 23
  jr      z,L3C32                         ; 28 f7
  ret                                     ; c9
  ld      d,e                             ; 53
  ld      a,c                             ; 79
  ld      l,l                             ; 6d
  ld      h,d                             ; 62
  ld      l,a                             ; 6f
  call    pe,0x0021                       ; ec 21 00
  nop                                     ; 00
  ld      de,0x0000                       ; 11 00 00
  call    0xad77                          ; cd 77 ad
  ret     c                               ; d8
  ex      de,hl                           ; eb
  ret                                     ; c9
  exx                                     ; d9
  push    ix                              ; dd e5
  call    0xd878                          ; cd 78 d8
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
  pop     hl                              ; e1
  push    hl                              ; e5
  xor     a                               ; af
  sbc     hl,bc                           ; ed 42
  pop     hl                              ; e1
  jr      c,L3C61                         ; 38 03
  ex      de,hl                           ; eb
  sbc     hl,de                           ; ed 52
L3C61:
  exx                                     ; d9
  ret                                     ; c9
  inc     ix                              ; dd 23
  ld      d,(ix+2)                        ; dd 56 02
  ld      e,(ix+3)                        ; dd 5e 03
  ret                                     ; c9
  call    0xd89b                          ; cd 9b d8
  ld      hl,(0xdfa6)                     ; 2a a6 df
  push    hl                              ; e5
  res     7,d                             ; cb ba
  add     hl,de                           ; 19
  add     hl,de                           ; 19
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  and     0x3f                            ; e6 3f
  ld      d,a                             ; 57
  ex      (sp),hl                         ; e3
  push    hl                              ; e5
  ex      de,hl                           ; eb
  ex      (sp),hl                         ; e3
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  inc     hl                              ; 23
  ex      de,hl                           ; eb
  inc     hl                              ; 23
  add     hl,hl                           ; 29
  add     hl,de                           ; 19
  pop     de                              ; d1
  add     hl,de                           ; 19
  ex      de,hl                           ; eb
  pop     hl                              ; e1
  ret                                     ; c9
  ld      hl,0xabe4                       ; 21 e4 ab
  push    hl                              ; e5
  ld      bc,0x2000                       ; 01 00 20
  call    0xdaab                          ; cd ab da
  push    ix                              ; dd e5
  pop     hl                              ; e1
  call    0xe2db                          ; cd db e2
  ld      ix,0xac82                       ; dd 21 82 ac
  pop     hl                              ; e1
  ld      a,(ix+0)                        ; dd 7e 00
  dec     a                               ; 3d
  jr      nz,L3CC9                        ; 20 15
  ld      a,(ix+1)                        ; dd 7e 01
  cp      0x37                            ; fe 37
  jr      nz,L3CC9                        ; 20 0e
L3CBB:
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0xc0                            ; fe c0
  ld      (hl),0x01                       ; 36 01
  ret     nc                              ; d0
  inc     ix                              ; dd 23
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  jr      L3CBB                           ; 18 f2
L3CC9:
  ld      b,0x09                          ; 06 09
  bit     3,(ix+1)                        ; dd cb 01 5e
  call    z,0xdaa1                        ; cc a1 da
  jr      z,L3CDE                         ; 28 0a
  push    hl                              ; e5
  call    0xd8a2                          ; cd a2 d8
  pop     hl                              ; e1
  ld      b,0x09                          ; 06 09
  call    0xda99                          ; cd 99 da
L3CDE:
  push    hl                              ; e5
  ld      b,(ix+0)                        ; dd 46 00
  ld      a,(ix+1)                        ; dd 7e 01
  and     0xf0                            ; e6 f0
  ld      c,a                             ; 4f
  call    0xdae6                          ; cd e6 da
  pop     hl                              ; e1
  jr      z,L3CF4                         ; 28 06
  ld      a,0x10                          ; 3e 10
  ld      (0xd473),a                      ; 32 73 d4
  ret                                     ; c9
L3CF4:
  ld      (hl),0x01                       ; 36 01
  or      a                               ; b7
  ret     z                               ; c8
  cp      0x3a                            ; fe 3a
  jr      c,L3D02                         ; 38 06
  cp      0x3e                            ; fe 3e
  jr      nc,L3D02                        ; 30 02
  ld      d,0x2c                          ; 16 2c
L3D02:
  push    de                              ; d5
  ld      de,0xe4b2                       ; 11 b2 e4
  call    0xda73                          ; cd 73 da
  ld      b,0x05                          ; 06 05
  call    0xda9e                          ; cd 9e da
  pop     de                              ; d1
  ld      (hl),0x01                       ; 36 01
  inc     hl                              ; 23
  bit     3,(ix+1)                        ; dd cb 01 5e
  jr      z,L3D1C                         ; 28 04
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
L3D1C:
  push    de                              ; d5
  ld      a,d                             ; 7a
  call    0xd95e                          ; cd 5e d9
  pop     de                              ; d1
  ld      a,e                             ; 7b
  or      a                               ; b7
  ret     z                               ; c8
  ld      (hl),0x2c                       ; 36 2c
  inc     hl                              ; 23
  or      a                               ; b7
  ret     z                               ; c8
  cp      0x2c                            ; fe 2c
  jr      nc,L3D4C                        ; 30 1e
  ld      de,0xe5f0                       ; 11 f0 e5
  call    0xda73                          ; cd 73 da
  ld      b,0x09                          ; 06 09
L3D36:
  ld      a,(de)                          ; 1a
  and     0x7f                            ; e6 7f
  ld      (hl),a                          ; 77
  dec     b                               ; 05
  jr      nz,L3D44                        ; 20 07
  ld      a,0x10                          ; 3e 10
  ld      (0xd473),a                      ; 32 73 d4
  pop     af                              ; f1
  ret                                     ; c9
L3D44:
  ld      a,(de)                          ; 1a
  and     0x80                            ; e6 80
  inc     hl                              ; 23
  inc     de                              ; 13
  jr      z,L3D36                         ; 28 eb
  ret                                     ; c9
L3D4C:
  push    af                              ; f5
  cp      0x2d                            ; fe 2d
  jr      c,L3D6F                         ; 38 1e
  ld      (hl),0x28                       ; 36 28
  inc     hl                              ; 23
  cp      0x2e                            ; fe 2e
  jr      c,L3D6F                         ; 38 17
  ld      (hl),0x69                       ; 36 69
  inc     hl                              ; 23
  ld      b,0x78                          ; 06 78
  cp      0x2f                            ; fe 2f
  jr      c,L3D63                         ; 38 02
  ld      b,0x79                          ; 06 79
L3D63:
  ld      (hl),b                          ; 70
  inc     hl                              ; 23
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x2d                            ; fe 2d
  jr      z,L3D6F                         ; 28 03
  ld      (hl),0x2b                       ; 36 2b
  inc     hl                              ; 23
L3D6F:
  ld      a,(ix+2)                        ; dd 7e 02
  cp      0x1f                            ; fe 1f
  jr      z,L3D96                         ; 28 20
  cp      0xc0                            ; fe c0
  jr      nc,L3D96                        ; 30 1c
  cp      0x80                            ; fe 80
  jr      nc,L3D84                        ; 30 06
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  inc     ix                              ; dd 23
  jr      L3D6F                           ; 18 eb
L3D84:
  ld      d,a                             ; 57
  ld      e,(ix+3)                        ; dd 5e 03
  inc     ix                              ; dd 23
  inc     ix                              ; dd 23
  push    hl                              ; e5
  call    0xd8a5                          ; cd a5 d8
  pop     hl                              ; e1
  call    0xda7e                          ; cd 7e da
  jr      L3D6F                           ; 18 d9
L3D96:
  pop     af                              ; f1
  inc     ix                              ; dd 23
  cp      0x2d                            ; fe 2d
  ret     c                               ; d8
  ld      (hl),0x29                       ; 36 29
  inc     hl                              ; 23
  ret                                     ; c9
  ld      hl,(0xda17)                     ; 2a 17 da
  dec     hl                              ; 2b
  call    0xade9                          ; cd e9 ad
  cp      0xc0                            ; fe c0
  jr      c,L3DB3                         ; 38 08
  and     0x3f                            ; e6 3f
  ld      e,a                             ; 5f
  ld      d,0x00                          ; 16 00
  sbc     hl,de                           ; ed 52
  dec     hl                              ; 2b
L3DB3:
  dec     hl                              ; 2b
  ret                                     ; c9
  ld      hl,(0xda17)                     ; 2a 17 da
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  bit     3,a                             ; cb 5f
  jr      z,L3DC5                         ; 28 04
  inc     hl                              ; 23
  inc     hl                              ; 23
  jr      L3DC8                           ; 18 03
L3DC5:
  and     0x07                            ; e6 07
  ret     z                               ; c8
L3DC8:
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  cp      0xc0                            ; fe c0
  ret     nc                              ; d0
  cp      0x80                            ; fe 80
  jr      c,L3DC8                         ; 38 f5
  inc     hl                              ; 23
  jr      L3DC8                           ; 18 f2
  xor     a                               ; af
  in      a,(0xfe)                        ; db fe
  cpl                                     ; 2f
  and     0x1f                            ; e6 1f
  ret     z                               ; c8
  call    0xb0a2                          ; cd a2 b0
  ld      hl,0x0000                       ; 21 00 00
  ld      b,0x0d                          ; 06 0d
L3DE5:
  call    0xd9d9                          ; cd d9 d9
  djnz    L3DE5                           ; 10 fb
  ld      a,0x10                          ; 3e 10
L3DEC:
  push    af                              ; f5
  push    hl                              ; e5
  push    hl                              ; e5
  call    0xddba                          ; cd ba dd
  pop     ix                              ; dd e1
  call    0xda39                          ; cd 39 da
  pop     hl                              ; e1
  call    0xd9ee                          ; cd ee d9
  pop     af                              ; f1
  add     a,0x08                          ; c6 08
  cp      0xa9                            ; fe a9
  jr      c,L3DEC                         ; 38 ea
  ret                                     ; c9
  push    ix                              ; dd e5
  call    0xd8cf                          ; cd cf d8
  pop     ix                              ; dd e1
  call    0xd884                          ; cd 84 d8
  jr      c,L3E14                         ; 38 05
  ld      hl,0xabec                       ; 21 ec ab
  ld      (hl),0xa0                       ; 36 a0
L3E14:
  ld      hl,0xdf0f                       ; 21 0f df
  ld      (0xda6f),hl                     ; 22 6f da
  ld      hl,0xabe4                       ; 21 e4 ab
  ld      c,0x00                          ; 0e 00
L3E1F:
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  dec     a                               ; 3d
  jr      z,L3E1F                         ; 28 fb
  inc     a                               ; 3c
  ret     z                               ; c8
  cp      0x22                            ; fe 22
  jr      nz,L3E2D                        ; 20 03
  inc     c                               ; 0c
  ld      a,0x22                          ; 3e 22
L3E2D:
  bit     0,c                             ; cb 41
  jr      nz,L3E38                        ; 20 07
  call    0xdef9                          ; cd f9 de
  jr      nz,L3E38                        ; 20 02
  and     0xff                            ; e6 ff
L3E38:
  call    0xdf0f                          ; cd 0f df
  jr      L3E1F                           ; 18 e2
  push    hl                              ; e5
  ex      de,hl                           ; eb
  ld      d,0x00                          ; 16 00
  ld      e,a                             ; 5f
  add     hl,de                           ; 19
  ld      e,(hl)                          ; 5e
  add     hl,de                           ; 19
  ex      de,hl                           ; eb
  pop     hl                              ; e1
  ret                                     ; c9
  ld      b,0x09                          ; 06 09
L3E4A:
  ex      de,hl                           ; eb
  call    0xade9                          ; cd e9 ad
  ex      de,hl                           ; eb
  ld      (hl),a                          ; 77
  dec     b                               ; 05
  jr      nz,L3E5A                        ; 20 07
  ld      a,0x10                          ; 3e 10
  ld      (0xd473),a                      ; 32 73 d4
  pop     af                              ; f1
  ret                                     ; c9
L3E5A:
  res     7,(hl)                          ; cb be
  and     0x80                            ; e6 80
  inc     hl                              ; 23
  inc     de                              ; 13
  jr      z,L3E4A                         ; 28 e8
  ret                                     ; c9
  call    0xda80                          ; cd 80 da
  jr      L3E6B                           ; 18 03
  call    0xd96c                          ; cd 6c d9
L3E6B:
  ld      c,0x20                          ; 0e 20
  jr      L3E75                           ; 18 06
  ld      bc,0x3700                       ; 01 00 37
  ld      hl,0xac06                       ; 21 06 ac
L3E75:
  ld      (hl),c                          ; 71
  inc     hl                              ; 23
  djnz    L3E75                           ; 10 fc
  ret                                     ; c9
  ld      b,0x00                          ; 06 00
  ld      hl,0xac3e                       ; 21 3e ac
  call    0xdd78                          ; cd 78 dd
  cp      0x41                            ; fe 41
  jr      c,L3E88                         ; 38 02
  set     3,d                             ; cb da
L3E88:
  ld      (0xac61),de                     ; ed 53 61 ac
  push    af                              ; f5
  ld      a,e                             ; 7b
  cp      0x03                            ; fe 03
  jr      nz,L3E98                        ; 20 06
  ld      a,d                             ; 7a
  cp      0x37                            ; fe 37
  jp      z,0xd811                        ; ca 11 d8
L3E98:
  pop     af                              ; f1
  ld      ix,0xac63                       ; dd 21 63 ac
  ret     c                               ; d8
  call    0xe032                          ; cd 32 e0
  ld      ix,0xac65                       ; dd 21 65 ac
  set     7,h                             ; cb fc
  ld      (ix-2),h                        ; dd 74 fe
  ld      (ix-1),l                        ; dd 75 ff
  ld      b,0x02                          ; 06 02
  ret                                     ; c9
  ld      de,0x0352                       ; 11 52 03
  ld      a,0x01                          ; 3e 01
  bit     5,c                             ; cb 69
  jr      nz,L3EC2                        ; 20 09
  bit     4,c                             ; cb 61
  jr      z,L3EC2                         ; 28 05
  dec     a                               ; 3d
  res     4,c                             ; cb a1
  set     5,c                             ; cb e9
L3EC2:
  ld      (0xdb3e),a                      ; 32 3e db
  ld      hl,0xed1f                       ; 21 1f ed
  exx                                     ; d9
  ld      b,0x0b                          ; 06 0b
L3ECB:
  exx                                     ; d9
  ld      a,(hl)                          ; 7e
  cp      b                               ; b8
  jr      nz,L3ED8                        ; 20 08
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  dec     hl                              ; 2b
  and     0xf0                            ; e6 f0
  cp      c                               ; b9
  jr      z,L3EEE                         ; 28 16
L3ED8:
  jr      c,L3EDE                         ; 38 04
  sbc     hl,de                           ; ed 52
  jr      L3EDF                           ; 18 01
L3EDE:
  add     hl,de                           ; 19
L3EDF:
  srl     d                               ; cb 3a
  rr      e                               ; cb 1b
  jr      nc,L3EE8                        ; 30 03
  inc     de                              ; 13
  inc     de                              ; 13
  inc     de                              ; 13
L3EE8:
  exx                                     ; d9
  djnz    L3ECB                           ; 10 e0
  inc     b                               ; 04
  exx                                     ; d9
  ret                                     ; c9
L3EEE:
  inc     hl                              ; 23
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  inc     hl                              ; 23
  ld      e,(hl)                          ; 5e
  srl     a                               ; cb 3f
  ld      b,0x03                          ; 06 03
  rr      d                               ; cb 1a
  jr      L3EFF                           ; 18 02
L3EFD:
  srl     d                               ; cb 3a
L3EFF:
  rr      e                               ; cb 1b
  djnz    L3EFD                           ; 10 fa
  srl     e                               ; cb 3b
  srl     e                               ; cb 3b
  ld      b,0x01                          ; 06 01
  dec     b                               ; 05
  ret     z                               ; c8
  push    af                              ; f5
  ld      a,e                             ; 7b
  inc     a                               ; 3c
  call    0xdc8d                          ; cd 8d dc
  jr      nz,L3F14                        ; 20 01
  inc     e                               ; 1c
L3F14:
  ld      a,d                             ; 7a
  inc     a                               ; 3c
  call    0xdc8d                          ; cd 8d dc
  jr      nz,L3F1C                        ; 20 01
  inc     d                               ; 14
L3F1C:
  pop     af                              ; f1
  cp      a                               ; bf
  ret                                     ; c9
  ld      hl,0xac10                       ; 21 10 ac
  ld      b,0x28                          ; 06 28
  ld      c,0x01                          ; 0e 01
  xor     a                               ; af
L3F27:
  cp      (hl)                            ; be
  inc     hl                              ; 23
  jr      z,L3F2C                         ; 28 01
  inc     c                               ; 0c
L3F2C:
  djnz    L3F27                           ; 10 f9
  ld      a,0x12                          ; 3e 12
  cp      c                               ; b9
  jr      c,L3F42                         ; 38 0f
  ret                                     ; c9
  cp      0x2c                            ; fe 2c
  jr      z,L3F3F                         ; 28 07
  inc     de                              ; 13
  cp      0x2d                            ; fe 2d
  jr      z,L3F3F                         ; 28 02
  inc     de                              ; 13
  inc     de                              ; 13
L3F3F:
  call    0xdc5c                          ; cd 5c dc
L3F42:
  jp      c,0xd802                        ; da 02 d8
  cp      0x2b                            ; fe 2b
  jr      z,L3F50                         ; 28 07
  cp      0x2d                            ; fe 2d
  jr      nz,L3F55                        ; 20 08
  call    0xe130                          ; cd 30 e1
L3F50:
  call    0xdc5c                          ; cd 5c dc
  jr      c,L3F42                         ; 38 ed
L3F55:
  cp      0x24                            ; fe 24
  jr      nz,L3F5E                        ; 20 05
  call    0xdc59                          ; cd 59 dc
  jr      L3F91                           ; 18 33
L3F5E:
  ld      c,a                             ; 4f
  or      0x20                            ; f6 20
  call    0xdef9                          ; cd f9 de
  jr      nz,L3F8D                        ; 20 27
  push    bc                              ; c5
  dec     de                              ; 1b
  push    de                              ; d5
  push    ix                              ; dd e5
  ex      de,hl                           ; eb
  call    0xe032                          ; cd 32 e0
  pop     ix                              ; dd e1
  set     7,h                             ; cb fc
  ld      (ix+0),h                        ; dd 74 00
  inc     ix                              ; dd 23
  ld      (ix+0),l                        ; dd 75 00
  inc     ix                              ; dd 23
  pop     bc                              ; c1
  ld      hl,(0xac06)                     ; 2a 06 ac
  ld      h,0x00                          ; 26 00
  add     hl,bc                           ; 09
  ex      de,hl                           ; eb
  pop     bc                              ; c1
  inc     b                               ; 04
  inc     b                               ; 04
  call    0xdc5c                          ; cd 5c dc
  jr      L3F91                           ; 18 04
L3F8D:
  ld      a,c                             ; 79
  call    0xdbe3                          ; cd e3 db
L3F91:
  ccf                                     ; 3f
  ret     nc                              ; d0
  cp      0x2b                            ; fe 2b
  jr      z,L3FA8                         ; 28 11
  cp      0x2d                            ; fe 2d
  jr      z,L3FA8                         ; 28 0d
  cp      0x2a                            ; fe 2a
  jr      z,L3FA8                         ; 28 09
  cp      0x2f                            ; fe 2f
  jr      z,L3FA8                         ; 28 05
  cp      0x3f                            ; fe 3f
L3FA5:
  jp      nz,0xd802                       ; c2 02 d8
L3FA8:
  call    0xdc59                          ; cd 59 dc
  jr      L3F42                           ; 18 95
  cp      0x22                            ; fe 22
  jr      z,L3FF3                         ; 28 42
  ld      c,0x0a                          ; 0e 0a
  call    0xdef1                          ; cd f1 de
  jr      z,L3FCC                         ; 28 14
  cp      0x25                            ; fe 25
  jr      nz,L3FC0                        ; 20 04
  ld      c,0x02                          ; 0e 02
  jr      L3FC6                           ; 18 06
L3FC0:
  cp      0x23                            ; fe 23
  jr      nz,L3FA5                        ; 20 e1
  ld      c,0x10                          ; 0e 10
L3FC6:
  call    0xdc59                          ; cd 59 dc
  jp      c,0xd802                        ; da 02 d8
L3FCC:
  ld      hl,0x0000                       ; 21 00 00
L3FCF:
  call    0xdc6a                          ; cd 6a dc
  ret     nc                              ; d0
  push    de                              ; d5
  push    af                              ; f5
  ld      a,c                             ; 79
  dec     a                               ; 3d
  ld      d,h                             ; 54
  ld      e,l                             ; 5d
L3FD9:
  add     hl,de                           ; 19
L3FDA:
  jp      c,0xd7fe                        ; da fe d7
  dec     a                               ; 3d
  jr      nz,L3FD9                        ; 20 f9
  pop     af                              ; f1
  cp      c                               ; b9
  jp      nc,0xd7fe                       ; d2 fe d7
  ld      d,0x00                          ; 16 00
  ld      e,a                             ; 5f
  add     hl,de                           ; 19
  jr      c,L3FDA                         ; 38 ef
  pop     de                              ; d1
  ex      af,af'                          ; 08
  call    0xdc59                          ; cd 59 dc
  ret     c                               ; d8
  jr      L3FCF                           ; 18 dc
L3FF3:
  ld      hl,0x0000                       ; 21 00 00
  call    0xdc44                          ; cd 44 dc
  or      a                               ; b7
  jr      z,L400C                         ; 28 10
  ld      l,a                             ; 6f
  call    0xdc44                          ; cd 44 dc
  or      a                               ; b7
  jr      z,L400C                         ; 28 09
  ld      h,l                             ; 65
  ld      l,a                             ; 6f
  call    0xdc44                          ; cd 44 dc
  or      a                               ; b7
  jp      nz,0xd80d                       ; c2 0d d8
L400C:
  jr      L4021                           ; 18 13
  call    0xdc59                          ; cd 59 dc
  or      a                               ; b7
  jp      z,0xd80d                        ; ca 0d d8
  cp      0x22                            ; fe 22
  jr      z,L401B                         ; 28 02
  and     a                               ; a7
  ret                                     ; c9
L401B:
  ld      a,(de)                          ; 1a
  cp      0x22                            ; fe 22
  ld      a,0x00                          ; 3e 00
  ret     nz                              ; c0
L4021:
  ld      a,0x22                          ; 3e 22
  call    0xe130                          ; cd 30 e1
  ld      a,(de)                          ; 1a
  inc     de                              ; 13
  cp      0x29                            ; fe 29
  jr      z,L4032                         ; 28 06
  cp      0x2c                            ; fe 2c
  jr      z,L4032                         ; 28 02
  or      a                               ; b7
  ret     nz                              ; c0
L4032:
  scf                                     ; 37
  ret                                     ; c9
  push    af                              ; f5
  ex      af,af'                          ; 08
  pop     af                              ; f1
  sub     0x30                            ; d6 30
  cp      0x0a                            ; fe 0a
  ret     c                               ; d8
  sub     0x07                            ; d6 07
  cp      0x0a                            ; fe 0a
  jr      c,L4054                         ; 38 12
  cp      0x10                            ; fe 10
  ret     c                               ; d8
  sub     0x20                            ; d6 20
  cp      0x0a                            ; fe 0a
  jr      c,L4054                         ; 38 09
  cp      0x10                            ; fe 10
  jr      nc,L4054                        ; 30 05
  ex      af,af'                          ; 08
  sub     0x20                            ; d6 20
  ex      af,af'                          ; 08
  ret     c                               ; d8
L4054:
  ex      af,af'                          ; 08
  and     a                               ; a7
  ret                                     ; c9
  cp      0x1a                            ; fe 1a
  jr      z,L406A                         ; 28 0f
  cp      0x1c                            ; fe 1c
  jr      z,L406A                         ; 28 0b
  cp      0x1e                            ; fe 1e
  jr      z,L406A                         ; 28 07
  cp      0x2a                            ; fe 2a
  jr      z,L406A                         ; 28 03
  cp      0x2f                            ; fe 2f
  ret     nz                              ; c0
L406A:
  dec     a                               ; 3d
  push    hl                              ; e5
  ld      hl,0xd736                       ; 21 36 d7
  ld      (hl),0x01                       ; 36 01
  pop     hl                              ; e1
  cp      a                               ; bf
  ret                                     ; c9
  push    hl                              ; e5
  call    0xdce9                          ; cd e9 dc
  pop     hl                              ; e1
  ld      a,b                             ; 78
  or      a                               ; b7
  ret     z                               ; c8
  cp      0x05                            ; fe 05
  jr      nc,L408C                        ; 30 0c
  push    hl                              ; e5
  ld      hl,0xdd19                       ; 21 19 dd
  call    0xdd23                          ; cd 23 dd
  pop     hl                              ; e1
  call    0xdcf1                          ; cd f1 dc
  ret     nc                              ; d0
L408C:
  ld      a,(hl)                          ; 7e
  cp      0x28                            ; fe 28
  ld      a,0x2c                          ; 3e 2c
  ret     nz                              ; c0
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  cp      0x69                            ; fe 69
  jr      nz,L40AE                        ; 20 16
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  cp      0x78                            ; fe 78
  ld      b,0x2e                          ; 06 2e
  jr      z,L40A6                         ; 28 06
  cp      0x79                            ; fe 79
  ld      b,0x2f                          ; 06 2f
  jr      nz,L40AE                        ; 20 08
L40A6:
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  cp      0x2b                            ; fe 2b
  jr      z,L40B1                         ; 28 05
  cp      0x2d                            ; fe 2d
L40AE:
  ld      a,0x2d                          ; 3e 2d
  ret     nz                              ; c0
L40B1:
  ld      a,b                             ; 78
  ret                                     ; c9
  xor     a                               ; af
  ld      b,a                             ; 47
L40B5:
  cp      (hl)                            ; be
  ret     z                               ; c8
  inc     hl                              ; 23
  inc     b                               ; 04
  jr      L40B5                           ; 18 fa
L40BB:
  push    hl                              ; e5
L40BC:
  ld      a,(de)                          ; 1a
  and     0x7f                            ; e6 7f
  cp      (hl)                            ; be
  jr      nz,L40CD                        ; 20 0b
  ld      a,(de)                          ; 1a
  inc     hl                              ; 23
  inc     de                              ; 13
  and     0x80                            ; e6 80
  jr      z,L40BC                         ; 28 f3
  pop     hl                              ; e1
  xor     a                               ; af
  ld      a,c                             ; 79
  ret                                     ; c9
L40CD:
  pop     hl                              ; e1
L40CE:
  ld      a,(de)                          ; 1a
  and     0x80                            ; e6 80
  inc     de                              ; 13
  jr      z,L40CE                         ; 28 fa
  inc     c                               ; 0c
  djnz    L40BB                           ; 10 e4
  scf                                     ; 37
  ret                                     ; c9
  or      d                               ; b2
  call    po,0x0101                       ; e4 01 01
  inc     c                               ; 0c
  ld      (bc),a                          ; 02
  add     hl,hl                           ; 29
  ld      c,0x17                          ; 0e 17
  scf                                     ; 37
  ret     p                               ; f0
  push    hl                              ; e5
  inc     c                               ; 0c
  add     hl,bc                           ; 09
  rrca                                    ; 0f
  dec     d                               ; 15
  ld      (bc),a                          ; 02
  inc     h                               ; 24
  ld      b,0x26                          ; 06 26
  ld      a,b                             ; 78
  add     a,a                             ; 87
  ld      c,a                             ; 4f
  xor     a                               ; af
  ld      b,a                             ; 47
  push    hl                              ; e5
  add     hl,bc                           ; 09
  ld      b,(hl)                          ; 46
  inc     hl                              ; 23
  ld      c,(hl)                          ; 4e
  pop     hl                              ; e1
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ld      h,a                             ; 67
  ld      l,c                             ; 69
  add     hl,de                           ; 19
  ld      e,(hl)                          ; 5e
  ld      d,a                             ; 57
  add     hl,de                           ; 19
  ex      de,hl                           ; eb
  ret                                     ; c9
  ld      b,0x20                          ; 06 20
  jr      L410D                           ; 18 06
  ld      b,0x2c                          ; 06 2c
  jr      L410D                           ; 18 02
  ld      b,0x00                          ; 06 00
L410D:
  call    0xdd78                          ; cd 78 dd
  cp      0x22                            ; fe 22
  jr      z,L4139                         ; 28 25
  cp      0x27                            ; fe 27
  jr      z,L4139                         ; 28 21
L4118:
  cp      b                               ; b8
  ret     z                               ; c8
  cp      0x20                            ; fe 20
  inc     hl                              ; 23
  jr      z,L410D                         ; 28 ee
  dec     hl                              ; 2b
  or      a                               ; b7
  jr      nz,L4125                        ; 20 02
  inc     a                               ; 3c
  ret                                     ; c9
L4125:
  inc     hl                              ; 23
  set     5,a                             ; cb ef
  ld      (de),a                          ; 12
  inc     de                              ; 13
  dec     c                               ; 0d
  jr      nz,L410D                        ; 20 e0
  jr      L413E                           ; 18 0f
L412F:
  call    0xdd77                          ; cd 77 dd
  or      a                               ; b7
  jr      z,L4118                         ; 28 e3
  cp      0x22                            ; fe 22
  jr      z,L4118                         ; 28 df
L4139:
  ld      (de),a                          ; 12
  inc     de                              ; 13
  dec     c                               ; 0d
  jr      nz,L412F                        ; 20 f1
L413E:
  jp      0xd802                          ; c3 02 d8
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  cp      0x01                            ; fe 01
  ret     nz                              ; c0
  inc     hl                              ; 23
  ld      a,(hl)                          ; 7e
  ret                                     ; c9
L4149:
  call    0xdd78                          ; cd 78 dd
  cp      0x20                            ; fe 20
  ret     nz                              ; c0
  inc     hl                              ; 23
  jr      L4149                           ; 18 f7
  ld      hl,0xe351                       ; 21 51 e3
  ld      (0xdf1c),hl                     ; 22 1c df
  ld      hl,0x50e0                       ; 21 e0 50
  call    0xddbf                          ; cd bf dd
  ld      hl,0xac3d                       ; 21 3d ac
L4161:
  inc     hl                              ; 23
  ld      a,(0xdf57)                      ; 3a 57 df
  and     0x1f                            ; e6 1f
  ld      (0xd622),a                      ; 32 22 d6
  ld      a,(hl)                          ; 7e
  dec     a                               ; 3d
  jr      z,L4175                         ; 28 07
  inc     a                               ; 3c
  ret     z                               ; c8
  call    0xdf15                          ; cd 15 df
  jr      L4161                           ; 18 ec
L4175:
  ld      (0xd5b1),hl                     ; 22 b1 d5
  push    hl                              ; e5
  ld      a,(0xde39)                      ; 3a 39 de
  add     a,0xcc                          ; c6 cc
  call    0xdf38                          ; cd 38 df
  pop     hl                              ; e1
  jr      L4161                           ; 18 dd
  ld      c,0x00                          ; 0e 00
  call    0x22b0                          ; cd b0 22
  ld      (0xdf57),hl                     ; 22 57 df
  ld      b,0x08                          ; 06 08
L418E:
  push    hl                              ; e5
  ld      c,0x20                          ; 0e 20
L4191:
  ld      (hl),0x00                       ; 36 00
  inc     l                               ; 2c
  dec     c                               ; 0d
  jr      nz,L4191                        ; 20 fa
  pop     hl                              ; e1
  inc     h                               ; 24
  djnz    L418E                           ; 10 f3
  ret                                     ; c9
  exx                                     ; d9
  call    0xde03                          ; cd 03 de
  exx                                     ; d9
  call    0xdef9                          ; cd f9 de
  ret     nz                              ; c0
  or      0x20                            ; f6 20
  ret                                     ; c9
  ld      hl,0x0000                       ; 21 00 00
  inc     hl                              ; 23
  ld      (0xdddf),hl                     ; 22 df dd
  ld      a,h                             ; 7c
  cp      0x05                            ; fe 05
  jr      nz,L41CD                        ; 20 19
  ld      a,0x00                          ; 3e 00
  jr      L4224                           ; 18 6c
L41B8:
  ld      h,0x02                          ; 26 02
L41BA:
  call    0xde79                          ; cd 79 de
  jr      nz,L41C7                        ; 20 08
  dec     hl                              ; 2b
  inc     h                               ; 24
  dec     h                               ; 25
  jr      nz,L41BA                        ; 20 f6
  call    0xde73                          ; cd 73 de
L41C7:
  ld      hl,0x0000                       ; 21 00 00
  ld      (0xdddf),hl                     ; 22 df dd
L41CD:
  di                                      ; f3
  call    0xde79                          ; cd 79 de
  jr      z,L41B8                         ; 28 e5
  ld      b,0x00                          ; 06 00
  ld      c,e                             ; 4b
  ld      a,e                             ; 7b
  ld      (0xde50),a                      ; 32 50 de
  ld      hl,0x0204                       ; 21 04 02
  ld      a,d                             ; 7a
  cp      0x19                            ; fe 19
  jr      z,L4258                         ; 28 76
  add     hl,bc                           ; 09
  ld      a,(hl)                          ; 7e
  cp      0x20                            ; fe 20
  ld      b,a                             ; 47
  jr      c,L4210                         ; 38 27
  ld      a,d                             ; 7a
  cp      0x28                            ; fe 28
  ld      a,b                             ; 78
  set     5,a                             ; cb ef
  jr      nz,L4201                        ; 20 10
  call    0xdef1                          ; cd f1 de
  jr      nz,L41FA                        ; 20 04
  sub     0x2d                            ; d6 2d
  jr      L4210                           ; 18 16
L41FA:
  call    0xdef9                          ; cd f9 de
  jr      nz,L4201                        ; 20 02
  res     5,a                             ; cb af
L4201:
  ld      b,a                             ; 47
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  ld      a,b                             ; 78
  jr      z,L4210                         ; 28 08
  call    0xdef9                          ; cd f9 de
  jr      nz,L4210                        ; 20 03
  ld      a,0x20                          ; 3e 20
  xor     b                               ; a8
L4210:
  ld      b,a                             ; 47
  or      a                               ; b7
  jr      z,L41CD                         ; 28 b9
  cp      0x80                            ; fe 80
  jr      z,L41CD                         ; 28 b5
  ld      b,a                             ; 47
  ld      a,0x00                          ; 3e 00
  cp      0x00                            ; fe 00
  ld      (0xde52),a                      ; 32 52 de
  ld      a,b                             ; 78
  jp      z,0xddde                        ; ca de dd
L4224:
  push    af                              ; f5
  call    0xdeda                          ; cd da de
  pop     af                              ; f1
  ld      h,0x14                          ; 26 14
L422B:
  dec     hl                              ; 2b
  inc     h                               ; 24
  dec     h                               ; 25
  jr      nz,L422B                        ; 20 fb
  bit     7,a                             ; cb 7f
  ld      (0xddeb),a                      ; 32 eb dd
  ret     z                               ; c8
  ld      h,0x4e                          ; 26 4e
L4238:
  dec     hl                              ; 2b
  inc     h                               ; 24
  dec     h                               ; 25
  jr      nz,L4238                        ; 20 fb
  ld      hl,0xde52                       ; 21 52 de
  ld      (hl),0x00                       ; 36 00
  ret                                     ; c9
  push    hl                              ; e5
  call    0x028e                          ; cd 8e 02
  pop     hl                              ; e1
  jr      z,L424C                         ; 28 02
  xor     a                               ; af
  ret                                     ; c9
L424C:
  ld      a,e                             ; 7b
  inc     e                               ; 1c
  ret     z                               ; c8
  inc     d                               ; 14
  ret     nz                              ; c0
  ld      a,e                             ; 7b
  sub     0x19                            ; d6 19
  ret     z                               ; c8
  sub     0x0f                            ; d6 0f
  ret                                     ; c9
L4258:
  ex      de,hl                           ; eb
  ld      a,c                             ; 79
  cp      0x1b                            ; fe 1b
  jr      z,L4275                         ; 28 17
  ld      hl,0xac3e                       ; 21 3e ac
  ld      a,(hl)                          ; 7e
  dec     a                               ; 3d
  jr      nz,L4275                        ; 20 10
  inc     hl                              ; 23
  or      (hl)                            ; b6
  jr      nz,L4275                        ; 20 0c
  ex      de,hl                           ; eb
  add     hl,bc                           ; 09
  ld      a,(hl)                          ; 7e
  call    0xdef9                          ; cd f9 de
  jr      nz,L4275                        ; 20 04
  set     7,a                             ; cb ff
  jr      L4210                           ; 18 9b
L4275:
  ld      hl,0xdeb1                       ; 21 b1 de
  add     hl,bc                           ; 09
  ld      a,(hl)                          ; 7e
  jr      L4210                           ; 18 94
  ld      hl,(0x5b5e)                     ; 2a 5e 5b
  ld      h,0x25                          ; 26 25
  ld      a,0x7d                          ; 3e 7d
  cpl                                     ; 2f
  inc     l                               ; 2c
  dec     l                               ; 2d
  ld      e,l                             ; 5d
  daa                                     ; 27
  inc     h                               ; 24
  inc     a                               ; 3c
  ld      a,e                             ; 7b
  ccf                                     ; 3f
  ld      l,0x2b                          ; 2e 2b
  ld      a,a                             ; 7f
  jr      z,L42B4                         ; 28 23
  nop                                     ; 00
  ld      e,h                             ; 5c
  ld      h,b                             ; 60
  nop                                     ; 00
  dec     a                               ; 3d
  dec     sp                              ; 3b
  add     hl,hl                           ; 29
  ld      b,b                             ; 40
  inc     d                               ; 14
  ld      a,h                             ; 7c
  ld      a,(0x0d20)                      ; 3a 20 0d
  ld      (0x215f),hl                     ; 22 5f 21
  dec     d                               ; 15
  ld      a,(hl)                          ; 7e
  nop                                     ; 00
  ld      e,0x1e                          ; 1e 1e
  jr      L42AA                           ; 18 02
  ld      e,0x00                          ; 1e 00
L42AA:
  ld      hl,0x012c                       ; 21 2c 01
  ld      a,0x17                          ; 3e 17
L42AF:
  ld      b,e                             ; 43
  xor     0x10                            ; ee 10
L42B2:
  out     (0xfe),a                        ; d3 fe
L42B4:
  djnz    L42B2                           ; 10 fc
  dec     hl                              ; 2b
  inc     h                               ; 24
  dec     h                               ; 25
  jr      nz,L42AF                        ; 20 f4
  cp      0x30                            ; fe 30
  ret     c                               ; d8
  cp      0x39                            ; fe 39
  ret     nc                              ; d0
  cp      a                               ; bf
  ret                                     ; c9
  cp      0x41                            ; fe 41
  ret     c                               ; d8
  cp      0x7a                            ; fe 7a
  ret     nc                              ; d0
  cp      0x5b                            ; fe 5b
  jr      c,L42D0                         ; 38 03
  cp      0x61                            ; fe 61
  ret     c                               ; d8
L42D0:
  cp      a                               ; bf
  ret                                     ; c9
  ld      a,0x20                          ; 3e 20
  jr      L42D9                           ; 18 03
  ld      a,(hl)                          ; 7e
  and     0x7f                            ; e6 7f
L42D9:
  exx                                     ; d9
  call    0xdf4e                          ; cd 4e df
  exx                                     ; d9
  ret                                     ; c9
  cp      0x80                            ; fe 80
  jr      c,L4300                         ; 38 1d
  push    hl                              ; e5
  push    de                              ; d5
  ld      hl,0x0000                       ; 21 00 00
  ld      d,0x00                          ; 16 00
  ld      e,a                             ; 5f
  add     hl,de                           ; 19
  ld      e,(hl)                          ; 5e
  add     hl,de                           ; 19
L42EE:
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  push    af                              ; f5
  call    0xdf36                          ; cd 36 df
  pop     af                              ; f1
  bit     7,a                             ; cb 7f
  jr      z,L42EE                         ; 28 f5
  pop     de                              ; d1
  pop     hl                              ; e1
  cp      0xba                            ; fe ba
  ret     z                               ; c8
  ld      a,0x20                          ; 3e 20
L4300:
  res     7,a                             ; cb bf
  exx                                     ; d9
  call    0xdf4e                          ; cd 4e df
  ld      a,h                             ; 7c
  add     a,0x0a                          ; c6 0a
  cp      0x5a                            ; fe 5a
  jr      z,L4313                         ; 28 06
L430D:
  add     a,0x07                          ; c6 07
  cp      0x58                            ; fe 58
  jr      c,L430D                         ; 38 fa
L4313:
  ld      h,a                             ; 67
  ld      (hl),0x38                       ; 36 38
  exx                                     ; d9
  ret                                     ; c9
  add     a,a                             ; 87
  ld      h,0x0f                          ; 26 0f
  ld      l,a                             ; 6f
  sbc     a,a                             ; 9f
  ld      c,a                             ; 4f
  add     hl,hl                           ; 29
  add     hl,hl                           ; 29
  ld      de,0x4000                       ; 11 00 40
  push    de                              ; d5
  ld      b,0x08                          ; 06 08
L4326:
  ld      a,(hl)                          ; 7e
  nop                                     ; 00
  or      (hl)                            ; b6
  xor     c                               ; a9
  ld      (de),a                          ; 12
  inc     hl                              ; 23
  inc     d                               ; 14
  djnz    L4326                           ; 10 f7
  pop     hl                              ; e1
  push    hl                              ; e5
  inc     l                               ; 2c
  jr      nz,L433E                        ; 20 0a
  ld      a,h                             ; 7c
  add     a,0x08                          ; c6 08
  cp      0x58                            ; fe 58
  jr      nz,L433D                        ; 20 02
  ld      a,0x40                          ; 3e 40
L433D:
  ld      h,a                             ; 67
L433E:
  ld      (0xdf57),hl                     ; 22 57 df
  pop     hl                              ; e1
  ret                                     ; c9
  ld      de,0xac07                       ; 11 07 ac
  ld      b,0x00                          ; 06 00
L4348:
  call    0xdd78                          ; cd 78 dd
  call    0xdef1                          ; cd f1 de
  jr      z,L435B                         ; 28 0b
  res     5,a                             ; cb af
  cp      0x5f                            ; fe 5f
  jr      z,L435B                         ; 28 05
  call    0xdef9                          ; cd f9 de
  jr      nz,L4367                        ; 20 0c
L435B:
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  inc     b                               ; 04
  ld      a,b                             ; 78
  cp      0x09                            ; fe 09
  jr      c,L4348                         ; 38 e4
  jp      0xd802                          ; c3 02 d8
L4367:
  ld      a,b                             ; 78
  ld      (0xac06),a                      ; 32 06 ac
  dec     de                              ; 1b
  ex      de,hl                           ; eb
  set     7,(hl)                          ; cb fe
  ld      hl,0x0000                       ; 21 00 00
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  inc     hl                              ; 23
  push    de                              ; d5
  ex      de,hl                           ; eb
  inc     hl                              ; 23
  add     hl,hl                           ; 29
  add     hl,de                           ; 19
  ld      (0xdfd1),hl                     ; 22 d1 df
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ld      (0xe040),hl                     ; 22 40 e0
  pop     bc                              ; c1
  jr      L43B7                           ; 18 2b
L438C:
  push    bc                              ; c5
  dec     hl                              ; 2b
  call    0xade9                          ; cd e9 ad
  and     0x3f                            ; e6 3f
  ld      d,a                             ; 57
  dec     hl                              ; 2b
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  push    hl                              ; e5
  ld      hl,0x0000                       ; 21 00 00
  add     hl,de                           ; 19
  ld      de,0xac06                       ; 11 06 ac
  ld      a,(de)                          ; 1a
  ld      b,a                             ; 47
  inc     de                              ; 13
L43A4:
  call    0xade9                          ; cd e9 ad
  ex      de,hl                           ; eb
  cp      (hl)                            ; be
  ex      de,hl                           ; eb
  jr      nz,L43B4                        ; 20 08
  inc     hl                              ; 23
  inc     de                              ; 13
  djnz    L43A4                           ; 10 f4
  pop     af                              ; f1
  pop     hl                              ; e1
  xor     a                               ; af
  ret                                     ; c9
L43B4:
  pop     hl                              ; e1
  pop     bc                              ; c1
  dec     bc                              ; 0b
L43B7:
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L438C                        ; 20 d1
  scf                                     ; 37
  ret                                     ; c9
  call    0xca48                          ; cd 48 ca
  ld      hl,(0xdfd1)                     ; 2a d1 df
  jr      L43F7                           ; 18 32
L43C5:
  pop     hl                              ; e1
  pop     bc                              ; c1
  ret                                     ; c9
L43C8:
  push    bc                              ; c5
  push    hl                              ; e5
  inc     hl                              ; 23
  ld      de,0xac07                       ; 11 07 ac
L43CE:
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      c,a                             ; 4f
  res     7,c                             ; cb b9
  ld      a,(de)                          ; 1a
  and     0x7f                            ; e6 7f
  cp      c                               ; b9
  jr      c,L43C5                         ; 38 ea
  jr      nz,L43EC                        ; 20 0f
  ld      a,(de)                          ; 1a
  and     0x80                            ; e6 80
  jr      nz,L43C5                        ; 20 e3
  call    0xade9                          ; cd e9 ad
  bit     7,a                             ; cb 7f
  jr      nz,L43EC                        ; 20 03
  inc     de                              ; 13
  jr      L43CE                           ; 18 e2
L43EC:
  call    0xade9                          ; cd e9 ad
  bit     7,a                             ; cb 7f
  inc     hl                              ; 23
  jr      z,L43EC                         ; 28 f8
  pop     af                              ; f1
  pop     bc                              ; c1
  dec     bc                              ; 0b
L43F7:
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L43C8                        ; 20 cd
  ret                                     ; c9
  call    0xdf79                          ; cd 79 df
  ret     nc                              ; d0
  ld      hl,0x0000                       ; 21 00 00
  ld      bc,0x000c                       ; 01 0c 00
  call    0xd7dd                          ; cd dd d7
  ld      de,0x0000                       ; 11 00 00
  call    0xbd66                          ; cd 66 bd
  ld      h,d                             ; 62
  ld      l,e                             ; 6b
  inc     de                              ; 13
  inc     de                              ; 13
  call    0xad7c                          ; cd 7c ad
  ld      hl,0xe037                       ; 21 37 e0
  call    0xe1bc                          ; cd bc e1
  call    0xdff3                          ; cd f3 df
  push    hl                              ; e5
  ex      de,hl                           ; eb
  ld      hl,(0xe037)                     ; 2a 37 e0
  xor     a                               ; af
  sbc     hl,de                           ; ed 52
  ex      de,hl                           ; eb
  push    hl                              ; e5
  ld      b,a                             ; 47
  ld      a,(0xac06)                      ; 3a 06 ac
  add     a,0x02                          ; c6 02
  ld      c,a                             ; 4f
  push    bc                              ; c5
  push    hl                              ; e5
  add     hl,bc                           ; 09
  ld      b,d                             ; 42
  ld      c,e                             ; 4b
  ex      de,hl                           ; eb
  pop     hl                              ; e1
  call    0xad7c                          ; cd 7c ad
  pop     bc                              ; c1
  ld      hl,0xe037                       ; 21 37 e0
  call    0xe1c4                          ; cd c4 e1
  pop     de                              ; d1
  ld      hl,0xac05                       ; 21 05 ac
  ld      (hl),0x00                       ; 36 00
  push    bc                              ; c5
  call    0xe2cd                          ; cd cd e2
  ld      hl,(0xdfa6)                     ; 2a a6 df
  call    0xe144                          ; cd 44 e1
  pop     bc                              ; c1
  dec     de                              ; 1b
  ex      de,hl                           ; eb
  ex      (sp),hl                         ; e3
  ld      de,(0xdfd1)                     ; ed 5b d1 df
  xor     a                               ; af
  sbc     hl,de                           ; ed 52
  ex      de,hl                           ; eb
  inc     hl                              ; 23
  inc     hl                              ; 23
  ld      (0xdfd1),hl                     ; 22 d1 df
  dec     hl                              ; 2b
  dec     hl                              ; 2b
  ld      ix,(0xdfa6)                     ; dd 2a a6 df
  ex      (sp),hl                         ; e3
  jr      L447C                           ; 18 11
L446B:
  call    0xcc2e                          ; cd 2e cc
  sbc     hl,de                           ; ed 52
  jr      c,L447A                         ; 38 08
  push    de                              ; d5
  push    ix                              ; dd e5
  pop     hl                              ; e1
  call    0xe147                          ; cd 47 e1
  pop     de                              ; d1
L447A:
  ex      (sp),hl                         ; e3
  dec     hl                              ; 2b
L447C:
  ld      a,h                             ; 7c
  or      l                               ; b5
  ex      (sp),hl                         ; e3
  jr      nz,L446B                        ; 20 ea
  pop     hl                              ; e1
  push    ix                              ; dd e5
  pop     hl                              ; e1
  inc     hl                              ; 23
  inc     hl                              ; 23
  ld      a,e                             ; 7b
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  ld      a,d                             ; 7a
  call    0xae29                          ; cd 29 ae
  call    0xca48                          ; cd 48 ca
  ld      h,b                             ; 60
  ld      l,c                             ; 69
  ret                                     ; c9
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  ret                                     ; c9
  ld      c,0x00                          ; 0e 00
  ld      ix,0xac06                       ; dd 21 06 ac
  call    0xe0cc                          ; cd cc e0
  jr      z,L44BE                         ; 28 19
  ld      (ix+0),0x23                     ; dd 36 00 23
  inc     ix                              ; dd 23
  ld      de,0x1000                       ; 11 00 10
  call    0xe10f                          ; cd 0f e1
  ld      d,0x01                          ; 16 01
  call    0xe10f                          ; cd 0f e1
  ld      de,0x0010                       ; 11 10 00
  call    0xe10f                          ; cd 0f e1
  jr      L44D5                           ; 18 17
L44BE:
  ld      de,0x2710                       ; 11 10 27
  call    0xe10f                          ; cd 0f e1
  ld      de,0x03e8                       ; 11 e8 03
  call    0xe10f                          ; cd 0f e1
  ld      de,0x0064                       ; 11 64 00
  call    0xe10f                          ; cd 0f e1
  ld      e,0x0a                          ; 1e 0a
  call    0xe10f                          ; cd 0f e1
L44D5:
  ld      e,0x01                          ; 1e 01
  ld      c,0x00                          ; 0e 00
  ld      a,0xff                          ; 3e ff
L44DB:
  inc     a                               ; 3c
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  jr      nc,L44DB                        ; 30 fa
  add     hl,de                           ; 19
  bit     0,c                             ; cb 41
  jr      z,L44E8                         ; 28 02
  or      a                               ; b7
  ret     z                               ; c8
L44E8:
  res     0,c                             ; cb 81
  add     a,0x30                          ; c6 30
  cp      0x3a                            ; fe 3a
  jr      c,L44F2                         ; 38 02
  add     a,0x07                          ; c6 07
L44F2:
  call    0xe131                          ; cd 31 e1
  ld      (ix+0),0x00                     ; dd 36 00 00
  ret                                     ; c9
  inc     b                               ; 04
  ld      (ix+0),a                        ; dd 77 00
  inc     ix                              ; dd 23
  ret                                     ; c9
  call    0xe155                          ; cd 55 e1
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
  jr      L4515                           ; 18 0c
  ld      bc,0x0002                       ; 01 02 00
  jr      L4511                           ; 18 03
  ld      bc,0x0001                       ; 01 01 00
L4511:
  call    0xe155                          ; cd 55 e1
  add     hl,bc                           ; 09
L4515:
  ex      de,hl                           ; eb
  ld      a,d                             ; 7a
  call    0xae29                          ; cd 29 ae
  dec     hl                              ; 2b
  ld      a,e                             ; 7b
  jp      0xae29                          ; c3 29 ae
  call    0xade9                          ; cd e9 ad
  ld      e,a                             ; 5f
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      d,a                             ; 57
  ex      de,hl                           ; eb
  ret                                     ; c9
  push    hl                              ; e5
  ld      (0xe1e0),hl                     ; 22 e0 e1
  push    bc                              ; c5
L452F:
  call    0xd9ee                          ; cd ee d9
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L452F                        ; 20 f8
  pop     bc                              ; c1
  pop     de                              ; d1
  push    hl                              ; e5
  call    0xbd66                          ; cd 66 bd
  pop     hl                              ; e1
  push    bc                              ; c5
  push    de                              ; d5
  push    hl                              ; e5
  ld      hl,(0xe037)                     ; 2a 37 e0
  pop     de                              ; d1
  call    0xbd66                          ; cd 66 bd
  ex      de,hl                           ; eb
  pop     de                              ; d1
  call    0xad7c                          ; cd 7c ad
  pop     bc                              ; c1
  push    bc                              ; c5
  call    0xe1ce                          ; cd ce e1
  pop     bc                              ; c1
  ld      hl,0xda17                       ; 21 17 da
  call    0xe1db                          ; cd db e1
  ld      hl,0xd879                       ; 21 79 d8
  call    0xe1db                          ; cd db e1
  ld      hl,0xd87c                       ; 21 7c d8
  call    0xe1db                          ; cd db e1
  ld      hl,0xe037                       ; 21 37 e0
  call    0xe1a4                          ; cd a4 e1
  ld      hl,0xdfa6                       ; 21 a6 df
L456E:
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ex      de,hl                           ; eb
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
  jr      L4593                           ; 18 1c
  push    hl                              ; e5
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  ld      h,(hl)                          ; 66
  ld      l,a                             ; 6f
  ld      de,0x0000                       ; 11 00 00
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  pop     hl                              ; e1
  ret     c                               ; d8
  jr      L458E                           ; 18 08
  ld      bc,0x0002                       ; 01 02 00
  jr      L458E                           ; 18 03
  ld      bc,0x0001                       ; 01 01 00
L458E:
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ex      de,hl                           ; eb
  add     hl,bc                           ; 09
L4593:
  ex      de,hl                           ; eb
  ld      (hl),d                          ; 72
  dec     hl                              ; 2b
  ld      (hl),e                          ; 73
  ret                                     ; c9
  ex      de,hl                           ; eb
L4599:
  xor     a                               ; af
  call    0xae29                          ; cd 29 ae
  inc     hl                              ; 23
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L4599                        ; 20 f6
  ex      de,hl                           ; eb
  ret                                     ; c9
  push    hl                              ; e5
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ld      hl,0x0000                       ; 21 00 00
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  pop     hl                              ; e1
  ret     nc                              ; d0
  jr      L456E                           ; 18 bb
  xor     a                               ; af
  ld      (0xd594),a                      ; 32 94 d5
  call    0xcd56                          ; cd 56 cd
  call    0xceaa                          ; cd aa ce
  ld      a,0x0a                          ; 3e 0a
  call    0xd830                          ; cd 30 d8
  ld      a,0x13                          ; 3e 13
  ld      (0xdf57),a                      ; 32 57 df
  ld      a,(0xd594)                      ; 3a 94 d5
  or      a                               ; b7
  ld      a,0x4f                          ; 3e 4f
  jr      nz,L45D1                        ; 20 02
  ld      a,0x49                          ; 3e 49
L45D1:
  call    0xdf0f                          ; cd 0f df
  ld      hl,(0xe037)                     ; 2a 37 e0
  call    0xe213                          ; cd 13 e2
  ld      hl,(0xd09f)                     ; 2a 9f d0
  call    0xdf08                          ; cd 08 df
  call    0xe0d0                          ; cd d0 e0
  ld      hl,0xac06                       ; 21 06 ac
L45E6:
  ld      a,(hl)                          ; 7e
  or      a                               ; b7
  ret     z                               ; c8
  call    0xdf0c                          ; cd 0c df
  inc     hl                              ; 23
  jr      L45E6                           ; 18 f7
  push    de                              ; d5
  ld      de,0x0000                       ; 11 00 00
  call    0xad77                          ; cd 77 ad
  pop     de                              ; d1
  ret                                     ; c9
  push    hl                              ; e5
  push    de                              ; d5
  ld      de,0x000c                       ; 11 0c 00
  add     hl,de                           ; 19
  ld      de,(0xdfa6)                     ; ed 5b a6 df
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  pop     de                              ; d1
  pop     hl                              ; e1
  ret                                     ; c9
  call    0xd878                          ; cd 78 d8
  push    hl                              ; e5
  push    de                              ; d5
  ld      bc,(0xda17)                     ; ed 4b 17 da
  and     a                               ; a7
  sbc     hl,bc                           ; ed 42
  jr      nc,L461B                        ; 30 05
  ex      de,hl                           ; eb
  ccf                                     ; 3f
  sbc     hl,bc                           ; ed 42
  ccf                                     ; 3f
L461B:
  pop     hl                              ; e1
  pop     de                              ; d1
  ret     c                               ; d8
  ld      a,0x01                          ; 3e 01
  ld      (0xe2c3),a                      ; 32 c3 e2
  push    bc                              ; c5
  call    0xd9ee                          ; cd ee d9
  call    0xbd66                          ; cd 66 bd
  pop     hl                              ; e1
  ld      (0xe1b3),hl                     ; 22 b3 e1
  ex      de,hl                           ; eb
  call    0xad77                          ; cd 77 ad
  jr      c,L4635                         ; 38 01
  add     hl,bc                           ; 09
L4635:
  ex      de,hl                           ; eb
  call    0xe28f                          ; cd 8f e2
  ld      b,0x4d                          ; 06 4d
  call    0xd37f                          ; cd 7f d3
  ret     nz                              ; c0
  call    0xd878                          ; cd 78 d8
  push    hl                              ; e5
  push    de                              ; d5
  call    0xc93d                          ; cd 3d c9
  pop     hl                              ; e1
  pop     de                              ; d1
  call    0xbd66                          ; cd 66 bd
  ld      hl,(0xda17)                     ; 2a 17 da
  ld      (0xd879),hl                     ; 22 79 d8
  add     hl,bc                           ; 09
  ld      (0xd87c),hl                     ; 22 7c d8
  ret                                     ; c9
  ld      b,0x00                          ; 06 00
  push    de                              ; d5
  push    hl                              ; e5
  call    0xd7dd                          ; cd dd d7
  push    bc                              ; c5
  push    bc                              ; c5
  ex      de,hl                           ; eb
  ld      hl,(0xe037)                     ; 2a 37 e0
  and     a                               ; a7
  sbc     hl,de                           ; ed 52
  ex      (sp),hl                         ; e3
  ex      de,hl                           ; eb
  push    hl                              ; e5
  add     hl,bc                           ; 09
  pop     de                              ; d1
  ex      de,hl                           ; eb
  pop     bc                              ; c1
  call    0xad7c                          ; cd 7c ad
  pop     bc                              ; c1
  ld      hl,0xe037                       ; 21 37 e0
  call    0xe1c4                          ; cd c4 e1
  ld      hl,0xdfa6                       ; 21 a6 df
  call    0xe1c4                          ; cd c4 e1
  ld      hl,0xd879                       ; 21 79 d8
  call    0xe1ad                          ; cd ad e1
  ld      hl,0xd87c                       ; 21 7c d8
  call    0xe1ad                          ; cd ad e1
  pop     de                              ; d1
  pop     hl                              ; e1
  ld      a,0x00                          ; 3e 00
  or      a                               ; b7
  ld      a,0x00                          ; 3e 00
  ld      (0xe2c3),a                      ; 32 c3 e2
  jp      nz,0xad7c                       ; c2 7c ad
L4697:
  ld      a,(hl)                          ; 7e
  ex      de,hl                           ; eb
  call    0xae29                          ; cd 29 ae
  ex      de,hl                           ; eb
  inc     hl                              ; 23
  inc     de                              ; 13
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L4697                        ; 20 f3
  ret                                     ; c9
  ld      de,0xac82                       ; 11 82 ac
  call    0xade9                          ; cd e9 ad
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  bit     3,a                             ; cb 5f
  jr      z,L46C6                         ; 28 0e
  call    0xade9                          ; cd e9 ad
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  call    0xade9                          ; cd e9 ad
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  jr      L46C9                           ; 18 03
L46C6:
  and     0x07                            ; e6 07
  ret     z                               ; c8
L46C9:
  call    0xade9                          ; cd e9 ad
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  cp      0xc0                            ; fe c0
  ret     nc                              ; d0
  cp      0x80                            ; fe 80
  jr      c,L46C9                         ; 38 f3
  call    0xade9                          ; cd e9 ad
  ld      (de),a                          ; 12
  inc     de                              ; 13
  inc     hl                              ; 23
  jr      L46C9                           ; 18 eb
  push    hl                              ; e5
  ld      hl,(0xe037)                     ; 2a 37 e0
  call    0xbd66                          ; cd 66 bd
  ex      de,hl                           ; eb
  pop     de                              ; d1
  jp      0xad7c                          ; c3 7c ad
  add     a,b                             ; 80


.ascii "Bad mnemoni"
.byte 'c'+0x80

.ascii "Bad operan"
.byte 'd'+0x80

.ascii "Big numbe"
.byte 'r'+0x80

.ascii "Syntax horro"
.byte 'r'+0x80

.ascii "Bad strin"
.byte 'g'+0x80

.ascii "Bad instructio"
.byte 'n'+0x80

.ascii "Memory ful"
.byte 'l'+0x80

.ascii "Bad PUT (ORG"
.byte ')'+0x80

.ascii " unknow"
.byte 'n'+0x80

.ascii "Wait pleas"
.byte 'e'+0x80

.ascii "Assembly complet"
.byte 'e'+0x80

.ascii "Start tap"
.byte 'e'+0x80

.ascii "Tape erro"
.byte 'r'+0x80

.ascii "Any ke"
.byte 'y'+0x80

.ascii "(C) 93 UNIVERSU"
.byte 'M'+0x80

.ascii "Source ERRO"
.byte 'R'+0x80

.ascii "Found"
.byte ':'+0x80

.ascii "Already define"
.byte 'd'+0x80

.ascii "ENT "
.byte '?'+0x80

.ascii "Not foun"
.byte 'd'+0x80

.ascii "Overwrite"
.byte '?'+0x80

.ascii "Disk erro"
.byte 'r'+0x80

.byte 0x1a

.ascii "!%(',/.kq+.1768<?ADHLKPgSASSEMBL"
.byte 'Y'+0x80

.ascii "BASI"
.byte 'C'+0x80

.ascii "COP"
.byte 'Y'+0x80

.ascii "DELET"
.byte 'E'+0x80

.ascii "FIN"
.byte 'D'+0x80

.ascii "GEN"
.byte 'S'+0x80

.ascii "LOA"
.byte 'D'+0x80

.ascii "MONITO"
.byte 'R'+0x80

.ascii "NE"
.byte 'W'+0x80

.ascii "PRIN"
.byte 'T'+0x80

.ascii "QUI"
.byte 'T'+0x80

.ascii "RU"
.byte 'N'+0x80

.ascii "SAV"
.byte 'E'+0x80

.ascii "TABL"
.byte 'E'+0x80

.ascii "U-TO"
.byte 'P'+0x80

.ascii "VERIF"
.byte 'Y'+0x80

.ascii "CLEA"
.byte 'R'+0x80

.ascii "REPLAC"
.byte 'E'+0x80

.ascii "S-BEGI"
.byte 'N'+0x80

.ascii "S-TO"
.byte 'P'+0x80

.ascii "CAL"
.byte 'C'+0x80

.ascii "Source begin"
.byte ':'+0x80

.ascii "   S-top"
.byte ':'+0x80

.ascii "Result"
.byte ':'+0x80
.byte 0


  ld      c,l                             ; 4d
  ld      c,l                             ; 4d
  ld      c,(hl)                          ; 4e
  ld      c,a                             ; 4f
  ld      d,b                             ; 50
  ld      d,c                             ; 51
  ld      d,d                             ; 52
  ld      d,e                             ; 53
  ld      d,h                             ; 54
  ld      d,l                             ; 55
  ld      d,(hl)                          ; 56
  ld      d,a                             ; 57
  ld      e,b                             ; 58
  ld      e,c                             ; 59
  ld      e,e                             ; 5b
  ld      e,l                             ; 5d
  ld      e,a                             ; 5f
L488E:
  ld      h,c                             ; 61
  ld      h,e                             ; 63
  ld      h,l                             ; 65
  ld      h,a                             ; 67
  ld      l,c                             ; 69
  ld      l,e                             ; 6b
  ld      l,l                             ; 6d
  ld      l,a                             ; 6f
  ld      (hl),c                          ; 71
  ld      (hl),e                          ; 73
  ld      (hl),l                          ; 75
  ld      (hl),a                          ; 77
  ld      a,c                             ; 79
  ld      a,e                             ; 7b
  ld      a,l                             ; 7d
  ld      a,a                             ; 7f
  add     a,c                             ; 81
  add     a,e                             ; 83
  add     a,l                             ; 85
  add     a,a                             ; 87
  adc     a,c                             ; 89
  adc     a,e                             ; 8b
  adc     a,l                             ; 8d
  adc     a,a                             ; 8f
  sub     c                               ; 91
  sub     e                               ; 93
  sub     l                               ; 95
  sub     a                               ; 97
  sbc     a,c                             ; 99
  sbc     a,e                             ; 9b
  sbc     a,l                             ; 9d
  sbc     a,a                             ; 9f
  and     c                               ; a1
  and     e                               ; a3
  and     l                               ; a5
  and     a                               ; a7
  xor     c                               ; a9
  xor     e                               ; ab
  xor     (hl)                            ; ae
  or      c                               ; b1
  or      h                               ; b4
  or      a                               ; b7
  cp      d                               ; ba
  cp      l                               ; bd
  ret     nz                              ; c0
  jp      0xc9c6                          ; c3 c6 c9
  call    z,0xd2cf                        ; cc cf d2
  push    de                              ; d5
  ret     c                               ; d8
L48C3:
  in      a,(0xde)                        ; db de
  pop     hl                              ; e1
  call    po,0xeae7                       ; e4 e7 ea
L48C9:
  otdr                                    ; ed bb


.ascii "c"
.byte 'p'+0x80

.ascii "d"
.byte 'i'+0x80

.ascii "e"
.byte 'i'+0x80

.ascii "e"
.byte 'x'+0x80

.ascii "i"
.byte 'm'+0x80

.ascii "i"
.byte 'n'+0x80

.ascii "j"
.byte 'p'+0x80

.ascii "j"
.byte 'r'+0x80

.ascii "l"
.byte 'd'+0x80

.ascii "o"
.byte 'r'+0x80

.ascii "r"
.byte 'l'+0x80

.ascii "r"
.byte 'r'+0x80

.ascii "ad"
.byte 'c'+0x80

.ascii "ad"
.byte 'd'+0x80

.ascii "an"
.byte 'd'+0x80

.ascii "bi"
.byte 't'+0x80

.ascii "cc"
.byte 'f'+0x80

.ascii "cp"
.byte 'd'+0x80

.ascii "cp"
.byte 'i'+0x80

.ascii "cp"
.byte 'l'+0x80

.ascii "da"
.byte 'a'+0x80

.ascii "de"
.byte 'c'+0x80

.ascii "en"
.byte 't'+0x80

.ascii "eq"
.byte 'u'+0x80

.ascii "ex"
.byte 'x'+0x80

.ascii "in"
.byte 'c'+0x80

.ascii "in"
.byte 'd'+0x80

.ascii "in"
.byte 'i'+0x80

.ascii "ld"
.byte 'd'+0x80

.ascii "ld"
.byte 'i'+0x80

.ascii "ne"
.byte 'g'+0x80

.ascii "no"
.byte 'p'+0x80

.ascii "or"
.byte 'g'+0x80

.ascii "ou"
.byte 't'+0x80

.ascii "po"
.byte 'p'+0x80

.ascii "pu"
.byte 't'+0x80

.ascii "re"
.byte 's'+0x80

.ascii "re"
.byte 't'+0x80

.ascii "rl"
.byte 'a'+0x80

.ascii "rl"
.byte 'c'+0x80

.ascii "rl"
.byte 'd'+0x80

.ascii "rr"
.byte 'a'+0x80

.ascii "rr"
.byte 'c'+0x80

.ascii "rr"
.byte 'd'+0x80

.ascii "rs"
.byte 't'+0x80

.ascii "sb"
.byte 'c'+0x80

.ascii "sc"
.byte 'f'+0x80

.ascii "se"
.byte 't'+0x80

.ascii "sl"
.byte 'a'+0x80

.ascii "sr"
.byte 'a'+0x80

.ascii "sr"
.byte 'l'+0x80

.ascii "su"
.byte 'b'+0x80

.ascii "xo"
.byte 'r'+0x80

.ascii "cal"
.byte 'l'+0x80

.ascii "cpd"
.byte 'r'+0x80

.ascii "cpi"
.byte 'r'+0x80

.ascii "def"
.byte 'b'+0x80

.ascii "def"
.byte 'm'+0x80

.ascii "def"
.byte 's'+0x80

.ascii "def"
.byte 'w'+0x80

.ascii "djn"
.byte 'z'+0x80

.ascii "hal"
.byte 't'+0x80

.ascii "ind"
.byte 'r'+0x80

.ascii "ini"
.byte 'r'+0x80

.ascii "ldd"
.byte 'r'+0x80

.ascii "ldi"
.byte 'r'+0x80

.ascii "otd"
.byte 'r'+0x80

.ascii "oti"
.byte 'r'+0x80

.ascii "out"
.byte 'd'+0x80

.ascii "out"
.byte 'i'+0x80

.ascii "pus"
.byte 'h'+0x80

.ascii "ret"
.byte 'i'+0x80

.ascii "ret"
.byte 'n'+0x80

.ascii "rlc"
.byte 'a'+0x80

.ascii "rrc"
.byte 'a'+0x80

.ascii "sli"
.byte 'a'+0x80

.ascii " +++++++++++++++++++++,-./0123456789:<>ADGJM"
.byte '0'+0x80

L49E7:
  or      c                               ; b1
  or      d                               ; b2
  or      e                               ; b3
  or      h                               ; b4
  or      l                               ; b5
  or      (hl)                            ; b6
  or      a                               ; b7
  pop     hl                              ; e1
  jp      po,0xe4e3                       ; e2 e3 e4
  push    hl                              ; e5
  ret     pe                              ; e8
  jp      (hl)                            ; e9
  call    pe,0xf0ed                       ; ec ed f0
  jp      p,0x61fa                        ; f2 fa 61
  and     0x62                            ; e6 62
  ex      (sp),hl                         ; e3
  ld      h,h                             ; 64
  push    hl                              ; e5
  ld      l,b                             ; 68
  call    pe,0xf868                       ; ec 68 f8
  ld      l,b                             ; 68
  ld      sp,hl                           ; f9
  ld      l,c                             ; 69
L4A07:
  ret     m                               ; f8
  ld      l,c                             ; 69
  ld      sp,hl                           ; f9
  ld      l,h                             ; 6c
  ret     m                               ; f8
  ld      l,h                             ; 6c
  ld      sp,hl                           ; f9
  ld      l,(hl)                          ; 6e
  ex      (sp),hl                         ; e3
  ld      l,(hl)                          ; 6e
  jp      m,0xe570                        ; fa 70 e5
  ld      (hl),b                          ; 70
  rst     0x28                            ; ef
  ld      (hl),e                          ; 73
L4A17:
  ret     p                               ; f0
  jr      z,L4A7D                         ; 28 63
  xor     c                               ; a9
  ld      h,c                             ; 61
  ld      h,(hl)                          ; 66
  and     a                               ; a7
  jr      z,L4A82                         ; 28 62
  ld      h,e                             ; 63
  xor     c                               ; a9
  jr      z,L4A88                         ; 28 64
  ld      h,l                             ; 65
  xor     c                               ; a9
  jr      z,L4A90                         ; 28 68
  ld      l,h                             ; 6c
  xor     c                               ; a9
  jr      z,L4A95                         ; 28 69
  ld      a,b                             ; 78
  xor     c                               ; a9
  jr      z,L4A99                         ; 28 69
  ld      a,c                             ; 79
  xor     c                               ; a9
  jr      z,L4AA7                         ; 28 73
  ld      (hl),b                          ; 70
  xor     c                               ; a9
  nop                                     ; 00
  nop                                     ; 00
  ld      b,d                             ; 42
  nop                                     ; 00
  inc     b                               ; 04
  nop                                     ; 00
  jr      nc,L4A3E                        ; 30 00
L4A3E:
  nop                                     ; 00
  nop                                     ; 00
  nop                                     ; 00
  add     a,b                             ; 80
  ld      d,d                             ; 52
  ld      d,b                             ; 50
  ex      af,af'                          ; 08
  ld      bc,0x1402                       ; 01 02 14
  or      l                               ; b5
  adc     a,d                             ; 8a
  ld      bc,0x0237                       ; 01 37 02
  nop                                     ; 00
  nop                                     ; 00
  ld      bc,0x5280                       ; 01 80 52
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      (bc),a                          ; 02
  nop                                     ; 00
  dec     d                               ; 15
  ld      sp,0x0227                       ; 31 27 02
  scf                                     ; 37
  ld      sp,0x0060                       ; 31 60 00
  ld      (bc),a                          ; 02
  add     a,b                             ; 80
  ld      d,d                             ; 52
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  inc     bc                              ; 03
  nop                                     ; 00
  ld      (hl),0xb0                       ; 36 b0
  ld      b,0x03                          ; 06 03
  scf                                     ; 37
  inc     sp                              ; 33
  ld      h,b                             ; 60
  nop                                     ; 00
  inc     bc                              ; 03
  add     a,b                             ; 80
  ld      d,d                             ; 52
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     b                               ; 04
  nop                                     ; 00
  ld      (hl),0x50                       ; 36 50
  inc     b                               ; 04
  inc     b                               ; 04
  scf                                     ; 37
  ld      b,l                             ; 45
  ld      h,b                             ; 60
  nop                                     ; 00
  inc     b                               ; 04
L4A7D:
  add     a,b                             ; 80
  ld      d,d                             ; 52
  ld      (hl),b                          ; 70
  ex      af,af'                          ; 08
  dec     b                               ; 05
L4A82:
  nop                                     ; 00
  ld      l,0x50                          ; 2e 50
  inc     b                               ; 04
  dec     b                               ; 05
  scf                                     ; 37
L4A88:
  ld      c,e                             ; 4b
  ld      h,b                             ; 60
  nop                                     ; 00
  dec     b                               ; 05
  add     a,b                             ; 80
  ld      d,d                             ; 52
  add     a,b                             ; 80
  ex      af,af'                          ; 08
L4A90:
  ld      b,0x01                          ; 06 01
  inc     d                               ; 14
  ld      d,l                             ; 55
  add     a,a                             ; 87
L4A95:
  ld      b,0x37                          ; 06 37
  ld      (hl),h                          ; 74
  nop                                     ; 00
L4A99:
  nop                                     ; 00
  ld      b,0x80                          ; 06 80
  ld      d,e                             ; 53
  ld      b,b                             ; 40
L4A9E:
  rrca                                    ; 0f
  ld      b,0xa4                          ; 06 a4
  ld      d,e                             ; 53
  ld      (hl),b                          ; 70
  rla                                     ; 17
  rlca                                    ; 07
  nop                                     ; 00
  sub     (hl)                            ; 96
L4AA7:
  nop                                     ; 00
  inc     b                               ; 04
  rlca                                    ; 07
  scf                                     ; 37
  halt                                    ; 76
  nop                                     ; 00
  nop                                     ; 00
  rlca                                    ; 07
  add     a,b                             ; 80
  ld      d,d                             ; 52
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  ex      af,af'                          ; 08
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  xor     h                               ; ac
  and     h                               ; a4
  ex      af,af'                          ; 08
  scf                                     ; 37
  ld      a,b                             ; 78
  nop                                     ; 00
  nop                                     ; 00
  ex      af,af'                          ; 08
  add     a,b                             ; 80
  ld      e,b                             ; 58
  ld      d,b                             ; 50
  ex      af,af'                          ; 08
  add     hl,bc                           ; 09
  nop                                     ; 00
  ld      e,0xc2                          ; 1e c2
  rrc     c                               ; cb 09
  jr      nz,L4AE8                        ; 20 1e
  jp      c,0x09cf                        ; da cf 09
  scf                                     ; 37
  ld      a,d                             ; 7a
  nop                                     ; 00
  nop                                     ; 00
  add     hl,bc                           ; 09
L4AD2:
  add     a,b                             ; 80
  ld      e,b                             ; 58
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      a,(bc)                          ; 0a
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,h                             ; 4c
  rst     0x00                            ; c7
  ld      a,(bc)                          ; 0a
  add     a,b                             ; 80
  ld      e,b                             ; 58
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  dec     bc                              ; 0b
  nop                                     ; 00
  ld      l,0xb0                          ; 2e b0
  ld      b,0x0b                          ; 06 0b
  add     a,b                             ; 80
  ld      e,b                             ; 58
L4AE8:
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     c                               ; 0c
  nop                                     ; 00
  ld      (hl),0x58                       ; 36 58
  inc     b                               ; 04
  inc     c                               ; 0c
  add     a,b                             ; 80
  ld      e,b                             ; 58
  ld      (hl),b                          ; 70
L4AF3:
  ex      af,af'                          ; 08
  dec     c                               ; 0d
  nop                                     ; 00
  ld      l,0x58                          ; 2e 58
  inc     b                               ; 04
  dec     c                               ; 0d
  add     a,b                             ; 80
  ld      e,b                             ; 58
  add     a,b                             ; 80
  ex      af,af'                          ; 08
  ld      c,0x01                          ; 0e 01
  inc     d                               ; 14
  ld      e,l                             ; 5d
  add     a,a                             ; 87
  ld      c,0x80                          ; 0e 80
  ld      e,c                             ; 59
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      c,0xa4                          ; 0e a4
  ld      e,c                             ; 59
  ld      (hl),b                          ; 70
  rla                                     ; 17
  rrca                                    ; 0f
  nop                                     ; 00
  sbc     a,b                             ; 98
  nop                                     ; 00
  inc     b                               ; 04
  rrca                                    ; 0f
  add     a,b                             ; 80
  ld      e,b                             ; 58
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  djnz    L4B1C                           ; 10 03
  ld      a,l                             ; 7d
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
L4B1C:
  djnz    L4A9E                           ; 10 80
  jr      L4B70                           ; 18 50
  ex      af,af'                          ; 08
  ld      de,0x1402                       ; 11 02 14
  cp      l                               ; bd
  adc     a,d                             ; 8a
  ld      de,0x1880                       ; 11 80 18
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      (de),a                          ; 12
  nop                                     ; 00
  dec     d                               ; 15
  add     hl,sp                           ; 39
  daa                                     ; 27
  ld      (de),a                          ; 12
  add     a,b                             ; 80
  defb    0x18, 0x60
  ex      af,af'                          ; 08
  inc     de                              ; 13
  nop                                     ; 00
  ld      (hl),0xb8                       ; 36 b8
  ld      b,0x13                          ; 06 13
  add     a,b                             ; 80
  defb    0x18, 0x68
  ex      af,af'                          ; 08
  inc     d                               ; 14
  nop                                     ; 00
  ld      (hl),0x60                       ; 36 60
  inc     b                               ; 04
  inc     d                               ; 14
  add     a,b                             ; 80
  defb    0x18, 0x70
  ex      af,af'                          ; 08
  dec     d                               ; 15
  nop                                     ; 00
  ld      l,0x60                          ; 2e 60
L4B4D:
  inc     b                               ; 04
  dec     d                               ; 15
  add     a,b                             ; 80
  jr      L4AD2                           ; 18 80
  ex      af,af'                          ; 08
  ld      d,0x01                          ; 16 01
  inc     d                               ; 14
  ld      h,l                             ; 65
  add     a,a                             ; 87
  ld      d,0x80                          ; 16 80
  add     hl,de                           ; 19
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      d,0xa4                          ; 16 a4
  add     hl,de                           ; 19
  ld      (hl),b                          ; 70
  rla                                     ; 17
  rla                                     ; 17
  nop                                     ; 00
  ld      d,b                             ; 50
  nop                                     ; 00
  inc     b                               ; 04
  rla                                     ; 17
  add     a,b                             ; 80
  defb    0x18, 0x48
  ex      af,af'                          ; 08
  jr      L4B71                           ; 18 03
  inc     de                              ; 13
  ld      h,b                             ; 60
L4B70:
  rlca                                    ; 07
L4B71:
  jr      L4AF3                           ; 18 80
  ld      a,(de)                          ; 1a
  ld      d,b                             ; 50
  ex      af,af'                          ; 08
  add     hl,de                           ; 19
  nop                                     ; 00
  ld      e,0xc2                          ; 1e c2
  ex      de,hl                           ; eb
  add     hl,de                           ; 19
  defb    0x20, 0x1e
  jp      c,0x19ef                        ; da ef 19
  add     a,b                             ; 80
  ld      a,(de)                          ; 1a
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      a,(de)                          ; 1a
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,h                             ; 4c
  rst     0x20                            ; e7
  ld      a,(de)                          ; 1a
  add     a,b                             ; 80
  ld      a,(de)                          ; 1a
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  dec     de                              ; 1b
  nop                                     ; 00
  ld      l,0xb8                          ; 2e b8
  ld      b,0x1b                          ; 06 1b
  add     a,b                             ; 80
  ld      a,(de)                          ; 1a
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     e                               ; 1c
  nop                                     ; 00
  ld      (hl),0x68                       ; 36 68
  inc     b                               ; 04
  inc     e                               ; 1c
  add     a,b                             ; 80
  ld      a,(de)                          ; 1a
  ld      (hl),b                          ; 70
  ex      af,af'                          ; 08
  dec     e                               ; 1d
  nop                                     ; 00
  ld      l,0x68                          ; 2e 68
  inc     b                               ; 04
  dec     e                               ; 1d
  add     a,b                             ; 80
  ld      a,(de)                          ; 1a
  add     a,b                             ; 80
  ex      af,af'                          ; 08
  ld      e,0x01                          ; 1e 01
  inc     d                               ; 14
  ld      l,l                             ; 6d
  add     a,a                             ; 87
  ld      e,0x80                          ; 1e 80
  dec     de                              ; 1b
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      e,0xa4                          ; 1e a4
  dec     de                              ; 1b
  ld      (hl),b                          ; 70
  rla                                     ; 17
  rra                                     ; 1f
  nop                                     ; 00
  ld      d,(hl)                          ; 56
  nop                                     ; 00
L4BC0:
  inc     b                               ; 04
  rra                                     ; 1f
  add     a,b                             ; 80
  ld      a,(de)                          ; 1a
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  jr      nz,L4BCB                        ; 20 03
  inc     de                              ; 13
  dec     b                               ; 05
  add     a,a                             ; 87
L4BCB:
  jr      nz,L4B4D                        ; 20 80
  ld      h,h                             ; 64
  ld      d,b                             ; 50
  ex      af,af'                          ; 08
  ld      hl,0x1402                       ; 21 02 14
  push    bc                              ; c5
  adc     a,d                             ; 8a
  ld      hl,0x1422                       ; 21 22 14
  adc     a,(ix+33)                       ; dd 8e 21
  add     a,b                             ; 80
  ld      h,h                             ; 64
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      (0x1502),hl                     ; 22 02 15
  ld      l,e                             ; 6b
  djnz    L4C07                           ; 10 22
  ld      (0x6b15),hl                     ; 22 15 6b
  ld      (hl),h                          ; 74
  ld      (0x6480),hl                     ; 22 80 64
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  inc     hl                              ; 23
  nop                                     ; 00
  ld      (hl),0xc0                       ; 36 c0
  ld      b,0x23                          ; 06 23
  jr      nz,L4C2C                        ; 20 36
  ret     c                               ; d8
  ld      a,(bc)                          ; 0a
  inc     hl                              ; 23
  add     a,b                             ; 80
  ld      h,h                             ; 64
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     h                               ; 24
  nop                                     ; 00
  ld      (hl),0x70                       ; 36 70
  inc     b                               ; 04
  inc     h                               ; 24
  jr      nz,L4C3B                        ; 20 36
  ret     z                               ; c8
  ex      af,af'                          ; 08
L4C07:
  inc     h                               ; 24
  add     a,b                             ; 80
  ld      h,h                             ; 64
  ld      (hl),b                          ; 70
  ex      af,af'                          ; 08
  dec     h                               ; 25
  nop                                     ; 00
  ld      l,0x70                          ; 2e 70
  inc     b                               ; 04
  dec     h                               ; 25
  jr      nz,L4C42                        ; 20 2e
  ret     z                               ; c8
  ex      af,af'                          ; 08
  dec     h                               ; 25
  add     a,b                             ; 80
  ld      h,h                             ; 64
  add     a,b                             ; 80
  ex      af,af'                          ; 08
  ld      h,0x01                          ; 26 01
  inc     d                               ; 14
  ld      (hl),l                          ; 75
  add     a,a                             ; 87
  ld      h,0x21                          ; 26 21
  inc     d                               ; 14
  call    0x268b                          ; cd 8b 26
  add     a,b                             ; 80
  ld      h,l                             ; 65
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      h,0xa4                          ; 26 a4
L4C2C:
  ld      h,l                             ; 65
  ld      (hl),b                          ; 70
  rla                                     ; 17
  daa                                     ; 27
  nop                                     ; 00
  inc     l                               ; 2c
  nop                                     ; 00
L4C33:
  inc     b                               ; 04
  daa                                     ; 27
  add     a,b                             ; 80
  ld      h,h                             ; 64
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  jr      z,L4C3E                         ; 28 03
L4C3B:
  ld      (de),a                          ; 12
  and     l                               ; a5
  add     a,a                             ; 87
L4C3E:
  jr      z,L4BC0                         ; 28 80
  ld      h,(hl)                          ; 66
  ld      d,b                             ; 50
L4C42:
  ex      af,af'                          ; 08
  add     hl,hl                           ; 29
  nop                                     ; 00
  ld      e,0xc3                          ; 1e c3
  dec     bc                              ; 0b
  add     hl,hl                           ; 29
  jr      nz,L4C69                        ; 20 1e
  in      a,(0x6f)                        ; db 6f
  add     hl,hl                           ; 29
  add     a,b                             ; 80
  ld      h,(hl)                          ; 66
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      hl,(0x1402)                     ; 2a 02 14
  push    bc                              ; c5
  or      b                               ; b0
  ld      hl,(0x1422)                     ; 2a 22 14
  or      ixh                             ; dd b4
  ld      hl,(0x6680)                     ; 2a 80 66
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  dec     hl                              ; 2b
  nop                                     ; 00
  ld      l,0xc0                          ; 2e c0
  ld      b,0x2b                          ; 06 2b
  defb    0x20, 0x2e
L4C69:
  ret     c                               ; d8
  ld      a,(bc)                          ; 0a
  dec     hl                              ; 2b
  add     a,b                             ; 80
  ld      h,(hl)                          ; 66
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     l                               ; 2c
  nop                                     ; 00
  ld      (hl),0x80                       ; 36 80
  inc     b                               ; 04
  inc     l                               ; 2c
  jr      nz,L4CAE                        ; 20 36
  ret     pe                              ; e8
  ex      af,af'                          ; 08
  inc     l                               ; 2c
  add     a,b                             ; 80
  ld      h,(hl)                          ; 66
  ld      (hl),b                          ; 70
  ex      af,af'                          ; 08
  dec     l                               ; 2d
  nop                                     ; 00
  ld      l,0x80                          ; 2e 80
  inc     b                               ; 04
  dec     l                               ; 2d
  jr      nz,L4CB5                        ; 20 2e
  ret     pe                              ; e8
  ex      af,af'                          ; 08
  dec     l                               ; 2d
  add     a,b                             ; 80
  ld      h,(hl)                          ; 66
  add     a,b                             ; 80
  ex      af,af'                          ; 08
  ld      l,0x01                          ; 2e 01
  inc     d                               ; 14
  add     a,l                             ; 85
  add     a,a                             ; 87
  ld      l,0x21                          ; 2e 21
  inc     d                               ; 14
  defb    0xed, 0x8b
  ld      l,0x80                          ; 2e 80
  ld      h,a                             ; 67
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      l,0xa4                          ; 2e a4
  ld      h,a                             ; 67
  ld      (hl),b                          ; 70
  rla                                     ; 17
  cpl                                     ; 2f
  nop                                     ; 00
  ld      hl,(0x0400)                     ; 2a 00 04
  cpl                                     ; 2f
  add     a,b                             ; 80
  ld      h,(hl)                          ; 66
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  jr      nc,L4CB1                        ; 30 03
L4CAE:
  ld      (de),a                          ; 12
  defb    0xfd
  add     a,a                             ; 87
L4CB1:
  jr      nc,L4C33                        ; 30 80
  sbc     a,d                             ; 9a
  ld      d,b                             ; 50
L4CB5:
  ex      af,af'                          ; 08
  ld      sp,0x1502                       ; 31 02 15
  dec     e                               ; 1d
  adc     a,d                             ; 8a
  ld      sp,0x9a80                       ; 31 80 9a
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      (0x1502),a                      ; 32 02 15
  ld      l,c                             ; 69
  dec     l                               ; 2d
  ld      (0x9a80),a                      ; 32 80 9a
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  inc     sp                              ; 33
  nop                                     ; 00
  scf                                     ; 37
  jr      L4CD5                           ; 18 06
  inc     sp                              ; 33
  add     a,b                             ; 80
  sbc     a,d                             ; 9a
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     (hl)                            ; 34
L4CD5:
  nop                                     ; 00
  scf                                     ; 37
  ld      b,b                             ; 40
  dec     bc                              ; 0b
  inc     (hl)                            ; 34
  inc     h                               ; 24
  scf                                     ; 37
  ld      (hl),b                          ; 70
  rla                                     ; 17
  inc     (hl)                            ; 34
  add     a,b                             ; 80
  sbc     a,d                             ; 9a
  ld      (hl),b                          ; 70
  ex      af,af'                          ; 08
  dec     (hl)                            ; 35
  nop                                     ; 00
  cpl                                     ; 2f
  ld      b,b                             ; 40
  dec     bc                              ; 0b
  dec     (hl)                            ; 35
  inc     h                               ; 24
  cpl                                     ; 2f
  ld      (hl),b                          ; 70
  rla                                     ; 17
  dec     (hl)                            ; 35
  add     a,b                             ; 80
  sbc     a,d                             ; 9a
  add     a,b                             ; 80
  ex      af,af'                          ; 08
  ld      (hl),0x01                       ; 36 01
  dec     d                               ; 15
  ld      b,l                             ; 45
  adc     a,d                             ; 8a
  ld      (hl),0x25                       ; 36 25
  dec     d                               ; 15
  ld      (hl),l                          ; 75
  sub     e                               ; 93
  ld      (hl),0x80                       ; 36 80
  sbc     a,e                             ; 9b
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      (hl),0xa4                       ; 36 a4
  sbc     a,e                             ; 9b
  ld      (hl),b                          ; 70
  rla                                     ; 17
  scf                                     ; 37
  nop                                     ; 00
  ld      h,b                             ; 60
  nop                                     ; 00
  inc     b                               ; 04
  scf                                     ; 37
  add     a,b                             ; 80
  sbc     a,d                             ; 9a
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  jr      c,L4D15                         ; 38 03
  ld      (de),a                          ; 12
  ld      e,l                             ; 5d
  add     a,a                             ; 87
L4D15:
  defb    0x38, 0x80
  ld      l,b                             ; 68
  ld      d,b                             ; 50
  ex      af,af'                          ; 08
  add     hl,sp                           ; 39
  nop                                     ; 00
  ld      e,0xc4                          ; 1e c4
  ld      l,e                             ; 6b
  add     hl,sp                           ; 39
  defb    0x20, 0x1e
  call    c,0x396f                        ; dc 6f 39
  add     a,b                             ; 80
  ld      l,b                             ; 68
  ld      e,b                             ; 58
  ex      af,af'                          ; 08
  ld      a,(0x1402)                      ; 3a 02 14
  ld      c,l                             ; 4d
  xor     l                               ; ad
  ld      a,(0x6880)                      ; 3a 80 68
  ld      h,b                             ; 60
  ex      af,af'                          ; 08
  dec     sp                              ; 3b
  nop                                     ; 00
  cpl                                     ; 2f
  jr      L4D3E                           ; 18 06
  dec     sp                              ; 3b
  add     a,b                             ; 80
  ld      l,b                             ; 68
  ld      l,b                             ; 68
  ex      af,af'                          ; 08
  inc     a                               ; 3c
L4D3E:
  nop                                     ; 00
  ld      (hl),0x48                       ; 36 48
  inc     b                               ; 04
  inc     a                               ; 3c
  add     a,b                             ; 80
  ld      l,b                             ; 68
  ld      (hl),b                          ; 70
  ex      af,af'                          ; 08
  dec     a                               ; 3d
  nop                                     ; 00
  ld      l,0x48                          ; 2e 48
  inc     b                               ; 04
  dec     a                               ; 3d
  add     a,b                             ; 80
  ld      l,b                             ; 68
  add     a,b                             ; 80
  ex      af,af'                          ; 08
  ld      a,0x01                          ; 3e 01
  inc     d                               ; 14
  ld      c,l                             ; 4d
  add     a,a                             ; 87
  ld      a,0x80                          ; 3e 80
  ld      l,c                             ; 69
  ld      b,b                             ; 40
  rrca                                    ; 0f
  ld      a,0xa4                          ; 3e a4
  ld      l,c                             ; 69
  ld      (hl),b                          ; 70
  rla                                     ; 17
  ccf                                     ; 3f
  nop                                     ; 00
  inc     h                               ; 24
  nop                                     ; 00
  inc     b                               ; 04
  ccf                                     ; 3f
  add     a,b                             ; 80
  ld      l,b                             ; 68
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  ld      b,b                             ; 40
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,c                             ; 51
  ld      b,h                             ; 44
  ld      b,b                             ; 40
  ld      b,b                             ; 40
  ld      c,0x54                          ; 0e 54
  adc     a,h                             ; 8c
  ld      b,b                             ; 40
  add     a,b                             ; 80
  ld      (0x4809),hl                     ; 22 09 48
  ld      b,c                             ; 41
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,c                             ; 51
  ld      h,h                             ; 64
  ld      b,c                             ; 41
  ld      b,b                             ; 40
  ld      b,a                             ; 47
  ld      hl,0x414c                       ; 21 4c 41
  add     a,b                             ; 80
  ld      (0x6809),hl                     ; 22 09 68
  ld      b,d                             ; 42
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,c                             ; 51
  add     a,h                             ; 84
  ld      b,d                             ; 42
  ld      b,b                             ; 40
  ld      e,(hl)                          ; 5e
  jp      nz,0x42cf                       ; c2 cf 42
  add     a,b                             ; 80
  ld      (0x8809),hl                     ; 22 09 88
  ld      b,e                             ; 43
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,c                             ; 51
  and     h                               ; a4
  ld      b,e                             ; 43
  ld      b,d                             ; 42
  dec     d                               ; 15
  ld      l,d                             ; 6a
  call    nc,0x8043                       ; d4 43 80
  ld      (0xa809),hl                     ; 22 09 a8
  ld      b,h                             ; 44
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,c                             ; 51
  call    nz,0x2044                       ; c4 44 20
  inc     d                               ; 14
  ld      d,e                             ; 53
  defb    0x28, 0x44
  ld      b,b                             ; 40
  ld      b,b                             ; 40
  nop                                     ; 00
  ex      af,af'                          ; 08
  ld      b,h                             ; 44
  add     a,b                             ; 80
  ld      (0xc809),hl                     ; 22 09 c8
  ld      b,l                             ; 45
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,d                             ; 52
  inc     b                               ; 04
  ld      b,l                             ; 45
  jr      nz,L4DD6                        ; 20 14
  ld      d,e                             ; 53
  xor     b                               ; a8
  ld      b,l                             ; 45
  ld      b,b                             ; 40
  sub     h                               ; 94
  nop                                     ; 00
  ld      c,0x45                          ; 0e 45
  add     a,b                             ; 80
  ld      (0x080a),hl                     ; 22 0a 08
  ld      b,(hl)                          ; 46
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,l                             ; 55
  rlca                                    ; 07
  ld      b,(hl)                          ; 46
  inc     h                               ; 24
  inc     d                               ; 14
L4DD6:
  ld      d,l                             ; 55
  out     (0x46),a                        ; d3 46
  ld      b,b                             ; 40
  inc     c                               ; 0c
  ex      af,af'                          ; 08
  ex      af,af'                          ; 08
  ld      b,(hl)                          ; 46
  add     a,b                             ; 80
  ld      (0x0c0d),hl                     ; 22 0d 0c
  ld      b,(hl)                          ; 46
  and     h                               ; a4
  ld      (0xd40d),hl                     ; 22 0d d4
  ld      b,a                             ; 47
  nop                                     ; 00
  inc     d                               ; 14
  ld      d,c                             ; 51
  inc     h                               ; 24
  ld      b,a                             ; 47
  ld      b,b                             ; 40
  inc     d                               ; 14
  ld      a,c                             ; 79
  add     hl,hl                           ; 29
  ld      b,a                             ; 47
  add     a,b                             ; 80
  ld      (0x2809),hl                     ; 22 09 28
  ld      c,b                             ; 48
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,c                             ; 59
  ld      b,h                             ; 44
  ld      c,b                             ; 48
  ld      b,b                             ; 40
  ld      c,0x5c                          ; 0e 5c
  adc     a,h                             ; 8c
  ld      c,b                             ; 48
  add     a,b                             ; 80
  ld      (0x4811),hl                     ; 22 11 48
  ld      c,c                             ; 49
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,c                             ; 59
  ld      h,h                             ; 64
  ld      c,c                             ; 49
  ld      b,b                             ; 40
  ld      b,a                             ; 47
  ld      hl,0x496c                       ; 21 6c 49
  add     a,b                             ; 80
  ld      (0x6811),hl                     ; 22 11 68
  ld      c,d                             ; 4a
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,c                             ; 59
  add     a,h                             ; 84
  ld      c,d                             ; 4a
  ld      b,b                             ; 40
  inc     e                               ; 1c
  jp      nz,0x4acf                       ; c2 cf 4a
  add     a,b                             ; 80
  ld      (0x8811),hl                     ; 22 11 88
  ld      c,e                             ; 4b
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,c                             ; 59
  and     h                               ; a4
  ld      c,e                             ; 4b
  ld      b,d                             ; 42
  inc     d                               ; 14
  or      l                               ; b5
  or      h                               ; b4
  ld      c,e                             ; 4b
  add     a,b                             ; 80
  ld      (0xa811),hl                     ; 22 11 a8
  ld      c,h                             ; 4c
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,c                             ; 59
  call    nz,0x204c                       ; c4 4c 20
  inc     d                               ; 14
  ld      e,e                             ; 5b
  jr      z,L4E89                         ; 28 4c
  add     a,b                             ; 80
  ld      (0xc811),hl                     ; 22 11 c8
  ld      c,l                             ; 4d
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,d                             ; 5a
  inc     b                               ; 04
  ld      c,l                             ; 4d
  jr      nz,L4E5D                        ; 20 14
  ld      e,e                             ; 5b
  xor     b                               ; a8
  ld      c,l                             ; 4d
  ld      b,b                             ; 40
  sub     d                               ; 92
  nop                                     ; 00
  ld      c,0x4d                          ; 0e 4d
  add     a,b                             ; 80
  ld      (0x0812),hl                     ; 22 12 08
  ld      c,(hl)                          ; 4e
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,l                             ; 5d
  rlca                                    ; 07
  ld      c,(hl)                          ; 4e
  inc     h                               ; 24
  inc     d                               ; 14
L4E5D:
  ld      e,l                             ; 5d
  out     (0x4e),a                        ; d3 4e
  add     a,b                             ; 80
  ld      (0x0c15),hl                     ; 22 15 0c
  ld      c,(hl)                          ; 4e
  and     h                               ; a4
  ld      (0xd415),hl                     ; 22 15 d4
  ld      c,a                             ; 4f
  nop                                     ; 00
  inc     d                               ; 14
  ld      e,c                             ; 59
  inc     h                               ; 24
  ld      c,a                             ; 4f
  ld      b,b                             ; 40
  inc     d                               ; 14
  sbc     a,c                             ; 99
  add     hl,hl                           ; 29
  ld      c,a                             ; 4f
  add     a,b                             ; 80
  ld      (0x2811),hl                     ; 22 11 28
  ld      d,b                             ; 50
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,c                             ; 61
  ld      b,h                             ; 44
  ld      d,b                             ; 50
  ld      b,b                             ; 40
  ld      c,0x64                          ; 0e 64
  adc     a,h                             ; 8c
  ld      d,b                             ; 50
  add     a,b                             ; 80
  ld      (0x4819),hl                     ; 22 19 48
  ld      d,c                             ; 51
  nop                                     ; 00
L4E89:
  inc     d                               ; 14
  ld      h,c                             ; 61
  ld      h,h                             ; 64
  ld      d,c                             ; 51
  ld      b,b                             ; 40
  ld      b,a                             ; 47
  ld      hl,0x518c                       ; 21 8c 51
  add     a,b                             ; 80
  ld      (0x6819),hl                     ; 22 19 68
  ld      d,d                             ; 52
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,c                             ; 61
  add     a,h                             ; 84
  ld      d,d                             ; 52
  ld      b,b                             ; 40
  ld      e,(hl)                          ; 5e
  jp      nz,0x52ef                       ; c2 ef 52
  add     a,b                             ; 80
  ld      (0x8819),hl                     ; 22 19 88
  ld      d,e                             ; 53
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,c                             ; 61
  and     h                               ; a4
  ld      d,e                             ; 53
  ld      b,d                             ; 42
  dec     d                               ; 15
  ld      l,d                             ; 6a
  call    p,0x8053                        ; f4 53 80
  ld      (0xa819),hl                     ; 22 19 a8
  ld      d,h                             ; 54
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,c                             ; 61
  call    nz,0x2054                       ; c4 54 20
  inc     d                               ; 14
  ld      h,e                             ; 63
  defb    0x28, 0x54
  add     a,b                             ; 80
  ld      (0xc819),hl                     ; 22 19 c8
  ld      d,l                             ; 55
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,d                             ; 62
  inc     b                               ; 04
  ld      d,l                             ; 55
  jr      nz,L4EDF                        ; 20 14
  ld      h,e                             ; 63
  xor     b                               ; a8
  ld      d,l                             ; 55
  add     a,b                             ; 80
  ld      (0x081a),hl                     ; 22 1a 08
  ld      d,(hl)                          ; 56
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,l                             ; 65
  rlca                                    ; 07
  ld      d,(hl)                          ; 56
  inc     h                               ; 24
  inc     d                               ; 14
  ld      h,l                             ; 65
  out     (0x56),a                        ; d3 56
  ld      b,b                             ; 40
  inc     c                               ; 0c
L4EDF:
  defb    0x10, 0x08
  ld      d,(hl)                          ; 56
  add     a,b                             ; 80
  ld      (0x0c1d),hl                     ; 22 1d 0c
  ld      d,(hl)                          ; 56
  and     h                               ; a4
  ld      (0xd41d),hl                     ; 22 1d d4
  ld      d,a                             ; 57
  nop                                     ; 00
  inc     d                               ; 14
  ld      h,c                             ; 61
  inc     h                               ; 24
  ld      d,a                             ; 57
  ld      b,b                             ; 40
  inc     d                               ; 14
  ld      c,c                             ; 49
  jp      (hl)                            ; e9
  ld      d,a                             ; 57
  add     a,b                             ; 80
  ld      (0x2819),hl                     ; 22 19 28
  ld      e,b                             ; 58
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,c                             ; 69
  ld      b,h                             ; 44
  ld      e,b                             ; 58
  ld      b,b                             ; 40
  ld      c,0x6c                          ; 0e 6c
  adc     a,h                             ; 8c
  ld      e,b                             ; 58
  add     a,b                             ; 80
  ld      (0x4821),hl                     ; 22 21 48
  ld      e,c                             ; 59
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,c                             ; 69
  ld      h,h                             ; 64
  ld      e,c                             ; 59
  ld      b,b                             ; 40
  ld      b,a                             ; 47
  ld      hl,0x59ac                       ; 21 ac 59
  add     a,b                             ; 80
  ld      (0x6821),hl                     ; 22 21 68
  ld      e,d                             ; 5a
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,c                             ; 69
  add     a,h                             ; 84
  ld      e,d                             ; 5a
  ld      b,b                             ; 40
  inc     e                               ; 1c
  jp      nz,0x5aef                       ; c2 ef 5a
  add     a,b                             ; 80
  ld      (0x8821),hl                     ; 22 21 88
  ld      e,e                             ; 5b
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,c                             ; 69
  and     h                               ; a4
  ld      e,e                             ; 5b
  ld      b,d                             ; 42
  inc     d                               ; 14
  cp      l                               ; bd
  or      h                               ; b4
  ld      e,e                             ; 5b
  add     a,b                             ; 80
  ld      (0xa821),hl                     ; 22 21 a8
  ld      e,h                             ; 5c
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,c                             ; 69
  call    nz,0x205c                       ; c4 5c 20
  inc     d                               ; 14
  ld      l,e                             ; 6b
  jr      z,L4F9D                         ; 28 5c
  add     a,b                             ; 80
  ld      (0xc821),hl                     ; 22 21 c8
  ld      e,l                             ; 5d
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,d                             ; 6a
  inc     b                               ; 04
  ld      e,l                             ; 5d
  jr      nz,L4F61                        ; 20 14
  ld      l,e                             ; 6b
  xor     b                               ; a8
  ld      e,l                             ; 5d
  add     a,b                             ; 80
  ld      (0x0822),hl                     ; 22 22 08
  ld      e,(hl)                          ; 5e
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,l                             ; 6d
  rlca                                    ; 07
  ld      e,(hl)                          ; 5e
  inc     h                               ; 24
  inc     d                               ; 14
  ld      l,l                             ; 6d
  out     (0x5e),a                        ; d3 5e
  ld      b,b                             ; 40
  inc     c                               ; 0c
L4F61:
  defb    0x18, 0x08
  ld      e,(hl)                          ; 5e
  add     a,b                             ; 80
  ld      (0x0c25),hl                     ; 22 25 0c
  ld      e,(hl)                          ; 5e
  and     h                               ; a4
  ld      (0xd425),hl                     ; 22 25 d4
  ld      e,a                             ; 5f
  nop                                     ; 00
  inc     d                               ; 14
  ld      l,c                             ; 69
  inc     h                               ; 24
  ld      e,a                             ; 5f
  ld      b,b                             ; 40
  inc     d                               ; 14
  ld      c,d                             ; 4a
  ld      l,c                             ; 69
  ld      e,a                             ; 5f
  add     a,b                             ; 80
  ld      (0x2821),hl                     ; 22 21 28
  ld      h,b                             ; 60
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),c                          ; 71
  ld      b,h                             ; 44
  ld      h,b                             ; 60
  jr      nz,L4F98                        ; 20 14
  ret                                     ; c9
  ld      c,b                             ; 48
  ld      h,b                             ; 60
  ld      b,b                             ; 40
  ld      c,0x74                          ; 0e 74
  adc     a,h                             ; 8c
  ld      h,b                             ; 60
  add     a,b                             ; 80
  ld      (0x4829),hl                     ; 22 29 48
  ld      h,c                             ; 61
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),c                          ; 71
  ld      h,h                             ; 64
  ld      h,c                             ; 61
  jr      nz,L4FAC                        ; 20 14
L4F98:
  ret                                     ; c9
  ld      l,b                             ; 68
  ld      h,c                             ; 61
  ld      b,b                             ; 40
  ld      b,a                             ; 47
L4F9D:
  ld      hl,0x61cc                       ; 21 cc 61
  add     a,b                             ; 80
  ld      (0x6829),hl                     ; 22 29 68
  ld      h,d                             ; 62
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),c                          ; 71
  add     a,h                             ; 84
  ld      h,d                             ; 62
  jr      nz,L4FC0                        ; 20 14
L4FAC:
  ret                                     ; c9
  adc     a,b                             ; 88
  ld      h,d                             ; 62
  ld      b,b                             ; 40
  ld      e,(hl)                          ; 5e
  jp      0x620f                          ; c3 0f 62
  add     a,b                             ; 80
  ld      (0x8829),hl                     ; 22 29 88
  ld      h,e                             ; 63
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),c                          ; 71
  and     h                               ; a4
  ld      h,e                             ; 63
  jr      nz,L4FD4                        ; 20 14
L4FC0:
  ret                                     ; c9
  xor     b                               ; a8
  ld      h,e                             ; 63
  ld      b,d                             ; 42
  dec     d                               ; 15
  ld      l,e                             ; 6b
  inc     d                               ; 14
  ld      h,e                             ; 63
  add     a,b                             ; 80
  ld      (0xa829),hl                     ; 22 29 a8
  ld      h,h                             ; 64
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),c                          ; 71
  call    nz,0x2064                       ; c4 64 20
  inc     d                               ; 14
L4FD4:
  sra     b                               ; cb 28
  ld      h,h                             ; 64
  add     a,b                             ; 80
  ld      (0xc829),hl                     ; 22 29 c8
  ld      h,l                             ; 65
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),d                          ; 72
  inc     b                               ; 04
  ld      h,l                             ; 65
  defb    0x20, 0x14
  res     5,b                             ; cb a8
  ld      h,l                             ; 65
  add     a,b                             ; 80
  ld      (0x082a),hl                     ; 22 2a 08
  ld      h,(hl)                          ; 66
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),l                          ; 75
  rlca                                    ; 07
  ld      h,(hl)                          ; 66
  inc     h                               ; 24
  inc     d                               ; 14
  ld      (hl),l                          ; 75
  out     (0x66),a                        ; d3 66
  add     a,b                             ; 80
  ld      (0x0c2d),hl                     ; 22 2d 0c
  ld      h,(hl)                          ; 66
  and     h                               ; a4
  ld      (0xd42d),hl                     ; 22 2d d4
  ld      h,a                             ; 67
  nop                                     ; 00
  inc     d                               ; 14
  ld      (hl),c                          ; 71
  inc     h                               ; 24
  ld      h,a                             ; 67
  jr      nz,L501A                        ; 20 14
  ret                                     ; c9
  defb    0x28, 0x67
  ld      b,b                             ; 40
  ld      e,d                             ; 5a
  nop                                     ; 00
  ld      (de),a                          ; 12
  ld      h,a                             ; 67
  add     a,b                             ; 80
  ld      (0x2829),hl                     ; 22 29 28
  ld      l,b                             ; 68
  nop                                     ; 00
  inc     d                               ; 14
  add     a,c                             ; 81
  ld      b,h                             ; 44
  ld      l,b                             ; 68
  jr      nz,L502E                        ; 20 14
L501A:
  jp      (hl)                            ; e9
  ld      c,b                             ; 48
  ld      l,b                             ; 68
  ld      b,b                             ; 40
  ld      c,0x84                          ; 0e 84
  adc     a,h                             ; 8c
  ld      l,b                             ; 68
  add     a,b                             ; 80
  ld      (0x4831),hl                     ; 22 31 48
  ld      l,c                             ; 69
  nop                                     ; 00
  inc     d                               ; 14
  add     a,c                             ; 81
  ld      h,h                             ; 64
  ld      l,c                             ; 69
  jr      nz,L5042                        ; 20 14
L502E:
  jp      (hl)                            ; e9
  ld      l,b                             ; 68
  ld      l,c                             ; 69
  ld      b,b                             ; 40
  ld      b,a                             ; 47
  ld      (0x690c),hl                     ; 22 0c 69
  add     a,b                             ; 80
  ld      (0x6831),hl                     ; 22 31 68
  ld      l,d                             ; 6a
  nop                                     ; 00
  inc     d                               ; 14
  add     a,c                             ; 81
  add     a,h                             ; 84
  ld      l,d                             ; 6a
  jr      nz,L5056                        ; 20 14
L5042:
  jp      (hl)                            ; e9
  adc     a,b                             ; 88
  ld      l,d                             ; 6a
  ld      b,b                             ; 40
  inc     e                               ; 1c
  jp      0x6a0f                          ; c3 0f 6a
  add     a,b                             ; 80
  ld      (0x8831),hl                     ; 22 31 88
  ld      l,e                             ; 6b
  nop                                     ; 00
  inc     d                               ; 14
  add     a,c                             ; 81
  and     h                               ; a4
  ld      l,e                             ; 6b
  jr      nz,L506A                        ; 20 14
L5056:
  jp      (hl)                            ; e9
  xor     b                               ; a8
  ld      l,e                             ; 6b
  ld      b,d                             ; 42
  inc     d                               ; 14
  push    bc                              ; c5
  or      h                               ; b4
  ld      l,e                             ; 6b
  add     a,b                             ; 80
  ld      (0xa831),hl                     ; 22 31 a8
  ld      l,h                             ; 6c
  nop                                     ; 00
  inc     d                               ; 14
  add     a,c                             ; 81
  call    nz,0x206c                       ; c4 6c 20
  inc     d                               ; 14
L506A:
  ex      de,hl                           ; eb
  defb    0x28, 0x6c
  add     a,b                             ; 80
  ld      (0xc831),hl                     ; 22 31 c8
  ld      l,l                             ; 6d
  nop                                     ; 00
  inc     d                               ; 14
  add     a,d                             ; 82
  inc     b                               ; 04
  ld      l,l                             ; 6d
  defb    0x20, 0x14
  ex      de,hl                           ; eb
  xor     b                               ; a8
  ld      l,l                             ; 6d
  add     a,b                             ; 80
  ld      (0x0832),hl                     ; 22 32 08
  ld      l,(hl)                          ; 6e
  nop                                     ; 00
  inc     d                               ; 14
  add     a,l                             ; 85
  rlca                                    ; 07
  ld      l,(hl)                          ; 6e
  inc     h                               ; 24
  inc     d                               ; 14
  add     a,l                             ; 85
  out     (0x6e),a                        ; d3 6e
  add     a,b                             ; 80
  ld      (0x0c35),hl                     ; 22 35 0c
  ld      l,(hl)                          ; 6e
  and     h                               ; a4
  ld      (0xd435),hl                     ; 22 35 d4
  ld      l,a                             ; 6f
  nop                                     ; 00
  inc     d                               ; 14
  add     a,c                             ; 81
  inc     h                               ; 24
  ld      l,a                             ; 6f
  jr      nz,L50B0                        ; 20 14
  jp      (hl)                            ; e9
  jr      z,L510E                         ; 28 6f
  ld      b,b                             ; 40
  ld      d,h                             ; 54
  nop                                     ; 00
  ld      (de),a                          ; 12
  ld      l,a                             ; 6f
  add     a,b                             ; 80
  ld      (0x2831),hl                     ; 22 31 28
  ld      (hl),b                          ; 70
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,c                             ; 41
  ld      b,a                             ; 47
  ld      (hl),b                          ; 70
  inc     h                               ; 24
  dec     d                               ; 15
L50B0:
  ld      (hl),c                          ; 71
  ld      d,e                             ; 53
  ld      (hl),b                          ; 70
  add     a,b                             ; 80
  ld      (0x4839),hl                     ; 22 39 48
  ld      (hl),c                          ; 71
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,c                             ; 41
  ld      h,a                             ; 67
  ld      (hl),c                          ; 71
  inc     h                               ; 24
  dec     d                               ; 15
  ld      (hl),c                          ; 71
  ld      (hl),e                          ; 73
  ld      (hl),c                          ; 71
  add     a,b                             ; 80
  ld      (0x6839),hl                     ; 22 39 68
  ld      (hl),d                          ; 72
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,c                             ; 41
  add     a,a                             ; 87
  ld      (hl),d                          ; 72
  inc     h                               ; 24
  dec     d                               ; 15
  ld      (hl),c                          ; 71
  sub     e                               ; 93
  ld      (hl),d                          ; 72
  ld      b,b                             ; 40
  ld      e,(hl)                          ; 5e
  call    nz,0x726f                       ; c4 6f 72
  add     a,b                             ; 80
  ld      (0x8839),hl                     ; 22 39 88
  ld      (hl),e                          ; 73
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,c                             ; 41
  and     a                               ; a7
  ld      (hl),e                          ; 73
  inc     h                               ; 24
  dec     d                               ; 15
  ld      (hl),c                          ; 71
  or      e                               ; b3
  ld      (hl),e                          ; 73
  ld      b,d                             ; 42
  dec     d                               ; 15
  ld      l,h                             ; 6c
  ld      (hl),h                          ; 74
  ld      (hl),e                          ; 73
  add     a,b                             ; 80
  ld      (0xa839),hl                     ; 22 39 a8
  ld      (hl),h                          ; 74
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,c                             ; 41
  rst     0x00                            ; c7
  ld      (hl),h                          ; 74
  inc     h                               ; 24
  dec     d                               ; 15
  ld      (hl),c                          ; 71
  out     (0x74),a                        ; d3 74
  add     a,b                             ; 80
  ld      (0xc839),hl                     ; 22 39 c8
  ld      (hl),l                          ; 75
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,d                             ; 42
  rlca                                    ; 07
  ld      (hl),l                          ; 75
  inc     h                               ; 24
  dec     d                               ; 15
  ld      (hl),d                          ; 72
  inc     de                              ; 13
  ld      (hl),l                          ; 75
  add     a,b                             ; 80
  ld      (0x083a),hl                     ; 22 3a 08
  halt                                    ; 76
  nop                                     ; 00
L510E:
  ld      a,(hl)                          ; 7e
  nop                                     ; 00
  inc     b                               ; 04
  halt                                    ; 76
  add     a,b                             ; 80
  ld      (0x0c3d),hl                     ; 22 3d 0c
  halt                                    ; 76
  and     h                               ; a4
  ld      (0xd43d),hl                     ; 22 3d d4
  ld      (hl),a                          ; 77
  nop                                     ; 00
  dec     d                               ; 15
  ld      b,c                             ; 41
  daa                                     ; 27
  ld      (hl),a                          ; 77
  inc     h                               ; 24
  dec     d                               ; 15
  ld      (hl),c                          ; 71
  inc     sp                              ; 33
  ld      (hl),a                          ; 77
  add     a,b                             ; 80
  ld      (0x2839),hl                     ; 22 39 28
  ld      a,b                             ; 78
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,c                             ; 49
  ld      b,h                             ; 44
  ld      a,b                             ; 78
  ld      b,b                             ; 40
  ld      c,0x4c                          ; 0e 4c
  adc     a,h                             ; 8c
  ld      a,b                             ; 78
  add     a,b                             ; 80
  ld      (0x4841),hl                     ; 22 41 48
  ld      a,c                             ; 79
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,c                             ; 49
  ld      h,h                             ; 64
  ld      a,c                             ; 79
  ld      b,b                             ; 40
  ld      b,a                             ; 47
  ld      hl,0x792c                       ; 21 2c 79
  add     a,b                             ; 80
  ld      (0x6841),hl                     ; 22 41 68
  ld      a,d                             ; 7a
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,c                             ; 49
  add     a,h                             ; 84
  ld      a,d                             ; 7a
  ld      b,b                             ; 40
  inc     e                               ; 1c
  call    nz,0x7a6f                       ; c4 6f 7a
  add     a,b                             ; 80
  ld      (0x8841),hl                     ; 22 41 88
  ld      a,e                             ; 7b
  nop                                     ; 00
L5159:
  inc     d                               ; 14
  ld      c,c                             ; 49
  and     h                               ; a4
  ld      a,e                             ; 7b
  ld      b,d                             ; 42
  dec     d                               ; 15
  dec     e                               ; 1d
  or      h                               ; b4
  ld      a,e                             ; 7b
  add     a,b                             ; 80
  ld      (0xa841),hl                     ; 22 41 a8
  ld      a,h                             ; 7c
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,c                             ; 49
  call    nz,0x207c                       ; c4 7c 20
  inc     d                               ; 14
  ld      c,e                             ; 4b
  jr      z,L51ED                         ; 28 7c
  add     a,b                             ; 80
  ld      (0xc841),hl                     ; 22 41 c8
  ld      a,l                             ; 7d
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,d                             ; 4a
  inc     b                               ; 04
  ld      a,l                             ; 7d
  defb    0x20, 0x14
  ld      c,e                             ; 4b
  xor     b                               ; a8
  ld      a,l                             ; 7d
  add     a,b                             ; 80
  ld      (0x0842),hl                     ; 22 42 08
  ld      a,(hl)                          ; 7e
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,l                             ; 4d
  rlca                                    ; 07
  ld      a,(hl)                          ; 7e
  inc     h                               ; 24
  inc     d                               ; 14
  ld      c,l                             ; 4d
  out     (0x7e),a                        ; d3 7e
L518F:
  add     a,b                             ; 80
  ld      (0x0c45),hl                     ; 22 45 0c
  ld      a,(hl)                          ; 7e
  and     h                               ; a4
  ld      (0xd445),hl                     ; 22 45 d4
  ld      a,a                             ; 7f
  nop                                     ; 00
  inc     d                               ; 14
  ld      c,c                             ; 49
  inc     h                               ; 24
  ld      a,a                             ; 7f
  add     a,b                             ; 80
  ld      (0x2841),hl                     ; 22 41 28
  add     a,b                             ; 80
  nop                                     ; 00
  ld      e,0x49                          ; 1e 49
  ld      b,h                             ; 44
  add     a,b                             ; 80
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,bc                           ; 09
  ld      c,b                             ; 48
  add     a,c                             ; 81
  nop                                     ; 00
  ld      e,0x49                          ; 1e 49
  ld      h,h                             ; 64
  add     a,c                             ; 81
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,bc                           ; 09
  ld      l,b                             ; 68
  add     a,d                             ; 82
  nop                                     ; 00
  ld      e,0x49                          ; 1e 49
  add     a,h                             ; 84
  add     a,d                             ; 82
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,bc                           ; 09
  adc     a,b                             ; 88
  add     a,e                             ; 83
  nop                                     ; 00
  ld      e,0x49                          ; 1e 49
  and     h                               ; a4
L51C5:
  add     a,e                             ; 83
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,bc                           ; 09
  xor     b                               ; a8
  add     a,h                             ; 84
  nop                                     ; 00
  ld      e,0x49                          ; 1e 49
  call    nz,0x2084                       ; c4 84 20
  ld      e,0x4b                          ; 1e 4b
  jr      z,L5159                         ; 28 84
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,bc                           ; 09
  ret     z                               ; c8
  add     a,l                             ; 85
  nop                                     ; 00
  ld      e,0x4a                          ; 1e 4a
  inc     b                               ; 04
  add     a,l                             ; 85
  defb    0x20, 0x1e
  ld      c,e                             ; 4b
  xor     b                               ; a8
  add     a,l                             ; 85
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      a,(bc)                          ; 0a
  ex      af,af'                          ; 08
  add     a,(hl)                          ; 86
  nop                                     ; 00
  ld      e,0x4d                          ; 1e 4d
  rlca                                    ; 07
L51ED:
  add     a,(hl)                          ; 86
  inc     h                               ; 24
  ld      e,0x4d                          ; 1e 4d
  out     (0x86),a                        ; d3 86
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     c                               ; 0d
  rrca                                    ; 0f
  add     a,(hl)                          ; 86
  and     h                               ; a4
  ld      c,h                             ; 4c
  dec     c                               ; 0d
  rst     0x10                            ; d7
  add     a,a                             ; 87
  nop                                     ; 00
  ld      e,0x49                          ; 1e 49
  inc     h                               ; 24
  add     a,a                             ; 87
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,bc                           ; 09
  jr      z,L518F                         ; 28 88
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,c                             ; 49
  ld      b,h                             ; 44
  adc     a,b                             ; 88
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      de,0x8948                       ; 11 48 89
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,c                             ; 49
  ld      h,h                             ; 64
  adc     a,c                             ; 89
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      de,0x8a68                       ; 11 68 8a
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,c                             ; 49
  add     a,h                             ; 84
  adc     a,d                             ; 8a
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      de,0x8b88                       ; 11 88 8b
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,c                             ; 49
  and     h                               ; a4
  adc     a,e                             ; 8b
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      de,0x8ca8                       ; 11 a8 8c
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,c                             ; 49
  call    nz,0x208c                       ; c4 8c 20
  inc     e                               ; 1c
  ld      c,e                             ; 4b
  jr      z,L51C5                         ; 28 8c
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      de,0x8dc8                       ; 11 c8 8d
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,d                             ; 4a
  inc     b                               ; 04
  adc     a,l                             ; 8d
  jr      nz,L5261                        ; 20 1c
  ld      c,e                             ; 4b
  xor     b                               ; a8
  adc     a,l                             ; 8d
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      (de),a                          ; 12
  ex      af,af'                          ; 08
  adc     a,(hl)                          ; 8e
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,l                             ; 4d
  rlca                                    ; 07
  adc     a,(hl)                          ; 8e
  inc     h                               ; 24
  inc     e                               ; 1c
  ld      c,l                             ; 4d
  out     (0x8e),a                        ; d3 8e
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     d                               ; 15
  rrca                                    ; 0f
  adc     a,(hl)                          ; 8e
  and     h                               ; a4
  ld      c,h                             ; 4c
  dec     d                               ; 15
  rst     0x10                            ; d7
  adc     a,a                             ; 8f
L5261:
  nop                                     ; 00
  inc     e                               ; 1c
  ld      c,c                             ; 49
  inc     h                               ; 24
  adc     a,a                             ; 8f
  add     a,b                             ; 80
L5267:
  ld      c,h                             ; 4c
  ld      de,0x9028                       ; 11 28 90
  nop                                     ; 00
  ld      l,d                             ; 6a
  ld      d,b                             ; 50
  inc     b                               ; 04
  sub     b                               ; 90
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,de                           ; 19
  ld      c,b                             ; 48
  sub     c                               ; 91
  nop                                     ; 00
  ld      l,d                             ; 6a
  ld      e,b                             ; 58
  inc     b                               ; 04
  sub     c                               ; 91
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,de                           ; 19
  ld      l,b                             ; 68
  sub     d                               ; 92
  nop                                     ; 00
  ld      l,d                             ; 6a
  ld      h,b                             ; 60
  inc     b                               ; 04
  sub     d                               ; 92
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,de                           ; 19
  adc     a,b                             ; 88
  sub     e                               ; 93
  nop                                     ; 00
  ld      l,d                             ; 6a
  ld      l,b                             ; 68
  inc     b                               ; 04
  sub     e                               ; 93
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,de                           ; 19
  xor     b                               ; a8
  sub     h                               ; 94
  nop                                     ; 00
  ld      l,d                             ; 6a
  ld      (hl),b                          ; 70
  inc     b                               ; 04
  sub     h                               ; 94
  defb    0x20, 0x6a
  ret     z                               ; c8
  ex      af,af'                          ; 08
  sub     h                               ; 94
L529D:
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,de                           ; 19
  ret     z                               ; c8
  sub     l                               ; 95
  nop                                     ; 00
  ld      l,d                             ; 6a
  add     a,b                             ; 80
  inc     b                               ; 04
  sub     l                               ; 95
  defb    0x20, 0x6a
  ret     pe                              ; e8
  ex      af,af'                          ; 08
  sub     l                               ; 95
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      a,(de)                          ; 1a
  ex      af,af'                          ; 08
  sub     (hl)                            ; 96
  nop                                     ; 00
  ld      l,e                             ; 6b
  ld      b,b                             ; 40
  rlca                                    ; 07
  sub     (hl)                            ; 96
  inc     h                               ; 24
  ld      l,e                             ; 6b
  ld      (hl),b                          ; 70
  inc     de                              ; 13
  sub     (hl)                            ; 96
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     e                               ; 1d
  rrca                                    ; 0f
  sub     (hl)                            ; 96
  and     h                               ; a4
  ld      c,h                             ; 4c
  dec     e                               ; 1d
  rst     0x10                            ; d7
  sub     a                               ; 97
  nop                                     ; 00
  ld      l,d                             ; 6a
  ld      c,b                             ; 48
  inc     b                               ; 04
  sub     a                               ; 97
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,de                           ; 19
  jr      z,L5267                         ; 28 98
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,c                             ; 49
  ld      b,h                             ; 44
  sbc     a,b                             ; 98
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,0x9948                       ; 21 48 99
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,c                             ; 49
  ld      h,h                             ; 64
L52DD:
  sbc     a,c                             ; 99
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,0x9a68                       ; 21 68 9a
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,c                             ; 49
  add     a,h                             ; 84
  sbc     a,d                             ; 9a
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,0x9b88                       ; 21 88 9b
L52ED:
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,c                             ; 49
  and     h                               ; a4
  sbc     a,e                             ; 9b
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,0x9ca8                       ; 21 a8 9c
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,c                             ; 49
  call    nz,0x209c                       ; c4 9c 20
  ld      e,(hl)                          ; 5e
  ld      c,e                             ; 4b
  jr      z,L529D                         ; 28 9c
L5301:
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,0x9dc8                       ; 21 c8 9d
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,d                             ; 4a
  inc     b                               ; 04
  sbc     a,l                             ; 9d
  jr      nz,L536B                        ; 20 5e
L530D:
  ld      c,e                             ; 4b
  xor     b                               ; a8
  sbc     a,l                             ; 9d
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      (0x9e08),hl                     ; 22 08 9e
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,l                             ; 4d
  rlca                                    ; 07
  sbc     a,(hl)                          ; 9e
  inc     h                               ; 24
  ld      e,(hl)                          ; 5e
  ld      c,l                             ; 4d
  out     (0x9e),a                        ; d3 9e
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     h                               ; 25
  rrca                                    ; 0f
  sbc     a,(hl)                          ; 9e
  and     h                               ; a4
  ld      c,h                             ; 4c
  dec     h                               ; 25
  rst     0x10                            ; d7
  sbc     a,a                             ; 9f
  nop                                     ; 00
  ld      e,(hl)                          ; 5e
  ld      c,c                             ; 49
  inc     h                               ; 24
  sbc     a,a                             ; 9f
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,0xa028                       ; 21 28 a0
  nop                                     ; 00
  jr      nz,L5386                        ; 20 50
  inc     b                               ; 04
  and     b                               ; a0
  ld      b,b                             ; 40
  ld      a,0x00                          ; 3e 00
  djnz    L52DD                           ; 10 a0
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,hl                           ; 29
  ld      c,b                             ; 48
  and     c                               ; a1
  nop                                     ; 00
  jr      nz,L539D                        ; 20 58
  inc     b                               ; 04
  and     c                               ; a1
  ld      b,b                             ; 40
  jr      z,L534A                         ; 28 00
L534A:
  djnz    L52ED                           ; 10 a1
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,hl                           ; 29
  ld      l,b                             ; 68
  and     d                               ; a2
  nop                                     ; 00
  defb    0x20, 0x60
  inc     b                               ; 04
  and     d                               ; a2
  ld      b,b                             ; 40
  ld      a,(0x1000)                      ; 3a 00 10
  and     d                               ; a2
  add     a,b                             ; 80
  ld      c,h                             ; 4c
L535D:
  add     hl,hl                           ; 29
  adc     a,b                             ; 88
  and     e                               ; a3
  nop                                     ; 00
  jr      nz,L53CB                        ; 20 68
  inc     b                               ; 04
  and     e                               ; a3
  ld      b,b                             ; 40
  adc     a,(hl)                          ; 8e
  nop                                     ; 00
  djnz    L530D                           ; 10 a3
  add     a,b                             ; 80
L536B:
  ld      c,h                             ; 4c
  add     hl,hl                           ; 29
L536D:
  xor     b                               ; a8
  and     h                               ; a4
  nop                                     ; 00
  jr      nz,L53E2                        ; 20 70
  inc     b                               ; 04
  and     h                               ; a4
  jr      nz,L5396                        ; 20 20
  ret     z                               ; c8
  ex      af,af'                          ; 08
  and     h                               ; a4
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,hl                           ; 29
  ret     z                               ; c8
L537D:
  and     l                               ; a5
  nop                                     ; 00
  jr      nz,L5301                        ; 20 80
  inc     b                               ; 04
  and     l                               ; a5
  jr      nz,L53A5                        ; 20 20
  ret     pe                              ; e8
L5386:
  ex      af,af'                          ; 08
  and     l                               ; a5
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      hl,(0xa608)                     ; 2a 08 a6
L538D:
  nop                                     ; 00
  ld      hl,0x0740                       ; 21 40 07
  and     (hl)                            ; a6
  inc     h                               ; 24
  ld      hl,0x1370                       ; 21 70 13
L5396:
  and     (hl)                            ; a6
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     l                               ; 2d
  rrca                                    ; 0f
  and     (hl)                            ; a6
  and     h                               ; a4
L539D:
  ld      c,h                             ; 4c
  dec     l                               ; 2d
  rst     0x10                            ; d7
  and     a                               ; a7
  nop                                     ; 00
  jr      nz,L53EC                        ; 20 48
  inc     b                               ; 04
L53A5:
  and     a                               ; a7
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,hl                           ; 29
  defb    0x28, 0xa8
  nop                                     ; 00
  ld      l,h                             ; 6c
  ld      d,b                             ; 50
  inc     b                               ; 04
  xor     b                               ; a8
  ld      b,b                             ; 40
  inc     a                               ; 3c
  nop                                     ; 00
  djnz    L535D                           ; 10 a8
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      sp,0xa948                       ; 31 48 a9
  nop                                     ; 00
  ld      l,h                             ; 6c
  ld      e,b                             ; 58
  inc     b                               ; 04
  xor     c                               ; a9
  ld      b,b                             ; 40
  ld      h,0x00                          ; 26 00
  djnz    L536D                           ; 10 a9
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      sp,0xaa68                       ; 31 68 aa
  nop                                     ; 00
  ld      l,h                             ; 6c
L53CB:
  ld      h,b                             ; 60
  inc     b                               ; 04
  xor     d                               ; aa
  ld      b,b                             ; 40
  jr      c,L53D1                         ; 38 00
L53D1:
  djnz    L537D                           ; 10 aa
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      sp,0xab88                       ; 31 88 ab
  nop                                     ; 00
  ld      l,h                             ; 6c
  ld      l,b                             ; 68
  inc     b                               ; 04
  xor     e                               ; ab
  ld      b,b                             ; 40
  adc     a,h                             ; 8c
  nop                                     ; 00
  djnz    L538D                           ; 10 ab
L53E2:
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      sp,0xaca8                       ; 31 a8 ac
  nop                                     ; 00
  ld      l,h                             ; 6c
  ld      (hl),b                          ; 70
  inc     b                               ; 04
  xor     h                               ; ac
L53EC:
  jr      nz,L545A                        ; 20 6c
  ret     z                               ; c8
  ex      af,af'                          ; 08
  xor     h                               ; ac
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      sp,0xadc8                       ; 31 c8 ad
  nop                                     ; 00
  ld      l,h                             ; 6c
  add     a,b                             ; 80
  inc     b                               ; 04
  xor     l                               ; ad
  jr      nz,L5469                        ; 20 6c
  ret     pe                              ; e8
  ex      af,af'                          ; 08
  xor     l                               ; ad
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      (0xae08),a                      ; 32 08 ae
  nop                                     ; 00
  ld      l,l                             ; 6d
  ld      b,b                             ; 40
  rlca                                    ; 07
  xor     (hl)                            ; ae
  inc     h                               ; 24
  ld      l,l                             ; 6d
  ld      (hl),b                          ; 70
  inc     de                              ; 13
  xor     (hl)                            ; ae
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     (hl)                            ; 35
  rrca                                    ; 0f
  xor     (hl)                            ; ae
  and     h                               ; a4
  ld      c,h                             ; 4c
  dec     (hl)                            ; 35
  rst     0x10                            ; d7
  xor     a                               ; af
  nop                                     ; 00
  ld      l,h                             ; 6c
  ld      c,b                             ; 48
  inc     b                               ; 04
  xor     a                               ; af
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      sp,0xb028                       ; 31 28 b0
  nop                                     ; 00
  ld      d,0x50                          ; 16 50
  inc     b                               ; 04
  or      b                               ; b0
  ld      b,b                             ; 40
  add     a,(hl)                          ; 86
  nop                                     ; 00
  dec     d                               ; 15
  or      b                               ; b0
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,sp                           ; 39
  ld      c,b                             ; 48
  or      c                               ; b1
  nop                                     ; 00
  ld      d,0x58                          ; 16 58
  inc     b                               ; 04
  or      c                               ; b1
  ld      b,b                             ; 40
  ld      (hl),d                          ; 72
  nop                                     ; 00
  dec     d                               ; 15
  or      c                               ; b1
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,sp                           ; 39
  ld      l,b                             ; 68
  or      d                               ; b2
  nop                                     ; 00
  ld      d,0x60                          ; 16 60
  inc     b                               ; 04
  or      d                               ; b2
  ld      b,b                             ; 40
  add     a,d                             ; 82
  nop                                     ; 00
  dec     d                               ; 15
  or      d                               ; b2
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,sp                           ; 39
  adc     a,b                             ; 88
  or      e                               ; b3
  nop                                     ; 00
  ld      d,0x68                          ; 16 68
L5453:
  inc     b                               ; 04
  or      e                               ; b3
  ld      b,b                             ; 40
  adc     a,d                             ; 8a
  nop                                     ; 00
  dec     d                               ; 15
  or      e                               ; b3
L545A:
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,sp                           ; 39
  xor     b                               ; a8
  or      h                               ; b4
  nop                                     ; 00
  ld      d,0x70                          ; 16 70
  inc     b                               ; 04
  or      h                               ; b4
  defb    0x20, 0x16
  ret     z                               ; c8
  ex      af,af'                          ; 08
  or      h                               ; b4
L5469:
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,sp                           ; 39
  ret     z                               ; c8
  or      l                               ; b5
  nop                                     ; 00
  ld      d,0x80                          ; 16 80
  inc     b                               ; 04
  or      l                               ; b5
  jr      nz,L548B                        ; 20 16
  ret     pe                              ; e8
  ex      af,af'                          ; 08
  or      l                               ; b5
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      a,(0xb608)                      ; 3a 08 b6
  nop                                     ; 00
  rla                                     ; 17
  ld      b,b                             ; 40
  rlca                                    ; 07
  or      (hl)                            ; b6
  inc     h                               ; 24
  rla                                     ; 17
  ld      (hl),b                          ; 70
  inc     de                              ; 13
  or      (hl)                            ; b6
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  dec     a                               ; 3d
  rrca                                    ; 0f
L548B:
  or      (hl)                            ; b6
  and     h                               ; a4
  ld      c,h                             ; 4c
  dec     a                               ; 3d
  rst     0x10                            ; d7
  or      a                               ; b7
  nop                                     ; 00
  ld      d,0x48                          ; 16 48
  inc     b                               ; 04
  or      a                               ; b7
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  add     hl,sp                           ; 39
  jr      z,L5453                         ; 28 b8
  nop                                     ; 00
  inc     b                               ; 04
  ld      d,b                             ; 50
  inc     b                               ; 04
  cp      b                               ; b8
  ld      b,b                             ; 40
  add     a,h                             ; 84
  nop                                     ; 00
  dec     d                               ; 15
  cp      b                               ; b8
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      b,c                             ; 41
  ld      c,b                             ; 48
  cp      c                               ; b9
  nop                                     ; 00
  inc     b                               ; 04
  ld      e,b                             ; 58
  inc     b                               ; 04
  cp      c                               ; b9
  ld      b,b                             ; 40
  ld      (hl),b                          ; 70
  nop                                     ; 00
  dec     d                               ; 15
  cp      c                               ; b9
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      b,c                             ; 41
  ld      l,b                             ; 68
  cp      d                               ; ba
  nop                                     ; 00
  inc     b                               ; 04
  ld      h,b                             ; 60
  inc     b                               ; 04
  cp      d                               ; ba
  ld      b,b                             ; 40
  add     a,b                             ; 80
  nop                                     ; 00
  dec     d                               ; 15
  cp      d                               ; ba
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      b,c                             ; 41
  adc     a,b                             ; 88
  cp      e                               ; bb
  nop                                     ; 00
  inc     b                               ; 04
  ld      l,b                             ; 68
  inc     b                               ; 04
  cp      e                               ; bb
  ld      b,b                             ; 40
  adc     a,b                             ; 88
  nop                                     ; 00
  dec     d                               ; 15
  cp      e                               ; bb
  add     a,b                             ; 80
L54D3:
  ld      c,h                             ; 4c
  ld      b,c                             ; 41
  xor     b                               ; a8
  cp      h                               ; bc
  nop                                     ; 00
  inc     b                               ; 04
  ld      (hl),b                          ; 70
  inc     b                               ; 04
  cp      h                               ; bc
  jr      nz,L54E2                        ; 20 04
  ret     z                               ; c8
  ex      af,af'                          ; 08
  cp      h                               ; bc
  add     a,b                             ; 80
L54E2:
  ld      c,h                             ; 4c
  ld      b,c                             ; 41
  ret     z                               ; c8
  cp      l                               ; bd
  nop                                     ; 00
  inc     b                               ; 04
  add     a,b                             ; 80
  inc     b                               ; 04
  cp      l                               ; bd
  jr      nz,L54F1                        ; 20 04
  ret     pe                              ; e8
  ex      af,af'                          ; 08
  cp      l                               ; bd
  add     a,b                             ; 80
L54F1:
  ld      c,h                             ; 4c
  ld      b,d                             ; 42
  ex      af,af'                          ; 08
  cp      (hl)                            ; be
  nop                                     ; 00
  dec     b                               ; 05
  ld      b,b                             ; 40
  rlca                                    ; 07
  cp      (hl)                            ; be
  inc     h                               ; 24
  dec     b                               ; 05
  ld      (hl),b                          ; 70
  inc     de                              ; 13
  cp      (hl)                            ; be
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      b,l                             ; 45
  rrca                                    ; 0f
  cp      (hl)                            ; be
  and     h                               ; a4
  ld      c,h                             ; 4c
  ld      b,l                             ; 45
  rst     0x10                            ; d7
  cp      a                               ; bf
  nop                                     ; 00
  inc     b                               ; 04
  ld      c,b                             ; 48
  inc     b                               ; 04
  cp      a                               ; bf
  add     a,b                             ; 80
  ld      c,h                             ; 4c
  ld      b,c                             ; 41
  jr      z,L54D3                         ; 28 c0
  nop                                     ; 00
  ld      c,a                             ; 4f
  nop                                     ; 00
  dec     b                               ; 05
  ret     nz                              ; c0
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,bc                           ; 09
  ld      c,b                             ; 48
  pop     bc                              ; c1
  nop                                     ; 00
  ld      c,b                             ; 48
  or      b                               ; b0
  ld      a,(bc)                          ; 0a
  pop     bc                              ; c1
  add     a,b                             ; 80
  ld      h,d                             ; 62
L5524:
  add     hl,bc                           ; 09
  ld      l,b                             ; 68
  jp      nz,0x1102                       ; c2 02 11
  dec     b                               ; 05
  adc     a,d                             ; 8a
  jp      nz,0x6280                       ; c2 80 62
  add     hl,bc                           ; 09
  adc     a,b                             ; 88
L5530:
  jp      0x1102                          ; c3 02 11
  ld      h,b                             ; 60
  ld      a,(bc)                          ; 0a
  jp      0x6280                          ; c3 80 62
  add     hl,bc                           ; 09
  xor     b                               ; a8
  call    nz,0x6f02                       ; c4 02 6f
  dec     b                               ; 05
  adc     a,c                             ; 89
  call    nz,0x6280                       ; c4 80 62
  add     hl,bc                           ; 09
  ret     z                               ; c8
  push    bc                              ; c5
  nop                                     ; 00
  sub     b                               ; 90
  or      b                               ; b0
  dec     bc                              ; 0b
  push    bc                              ; c5
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      a,(bc)                          ; 0a
  ex      af,af'                          ; 08
  add     a,0x01                          ; c6 01
  ld      e,0x4d                          ; 1e 4d
  add     a,a                             ; 87
  add     a,0x80                          ; c6 80
  ld      h,d                             ; 62
  dec     c                               ; 0d
  rrca                                    ; 0f
  add     a,0xa4                          ; c6 a4
  ld      h,d                             ; 62
  dec     c                               ; 0d
  rst     0x10                            ; d7
  rst     0x00                            ; c7
  ld      b,0x5d                          ; 06 5d
  ld      h,b                             ; 60
  dec     bc                              ; 0b
  rst     0x00                            ; c7
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,bc                           ; 09
  jr      z,L5530                         ; 28 c8
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  and     b                               ; a0
  dec     b                               ; 05
  ret     z                               ; c8
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      de,0xc948                       ; 11 48 c9
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  nop                                     ; 00
  dec     b                               ; 05
  ret                                     ; c9
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      de,0xca68                       ; 11 68 ca
  ld      (bc),a                          ; 02
  djnz    L5524                           ; 10 a5
  adc     a,d                             ; 8a
  jp      z,0x6280                        ; ca 80 62
  ld      de,0xcb88                       ; 11 88 cb
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      de,0xcca8                       ; 11 a8 cc
  ld      (bc),a                          ; 02
  ld      l,(hl)                          ; 6e
  and     l                               ; a5
  adc     a,c                             ; 89
  call    z,0x6280                        ; cc 80 62
  ld      de,0xcdc8                       ; 11 c8 cd
  ld      (bc),a                          ; 02
  ld      l,a                             ; 6f
  ld      h,b                             ; 60
  add     hl,bc                           ; 09
  call    0x6280                          ; cd 80 62
  ld      (de),a                          ; 12
  ex      af,af'                          ; 08
  adc     a,0x01                          ; ce 01
  inc     e                               ; 1c
  ld      c,l                             ; 4d
  add     a,a                             ; 87
  adc     a,0x80                          ; ce 80
  ld      h,d                             ; 62
  dec     d                               ; 15
  rrca                                    ; 0f
  adc     a,0xa4                          ; ce a4
  ld      h,d                             ; 62
  dec     d                               ; 15
  rst     0x10                            ; d7
  rst     0x08                            ; cf
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      de,0xd028                       ; 11 28 d0
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  ret     m                               ; f8
  dec     b                               ; 05
  ret     nc                              ; d0
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,de                           ; 19
  ld      c,b                             ; 48
  pop     de                              ; d1
  nop                                     ; 00
  ld      c,b                             ; 48
  cp      b                               ; b8
  ld      a,(bc)                          ; 0a
  pop     de                              ; d1
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,de                           ; 19
  ld      l,b                             ; 68
  jp      nc,0x1002                       ; d2 02 10
  defb    0xfd
  adc     a,d                             ; 8a
  jp      nc,0x6280                       ; d2 80 62
  add     hl,de                           ; 19
  adc     a,b                             ; 88
  out     (0x01),a                        ; d3 01
  ld      b,a                             ; 47
  ld      l,c                             ; 69
  dec     hl                              ; 2b
  out     (0x80),a                        ; d3 80
  ld      h,d                             ; 62
  add     hl,de                           ; 19
  xor     b                               ; a8
  call    nc,0x6e02                       ; d4 02 6e
  defb    0xfd
  adc     a,c                             ; 89
  call    nc,0x6280                       ; d4 80 62
  add     hl,de                           ; 19
  ret     z                               ; c8
  push    de                              ; d5
  nop                                     ; 00
  sub     b                               ; 90
  cp      b                               ; b8
  dec     bc                              ; 0b
  push    de                              ; d5
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      a,(de)                          ; 1a
  ex      af,af'                          ; 08
  sub     0x01                            ; d6 01
  ld      l,e                             ; 6b
  ld      h,b                             ; 60
  rlca                                    ; 07
  sub     0x80                            ; d6 80
  ld      h,d                             ; 62
  dec     e                               ; 1d
  rrca                                    ; 0f
  sub     0xa4                            ; d6 a4
  ld      h,d                             ; 62
  dec     e                               ; 1d
  rst     0x10                            ; d7
  rst     0x10                            ; d7
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,de                           ; 19
  defb    0x28, 0xd8
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  ld      e,b                             ; 58
  dec     b                               ; 05
  ret     c                               ; d8
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      hl,0xd948                       ; 21 48 d9
  nop                                     ; 00
  inc     (hl)                            ; 34
  nop                                     ; 00
  inc     b                               ; 04
  exx                                     ; d9
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      hl,0xda68                       ; 21 68 da
  ld      (bc),a                          ; 02
  defb    0x10, 0x5d
  adc     a,d                             ; 8a
  jp      c,0x6280                        ; da 80 62
  ld      hl,0xdb88                       ; 21 88 db
L5621:
  ld      bc,0x4d0e                       ; 01 0e 4d
  xor     e                               ; ab
  in      a,(0x80)                        ; db 80
  ld      h,d                             ; 62
  ld      hl,0xdca8                       ; 21 a8 dc
  ld      (bc),a                          ; 02
  ld      l,(hl)                          ; 6e
  ld      e,l                             ; 5d
  adc     a,c                             ; 89
  call    c,0x6280                        ; dc 80 62
  ld      hl,0xddc8                       ; 21 c8 dd
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      (0xde08),hl                     ; 22 08 de
  ld      bc,0x4d5e                       ; 01 5e 4d
  add     a,a                             ; 87
  sbc     a,0x80                          ; de 80
  ld      h,d                             ; 62
  dec     h                               ; 25
  rrca                                    ; 0f
  sbc     a,0xa4                          ; de a4
  ld      h,d                             ; 62
  dec     h                               ; 25
  rst     0x10                            ; d7
  rst     0x18                            ; df
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      hl,0xe028                       ; 21 28 e0
  nop                                     ; 00
  ld      c,a                             ; 4f
  djnz    L5657                           ; 10 05
  ret     po                              ; e0
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,hl                           ; 29
  ld      c,b                             ; 48
L5657:
  pop     hl                              ; e1
  nop                                     ; 00
  ld      c,b                             ; 48
  ret     nz                              ; c0
  ld      a,(bc)                          ; 0a
  pop     hl                              ; e1
  jr      nz,L56A7                        ; 20 48
  ret     c                               ; d8
  ld      c,0xe1                          ; 0e e1
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,hl                           ; 29
  ld      l,b                             ; 68
  jp      po,0x1102                       ; e2 02 11
  dec     d                               ; 15
  adc     a,d                             ; 8a
  jp      po,0x6280                       ; e2 80 62
  add     hl,hl                           ; 29
  adc     a,b                             ; 88
  ex      (sp),hl                         ; e3
  nop                                     ; 00
  dec     bc                              ; 0b
  ld      e,e                             ; 5b
  inc     de                              ; 13
  ex      (sp),hl                         ; e3
  jr      nz,L5683                        ; 20 0b
  ld      e,e                             ; 5b
  ld      (hl),a                          ; 77
  ex      (sp),hl                         ; e3
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,hl                           ; 29
  xor     b                               ; a8
  call    po,0x6f02                       ; e4 02 6f
  dec     d                               ; 15
L5683:
  adc     a,c                             ; 89
  call    po,0x6280                       ; e4 80 62
  add     hl,hl                           ; 29
  ret     z                               ; c8
  push    hl                              ; e5
  nop                                     ; 00
  sub     b                               ; 90
  ret     nz                              ; c0
  dec     bc                              ; 0b
  push    hl                              ; e5
  jr      nz,L5621                        ; 20 90
  ret     c                               ; d8
  rrca                                    ; 0f
  push    hl                              ; e5
  add     a,b                             ; 80
L5695:
  ld      h,d                             ; 62
  ld      hl,(0xe608)                     ; 2a 08 e6
  ld      bc,0x6021                       ; 01 21 60
  rlca                                    ; 07
  and     0x80                            ; e6 80
  ld      h,d                             ; 62
  dec     l                               ; 2d
  rrca                                    ; 0f
  and     0xa4                            ; e6 a4
  ld      h,d                             ; 62
  dec     l                               ; 2d
  rst     0x10                            ; d7
L56A7:
  rst     0x20                            ; e7
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,hl                           ; 29
  jr      z,L5695                         ; 28 e8
  nop                                     ; 00
  ld      c,a                             ; 4f
  ex      af,af'                          ; 08
  dec     b                               ; 05
  ret     pe                              ; e8
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      sp,0xe948                       ; 31 48 e9
  nop                                     ; 00
  ld      de,0x0440                       ; 11 40 04
  jp      (hl)                            ; e9
  defb    0x20, 0x11
  ld      c,b                             ; 48
  ex      af,af'                          ; 08
  jp      (hl)                            ; e9
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      sp,0xea68                       ; 31 68 ea
  ld      (bc),a                          ; 02
  ld      de,0x8a0d                       ; 11 0d 8a
  jp      pe,0x6280                       ; ea 80 62
  ld      sp,0xeb88                       ; 31 88 eb
  nop                                     ; 00
  ld      a,(bc)                          ; 0a
  cp      e                               ; bb
  inc     b                               ; 04
  ex      de,hl                           ; eb
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      sp,0xeca8                       ; 31 a8 ec
  ld      (bc),a                          ; 02
  ld      l,a                             ; 6f
  dec     c                               ; 0d
  adc     a,c                             ; 89
  call    pe,0x6280                       ; ec 80 62
  ld      sp,0xedc8                       ; 31 c8 ed
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      (0xee08),a                      ; 32 08 ee
  ld      bc,0x606d                       ; 01 6d 60
  rlca                                    ; 07
  xor     0x80                            ; ee 80
  ld      h,d                             ; 62
  dec     (hl)                            ; 35
  rrca                                    ; 0f
  xor     0xa4                            ; ee a4
  ld      h,d                             ; 62
  dec     (hl)                            ; 35
  rst     0x10                            ; d7
  rst     0x28                            ; ef
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      sp,0xf028                       ; 31 28 f0
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  sub     b                               ; 90
  dec     b                               ; 05
  ret     p                               ; f0
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,sp                           ; 39
  ld      c,b                             ; 48
  pop     af                              ; f1
  nop                                     ; 00
  ld      c,b                             ; 48
  xor     b                               ; a8
  ld      a,(bc)                          ; 0a
  pop     af                              ; f1
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,sp                           ; 39
  ld      l,b                             ; 68
  jp      p,0x1002                        ; f2 02 10
  sub     l                               ; 95
  adc     a,d                             ; 8a
  jp      p,0x6280                        ; f2 80 62
  add     hl,sp                           ; 39
  adc     a,b                             ; 88
  di                                      ; f3
  nop                                     ; 00
  ld      b,0x00                          ; 06 00
  inc     b                               ; 04
  di                                      ; f3
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,sp                           ; 39
  xor     b                               ; a8
  call    p,0x6e02                        ; f4 02 6e
  sub     l                               ; 95
  adc     a,c                             ; 89
  call    p,0x6280                        ; f4 80 62
  add     hl,sp                           ; 39
  ret     z                               ; c8
  push    af                              ; f5
  nop                                     ; 00
  sub     b                               ; 90
  xor     b                               ; a8
  dec     bc                              ; 0b
  push    af                              ; f5
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      a,(0xf608)                      ; 3a 08 f6
  ld      bc,0x6017                       ; 01 17 60
  rlca                                    ; 07
  or      0x80                            ; f6 80
  ld      h,d                             ; 62
  dec     a                               ; 3d
  rrca                                    ; 0f
  or      0xa4                            ; f6 a4
  ld      h,d                             ; 62
L5745:
  dec     a                               ; 3d
  rst     0x10                            ; d7
  rst     0x30                            ; f7
  add     a,b                             ; 80
  ld      h,d                             ; 62
  add     hl,sp                           ; 39
  jr      z,L5745                         ; 28 f8
  nop                                     ; 00
  ld      c,(hl)                          ; 4e
  adc     a,b                             ; 88
  dec     b                               ; 05
  ret     m                               ; f8
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      b,c                             ; 41
  ld      c,b                             ; 48
  ld      sp,hl                           ; f9
  nop                                     ; 00
  dec     d                               ; 15
  dec     de                              ; 1b
  ld      b,0xf9                          ; 06 f9
  jr      nz,L5773                        ; 20 15
  dec     de                              ; 1b
  ld      l,d                             ; 6a
  ld      sp,hl                           ; f9
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      b,c                             ; 41
  ld      l,b                             ; 68
  jp      m,0x1002                        ; fa 02 10
  adc     a,l                             ; 8d
  adc     a,d                             ; 8a
  jp      m,0x6280                        ; fa 80 62
  ld      b,c                             ; 41
  adc     a,b                             ; 88
  ei                                      ; fb
  nop                                     ; 00
  ex      af,af'                          ; 08
  nop                                     ; 00
L5773:
  inc     b                               ; 04
  ei                                      ; fb
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      b,c                             ; 41
  xor     b                               ; a8
  call    m,0x6e02                        ; fc 02 6e
  adc     a,l                             ; 8d
  adc     a,c                             ; 89
  call    m,0x6280                        ; fc 80 62
  ld      b,c                             ; 41
  ret     z                               ; c8
  defb    0xfd
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      b,d                             ; 42
  ex      af,af'                          ; 08
  cp      0x01                            ; fe 01
  dec     b                               ; 05
  ld      h,b                             ; 60
  rlca                                    ; 07
  cp      0x80                            ; fe 80
  ld      h,d                             ; 62
  ld      b,l                             ; 45
  rrca                                    ; 0f
  cp      0xa4                            ; fe a4
  ld      h,d                             ; 62
  ld      b,l                             ; 45
  rst     0x10                            ; d7
  rst     0x38                            ; ff
  add     a,b                             ; 80
  ld      h,d                             ; 62
  ld      b,c                             ; 41
  defb    0x28, 0xff
  rst     0x38                            ; ff
  rst     0x38                            ; ff
  rst     0x38                            ; ff
  rst     0x38                            ; ff
  call    p,0x3223                        ; f4 23 32
  ld      c,0x00                          ; 0e 00
  nop                                     ; 00
  rst     0x30                            ; f7
  nop                                     ; 00
  nop                                     ; 00
  inc     l                               ; 2c
  scf                                     ; 37
  ld      c,0x00                          ; 0e 00
  nop                                     ; 00
  ld      c,a                             ; 4f
  nop                                     ; 00
  nop                                     ; 00
  ld      a,(0xfb3f)                      ; 3a 3f fb
  ld      a,(0x3acf)                      ; 3a cf 3a
  jp      p,0xa7c3                        ; f2 c3 a7
  ld      a,(0xd13f)                      ; 3a 3f d1
  ld      (0x3a00),hl                     ; 22 00 3a
  ld      (0x3f3a),hl                     ; 22 3a 3f
  ld      de,0xf3d6                       ; 11 d6 f3
  ld      hl,(0x5c5d)                     ; 2a 5d 5c
  ld      iy,0x5c3a                       ; fd 21 3a 5c
  push    hl                              ; e5
  ld      (0xf428),sp                     ; ed 73 28 f4
  ld      sp,(0x5c3d)                     ; ed 7b 3d 5c
  ld      hl,0xf41d                       ; 21 1d f4
  ex      (sp),hl                         ; e3
  ld      (0xf420),hl                     ; 22 20 f4
  im      1                               ; ed 56
  ei                                      ; fb
  ld      a,0x01                          ; 3e 01
  ex      de,hl                           ; eb
  jp      0x1bd5                          ; c3 d5 1b
  dec     sp                              ; 3b
  dec     sp                              ; 3b
  ld      hl,0x0000                       ; 21 00 00
  ex      (sp),hl                         ; e3
  ld      hl,0x1b76                       ; 21 76 1b
  push    hl                              ; e5
  ld      sp,0x0000                       ; 31 00 00
  pop     hl                              ; e1
  ld      (0x5c5d),hl                     ; 22 5d 5c
  jr      L5803                           ; 18 09
  ld      de,0x0000                       ; 11 00 00
  ld      hl,(0x5c3d)                     ; 2a 3d 5c
  ld      (hl),e                          ; 73
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
L5803:
  ld      (iy+0),0xff                     ; fd 36 00 ff
  di                                      ; f3
  ret                                     ; c9
  ld      hl,(0x5c3d)                     ; 2a 3d 5c
  push    de                              ; d5
  ld      e,(hl)                          ; 5e
  inc     hl                              ; 23
  ld      d,(hl)                          ; 56
  ld      (0xf431),de                     ; ed 53 31 f4
  ld      (hl),b                          ; 70
  dec     hl                              ; 2b
  ld      (hl),c                          ; 71
  pop     de                              ; d1
  ret                                     ; c9
  ld      de,0xf3f2                       ; 11 f2 f3
  call    0xf3fd                          ; cd fd f3
  jp      0xd440                          ; c3 40 d4
L5822:
  ld      de,0xf3e9                       ; 11 e9 f3
  call    0xf3fd                          ; cd fd f3
  jp      0xabe0                          ; c3 e0 ab
  ld      a,(0xcd7b)                      ; 3a 7b cd
  cp      0x21                            ; fe 21
  jr      z,L5822                         ; 28 f0
  call    0xe1f3                          ; cd f3 e1
  call    0xf493                          ; cd 93 f4
  ld      a,0x14                          ; 3e 14
  jp      nz,0xd813                       ; c2 13 d8
  ld      (0x3e72),hl                     ; 22 72 3e
  push    ix                              ; dd e5
  push    hl                              ; e5
  pop     ix                              ; dd e1
  call    0xcec7                          ; cd c7 ce
  ld      (0xf520),ix                     ; dd 22 20 f5
  pop     ix                              ; dd e1
  call    0xf4e8                          ; cd e8 f4
  call    0x02e1                          ; cd e1 02
  call    0xf430                          ; cd 30 f4
  call    0xd3f8                          ; cd f8 d3
  jp      0xcec2                          ; c3 c2 ce
  ld      hl,0xcd84                       ; 21 84 cd
  ld      bc,0xf4ce                       ; 01 ce f4
  push    hl                              ; e5
  call    0xf43f                          ; cd 3f f4
  call    0xf3fa                          ; cd fa f3
  rst     0x00                            ; c7
  call    0x1c8f                          ; cd 8f 1c
  pop     hl                              ; e1
  ld      de,0x3e94                       ; 11 94 3e
  ld      a,0x42                          ; 3e 42
  ld      (de),a                          ; 12
  dec     de                              ; 1b
  ld      bc,0x0900                       ; 01 00 09
L5879:
  ld      a,(hl)                          ; 7e
  dec     hl                              ; 2b
  cp      0x20                            ; fe 20
  jr      nz,L5880                        ; 20 01
  ld      a,c                             ; 79
L5880:
  ld      (de),a                          ; 12
  cp      0x20                            ; fe 20
  jr      z,L588A                         ; 28 05
  or      a                               ; b7
  jr      z,L588A                         ; 28 02
  ld      c,0x20                          ; 0e 20
L588A:
  dec     de                              ; 1b
  djnz    L5879                           ; 10 ec
  ld      a,(hl)                          ; 7e
  ld      (de),a                          ; 12
  call    0x212b                          ; cd 2b 21
  push    hl                              ; e5
  call    0xf430                          ; cd 30 f4
  pop     hl                              ; e1
  ret                                     ; c9
  ld      sp,0xad04                       ; 31 04 ad
  call    0xf430                          ; cd 30 f4
  call    0xf4df                          ; cd df f4
  call    0xd3f8                          ; cd f8 d3
  ld      a,0x16                          ; 3e 16
  jp      0xd813                          ; c3 13 d8
  ld      a,(0x0000)                      ; 3a 00 00
  cp      0xf3                            ; fe f3
  ret     z                               ; c8
  jp      0x02e1                          ; c3 e1 02
  push    de                              ; d5
  ld      bc,0xf4ce                       ; 01 ce f4
  call    0xf43f                          ; cd 3f f4
  ld      hl,(0x3e72)                     ; 2a 72 3e
  ld      a,0x11                          ; 3e 11
  call    0x0fad                          ; cd ad 0f
  ld      a,(hl)                          ; 7e
  inc     hl                              ; 23
  ld      h,(hl)                          ; 66
  ld      l,a                             ; 6f
L58C5:
  push    hl                              ; e5
  call    0x1df9                          ; cd f9 1d
  pop     hl                              ; e1
  push    bc                              ; c5
  call    0x1cf1                          ; cd f1 1c
  ex      de,hl                           ; eb
  ld      de,0x0101                       ; 11 01 01
  pop     bc                              ; c1
  ex      (sp),hl                         ; e3
  push    hl                              ; e5
  ld      hl,0x3a00                       ; 21 00 3a
  push    hl                              ; e5
  call    0x22a2                          ; cd a2 22
  pop     de                              ; d1
  pop     hl                              ; e1
  ld      a,h                             ; 7c
  ld      bc,0x0200                       ; 01 00 02
  cp      b                               ; b8
  jr      nc,L58E7                        ; 30 02
  ld      b,h                             ; 44
  ld      c,l                             ; 4d
L58E7:
  push    hl                              ; e5
  push    bc                              ; c5
  ld      hl,0x0000                       ; 21 00 00
  ex      de,hl                           ; eb
  call    0xe2cd                          ; cd cd e2
  ex      de,hl                           ; eb
  ld      (0xf520),hl                     ; 22 20 f5
  pop     bc                              ; c1
  pop     hl                              ; e1
  sbc     hl,bc                           ; ed 42
  ex      (sp),hl                         ; e3
  jr      nz,L58C5                        ; 20 ca
  call    0x217b                          ; cd 7b 21
  pop     hl                              ; e1
  ret                                     ; c9
  push    hl                              ; e5
  ld      a,0x15                          ; 3e 15
  rst     0x28                            ; ef
  push    af                              ; f5
  pop     hl                              ; e1
  rst     0x28                            ; ef
  inc     bc                              ; 03
  sbc     a,0xcb                          ; de cb
  rst     0x28                            ; ef
  pop     hl                              ; e1
  cp      0x70                            ; fe 70
  jr      z,L5917                         ; 28 07
  cp      0x72                            ; fe 72
  jr      z,L5917                         ; 28 03
  cp      0x79                            ; fe 79
  ret     nz                              ; c0
L5917:
  call    0x1f88                          ; cd 88 1f
  xor     a                               ; af
  ret                                     ; c9
  call    0xf493                          ; cd 93 f4
  jr      nz,L5927                        ; 20 06
  call    0xf536                          ; cd 36 f5
  jp      nz,0xf5ec                       ; c2 ec f5
L5927:
  ld      bc,0xf4ce                       ; 01 ce f4
  call    0xf43f                          ; cd 3f f4
  push    ix                              ; dd e5
  rst     0x28                            ; ef
  di                                      ; f3
  pop     hl                              ; e1
  pop     ix                              ; dd e1
  call    0x202c                          ; cd 2c 20
  ex      de,hl                           ; eb
  ld      hl,0xac8d                       ; 21 8d ac
  ld      bc,0x0006                       ; 01 06 00
  ldir                                    ; ed b0
  ex      de,hl                           ; eb
  push    hl                              ; e5
  inc     hl                              ; 23
  inc     hl                              ; 23
  xor     a                               ; af
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (hl),0x0f                       ; 36 0f
  inc     hl                              ; 23
  ld      (hl),a                          ; 77
  ld      de,(0xac8d)                     ; ed 5b 8d ac
  call    0x201e                          ; cd 1e 20
  or      b                               ; b0
  ld      a,d                             ; 7a
  jr      nz,L5961                        ; 20 0b
  ld      a,0x0c                          ; 3e 0c
  inc     b                               ; 04
  jr      L5963                           ; 18 08
L595B:
  call    0x217b                          ; cd 7b 21
  jp      0xf4ce                          ; c3 ce f4
L5961:
  or      0x0e                            ; f6 0e
L5963:
  ld      d,a                             ; 57
  call    0x210a                          ; cd 0a 21
  jr      z,L5971                         ; 28 08
  ld      hl,0x0000                       ; 21 00 00
  call    0x20f6                          ; cd f6 20
  jr      nz,L595B                        ; 20 ea
L5971:
  ex      de,hl                           ; eb
  ex      (sp),hl                         ; e3
  ld      (hl),e                          ; 73
  inc     hl                              ; 23
  ld      (hl),d                          ; 72
  call    0x1e65                          ; cd 65 1e
  ex      de,hl                           ; eb
  pop     de                              ; d1
  push    hl                              ; e5
  call    0x20db                          ; cd db 20
  inc     b                               ; 04
  dec     b                               ; 05
  jr      nz,L595B                        ; 20 d8
  call    0xf629                          ; cd 29 f6
  pop     hl                              ; e1
  ld      (0xf637),hl                     ; 22 37 f6
  ld      hl,(0xcd91)                     ; 2a 91 cd
  ld      bc,(0xcd94)                     ; ed 4b 94 cd
  call    0xf5f5                          ; cd f5 f5
  ld      a,e                             ; 7b
  call    0xf608                          ; cd 08 f6
  ld      a,0xff                          ; 3e ff
  call    0xf608                          ; cd 08 f6
  ld      hl,(0xdfa6)                     ; 2a a6 df
  ld      bc,(0xafcd)                     ; ed 4b cd af
  dec     bc                              ; 0b
  call    0xf5f5                          ; cd f5 f5
  ld      hl,(0xf612)                     ; 2a 12 f6
  ld      a,h                             ; 7c
  or      l                               ; b5
  call    nz,0xf636                       ; c4 36 f6
  call    0x217b                          ; cd 7b 21
  call    0xf430                          ; cd 30 f4
  call    0x02e1                          ; cd e1 02
  call    0xd3f8                          ; cd f8 d3
  jp      0xd440                          ; c3 40 d4
  ld      e,0xff                          ; 1e ff
L59C1:
  call    0xade9                          ; cd e9 ad
  inc     hl                              ; 23
  ld      d,a                             ; 57
  xor     e                               ; ab
  ld      e,a                             ; 5f
  ld      a,d                             ; 7a
  call    0xf608                          ; cd 08 f6
  dec     bc                              ; 0b
  ld      a,b                             ; 78
  or      c                               ; b1
  jr      nz,L59C1                        ; 20 f0
  ret                                     ; c9
  push    hl                              ; e5
  ld      hl,0x0000                       ; 21 00 00
  ld      (hl),a                          ; 77
  inc     hl                              ; 23
  ld      (0xf60a),hl                     ; 22 0a f6
  ld      hl,0x0000                       ; 21 00 00
  inc     hl                              ; 23
  ld      (0xf612),hl                     ; 22 12 f6
  ld      a,h                             ; 7c
  cp      0x02                            ; fe 02
  jr      c,L59F1                         ; 38 0a
  push    de                              ; d5
  push    bc                              ; c5
  call    0xf636                          ; cd 36 f6
  call    0xf629                          ; cd 29 f6
  pop     bc                              ; c1
  pop     de                              ; d1
L59F1:
  pop     hl                              ; e1
  ret                                     ; c9
  ld      hl,0x3a00                       ; 21 00 3a
  ld      (0xf60a),hl                     ; 22 0a f6
  ld      hl,0x0000                       ; 21 00 00
  ld      (0xf612),hl                     ; 22 12 f6
  ret                                     ; c9
  ld      hl,0x0000                       ; 21 00 00
  push    hl                              ; e5
  call    0x1df9                          ; cd f9 1d
  pop     hl                              ; e1
  push    bc                              ; c5
  call    0x1cf1                          ; cd f1 1c
  ld      (0xf637),de                     ; ed 53 37 f6
  ld      de,0x0100                       ; 11 00 01
  pop     bc                              ; c1
  ld      hl,0x3a00                       ; 21 00 3a
  ld      a,(0x3e6b)                      ; 3a 6b 3e
  jp      0x2296                          ; c3 96 22
  ld      hl,0xac1a                       ; 21 1a ac
  ld      bc,0xb080                       ; 01 80 b0
  call    0xf499                          ; cd 99 f4
  call    0xb6c7                          ; cd c7 b6
  ld      (0x3e78),hl                     ; 22 78 3e
  ld      (0x3e74),hl                     ; 22 74 3e
  ld      bc,0xb080                       ; 01 80 b0
  call    0xf43f                          ; cd 3f f4
  call    0xb070                          ; cd 70 b0
L5A38:
  call    0xf430                          ; cd 30 f4
  jp      0x02e1                          ; c3 e1 02
  ld      de,0xac11                       ; 11 11 ac
  inc     hl                              ; 23
  call    0xcd5f                          ; cd 5f cd
  ld      hl,0xac1a                       ; 21 1a ac
  ld      bc,0xb080                       ; 01 80 b0
  call    0xf499                          ; cd 99 f4
  jp      nz,0xb086                       ; c2 86 b0
  ld      (0x3e72),hl                     ; 22 72 3e
  ld      bc,0xb080                       ; 01 80 b0
  call    0xf43f                          ; cd 3f f4
  call    0xb6c7                          ; cd c7 b6
  call    0xb078                          ; cd 78 b0
  jr      L5A38                           ; 18 d6



; 00005dc0  f3 cd 52 00 3b 3b e1 e5  01 13 00 09 01 cd 01 11  |..R.;;..........|
; 00005dd0  17 40 ed b0 c3 17 40 01  c6 0d d5 ed b0 af 12 13  |.@....@.........|
; 00005de0  12 11 00 58 06 00 3e 3f  12 13 12 13 10 f8 3e 38  |...X..>?......>8|
; 00005df0  12 13 10 fa 11 00 50 af  12 13 7a fe 58 38 f8 dd  |......P...z.X8..|
; 00005e00  e1 d1 1b 1b 1b 1b e5 dd  e5 eb 01 d0 40 11 10 27  |............@..'|
; 00005e10  cd 26 41 11 e8 03 cd 26  41 11 64 00 cd 26 41 1e  |.&A....&A.d..&A.|
; 00005e20  0a cd 26 41 1e 01 cd 26  41 21 41 50 22 bc 41 cd  |..&A...&A!AP".A.|
; 00005e30  a9 41 50 52 4f 4d 45 54  48 45 55 53 20 31 32 38  |.APROMETHEUS 128|
; 00005e40  20 64 69 73 6b 20 76 65  72 73 69 6f 6e 20 cc 21  | disk version .!|
; 00005e50  81 50 22 bc 41 cd a9 41  7f 20 31 39 39 33 20 50  |.P".A..A. 1993 P|
; 00005e60  52 4f 58 49 4d 41 20 73  6f 66 74 77 61 72 65 20  |ROXIMA software |
; 00005e70  76 2e 6f 2e f3 ed 56 fb  fd cb 01 ae 21 c8 50 22  |v.o...V.....!.P"|
; 00005e80  bc 41 cd a9 41 41 64 64  72 65 73 73 ba cd a9 41  |.A..AAddress...A|
; 00005e90  30 30 30 30 30 5f a0 76  fd cb 01 6e 28 f9 21 c8  |00000_.v...n(.!.|
; 00005ea0  00 1e 02 54 cd b5 03 3a  08 5c fd cb 01 ae fe 0c  |...T...:.\......|
; 00005eb0  20 16 2a 15 41 01 d0 40  b7 ed 42 09 28 d9 36 20  | .*.A..@..B.(.6 |
; 00005ec0  2b 36 5f 22 15 41 18 b4  fe 0d 28 26 fe 30 38 c7  |+6_".A....(&.08.|
; 00005ed0  fe 3a 30 c3 21 d5 40 23  cb 7e 2b 20 ba 77 23 36  |.:0.!.@#.~+ .w#6|
; 00005ee0  5f 22 15 41 18 96 3e 2f  b7 3c ed 52 30 fa 19 02  |_".A..>/.<.R0...|
; 00005ef0  03 c9 01 d0 40 3e 04 d3  fe 21 00 00 0a 03 fe 5f  |....@>...!....._|
; 00005f00  28 0e 29 e5 29 29 d1 19  d6 30 5f 16 00 19 18 ec  |(.).))...0_.....|
; 00005f10  eb dd e1 e1 01 b8 4a d5  cd ce 41 e1 e5 11 e0 ab  |......J...A.....|
; 00005f20  b7 e5 ed 52 4d 44 d1 af  32 96 41 dd 6e 00 dd 66  |...RMD..2.A.n..f|
; 00005f30  01 dd 23 dd 23 7c b5 c8  7c e6 c0 cb bc cb b4 19  |..#.#|..|.......|
; 00005f40  e5 5e 23 56 eb b7 28 15  fe 40 28 09 7d 81 6f 3e  |.^#V..(..@(.}.o>|
; 00005f50  00 ce 00 18 0a 3e 00 85  80 6f af 18 02 09 af 32  |.....>...o.....2|
; 00005f60  96 41 eb 72 2b 73 d1 18  c2 e1 7e cd b4 41 cb 7e  |.A.r+s....~..A.~|
; 00005f70  23 28 f7 e9 87 d9 6f 26  0f 29 29 11 00 00 d5 06  |#(....o&.)).....|
; 00005f80  08 7e 12 23 14 10 fa e1  2c 22 bc 41 d9 c9 78 b1  |.~.#....,".A..x.|
; 00005f90  c8 e5 af ed 52 e1 38 03  ed b0 c9 09 2b eb 09 2b  |....R.8.....+..+|
; 00005fa0  eb ed b8 c9 01 00 04 00  03 00 03 00 06 00 03 00  |................|
; 00005fb0  03 00 03 00 0b 00 03 00  04 00 05 00 03 00 05 00  |................|
; 00005fc0  03 00 e9 00 04 00 16 00  05 00 59 00 07 00 05 00  |..........Y.....|
; 00005fd0  4e 00 04 00 0c 00 88 00  14 00 5f 00 37 00 19 00  |N........._.7...|
; 00005fe0  06 00 07 00 05 00 0f 00  03 00 41 00 16 00 11 00  |..........A.....|
; 00005ff0  36 00 24 00 13 00 06 00  0d 00 12 00 09 00 07 00  |6.$.............|
; 00006000  0e 00 03 00 08 00 08 00  03 00 03 00 03 00 03 00  |................|
; 00006010  03 00 10 00 09 00 25 00  04 00 03 00 03 00 19 00  |......%.........|
; 00006020  03 00 04 00 03 00 0e 00  12 00 03 00 0e 00 24 00  |..............$.|
; 00006030  05 00 03 00 0b 00 04 00  06 00 0d 00 11 00 11 00  |................|
; 00006040  03 00 0b 00 04 00 05 00  1d 00 04 00 04 00 08 00  |................|
; 00006050  09 00 03 00 08 00 11 00  08 00 04 00 07 00 04 00  |................|
; 00006060  04 00 03 00 03 00 03 00  03 00 04 00 05 00 04 00  |................|
; 00006070  03 00 03 00 2b 00 07 00  07 00 07 00 07 00 07 00  |....+...........|
; 00006080  07 00 07 00 07 00 07 00  07 00 07 00 07 00 07 00  |................|
; 00006090  07 00 07 00 07 00 07 00  07 00 07 00 07 00 07 00  |................|
; 000060a0  07 00 07 00 07 00 07 00  07 00 07 00 07 00 07 00  |................|
; 000060b0  ce 00 0a 00 07 00 03 00  03 00 03 00 03 00 09 00  |................|
; 000060c0  0e 00 0a 00 0b 00 05 00  03 00 03 00 03 00 03 00  |................|
; 000060d0  03 00 03 00 03 00 03 00  03 00 04 00 03 00 03 00  |................|
; 000060e0  03 00 03 00 07 00 05 00  05 00 05 00 05 00 05 00  |................|
; 000060f0  06 00 03 00 05 00 0b 00  04 00 04 00 08 00 04 00  |................|
; 00006100  08 00 09 00 08 00 08 00  0c 00 08 00 03 00 0d 00  |................|
; 00006110  05 00 08 00 05 00 04 00  03 00 03 00 06 00 08 00  |................|
; 00006120  59 00 08 00 03 00 0d 00  03 00 04 00 04 00 06 00  |Y...............|
; 00006130  03 00 03 00 03 00 03 00  03 00 06 00 03 00 03 00  |................|
; 00006140  05 00 03 00 03 00 03 00  03 00 03 00 03 00 03 00  |................|
; 00006150  05 00 05 00 0a 00 03 00  0d 00 05 00 03 00 03 00  |................|
; 00006160  03 00 05 00 03 00 03 00  11 00 05 00 0e 00 03 00  |................|
; 00006170  11 00 04 00 03 00 03 00  03 00 11 00 05 00 05 00  |................|
; 00006180  05 00 09 00 07 00 04 00  0c 00 03 00 03 00 03 00  |................|
; 00006190  03 00 05 00 03 00 11 00  05 00 03 00 03 00 06 00  |................|
; 000061a0  03 00 04 00 04 00 03 00  04 00 11 00 05 00 05 00  |................|
; 000061b0  03 00 03 00 1c 00 04 00  03 00 04 00 03 00 03 00  |................|
; 000061c0  03 00 03 00 0a 00 09 00  03 00 0d 00 03 00 03 00  |................|
; 000061d0  03 00 03 00 04 00 03 00  06 00 03 00 05 00 09 00  |................|
; 000061e0  03 00 03 00 09 00 03 00  05 00 03 00 04 00 03 00  |................|
; 000061f0  05 00 03 00 08 00 03 00  03 00 07 00 07 00 03 00  |................|
; 00006200  03 00 05 00 03 00 04 00  03 00 03 00 05 00 03 00  |................|
; 00006210  03 00 05 00 03 00 06 00  03 00 04 00 05 00 05 00  |................|
; 00006220  0d 00 07 00 09 00 03 00  03 00 05 00 05 00 0d 00  |................|
; 00006230  0c 00 03 00 05 00 03 00  03 00 11 00 03 00 04 00  |................|
; 00006240  04 00 04 00 0d 00 06 00  0d 00 05 00 0d 00 05 00  |................|
; 00006250  05 00 04 00 04 00 04 00  0a 00 05 00 05 00 16 00  |................|
; 00006260  04 00 0d 00 05 00 0f 00  05 00 05 00 0c 00 0d 00  |................|
; 00006270  05 00 06 00 0e 00 03 00  03 00 04 00 04 00 04 00  |................|
; 00006280  17 00 0c 00 0c 00 03 00  08 00 10 00 05 00 1b 00  |................|
; 00006290  02 00 02 00 02 00 02 00  02 00 20 00 10 00 05 00  |.......... .....|
; 000062a0  06 00 03 00 03 00 04 00  06 00 03 00 06 00 03 00  |................|
; 000062b0  03 00 0a 00 03 00 0b 00  0a 00 0e 00 03 00 06 00  |................|
; 000062c0  17 00 12 00 21 00 1f 00  03 00 03 00 04 00 03 00  |....!...........|
; 000062d0  06 00 03 00 06 00 03 00  05 00 0e 00 0e 00 04 00  |................|
; 000062e0  03 00 06 00 0d 00 0a 00  04 00 13 00 07 00 08 00  |................|
; 000062f0  03 00 03 00 05 00 04 00  04 00 0c 00 03 00 03 00  |................|
; 00006300  03 00 03 00 03 00 03 00  09 00 07 00 08 00 05 00  |................|
; 00006310  03 00 03 00 05 00 08 00  05 00 0d 00 03 00 03 00  |................|
; 00006320  06 00 03 00 07 00 05 00  03 00 03 00 03 00 03 00  |................|
; 00006330  03 00 03 00 04 00 04 00  03 00 03 00 04 00 04 00  |................|
; 00006340  03 00 03 00 06 00 04 00  03 00 05 00 03 00 04 00  |................|
; 00006350  03 00 03 00 03 00 03 00  03 00 04 00 03 00 03 00  |................|
; 00006360  09 00 03 00 04 00 05 00  05 00 04 00 03 00 04 00  |................|
; 00006370  08 00 04 00 05 00 05 00  05 00 05 00 0c 00 04 00  |................|
; 00006380  07 00 14 00 04 00 03 00  17 00 04 00 03 00 03 00  |................|
; 00006390  04 00 04 00 03 00 05 00  04 00 0d 00 05 00 05 00  |................|
; 000063a0  10 00 05 00 05 00 05 00  04 00 04 00 03 00 04 00  |................|
; 000063b0  03 00 04 00 05 00 0e 00  03 00 11 00 07 00 11 00  |................|
; 000063c0  04 00 03 00 27 00 08 00  03 00 05 00 03 00 03 00  |....'...........|
; 000063d0  05 00 03 00 06 00 04 00  03 00 03 00 03 00 04 00  |................|
; 000063e0  03 00 06 00 03 00 04 00  03 00 03 00 08 00 04 00  |................|
; 000063f0  06 00 03 00 25 00 03 00  04 00 03 00 03 00 0b 00  |....%...........|
; 00006400  04 00 04 00 04 00 05 00  0c 00 04 00 0b 00 05 00  |................|
; 00006410  0a 00 06 00 13 00 08 00  04 00 04 00 03 00 05 00  |................|
; 00006420  03 00 06 00 08 00 0f 00  05 00 1a 00 05 00 07 00  |................|
; 00006430  20 00 05 00 09 00 07 00  06 00 05 00 03 00 09 00  | ...............|
; 00006440  07 00 07 00 05 00 03 00  04 00 04 00 03 00 06 00  |................|
; 00006450  05 00 08 00 0b 00 11 00  10 00 0c 00 1a 00 0a 00  |................|
; 00006460  05 00 0e 00 06 00 05 00  23 00 04 00 08 00 04 00  |........#.......|
; 00006470  0e 00 03 00 10 00 05 00  0b 00 06 00 03 00 36 00  |..............6.|
; 00006480  03 00 03 00 2e 00 04 00  33 00 06 00 03 00 15 00  |........3.......|
; 00006490  03 00 04 00 07 00 05 00  09 00 03 00 06 00 07 00  |................|
; 000064a0  03 00 09 00 17 00 2a 00  08 00 03 00 05 00 03 00  |......*.........|
; 000064b0  07 00 1d 00 1a 00 0d 00  07 00 2d 00 2a 00 04 00  |..........-.*...|
; 000064c0  08 00 05 00 04 00 0e 00  05 00 05 00 0c 00 03 00  |................|
; 000064d0  21 00 05 00 09 00 03 00  08 00 05 00 11 00 14 00  |!...............|
; 000064e0  0d 00 15 00 03 00 04 00  0a 00 16 00 0d 00 03 00  |................|
; 000064f0  09 00 09 00 03 00 0f 00  15 00 04 00 05 00 03 00  |................|
; 00006500  04 00 03 00 04 00 05 00  11 00 06 00 1f 00 05 00  |................|
; 00006510  05 00 03 00 05 00 03 00  05 00 09 00 05 00 03 00  |................|
; 00006520  03 00 06 00 06 00 07 00  07 00 07 00 08 00 0c 00  |................|
; 00006530  07 00 05 00 10 00 05 00  0a 00 06 00 03 00 06 00  |................|
; 00006540  07 00 a8 01 02 00 02 00  02 00 02 00 02 00 02 00  |................|
; 00006550  02 00 02 00 02 00 02 00  02 00 02 00 06 00 02 00  |................|
; 00006560  02 00 02 00 02 00 02 00  02 00 02 00 02 00 02 00  |................|
; 00006570  02 00 03 00 04 00 04 00  09 00 05 00 06 00 04 00  |................|
; 00006580  05 00 04 00 08 00 06 00  03 00 05 00 05 00 04 00  |................|
; 00006590  03 00 03 00 03 00 07 00  03 00 03 00 03 00 03 00  |................|
; 000065a0  03 00 03 00 03 00 03 00  03 00 03 00 07 00 03 00  |................|
; 000065b0  03 00 03 00 05 00 03 00  03 00 0b 00 03 00 05 00  |................|
; 000065c0  03 00 03 00 03 00 04 00  04 00 05 00 03 00 03 00  |................|
; 000065d0  03 00 03 00 05 00 06 00  07 00 03 00 04 00 03 00  |................|
; 000065e0  05 00 08 00 03 00 04 00  03 00 06 00 0a 00 05 00  |................|
; 000065f0  03 00 07 00 07 00 05 00  05 00 0a 00 05 00 06 00  |................|
; 00006600  03 00 07 00 05 00 05 00  05 00 07 00 05 00 08 00  |................|
; 00006610  08 00 09 00 03 00 03 00  05 00 06 00 0b 00 03 00  |................|
; 00006620  03 00 04 00 04 00 03 00  03 00 03 00 0c 00 06 00  |................|
; 00006630  06 00 06 00 04 00 09 00  07 00 07 00 09 00 03 00  |................|
; 00006640  03 00 03 00 03 00 03 00  03 00 03 00 03 00 05 00  |................|
; 00006650  07 00 06 00 03 00 03 00  07 00 0b 00 03 00 03 00  |................|
; 00006660  03 00 03 00 03 00 06 00  03 00 06 00 03 00 0c 00  |................|
; 00006670  05 00 03 00 03 00 0a 00  12 00 08 00 03 00 05 00  |................|
; 00006680  03 00 05 00 0c 00 08 00  03 00 03 00 03 00 03 00  |................|
; 00006690  07 00 06 00 05 00 03 00  03 00 03 00 04 00 04 00  |................|
; 000066a0  09 00 49 00 09 00 0b 00  0c 00 05 00 06 00 16 00  |..I.............|
; 000066b0  03 00 05 00 05 00 07 00  0f 00 0f 00 0c 00 03 00  |................|
; 000066c0  03 00 06 00 0b 00 04 00  03 00 05 00 08 00 09 00  |................|
; 000066d0  03 00 06 00 07 00 08 00  03 00 21 00 05 00 03 00  |..........!.....|
; 000066e0  07 00 0d 00 0c 00 05 00  04 00 05 00 08 00 07 00  |................|
; 000066f0  09 00 03 00 06 00 03 00  07 00 05 00 09 00 07 00  |................|
; 00006700  03 00 04 00 03 00 03 00  03 00 03 00 03 00 03 00  |................|
; 00006710  03 00 03 00 07 00 0a 00  06 00 05 00 06 00 05 00  |................|
; 00006720  06 00 0a 00 04 00 03 00  05 00 14 00 08 00 08 00  |................|
; 00006730  03 00 03 00 03 00 09 00  06 00 03 00 03 00 03 00  |................|
; 00006740  07 00 03 00 05 00 0b 00  0e 00 07 00 04 00 0a 00  |................|
; 00006750  03 00 07 00 11 00 0a 00  05 00 0a 00 0a 00 05 00  |................|
; 00006760  09 00 05 00 0c 00 0d 00  0a 00 03 00 03 00 03 00  |................|
; 00006770  07 00 07 00 06 00 09 00  08 00 0b 00 05 00 03 00  |................|
; 00006780  03 00 0b 00 08 00 05 00  04 00 05 00 07 00 03 00  |................|
; 00006790  03 00 04 00 07 00 09 00  03 00 04 00 07 00 03 00  |................|
; 000067a0  04 00 0a 00 03 00 03 00  05 00 04 00 03 00 09 00  |................|
; 000067b0  06 00 03 00 03 00 21 00  04 00 06 00 23 00 03 00  |......!.....#...|
; 000067c0  0e 00 03 00 03 00 05 00  06 00 03 00 03 00 03 00  |................|
; 000067d0  07 00 03 00 0a 00 03 00  11 00 03 00 05 00 03 00  |................|
; 000067e0  03 00 07 00 03 00 08 00  03 00 03 00 04 00 03 00  |................|
; 000067f0  0a 00 03 00 03 00 05 00  03 00 05 00 05 00 04 00  |................|
; 00006800  04 00 06 00 03 00 06 00  03 00 05 00 04 00 03 00  |................|
; 00006810  03 00 03 00 03 00 05 00  03 00 1c 00 0e 00 03 00  |................|
; 00006820  03 00 03 00 0b 00 03 00  03 00 08 00 03 00 03 00  |................|
; 00006830  03 00 06 00 03 00 03 00  10 00 04 00 07 00 0a 00  |................|
; 00006840  05 00 08 00 03 00 08 00  03 00 05 00 05 00 03 00  |................|
; 00006850  03 00 03 00 04 00 03 00  03 00 03 00 05 00 06 00  |................|
; 00006860  04 00 0b 00 05 00 09 00  03 00 03 00 06 00 05 00  |................|
; 00006870  06 00 08 00 03 00 03 00  03 00 03 00 08 00 06 00  |................|
; 00006880  0e 00 05 00 05 00 04 00  06 00 03 00 03 00 0a 00  |................|
; 00006890  05 00 0d 00 03 00 0e 00  09 00 03 00 03 00 03 00  |................|
; 000068a0  08 00 0b 00 0a 00 03 00  07 00 07 00 07 00 07 00  |................|
; 000068b0  06 00 03 00 09 00 0a 00  05 00 07 00 0b 00 1b 00  |................|
; 000068c0  03 00 06 00 03 00 07 00  03 00 04 00 03 00 03 00  |................|
; 000068d0  06 00 0d 00 0b 00 09 00  15 00 15 00 05 00 03 00  |................|
; 000068e0  0c 00 04 00 09 00 04 00  03 00 0d 00 03 00 06 00  |................|
; 000068f0  03 00 06 00 05 00 14 00  28 00 08 00 08 00 05 00  |........(.......|
; 00006900  06 00 04 00 04 00 09 00  0b 00 0b 00 04 00 03 00  |................|
; 00006910  03 00 03 00 09 00 08 00  03 00 42 00 07 00 09 00  |..........B.....|
; 00006920  03 00 08 00 05 00 05 00  05 00 1b 00 08 00 06 00  |................|
; 00006930  0c 00 05 00 29 00 50 00  04 00 2b 00 03 00 03 00  |....).P...+.....|
; 00006940  03 00 05 00 07 00 08 00  07 00 03 00 10 00 06 00  |................|
; 00006950  0a 00 0d 00 03 00 0d 00  03 00 0a 00 05 00 0c 00  |................|
; 00006960  14 00 09 00 08 00 03 00  06 00 03 00 04 00 04 00  |................|
; 00006970  25 00 08 00 10 00 09 00  07 00 03 00 08 00 03 00  |%...............|
; 00006980  03 00 03 00 06 00 09 00  05 00 03 00 06 00 03 00  |................|
; 00006990  08 00 03 00 03 00 03 00  03 00 04 00 05 00 05 00  |................|
; 000069a0  0d 00 03 00 07 00 04 00  05 00 09 00 05 00 0b 00  |................|
; 000069b0  0b 00 08 00 0c 00 05 00  03 00 05 00 07 00 07 00  |................|
; 000069c0  0b 00 08 00 0c 00 05 00  03 00 05 00 10 00 03 00  |................|
; 000069d0  03 00 05 00 03 00 09 00  03 00 03 00 03 00 05 00  |................|
; 000069e0  0b 00 03 00 03 00 0b 00  03 00 06 00 0a 00 03 00  |................|
; 000069f0  04 00 03 00 06 00 04 00  08 00 03 00 06 00 05 00  |................|
; 00006a00  04 00 03 00 40 00 0f 00  1e 00 25 00 0f 00 03 00  |....@.....%.....|
; 00006a10  08 00 09 00 03 00 03 00  05 00 03 00 03 00 05 00  |................|
; 00006a20  06 00 03 00 05 00 03 00  03 00 08 00 03 00 03 00  |................|
; 00006a30  04 00 03 00 03 00 09 00  03 00 04 00 08 00 0c 00  |................|
; 00006a40  04 00 18 00 03 00 03 00  03 00 03 00 04 00 05 00  |................|
; 00006a50  08 00 0f 00 0e 00 20 00  03 00 05 00 03 00 03 00  |...... .........|
; 00006a60  10 00 05 00 11 00 0a 00  04 00 0a 00 20 00 05 00  |............ ...|
; 00006a70  10 00 03 00 03 00 05 00  05 00 09 00 07 00 07 00  |................|
; 00006a80  09 00 25 00 03 00 04 00  03 00 03 00 03 00 03 00  |..%.............|
; 00006a90  03 00 03 00 06 00 08 00  03 00 03 00 05 00 04 00  |................|
; 00006aa0  09 00 03 00 03 00 04 00  0c 00 15 00 09 00 1b 00  |................|
; 00006ab0  03 00 08 00 05 00 0a 00  05 00 0e 00 07 00 06 00  |................|
; 00006ac0  04 00 25 00 06 00 06 00  0d 00 08 00 13 00 03 00  |..%.............|
; 00006ad0  05 00 13 00 10 00 03 00  0e 00 4e 00 04 00 0f 00  |..........N.....|
; 00006ae0  04 00 11 00 04 00 0f 00  15 00 08 00 0a 00 05 00  |................|
; 00006af0  04 00 0d 00 05 00 05 00  05 00 03 00 03 00 17 00  |................|
; 00006b00  07 00 13 00 0a 00 0e 00  05 00 0a 00 0a 00 03 00  |................|
; 00006b10  0a 00 0c 00 05 00 04 00  04 00 20 00 03 00 49 00  |.......... ...I.|
; 00006b20  08 00 09 00 20 00 03 00  0b 00 03 00 09 00 08 00  |.... ...........|
; 00006b30  0b 00 12 00 0a 00 06 00  17 00 03 00 0b 00 13 00  |................|
; 00006b40  03 00 06 00 0b 00 08 00  0b 00 09 00 07 00 08 00  |................|
; 00006b50  04 00 05 00 04 00 11 00  49 00 09 00 0c 00 03 00  |........I.......|
; 00006b60  04 00 50 00 0a 00 2b 00  22 00 0f 00 0b 00 09 00  |..P...+.".......|
; 00006b70  03 00 06 00 03 00 04 00  05 00 09 00 05 00 04 00  |................|
; 00006b80  05 00 0b 00 14 00 04 00  0b 00 0e 00 0a 00 06 00  |................|
; 00006b90  04 00 09 00 1a 00 09 00  0e 00 15 00 04 00 04 00  |................|
; 00006ba0  0d 00 0b 00 21 00 0e 00  09 00 65 00 17 00 12 00  |....!.....e.....|
; 00006bb0  3b 00 05 00 05 00 03 00  0b 00 0e 00 04 00 0a 00  |;...............|
; 00006bc0  05 00 0a 00 05 00 08 00  07 00 09 00 06 00 19 00  |................|
; 00006bd0  03 00 0b 00 04 00 13 00  0a 00 10 00 0a 00 06 00  |................|
; 00006be0  07 00 03 00 03 00 03 00  05 00 09 00 0d 00 04 00  |................|
; 00006bf0  03 00 04 00 06 00 03 00  03 00 08 00 09 00 06 00  |................|
; 00006c00  06 00 0b 00 12 00 05 00  03 00 0d 00 03 00 0e 00  |................|
; 00006c10  05 00 06 00 08 00 06 00  06 00 05 00 20 00 0f 00  |............ ...|
; 00006c20  10 00 06 00 05 00 03 00  05 00 07 00 04 00 0b 00  |................|
; 00006c30  07 00 04 00 05 00 05 00  04 00 03 00 03 00 03 00  |................|
; 00006c40  03 00 03 00 03 00 03 00  03 00 2f 00 1a 00 03 00  |........../.....|
; 00006c50  03 00 05 00 05 00 03 00  0a 00 03 00 03 00 03 00  |................|
; 00006c60  03 00 03 00 03 00 06 00  0a 00 0c 00 09 00 06 00  |................|
; 00006c70  12 00 04 00 03 00 04 00  04 00 07 00 05 00 04 00  |................|
; 00006c80  05 00 05 00 03 00 03 00  04 00 08 00 06 00 0d 00  |................|
; 00006c90  04 00 03 00 03 00 03 00  03 00 03 00 03 00 03 00  |................|
; 00006ca0  0a 00 03 00 05 00 0c 00  03 00 06 00 0a 00 06 00  |................|
; 00006cb0  0b 00 0d 00 09 00 03 00  05 00 dd 10 0c 00 07 00  |................|
; 00006cc0  04 00 36 00 08 00 03 00  03 00 03 00 03 00 03 00  |..6.............|
; 00006cd0  03 00 07 00 03 00 05 00  0b 00 04 00 05 00 06 00  |................|
; 00006ce0  03 00 03 00 03 00 03 00  04 00 03 00 2c 00 05 00  |............,...|
; 00006cf0  03 00 03 00 03 00 05 00  0d 00 03 00 37 00 04 00  |............7...|
; 00006d00  12 00 03 00 16 00 05 00  03 00 03 00 03 00 05 00  |................|
; 00006d10  09 00 14 00 12 00 25 00  04 00 03 00 04 00 03 00  |......%.........|
; 00006d20  04 00 05 00 03 00 04 00  04 00 03 00 05 00 06 00  |................|
; 00006d30  06 00 03 00 05 00 08 00  0f 00 07 00 0a 00 03 00  |................|
; 00006d40  0a 00 06 00 11 00 10 00  03 00 03 00 03 00 09 00  |................|
; 00006d50  03 00 03 00 03 00 06 00  04 00 03 00 03 00 03 00  |................|
; 00006d60  03 00 06 00 03 00 03 00  03 00 c3 e4 ab 00 21 3a  |..............!:|
; 00006d70  d4 22 e1 ab cd 0d d4 21  64 48 22 57 df 21 1e ac  |.".....!dH"W.!..|
; 00006d80  cd 68 d8 cd 03 de fe 61  28 1b fe 79 28 17 21 d7  |.h.....a(..y(.!.|
; 00006d90  f3 22 98 d0 af 32 a7 ce  3e c9 32 67 cc 32 74 cc  |."...2..>.2g.2t.|
; 00006da0  3e 01 32 e6 b6 c3 1c d4  49 6e 73 74 61 6c 6c 20  |>.2.....Install |
; 00006db0  44 34 30 2f 44 38 30 20  76 65 72 73 69 6f 6e bf  |D40/D80 version.|
; 00006dc0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006dd0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006de0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006df0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e20  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e30  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e40  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e50  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e60  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e70  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00006e80  00 00 00 00 00 00 00 00  00 00 00 00 00 00 cd e9  |................|
; 00006e90  ad eb cd 29 ae eb 2b 1b  0b 78 b1 20 f1 c1 18 06  |...)..+..x. ....|
; 00006ea0  09 2b eb 09 2b eb 78 b1  ca 25 af e5 d5 cd 6f ad  |.+..+.x..%....o.|
; 00006eb0  30 01 eb 13 60 69 b7 ed  52 30 05 19 eb 21 00 00  |0...`i..R0...!..|
; 00006ec0  42 4b d1 e3 7c aa e6 c0  20 c4 e5 d5 c5 3e 16 cb  |BK..|... ....>..|
; 00006ed0  7c 20 02 3e 13 cb 74 20  02 d6 02 c5 01 fd 7f ed  || .>..t ........|
; 00006ee0  79 c1 cb f4 cb fc cb f2  cb fa ed b8 c1 e1 b7 ed  |y...............|
; 00006ef0  42 eb e1 b7 ed 42 c1 18  ad cb b4 cb bc cb b2 cb  |B....B..........|
; 00006f00  ba b7 ed 52 19 c9 cd 77  ad 38 95 78 b1 ca 25 af  |...R...w.8.x..%.|
; 00006f10  e5 d5 cd 6f ad 38 01 eb  21 00 40 b7 ed 52 eb 60  |...o.8..!.@..R.`|
; 00006f20  69 b7 ed 52 30 05 19 eb  21 00 00 42 4b d1 e3 7c  |i..R0...!..BK..||
; 00006f30  aa e6 c0 20 2b e5 d5 c5  3e 16 cb 7c 20 02 3e 13  |... +...>..| .>.|
; 00006f40  cb 74 20 02 d6 02 c5 01  fd 7f ed 79 c1 cb f4 cb  |.t ........y....|
; 00006f50  fc cb f2 cb fa ed b0 c1  e1 09 eb e1 09 c1 18 ab  |................|
; 00006f60  cd e9 ad eb cd 29 ae eb  23 13 0b 78 b1 20 f1 c1  |.....)..#..x. ..|
; 00006f70  c3 81 ad c5 cb 7c 3e 16  20 02 3e 13 cb 74 20 02  |.....|>. .>..t .|
; 00006f80  d6 02 01 fd 7f ed 79 44  cb fc cb f4 7e f5 60 06  |......yD....~.`.|
; 00006f90  7f 3e 10 ed 79 f1 c1 c9  cb 7c 3e 16 20 02 3e 13  |.>..y....|>. .>.|
; 00006fa0  cb 74 20 02 d6 02 01 fd  7f ed 79 44 cb fc cb f4  |.t .......yD....|
; 00006fb0  7e 60 c9 c5 f5 cb 7c 3e  16 20 02 3e 13 cb 74 20  |~`....|>. .>..t |
; 00006fc0  02 d6 02 01 fd 7f ed 79  f1 44 cb fc cb f4 77 f5  |.......y.D....w.|
; 00006fd0  60 06 7f 3e 10 ed 79 f1  c1 c9 dd e5 e1 cb 7c 16  |`..>..y.......|.|
; 00006fe0  16 20 02 16 13 cb 74 20  02 15 15 01 fd 7f cb fc  |. ....t ........|
; 00006ff0  cb f4 c9 2e 00 2c 08 d9  cd 50 ae ed 51 d9 f3 3e  |.....,...P..Q..>|
; 00007000  0f d3 fe db fe 1f e6 20  f6 02 4f bf c2 25 af cd  |....... ..O..%..|
; 00007010  e7 05 30 f8 21 15 04 10  fe 2b 7c b5 20 f9 cd e3  |..0.!....+|. ...|
; 00007020  05 30 e9 06 9c cd e3 05  30 e2 3e c6 b8 30 e0 24  |.0......0.>..0.$|
; 00007030  20 f1 06 c9 cd e7 05 30  d3 78 fe d4 30 f4 cd e7  | ......0.x..0...|
; 00007040  05 30 6c 79 ee 03 4f 26  00 06 b0 18 47 08 28 27  |.0ly..O&....G.('|
; 00007050  cb 11 ad 20 5a 79 1f 4f  13 08 18 35 ae 28 1d 18  |... Zy.O...5.(..|
; 00007060  4e d9 21 00 00 16 00 ed  51 d9 ed 5b cd af 1b 06  |N.!.....Q..[....|
; 00007070  b1 08 af 3d 08 18 1d 7d  d9 30 e1 77 08 23 cb 7c  |...=...}.0.w.#.||
; 00007080  20 0e 26 c0 14 7a fe 12  28 fa fe 15 28 f6 ed 51  | .&..z..(...(..Q|
; 00007090  d9 1b 06 b2 2e 01 cd e3  05 30 14 3e cb b8 cb 15  |.........0.>....|
; 000070a0  06 b0 d2 0c af 7c ad 67  7a b3 20 a1 7c fe 01 f5  |.....|.gz. .|...|
; 000070b0  c5 3e 10 01 fd 7f ed 79  c1 f1 c9 cd 5d af 12 13  |.>.....y....]...|
; 000070c0  ed 53 47 af 21 00 00 23  22 3b af 18 e2 cd 5d af  |.SG.!..#";....].|
; 000070d0  21 00 00 2b 7e 2b 46 77  23 70 18 d3 cd 5d af 2a  |!..+~+Fw#p...].*|
; 000070e0  47 af 2b 86 77 18 c8 f5  c5 01 fd 7f 3e 10 ed 79  |G.+.w.......>..y|
; 000070f0  c1 f1 c9 3e 00 01 fd 7f  ed 79 cd 00 00 f3 18 af  |...>.....y......|
; 00007100  21 80 1f d9 ed 51 d9 cb  7f 28 03 21 98 0c 08 13  |!....Q...(.!....|
; 00007110  3e 02 47 10 fe d3 fe ee  0f 06 a4 2d 20 f5 05 25  |>.G........- ..%|
; 00007120  f2 89 af 06 2f 10 fe d3  fe 3e 0d 06 37 10 fe d3  |..../....>..7...|
; 00007130  fe 01 0e 3b 08 6f c3 b9  af 7a b3 28 0d d9 7e d9  |...;.o...z.(..~.|
; 00007140  6f 7c ad 67 3e 01 37 c3  f1 af 6c 18 f4 d9 21 00  |o|.g>.7...l...!.|
; 00007150  00 16 00 ed 51 d9 11 00  00 2e ff 7c ad 67 3e 01  |....Q......|.g>.|
; 00007160  37 cb 15 06 31 18 09 79  cb 78 10 fe 30 04 06 42  |7...1..y.x..0..B|
; 00007170  10 fe d3 fe 06 3e 20 ef  05 af 3c cb 15 c2 e0 af  |.....> ...<.....|
; 00007180  1b d9 23 cb 7c 20 0e 26  c0 14 7a fe 12 28 fa fe  |..#.| .&..z..(..|
; 00007190  15 28 f6 ed 51 d9 06 2f  3e 7f db fe 1f 30 09 7a  |.(..Q../>....0.z|
; 000071a0  3c c2 af af 06 3b 10 fe  d9 3e 10 ed 79 d9 c9 c5  |<....;...>..y...|
; 000071b0  d9 11 00 00 cd 48 ca e5  09 09 22 55 b0 d9 e1 d9  |.....H...."U....|
; 000071c0  78 b1 37 28 30 d9 23 cd  0e ae 4f e6 c0 79 20 03  |x.7(0.#...O..y .|
; 000071d0  3c 18 1b e5 2b e6 3f 47  c5 cd 0e ae c1 4f 21 00  |<...+.?G.....O!.|
; 000071e0  00 09 cd 0e ae bb 20 05  23 cd 0e ae ba e1 23 d9  |...... .#.....#.|
; 000071f0  0b 13 20 cc d9 d9 c1 c3  25 af cd c1 b1 cd 00 1a  |.. .....%.......|
; 00007200  18 f5 cd c1 b1 cd ae 19  18 ed 31 04 ad cd 30 f4  |..........1...0.|
; 00007210  cd df f4 cd 25 af c3 f0  bb cd 69 ae 18 0e 14 08  |....%.....i.....|
; 00007220  15 f3 3e 0f d3 fe cd 62  05 cd 25 af f5 3e 7f db  |..>....b..%..>..|
; 00007230  fe 1f d2 1e d8 f1 c9 00  00 00 00 00 00 00 00 00  |................|
; 00007240  00 3a 5c 00 00 ff af 01  01 00 00 00 00 00 00 00  |.:\.............|
; 00007250  00 00 00 00 00 3e e9 cd  20 b8 ed 73 4d b1 cd c1  |.....>.. ..sM...|
; 00007260  b1 31 ad b0 e1 7d ed 4f  7c ed 47 c1 d1 e1 f1 d9  |.1...}.O|.G.....|
; 00007270  08 fd e1 dd e1 c1 d1 e1  f1 ed 7b c3 b0 c3 60 ac  |..........{...`.|
; 00007280  ed 73 c3 b0 31 60 ac f5  ed 57 f5 ed 5f f3 f5 f1  |.s..1`...W.._...|
; 00007290  f1 f1 31 c3 b0 f5 e5 d5  3e 01 11 00 00 21 00 00  |..1.....>....!..|
; 000072a0  18 22 00 ed 73 c3 b0 31  60 ac f5 ed 57 f5 ed 5f  |."..s..1`...W.._|
; 000072b0  f3 f5 f1 f1 f1 31 c3 b0  f5 e5 d5 3e 00 11 00 00  |.....1.....>....|
; 000072c0  21 00 00 00 c5 dd e5 fd  e5 d9 08 f5 e5 d5 c5 ed  |!...............|
; 000072d0  57 67 ed 5f 6f e5 31 00  00 cd 66 b1 3e db cd 20  |Wg._o.1...f.>.. |
; 000072e0  b8 21 5c ac 7e 2b 2b b6  e6 04 0f 0f 32 68 c3 c9  |.!\.~++.....2h..|
; 000072f0  11 82 ac 3e 01 b7 ca 25  af 21 00 c0 01 08 00 e5  |...>...%.!......|
; 00007300  c5 ed b0 21 04 ad c1 d1  ed b0 af 01 fd 7f 5f f6  |...!.........._.|
; 00007310  10 ed 79 4b 21 04 ad 11  00 c0 06 08 1a be 20 16  |..yK!......... .|
; 00007320  2c 1c 10 f8 79 32 c2 b1  21 82 ac 11 00 c0 01 08  |,...y2..!.......|
; 00007330  00 ed b0 c3 25 af 79 cd  b5 b1 20 cf c3 25 af 3c  |....%.y... ..%.<|
; 00007340  fe 02 28 fb fe 05 28 f7  fe 08 c9 3e 00 b7 c8 c5  |..(...(....>....|
; 00007350  01 fd 7f f6 10 ed 79 c1  c9 cd c1 b1 7e c3 25 af  |......y.....~.%.|
; 00007360  f5 cd c1 b1 f1 77 18 f5  f5 cd c1 b1 f1 77 ed b0  |.....w.......w..|
; 00007370  18 eb cd c1 b1 cd f0 b1  18 e3 78 b1 c8 cd 77 ad  |..........x...w.|
; 00007380  38 03 ed b0 c9 09 2b eb  09 2b eb ed b8 c9 cd c1  |8.....+..+......|
; 00007390  b1 01 03 00 ed b0 c3 25  af f5 cd c1 b1 f1 cd c6  |.......%........|
; 000073a0  04 c3 25 af f5 cd c1 b1  f1 cd 94 b0 c3 25 af 2a  |..%..........%.*|
; 000073b0  37 b1 cd 66 bd cd 6c bd  eb cd c1 b1 ed b0 cd 25  |7..f..l........%|
; 000073c0  af eb 11 19 b1 cd 41 b2  11 f6 b0 36 c3 23 73 23  |......A....6.#s#|
; 000073d0  72 23 c9 e0 50 c5 03 01  00 00 00 40 a0 03 8b 00  |r#..P......@....|
; 000073e0  00 a0 48 c4 03 82 00 00  12 50 a3 03 01 00 00 00  |..H......P......|
; 000073f0  50 c1 b2 01 c2 b0 20 50  c2 92 01 bc b0 40 50 c3  |P..... P.....@P.|
; 00007400  92 01 bb b0 60 50 c4 92  01 be b0 80 50 c5 92 01  |....`P......P...|
; 00007410  bd b0 a0 50 c8 92 01 c0  b0 c0 50 cc 92 01 bf b0  |...P......P.....|
; 00007420  80 48 c9 82 00 ae b0 c8  50 d2 82 01 ad b0 00 48  |.H......P......H|
; 00007430  19 82 00 ba b0 20 48 1d  82 00 b9 b0 40 48 1a 82  |..... H.....@H..|
; 00007440  00 b8 b0 60 48 1e 82 00  b7 b0 ce 50 c6 00 01 c1  |...`H......P....|
; 00007450  b0 e0 40 15 8a 00 c1 b0  49 50 16 8a 01 bb b0 69  |..@.....IP.....i|
; 00007460  50 17 8a 01 bd b0 89 50  18 8a 01 bf b0 52 50 23  |P......P.....RP#|
; 00007470  8a 01 c3 b0 72 50 1b 8a  01 b9 b0 92 50 1c 8a 01  |....rP......P...|
; 00007480  b7 b0 d9 50 d4 8a 01 c5  b0 a0 48 d8 81 e0 c7 b0  |...P......H.....|
; 00007490  b1 48 d9 81 e0 c9 b0 08  48 26 81 e0 bb b0 28 48  |.H......H&....(H|
; 000074a0  27 81 e0 bd b0 48 48 28  81 e0 bf b0 16 50 2b 8d  |'....HH(.....P+.|
; 000074b0  e5 c3 b0 68 48 29 81 e0  b9 b0 88 48 2a 81 e0 b7  |...hH).....H*...|
; 000074c0  b0 d4 02 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 000074d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 d5  |................|
; 000074e0  02 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 000074f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00007500  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00007510  00 00 00 00 00 00 00 00  00 00 d3 02 00 00 00 00  |................|
; 00007520  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00007530  00 00 00 00 00 00 00 00  d2 02 00 00 00 00 00 00  |................|
; 00007540  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00007550  00 00 00 00 00 00 d1 02  00 00 00 00 00 00 00 00  |................|
; 00007560  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00007570  00 00 00 00 cc 01 00 00  00 00 00 00 00 00 00 00  |................|
; 00007580  00 00 00 00 00 00 00 00  00 00 00 00 cd 46 c1 af  |.............F..|
; 00007590  db fe 2f e6 1f c0 cd d2  dd fe 04 c0 f3 cd c2 ce  |../.............|
; 000075a0  31 04 ad cd 86 bb 21 3e  ac 3a 6a b1 b7 28 0e 36  |1.....!>.:j..(.6|
; 000075b0  dc 23 3a c2 b1 c6 30 77  23 36 db 18 02 36 c6 23  |.#:...0w#6...6.#|
; 000075c0  3a 8b bd c6 c7 77 23 36  cc 23 3a ec bc b7 28 02  |:....w#6.#:...(.|
; 000075d0  d6 c7 c6 c9 77 cd 95 bb  3e 80 32 3e ac 21 51 e3  |....w...>.2>.!Q.|
; 000075e0  22 1c df 21 f5 e1 22 1c  d8 21 a5 da 22 1f d8 21  |"..!.."..!.."..!|
; 000075f0  40 d4 22 ae d5 21 12 b4  e5 cd 75 c2 cd d2 dd cd  |@."..!....u.....|
; 00007600  f8 b5 cd c2 dd 2a ed b4  1e 20 fe 71 ca 3a d4 fe  |.....*... .q.:..|
; 00007610  14 ca 7f c1 fe 23 ca 8c  d3 fe 3a ca 16 bc fe 2c  |.....#....:....,|
; 00007620  ca 22 ba fe 03 ca 0f d4  4f 06 2b 21 bc b4 11 3a  |."......O.+!...:|
; 00007630  b5 1a 13 cd 5d c0 1a b9  13 28 06 10 f4 79 c3 9f  |....]....(...y..|
; 00007640  b9 e5 2a ed b4 c9 cd a0  b5 c4 23 2b 2b 23 22 ed  |..*.......#++#".|
; 00007650  b4 c9 21 73 b3 7e b7 c8  35 87 cd 5d c0 7e 2b 6e  |..!s.~..5..].~+n|
; 00007660  67 18 eb 21 73 b3 7e fe  0a d0 e5 cd a0 b5 c4 e3  |g..!s.~.........|
; 00007670  34 7e 87 cd 5d c0 11 00  00 72 2b 73 e1 18 cf 21  |4~..]....r+s...!|
; 00007680  73 b3 7e fe 0a d0 e5 2a  ed b4 cd cf b1 23 fe dd  |s.~....*.....#..|
; 00007690  28 04 fe fd 20 01 23 cd  cf b1 f5 23 cd cf b1 67  |(... .#....#...g|
; 000076a0  f1 6f 18 cb cd c6 bf 18  a5 cd a0 b5 c2 cd 43 c1  |.o............C.|
; 000076b0  cd af be cd 02 b4 18 f8  dd 21 50 b2 dd 7e 04 e6  |.........!P..~..|
; 000076c0  1f c3 48 c3 00 6d 05 0a  02 0d 05 08 11 0b 1c 0c  |..H..m..........|
; 000076d0  25 09 05 76 04 24 0b 05  62 20 87 65 0e 60 06 78  |%..v.$..b .e.`.x|
; 000076e0  11 63 05 3f 0e 74 14 3e  1e 2e 05 73 05 7c 4a 6a  |.c.?.t.>...s.|Jj|
; 000076f0  05 2d 1a 79 69 2a 12 64  41 5c 2a 77 0e 5d 45 5e  |.-.yi*.dA\*w.]E^|
; 00007700  16 69 05 7f 21 70 05 22  1a 3d 04 6c 44 3b 04 6f  |.i..!p.".=.lD;.o|
; 00007710  32 36 23 66 24 6e 1d 62  0b 61 22 71 bb 3e 21 11  |26#f$n.b.a"q.>!.|
; 00007720  01 00 2a 17 da 22 15 d1  18 08 e1 5e 23 e5 16 01  |..*..".....^#...|
; 00007730  3e c3 32 ce b5 cd 86 bb  ed 53 3e ac ed 73 b7 b5  |>.2......S>..s..|
; 00007740  31 00 00 cd a5 da 21 12  b6 22 1c d8 cd a1 bb 21  |1.....!..".....!|
; 00007750  3f ac cd 78 dd fe 3a c8  c3 70 c7 21 3e ac cd 78  |?..x..:..p.!>..x|
; 00007760  dd 0e 09 cd 5c d6 cd 70  bb cd fd d0 cd 70 bb cd  |....\..p.....p..|
; 00007770  f2 cf 2a 3b af 22 71 bb  3a 63 af e6 07 32 c2 b1  |..*;."q.:c...2..|
; 00007780  af c9 2a 49 b2 f5 7d e6  e0 6f f1 c9 cd f8 b5 cd  |..*I..}..o......|
; 00007790  33 d8 26 01 23 e3 e3 24  25 20 f9 c9 cd 02 b6 18  |3.&.#..$% ......|
; 000077a0  9f cd 90 b5 2a 71 bb cd  78 c2 cd 93 b5 18 f5 21  |....*q..x......!|
; 000077b0  8b bd c3 94 d3 21 ec bc  7e b7 20 02 3e c7 3c fe  |.....!..~. .>.<.|
; 000077c0  ca 20 01 af 77 c9 21 a0  bf 18 e7 21 36 bf 7e b7  |. ..w.!....!6.~.|
; 000077d0  20 02 3e 03 3d 77 d3 fe  c9 cd 13 bc dc 75 c2 cd  | .>.=w.......u..|
; 000077e0  54 1f 38 f5 af db fe 2f  e6 1f 20 f8 c9 cd a0 b5  |T.8..../.. .....|
; 000077f0  c3 22 74 b6 cd 13 bc d4  75 c2 2a ed b4 11 00 00  |."t.....u.*.....|
; 00007800  b7 ed 52 c8 cd 54 1f 30  db 18 e9 21 68 c3 18 a2  |..R..T.0...!h...|
; 00007810  cd d4 bb 18 03 cd c7 bb  e5 d5 cd a0 b5 d9 ee 3a  |...............:|
; 00007820  20 29 dd 21 10 ac dd 36  00 03 11 11 ac 23 cd 5f  | ).!...6.....#._|
; 00007830  cd d1 e1 e5 d5 b7 ed 52  23 ed 53 1d ac 22 1b ac  |.......R#.S.."..|
; 00007840  cd a6 ce c2 53 f6 cd 3a  cd 2e ff cd c7 b6 c3 0f  |....S..:........|
; 00007850  b2 7d c1 d1 e1 c5 b7 ed  52 23 eb e5 dd e1 c9 cd  |.}......R#......|
; 00007860  d4 bb 18 03 cd c7 bb cd  df bb cd a0 b5 d9 ee 3a  |...............:|
; 00007870  ca 74 f6 cd c7 b6 37 cd  1a b2 d8 c3 f0 bb cd 43  |.t....7........C|
; 00007880  c1 dd 21 3e ac 11 12 00  af 37 08 3e 0f d3 fe cd  |..!>.....7.>....|
; 00007890  62 05 dd 21 e7 ab 38 0b  2a 3e ac 26 00 cd b4 bf  |b..!..8.*>.&....|
; 000078a0  c3 46 c1 21 3f ac 7e c6  30 dd 77 fd 06 0a 23 7e  |.F.!?.~.0.w...#~|
; 000078b0  fe 20 30 02 3e 3f dd 77  00 dd 23 10 f1 dd 23 2a  |. 0.>?.w..#...#*|
; 000078c0  4c ac e5 cd ae bf 2a 4a  ac e5 cd ae bf 2a 4e ac  |L.....*J.....*N.|
; 000078d0  cd ae bf cd 46 c1 cd d2  dd e1 d1 fe 6a c0 19 2b  |....F.......j..+|
; 000078e0  cd df bb 2e ff 18 8c 06  08 21 bb b0 11 af b0 4e  |.........!.....N|
; 000078f0  1a 77 79 12 23 13 10 f7  c9 21 1c c9 22 94 b7 21  |.wy.#....!.."..!|
; 00007900  a4 b7 22 ae d5 cd d4 bb  e5 21 a5 b7 22 1c d8 e1  |.."......!.."...|
; 00007910  eb d5 cd af be cd 46 c1  e5 ed 73 a6 b7 cd 52 00  |......F...s...R.|
; 00007920  f3 e1 d1 cd 89 bc d2 5a  b6 cd 77 ad 38 e3 c9 31  |.......Z..w.8..1|
; 00007930  00 00 cd a1 bb cd ca b7  18 e7 21 a4 b7 22 ae d5  |..........!.."..|
; 00007940  af 32 a0 bf 21 bf b7 18  b3 21 e4 ab 11 3e ac 01  |.2..!....!...>..|
; 00007950  20 00 ed b0 cd a5 da 21  3e ac cd 78 dd 16 00 0e  | ......!>..x....|
; 00007960  09 c3 7c d5 fe 77 20 0a  22 07 b8 3a c2 b1 32 0e  |..|..w ."..:..2.|
; 00007970  b8 c9 e5 22 47 af 11 2a  b8 d5 cd 04 b2 21 12 b4  |..."G..*.....!..|
; 00007980  22 1c d8 3e c3 cd 43 d0  01 18 b1 cd ae d0 0e c3  |"..>..C.........|
; 00007990  11 18 b1 3a c2 b1 f5 3e  00 32 c2 b1 cd 34 b8 f1  |...:...>.2...4..|
; 000079a0  32 c2 b1 e1 d1 cd 04 b2  3e ff 21 ad b0 86 ae e6  |2.......>.!.....|
; 000079b0  7f ae 77 c9 00 00 00 cd  a0 b5 cc eb 0e cd cd 6c  |..w............l|
; 000079c0  bd 71 23 73 23 72 23 cd  38 b2 c3 cb b0 cd d4 bb  |.q#s#r#.8.......|
; 000079d0  18 03 cd c7 bb e5 d5 cd  a0 b5 d8 d1 c1 d5 e5 b7  |................|
; 000079e0  ed 52 09 c1 cd e5 bb eb  ed 42 23 50 59 44 4d e1  |.R.......B#PYDM.|
; 000079f0  c3 e8 b1 cd d4 bb 18 03  cd c7 bb cd df bb cd a0  |................|
; 00007a00  b5 d7 7d d1 e1 b7 ed 52  c8 44 4d eb 54 5d 13 c3  |..}....R.DM.T]..|
; 00007a10  de b1 cd a0 b5 c2 cd 43  c1 dd 21 e4 ab e5 cd d6  |.......C..!.....|
; 00007a20  e0 e1 dd 23 dd 23 e5 01  00 05 e5 cd cf b1 6f 26  |...#.#........o&|
; 00007a30  00 3a cd e0 c5 b7 28 0b  dd 36 00 23 dd 23 cd ec  |.:....(..6.#.#..|
; 00007a40  e0 18 03 cd 00 e1 c1 dd  23 e1 23 10 dd e1 06 05  |........#.#.....|
; 00007a50  cd f0 b8 10 fb cd 02 b4  18 bf cd a0 b5 c2 cd 43  |...............C|
; 00007a60  c1 dd 21 e4 ab e5 cd b0  bf e1 dd 23 dd 23 06 19  |..!........#.#..|
; 00007a70  cd f0 b8 10 fb cd 02 b4  18 e7 cd cf b1 57 e6 7f  |.............W..|
; 00007a80  fe 20 7a 23 30 04 e6 80  f6 2e dd 77 00 dd 23 c9  |. z#0......w..#.|
; 00007a90  21 eb b3 e5 cd e5 ba e1  20 70 7e fe 0b d0 e5 3d  |!....... p~....=|
; 00007aa0  87 cd 5d c0 23 e5 cd a0  b5 cc eb e1 73 23 72 e1  |..].#.......s#r.|
; 00007ab0  34 18 e0 3e 31 32 35 c6  06 05 21 f0 b9 c5 e5 cd  |4..>125...!.....|
; 00007ac0  a0 b5 da ee 3a 0e 00 28  01 0d 45 21 35 c6 34 e1  |....:..(..E!5.4.|
; 00007ad0  70 23 71 23 c1 10 e6 ed  5b ed b4 13 d5 21 f0 b9  |p#q#....[....!..|
; 00007ae0  06 05 eb cd cf b1 eb 13  ae 23 a6 23 20 7a 10 f2  |.........#.# z..|
; 00007af0  e1 c3 c4 b4 21 6a b1 cd  94 d3 c0 32 c2 b1 c9 21  |....!j.....2...!|
; 00007b00  c2 b1 7e cd b5 b1 e6 07  77 c9 d6 2f be 30 84 3d  |..~.....w../.0.=|
; 00007b10  87 47 3e 15 90 4f 78 06  00 e5 cd 5d c0 23 54 5d  |.G>..Ox....].#T]|
; 00007b20  23 23 ed b0 e1 35 c3 09  b9 fe 31 d8 fe 36 d0 d6  |##...5....1..6..|
; 00007b30  31 87 21 e6 b9 cd 5d c0  5e 23 56 eb e5 cd df ba  |1.!...].^#V.....|
; 00007b40  e1 20 41 7e fe 07 d0 e5  3d 87 87 c6 04 cd 5d c0  |. A~....=.....].|
; 00007b50  23 e5 cd d4 bb e5 b7 ed  52 c1 e1 73 23 72 23 71  |#.......R..s#r#q|
; 00007b60  23 70 e1 38 d7 34 18 d4  d1 13 7a b3 c8 c3 52 b9  |#p.8.4....z...R.|
; 00007b70  38 b3 56 b3 91 b3 af b3  cd b3 00 00 00 00 00 00  |8.V.............|
; 00007b80  00 00 00 00 d6 2e be 30  b3 3d 87 87 47 3e 15 90  |.......0.=..G>..|
; 00007b90  4f 78 c6 04 06 00 e5 cd  5d c0 23 54 5d 23 23 23  |Ox......].#T]###|
; 00007ba0  23 ed b0 e1 35 18 95 cd  02 b6 18 13 cd 86 bb 21  |#...5..........!|
; 00007bb0  c5 01 22 3e ac 21 1d ba  22 1c d8 ed 73 36 ba 31  |..">.!.."...s6.1|
; 00007bc0  00 00 cd a5 da cd a1 bb  06 18 dd 21 65 b2 21 3f  |...........!e.!?|
; 00007bd0  ac cd 78 dd dd 7e 02 cb  7f 20 12 11 f0 e5 cd 73  |..x..~... .....s|
; 00007be0  da 1a ae e6 5f 20 13 13  23 cd 78 dd 1a ae e6 5f  |...._ ..#.x...._|
; 00007bf0  20 08 23 cd 78 dd fe 41  38 2f 11 07 00 dd 19 10  | .#.x..A8/......|
; 00007c00  cd c3 fa d7 cd 78 dd f6  20 e5 21 8f ba 06 04 be  |.....x.. .!.....|
; 00007c10  23 28 0e 23 10 f9 e1 18  18 73 80 7a 40 70 04 63  |#(.#.....s.z@p.c|
; 00007c20  01 11 c1 b0 1a ae 12 e1  c9 23 dd 7e 02 fe c6 28  |.........#.~...(|
; 00007c30  d3 dd e5 cd 73 c7 dd e1  eb dd 6e 05 dd 66 06 dd  |....s.....n..f..|
; 00007c40  7e 02 fe d8 30 06 dd cb  03 5e 28 03 23 72 2b 73  |~...0....^(.#r+s|
; 00007c50  c9 06 00 e5 21 d0 c4 09  4e 09 7e fe 80 cb bf 12  |....!...N.~.....|
; 00007c60  13 23 38 f6 af 12 13 e1  c9 3e 37 0e 35 18 04 3e  |.#8......>7.5..>|
; 00007c70  b7 0e 39 32 02 bb 32 11  bb 32 2c bb 79 32 41 bb  |..92..2..2,.y2A.|
; 00007c80  cd 43 c1 2b 4e 23 11 e4  ab cd c7 ba 37 0e d6 dc  |.C.+N#......7...|
; 00007c90  c7 ba cd 46 c1 3e 2f 32  e4 ab 7e 37 30 05 3d 01  |...F.>/2..~70.=.|
; 00007ca0  08 00 09 23 dd 21 e6 ab  3d 28 15 f5 dd 34 fe dd  |...#.!..=(...4..|
; 00007cb0  36 ff 3a cd 46 bb 37 dc  46 bb cd 46 c1 f1 18 e4  |6.:.F.7.F..F....|
; 00007cc0  cd d2 dd fe 69 c8 fe 30  38 03 fe 35 d8 c3 12 b4  |....i..08..5....|
; 00007cd0  5e 23 56 23 e5 eb e5 cd  b0 bf d1 cd 25 b0 dd e5  |^#V#........%...|
; 00007ce0  06 0a dd 36 00 20 dd 23  10 f8 e1 38 0b e5 cd a5  |...6. .#...8....|
; 00007cf0  d8 e1 23 06 09 cd 99 da  e1 c9 21 00 00 22 3b af  |..#.......!..";.|
; 00007d00  22 47 af 3a c2 b1 f6 10  32 63 af dd 21 61 ac c9  |"G.:....2c..!a..|
; 00007d10  21 3d ac 36 80 23 36 01  23 01 00 20 c3 ab da 21  |!=.6.#6.#.. ...!|
; 00007d20  d0 c4 22 1c df cd f8 b5  c3 91 dd cd 95 bb cd 03  |..".............|
; 00007d30  de fe 80 30 f6 fe 04 ca  12 b4 fe 03 20 08 2a b1  |...0........ .*.|
; 00007d40  d5 2b cb 7e 20 e5 cd b0  d5 20 e0 cd f8 b5 c3 c2  |.+.~ .... ......|
; 00007d50  dd cd a0 b5 c2 e5 cd a0  b5 c1 d1 19 2b c9 cd a0  |............+...|
; 00007d60  b5 c2 e5 cd a0 b5 c3 d1  c9 f1 e5 d5 f5 42 4b eb  |.............BK.|
; 00007d70  cd 62 c0 21 04 bc 22 1f  d8 d0 3e cd cd 86 bb 21  |.b.!.."...>....!|
; 00007d80  3e ac 77 23 36 d0 cd 95  bb 3e 00 32 ad b0 cd 75  |>.w#6....>.2...u|
; 00007d90  c2 cd de de cd 03 de cd  5a b6 c3 12 b4 2a ed b4  |........Z....*..|
; 00007da0  e5 cd c6 bf 08 c2 12 b4  22 37 b1 22 14 b1 ed 53  |........"7."...S|
; 00007db0  8b be c5 3a ad b0 32 00  bc cd 7a bd c1 d1 c5 cd  |...:..2...z.....|
; 00007dc0  25 b2 c1 21 66 c5 cd 2a  be 38 20 21 aa bc cd 5d  |%..!f..*.8 !...]|
; 00007dd0  c0 7e 21 b2 bc cd 5d c0  01 a9 bc 3a 34 b1 cd f8  |.~!...]....:4...|
; 00007de0  be 22 14 b1 ed 43 7c bc  32 11 b1 cd cb b0 08 f5  |."...C|.2.......|
; 00007df0  d9 e5 d9 d1 21 cd b3 3a  8b bd b7 cc 1c c1 3e ce  |....!..:......>.|
; 00007e00  da f2 bb f1 b7 c4 a9 bc  d9 22 ed b4 2a c5 b0 19  |........."..*...|
; 00007e10  22 c5 b0 3e bf c3 56 1f  2a c3 b0 ed 5b 37 b1 f5  |"..>..V.*...[7..|
; 00007e20  7b cd d6 b1 23 7a cd d6  b1 f1 c9 2a c3 b0 23 23  |{...#z.....*..##|
; 00007e30  22 c3 b0 c9 00 19 4f 72  87 8c 91 a0 21 62 ac f5  |".....Or....!b..|
; 00007e40  cd cf b1 5f f1 36 03 2a  37 b1 16 00 cb 7b 28 01  |..._.6.*7....{(.|
; 00007e50  15 19 c6 05 c9 fe 0a 28  27 d9 ed 5b 62 ac ed 73  |.......('..[b..s|
; 00007e60  e9 bc 21 eb b3 46 23 f9  10 02 18 06 e1 b7 ed 52  |..!..F#........R|
; 00007e70  20 f6 31 00 00 d9 00 c6  08 21 34 b1 34 01 8e bc  | .1......!4.4...|
; 00007e80  2a 62 ac 11 67 ac ed 53  62 ac c9 2a c3 b0 cd cf  |*b..g..Sb..*....|
; 00007e90  b1 5f 23 cd cf b1 57 21  61 ac 7e c6 02 fe cb 20  |._#...W!a.~.... |
; 00007ea0  02 d6 08 77 cd 43 b2 3e  0a 01 a1 bc 18 10 21 61  |...w.C.>......!a|
; 00007eb0  ac 7e e6 38 36 cd 23 77  23 36 00 23 3e 03 cd 38  |.~.86.#w#6.#>..8|
; 00007ec0  b2 18 92 2a bf b0 18 0c  2a b9 b0 18 03 2a b7 b0  |...*....*....*..|
; 00007ed0  af 32 62 ac af 32 61 ac  22 37 b1 c9 01 a1 bc 2a  |.2b..2a."7.....*|
; 00007ee0  c3 b0 f5 cd cf b1 5f 23  cd cf b1 57 eb f1 18 e0  |......_#...W....|
; 00007ef0  b7 ed 52 44 4d c9 21 60  ac 3a 68 c3 87 87 87 c6  |..RDM.!`.:h.....|
; 00007f00  f3 77 23 c9 78 d6 76 b1  20 0a 3a 68 c3 b7 c0 3e  |.w#.x.v. .:h...>|
; 00007f10  cf c3 f2 bb 3e 00 b7 c0  79 e6 40 28 57 78 d9 fe  |....>...y.@(Wx..|
; 00007f20  b0 ed 4b bb b0 ed 5b bd  b0 2a bf b0 20 0a e5 09  |..K...[..*.. ...|
; 00007f30  2b e5 eb e5 09 2b 18 12  fe b8 20 37 e5 a7 ed 42  |+....+.... 7...B|
; 00007f40  23 e3 e5 eb e5 a7 ed 42  23 e3 e5 60 69 11 15 00  |#......B#..`i...|
; 00007f50  cd a2 d2 2b 2b 2b 2b 2b  22 34 b1 21 af b3 d1 c1  |...+++++"4.!....|
; 00007f60  cd 72 c0 da f0 bb 21 91  b3 d1 c1 cd 72 c0 da f0  |.r....!.....r...|
; 00007f70  bb d9 c9 d9 21 b9 c4 d5  cd 2a be 21 91 b3 cd 01  |....!....*.!....|
; 00007f80  be 21 0b c5 d1 cd 2a be  21 af b3 d8 e5 f5 21 5b  |.!....*.!.....![|
; 00007f90  be cd 5d c0 7e 21 63 be  cd 5d c0 cd f8 be f1 e3  |..].~!c..]......|
; 00007fa0  d1 f5 e5 cd 1c c1 e1 da  f0 bb f1 c8 13 cd 1c c1  |................|
; 00007fb0  da f0 bb c9 79 e6 f0 4f  56 23 78 a6 23 be 23 28  |....y..OV#x.#.#(|
; 00007fc0  06 23 15 20 f5 37 c9 7e  e6 f0 b9 20 f4 7e e6 0f  |.#. .7.~... .~..|
; 00007fd0  cb 5f cb 9f c9 21 5b be  cd 5d c0 7e 21 63 be cd  |._...![..].~!c..|
; 00007fe0  5d c0 cd f8 be 00 04 08  0c 11 1d 21 27 2a bb b0  |]..........!'*..|
; 00007ff0  c9 2a bd b0 c9 2a bf b0  c9 2a b9 b0 18 03 2a b7  |.*...*...*....*.|
; 00008000  b0 cb 7b 16 00 28 01 15  19 c9 2a c3 b0 c9 2a c3  |..{..(....*...*.|
; 00008010  b0 2b 2b c9 21 00 00 c9  f5 cd cf b1 5f 23 cd cf  |.++.!......._#..|
; 00008020  b1 57 f1 01 37 09 18 0e  2a 2f bf f5 16 00 cd cf  |.W..7...*/......|
; 00008030  b1 5f f1 01 37 06 23 18  2f 3e 00 b7 28 0f 3e 20  |._..7.#./>..(.> |
; 00008040  47 11 e4 ab 12 13 10 fc  af 32 b0 be c9 22 2f bf  |G........2..."/.|
; 00008050  eb 21 38 b3 cd 1c c1 38  cf 21 56 b3 cd 1c c1 eb  |.!8....8.!V.....|
; 00008060  38 b6 cd c6 bf 08 20 c0  e5 dd 21 62 ac dd 71 ff  |8..... ...!b..q.|
; 00008070  dd 70 fe 79 e6 07 4f 06  00 21 f9 be 09 4e 21 0e  |.p.y..O..!...N!.|
; 00008080  bf 09 e9 5b 55 27 19 00  05 4c 27 cb 7b c8 dd 36  |...[U'...L'.{..6|
; 00008090  00 2d dd 23 af 93 5f c9  cd 01 bf 18 50 cd 01 bf  |.-.#.._.....P...|
; 000080a0  26 00 6b d5 cd b4 bf d1  5a dd 36 00 1f dd 23 18  |&.k.....Z.6...#.|
; 000080b0  3c 16 00 cb 7b 28 01 15  21 00 00 23 23 19 eb 0e  |<...{(..!..##...|
; 000080c0  00 0d 28 2b cd 25 b0 38  05 cd b9 bf 18 25 0d 28  |..(+.%.8.....%.(|
; 000080d0  1e 1b cd 25 b0 13 38 17  1b cd b9 bf 11 31 2b cd  |...%..8......1+.|
; 000080e0  bb bf 18 0f 2a 2f bf cd  cf b1 e6 38 5f 16 00 eb  |....*/.....8_...|
; 000080f0  cd b4 bf dd 36 00 c0 21  e4 ab e5 01 00 20 cd ab  |....6..!..... ..|
; 00008100  da e1 dd 21 60 ac cd e4  d8 dd 21 e4 ab ed 5b 2f  |...!`.....!...[/|
; 00008110  bf 3a 36 bf 3d 28 12 cd  25 b0 38 0d cd a5 d8 06  |.:6.=(..%.8.....|
; 00008120  09 dd e5 e1 cd 99 da 18  0d 3e 01 3d 20 08 eb cd  |.........>.= ...|
; 00008130  b0 bf dd 36 00 20 e1 c9  dd 23 0e 00 18 02 0e 01  |...6. ...#......|
; 00008140  c3 d6 e0 cb fa dd 72 00  dd 23 dd 73 00 dd 23 c9  |......r..#.s..#.|
; 00008150  cd cf b1 e6 c7 fe c7 47  0e 00 28 3b cd cf b1 0e  |.......G..(;....|
; 00008160  40 fe ed 28 2d 0e 00 fe  dd 20 04 cb e9 18 06 fe  |@..(-.... ......|
; 00008170  fd 20 19 cb e1 23 cd cf  b1 fe cb 20 16 cb f9 23  |. ...#..... ...#|
; 00008180  cd cf b1 5f 23 cd cf b1  47 e5 18 16 fe cb 20 03  |..._#...G..... .|
; 00008190  cb f9 23 cd cf b1 47 23  e5 cd cf b1 5f 23 cd cf  |..#...G#...._#..|
; 000081a0  b1 57 d5 79 fe 3f 30 13  fe 10 78 30 0c fe 18 28  |.W.y.?0...x0...(|
; 000081b0  0e fe c9 28 0a fe c3 28  06 fe e9 3e 00 20 02 3e  |...(...(...>. .>|
; 000081c0  01 32 b0 be c5 cd e6 da  08 c1 7e e6 1f 32 34 b1  |.2........~..24.|
; 000081d0  af 32 35 b1 2b 2b 2b 7e  e6 07 b1 4f d1 e6 07 21  |.25.+++~...O...!|
; 000081e0  55 d1 cd 5d c0 7e e1 85  6f d0 24 c9 d9 c5 d5 e5  |U..].~..o.$.....|
; 000081f0  d9 ed 73 a8 c0 3e 02 31  b0 b3 18 0c d9 c5 d5 e5  |..s..>.1........|
; 00008200  d9 ed 73 a8 c0 7e 23 f9  21 84 c0 c3 b0 c0 a7 3d  |..s..~#.!......=|
; 00008210  28 1f 08 af 62 6b ed 42  3f ce 00 e1 ed 52 28 03  |(...bk.B?....R(.|
; 00008220  3f ce 00 e1 a7 ed 42 ce  00 fe 02 37 20 03 08 18  |?.....B....7 ...|
; 00008230  dd 31 00 00 d9 e1 d1 c1  d9 c9 d9 08 d1 d1 d1 d1  |.1..............|
; 00008240  ed 5b 98 d0 01 e0 ab 3a  c2 b1 e6 07 28 53 fe 07  |.[.....:....(S..|
; 00008250  20 0a 7a fe c0 38 4a 11  ff bf 18 45 d5 c5 21 00  | .z..8J....E..!.|
; 00008260  3f 3d 28 10 21 40 7f d6  02 28 09 21 80 bf 3d 28  |?=(.!@...(.!..=(|
; 00008270  03 21 c0 ff ed 4b 12 c7  ed 5b 37 e0 7a bd 38 23  |.!...K...[7.z.8#|
; 00008280  7c b8 38 1f 78 ad e6 c0  28 03 01 00 c0 7a ac e6  ||.8.x...(....z..|
; 00008290  c0 28 03 11 ff ff cb f0  cb f8 cb f2 cb fa 08 3c  |.(.............<|
; 000082a0  08 d5 c5 08 d9 e9 d9 c5  d5 e5 d9 ed 73 a8 c0 7e  |............s..~|
; 000082b0  23 f9 21 2e c1 c3 b0 c0  3d 28 0f e1 b7 ed 52 e1  |#.!.....=(....R.|
; 000082c0  28 02 30 f4 a7 ed 52 3f  30 ee c3 a7 c0 cd b4 be  |(.0...R?0.......|
; 000082d0  e5 2a 50 b2 7d e6 e0 6f  3a 54 b2 e6 1f ca 12 b4  |.*P.}..o:T......|
; 000082e0  3d 28 0c 54 5d 08 cd b2  c4 cd da d3 08 18 f1 22  |=(.T].........."|
; 000082f0  57 df e1 e5 06 20 21 e3  ab cd 77 dd fe 20 30 02  |W.... !...w.. 0.|
; 00008300  3e 20 cd 38 df 10 f2 e1  c9 21 00 58 01 03 00 e5  |> .8.....!.X....|
; 00008310  c5 36 39 23 10 fb 0d 20  f8 cd 80 c2 c1 e1 7e fe  |.69#... ......~.|
; 00008320  39 20 16 e5 7c d6 0a 67  e6 07 28 05 7c d6 07 18  |9 ..|..g..(.|...|
; 00008330  f6 1e 08 77 24 1d 20 fb  e1 23 10 e2 0d 20 df 01  |...w$. ..#... ..|
; 00008340  00 00 dd 21 49 b2 dd 09  c5 3e 28 32 4b df cd ad  |...!I....>(2K...|
; 00008350  c2 3e 38 32 4b df cd d2  dd c1 fe 04 c8 21 7f c1  |.>82K........!..|
; 00008360  e5 06 07 fe 34 28 06 06  f9 fe 33 20 11 79 80 fe  |....4(....3 .y..|
; 00008370  f9 20 02 3e e7 fe ee 38  01 af 32 b6 c1 c9 dd 66  |. .>...8..2....f|
; 00008380  01 dd 6e 00 06 01 fe 38  28 1e fe 36 28 06 fe 37  |..n....8(..6(..7|
; 00008390  20 09 06 17 cd b2 c4 10  fb 18 10 fe 35 20 13 06  | ...........5 ..|
; 000083a0  1f cd a6 c4 10 fb 18 ea  cd a6 c4 dd 74 01 dd 75  |............t..u|
; 000083b0  00 c9 fe 61 38 19 fe 7b  30 15 d6 61 47 dd 7e 04  |...a8..{0..aG.~.|
; 000083c0  4f e6 1f a8 a9 cb 79 20  02 e6 e1 dd 77 04 c9 dd  |O.....y ....w...|
; 000083d0  56 03 dd 5e 04 21 63 c2  06 06 be 23 28 05 23 23  |V..^.!c....#(.##|
; 000083e0  10 f8 c9 7e a3 c8 23 7e  aa dd 77 03 c9 5c ff 80  |...~..#~..w..\..|
; 000083f0  5e ff 40 2a ff 20 3f ff  10 3e 40 08 7c 20 04 2a  |^.@*. ?..>@.| .*|
; 00008400  ed b4 dd 21 57 b2 06 20  18 06 dd 21 49 b2 06 22  |...!W.. ...!I.."|
; 00008410  22 7b c3 c5 cd a7 c2 01  07 00 dd 09 c1 10 f4 c9  |"{..............|
; 00008420  3e 28 cd 38 df e1 e5 cd  7b c4 3e 29 cd 36 df 18  |>(.8....{.>).6..|
; 00008430  2e dd 7e 04 e6 1f c8 af  32 f7 c3 cd 8c c3 dd 6e  |..~.....2......n|
; 00008440  05 dd 66 06 dd 7e 03 e6  03 3d 20 04 5e 23 56 eb  |..f..~...= .^#V.|
; 00008450  e5 dd 7e 02 fe d8 30 c8  fe 80 30 d0 cd 8d c4 3e  |..~...0...0....>|
; 00008460  3a cd 38 df d1 dd 7e 04  e6 1f 2a 57 df 01 ee c3  |:.8...~...*W....|
; 00008470  b7 c8 f5 e5 eb cd cf b1  5f 23 cd cf b1 57 eb dd  |........_#...W..|
; 00008480  7e 03 cb 5f 28 01 13 d5  5f e6 03 ca 9e c3 fe 03  |~.._(..._.......|
; 00008490  30 3d 16 04 dd cb 03 5e  c5 28 01 03 dd e5 dd 21  |0=.....^.(.....!|
; 000084a0  33 c4 0a 06 00 4f dd 09  cb 13 d5 e5 dc f6 c3 e1  |3....O..........|
; 000084b0  d1 dd e1 c1 03 03 15 20  db d1 e1 dd cb 03 56 28  |....... ......V(|
; 000084c0  0a cd b2 c4 22 57 df af  32 f7 c3 f1 3d 18 9e d1  |...."W..2...=...|
; 000084d0  e1 f1 cd 8c c3 07 07 07  6f 26 00 29 29 dd 7e 02  |........o&.)).~.|
; 000084e0  fe c4 28 17 fe a3 28 09  cd 36 df 2b 7c b5 20 ed  |..(...(..6.+|. .|
; 000084f0  c9 3e 00 c6 03 11 b2 e4  c3 90 c4 dd 7e 04 e6 1f  |.>..........~...|
; 00008500  47 cd be be 21 00 00 dd  e5 c5 cd af be cd 69 c1  |G...!.........i.|
; 00008510  c1 10 f6 dd e1 c9 dd 6e  00 dd 66 01 22 57 df c9  |.......n..f."W..|
; 00008520  73 7a 2d 68 2d 70 6e e3  f1 f1 7d 08 4d 06 04 cb  |sz-h-pn...}.M...|
; 00008530  6b cd 8c c3 e5 21 e2 c3  28 16 11 96 c3 cd 93 c4  |k....!..(.......|
; 00008540  e1 cd b2 c4 22 57 df 08  cd 54 c4 e1 c9 cd 34 df  |...."W...T....4.|
; 00008550  7e 23 a1 20 04 23 7e 18  02 7e 23 23 f5 07 dc 34  |~#. .#~..~##...4|
; 00008560  df f1 e6 7f cd 8d c4 10  e4 d1 e1 c9 40 94 20 01  |............@. .|
; 00008570  8b 1f 04 21 22 80 11 12  00 07 0e 15 20 1c 33 2f  |...!"....... .3/|
; 00008580  3e 00 b7 c4 34 df 3e 01  32 f7 c3 dd e9 cd 84 c4  |>...4.>.2.......|
; 00008590  cd 00 e1 18 1c cd 86 c4  cd f4 e0 18 14 cd 84 c4  |................|
; 000085a0  dd 36 00 23 dd 23 cd ec  e0 18 06 cd 86 c4 cd db  |.6.#.#..........|
; 000085b0  e0 21 06 ac 7e b7 c8 cd  38 df 23 18 f7 cd cc e0  |.!..~...8.#.....|
; 000085c0  28 cb 18 d9 cd cc e0 28  cc 18 e0 cd cc e0 20 bd  |(......(...... .|
; 000085d0  18 cb cd cc e0 20 be 18  d2 7c cd 54 c4 7d 4f 06  |..... ...|.T.}O.|
; 000085e0  08 af cb 11 ce 30 cd 38  df 10 f6 c9 7c cd 6c c4  |.....0.8....|.l.|
; 000085f0  af 65 32 f7 c3 7c 6f e6  7f fe 20 7d 30 04 e6 80  |.e2..|o... }0...|
; 00008600  f6 2e c3 38 df dd e5 cd  d0 e0 dd e1 18 a3 26 00  |...8..........&.|
; 00008610  dd 21 06 ac 0e 00 c9 11  f0 e5 cd 73 da 1a cb bf  |.!.........s....|
; 00008620  cd f9 de 20 02 d6 20 cd  36 df 1a 13 17 30 ee c9  |... .. .6....0..|
; 00008630  2c c0 7c c6 08 fe 58 67  c0 26 40 c9 7d c6 20 6f  |,.|...Xg.&@.}. o|
; 00008640  d0 18 ef 1b ff e3 0d ff  e3 1d ff e3 2d ff c9 0d  |............-...|
; 00008650  cf c1 0d c7 c0 0d f7 a0  42 c7 86 14 c7 86 23 c7  |........B.....#.|
; 00008660  86 02 cf 4b 4f c7 46 14  c7 46 23 c7 46 02 f7 45  |...KO.F..F#.F..E|
; 00008670  45 ff 3a 07 fe 34 14 fe  34 23 fe 34 02 ff 2a 0f  |E.:..4..4#.4..*.|
; 00008680  ff 2a 1f ff 2a 2f ff 1a  01 ff 0a 00 87 06 94 87  |.*..*/..........|
; 00008690  06 a3 87 06 82 1e ff e3  0d ff e3 1d ff e3 2d ff  |..............-.|
; 000086a0  cd 0e c7 c7 0e cf c5 0e  c7 c4 0e f7 a0 41 87 86  |.............A..|
; 000086b0  94 87 86 a3 87 86 82 f8  70 14 f8 70 23 f8 70 02  |........p..p#.p.|
; 000086c0  cf 43 4f ff 36 14 ff 36  23 ff 36 02 fe 34 14 fe  |.CO.6..6#.6..4..|
; 000086d0  34 23 fe 34 02 ff 32 07  ff 22 0f ff 22 1f ff 22  |4#.4..2.."..".."|
; 000086e0  2f ff 12 01 c7 06 94 c7  06 a3 c7 06 82 ff 02 00  |/...............|
; 000086f0  0e ff e9 16 ff e9 25 ff  e9 04 ff cd 01 ff c9 02  |......%.........|
; 00008700  c7 c7 03 c7 c4 01 ff c3  01 c7 c2 01 c7 c0 02 f7  |................|
; 00008710  45 47 e7 20 00 ff 18 00  ff 10 00 1c 21 25 28 2d  |EG. ........!%(-|
; 00008720  2e 3f 41 43 45 47 49 4c  55 57 5f 63 68 6f 75 78  |.?ACEGILUW_choux|
; 00008730  7b 82 85 86 8b 23 91 4c  65 6e 67 68 f4 46 69 72  |{....#.Lengh.Fir|
; 00008740  73 f4 4c 61 73 f4 4d 65  6d 6f 72 f9 6c e4 20 55  |s.Las.Memor.l. U|
; 00008750  4e 49 56 45 52 53 55 4d  20 43 6f 6e 74 72 6f ec  |NIVERSUM Contro.|
; 00008760  4f 4e a0 4f 46 c6 4e 4f  ce 44 45 c6 41 4c cc 43  |ON.OF.NO.DE.AL.C|
; 00008770  61 6c ec 52 65 61 64 2f  57 72 69 74 e5 52 75 ee  |al.Read/Writ.Ru.|
; 00008780  49 6e 74 65 72 72 75 70  f4 45 52 52 4f d2 4e 6f  |Interrup.ERRO.No|
; 00008790  20 72 75 ee 4e 6f 20 77  72 69 74 e5 4e 6f 20 72  | ru.No writ.No r|
; 000087a0  65 61 e4 44 65 66 e2 44  65 66 f7 77 69 6e 64 6f  |ea.Def.Def.windo|
; 000087b0  77 73 ba 57 69 74 e8 54  ef 4c 65 61 64 65 f2 31  |ws.Wit.T.Leade.1|
; 000087c0  2e 20 62 79 74 65 ba 20  4d 65 6d 50 61 67 65 ba  |. byte. MemPage.|
; 000087d0  53 cf 99 d3 3e e2 2d c9  59 c7 80 c8 50 ce 8c d3  |S...>.-.Y...P...|
; 000087e0  7a c6 b7 c6 52 c7 ad cd  19 d3 b7 11 b7 11 01 c9  |z...R...........|
; 000087f0  27 d3 21 d4 7a cc d9 ca  69 c7 85 cd 91 d3 0a cb  |'.!.z...i.......|
; 00008800  f0 c6 10 c8 cd 70 c7 eb  2a 37 e0 ed 4b 12 c7 b7  |.....p..*7..K...|
; 00008810  ed 42 44 4d 19 da ee d7  d5 eb 2a 95 ce b7 ed 52  |.BDM......*....R|
; 00008820  da ee d7 d1 2a 12 c7 e5  d5 cd 7c ad e1 22 12 c7  |....*.....|.."..|
; 00008830  e5 01 1a 00 09 cd 34 c7  e1 d1 eb cd 66 bd c3 9b  |......4.....f...|
; 00008840  e1 06 00 cd 7f d3 28 11  cd 70 c7 ed 5b 37 e0 cd  |......(..p..[7..|
; 00008850  77 ad da ee d7 22 95 ce  c9 21 00 40 cd bf dd 21  |w...."...!.@...!|
; 00008860  95 e4 cd 68 d8 2a 12 c7  cd 16 e2 21 a2 e4 cd 68  |...h.*.....!...h|
; 00008870  d8 2a 95 ce cd 16 e2 c3  4e d4 cd 70 c7 e5 21 00  |.*......N..p..!.|
; 00008880  40 cd bf dd 21 ab e4 cd  68 d8 cd 8c d3 e1 e5 cd  |@...!...h.......|
; 00008890  16 e2 cd 08 df cd 8c d3  e1 18 d9 21 00 c0 06 0d  |...........!....|
; 000088a0  cd 44 c7 cd 34 c7 06 07  cd 44 c7 22 a6 df cd 2a  |.D..4....D."...*|
; 000088b0  c7 22 37 e0 af cd 29 ae  23 cd 29 ae 23 c9 22 27  |."7...).#.).#."'|
; 000088c0  e2 22 79 d8 22 7c d8 22  17 da 22 c0 c8 c9 af cd  |."y."|."..".....|
; 000088d0  29 ae 23 3e 30 cd 29 ae  23 10 f3 c9 2a 27 e2 22  |).#>0.).#...*'."|
; 000088e0  17 da c9 cd 61 c7 cd d9  d9 18 f4 2a a6 df 11 f4  |....a......*....|
; 000088f0  ff 19 c9 cd 70 c7 22 9f  d0 c9 21 3f ac 11 10 ac  |....p."...!?....|
; 00008900  d5 0e 1e cd 41 dd d1 21  00 00 3e 2b dd 21 e4 ab  |....A..!..>+.!..|
; 00008910  e5 f5 cd 5c dc da 02 d8  fe 2b 28 07 32 e4 c7 fe  |...\.....+(.2...|
; 00008920  2d 20 03 cd 5c dc fe 24  2a 3b af 28 35 cd f9 de  |- ..\..$*;.(5...|
; 00008930  20 35 1b d5 dd e5 eb cd  79 df 3e 09 da 13 d8 dd  | 5......y.>.....|
; 00008940  e1 eb cd a5 d8 cd e9 ad  e6 c0 3e 09 ca 13 d8 1b  |..........>.....|
; 00008950  eb cd e9 ad 57 2b cd e9  ad 5f c1 2a 06 ac 26 00  |....W+..._.*..&.|
; 00008960  09 eb cd 5c dc 18 03 cd  e3 db f5 d5 eb 3e 00 cd  |...\.........>..|
; 00008970  b8 d2 e1 c1 f1 e3 c5 cd  77 d2 f1 d1 d8 18 91 e5  |........w.......|
; 00008980  cd 60 e1 2a 27 e2 cd 2e  e2 38 0d 11 0c c8 01 02  |.`.*'....8......|
; 00008990  00 cd 8d e2 18 ed 00 30  e1 c9 06 3a cd 7f d3 11  |.......0...:....|
; 000089a0  95 c9 cc ec c8 dd 2a 17  da dd 22 c0 c8 cd cf d8  |......*...".....|
; 000089b0  21 e4 ab 11 3e ac 3e 01  12 13 0e 1f e5 d5 eb cd  |!...>.>.........|
; 000089c0  65 c9 d1 30 18 21 94 c9  46 23 7e cd f2 d3 10 f9  |e..0.!..F#~.....|
; 000089d0  e1 3a 79 c9 47 cd 78 dd  23 10 fa 18 df e1 cd 78  |.:y.G.x.#......x|
; 000089e0  dd 23 b7 28 05 cd f2 d3  18 d2 3c 12 32 94 d5 3d  |.#.(......<.2..=|
; 000089f0  0c 12 0d 20 fc 21 74 c8  22 ae d5 c3 52 d5 21 40  |... .!t."...R.!@|
; 00008a00  d4 22 ae d5 cd b6 c8 c3  a9 d5 2a 17 da 22 c0 c8  |."........*.."..|
; 00008a10  06 53 cd 7f d3 20 13 af  ed 5b 27 e2 1b 1b ed 53  |.S... ...['....S|
; 00008a20  c0 c8 32 d6 c8 cd 82 d3  18 0b 06 42 cd 86 d3 20  |..2........B... |
; 00008a30  04 3e 01 18 e3 06 3a cd  86 d3 11 7a c9 cc ec c8  |.>....:....z....|
; 00008a40  cd f3 e1 21 58 c9 22 e3  c8 21 00 00 cd ee d9 22  |...!X."..!....."|
; 00008a50  c0 c8 cd 54 1f d2 5f d4  cd 2e e2 d0 e5 dd e1 3e  |...T.._........>|
; 00008a60  00 b7 28 05 cd 84 d8 38  0b cd cf d8 cd 58 c9 2a  |..(....8.....X.*|
; 00008a70  c0 c8 38 4f 18 d3 06 00  d5 cd 78 dd 23 b7 28 07  |..8O......x.#.(.|
; 00008a80  f6 20 12 13 04 18 f2 e1  2b 70 c9 cd 7d d3 3e 00  |. ......+p..}.>.|
; 00008a90  20 01 3c 32 d6 c8 2a 27  e2 2b 2b 22 c0 c8 21 19  | .<2..*'.++"..!.|
; 00008aa0  c9 18 a3 cd a2 b0 3e 03  cd 01 16 fb 21 10 00 cd  |......>.....!...|
; 00008ab0  4d da 3e 0d d7 af c9 cd  78 d8 cd 3d c9 22 79 d8  |M.>.....x..=."y.|
; 00008ac0  22 7c d8 22 17 da c9 01  01 00 cd 77 ad 30 06 03  |"|.".......w.0..|
; 00008ad0  cd ee d9 18 f5 cd 78 d8  cd f5 c7 cd 2e e2 cc d9  |......x.........|
; 00008ae0  d9 c9 11 e4 ab d5 cd 65  c9 d1 d8 13 20 f7 c9 21  |.......e.... ..!|
; 00008af0  79 c9 46 23 1a 13 3d 28  fb 3c c8 ae e6 df c0 10  |y.F#..=(.<......|
; 00008b00  f2 37 c9 00 00 00 00 00  00 00 00 00 00 00 00 00  |.7..............|
; 00008b10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00008b20  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
; 00008b30  00 00 00 00 00 00 00 00  32 be c9 3e 10 f5 08 78  |........2..>...x|
; 00008b40  b1 ca 37 d4 08 c5 e5 0e  00 cd b0 22 22 57 df e1  |..7........""W..|
; 00008b50  e5 11 00 00 a7 ed 52 eb  cd 48 ca 2b 23 cd e9 ad  |......R..H.+#...|
; 00008b60  23 e5 f5 cd e9 ad 67 f1  6f 7c e6 3f 67 ed 52 e1  |#.....g.o|.?g.R.|
; 00008b70  28 0a 0b 78 b1 20 e5 3e  10 c3 13 d8 cd e9 ad 4f  |(..x. .>.......O|
; 00008b80  e1 cd e9 ad 5f 23 cd e9  ad 57 23 d5 eb 21 e4 ab  |...._#...W#..!..|
; 00008b90  36 20 cb 79 28 02 36 2a  23 c5 06 09 cd 99 da c1  |6 .y(.6*#.......|
; 00008ba0  eb e3 eb 79 e6 c0 20 09  01 2e 05 cd ab da 70 18  |...y.. .......p.|
; 00008bb0  09 e5 dd e1 eb 0e 00 cd  d6 e0 21 e4 ab cd 1c e2  |..........!.....|
; 00008bc0  3e 00 b7 c4 19 c9 e1 c1  0b f1 c6 08 fe a9 da b3  |>...............|
; 00008bd0  c9 c9 2a a6 df cd e9 ad  4f 23 cd e9 ad 47 23 c9  |..*.....O#...G#.|
; 00008be0  06 50 cd 86 d3 f5 3e 01  28 01 3d 32 37 ca 11 07  |.P....>.(.=27...|
; 00008bf0  ac 3e 20 12 32 0f ac f1  06 3a b8 c4 82 d3 20 13  |.> .2....:.... .|
; 00008c00  01 df 08 cd 62 cd 21 07  ac 7e 23 fe 20 20 fa 2b  |....b.!..~#.  .+|
; 00008c10  2b cb fe 21 40 58 3e 38  08 3e 30 0e 14 06 20 77  |+..!@X>8.>0... w|
; 00008c20  23 10 fc 08 0d 20 f6 cd  48 ca 09 09 22 c8 c9 cd  |#.... ..H..."...|
; 00008c30  2d e0 c5 e5 3e 0e cd f5  e1 e1 c1 78 b1 28 1e d9  |-...>......x.(..|
; 00008c40  3e 10 f5 cd ba dd f1 c6  08 fe a9 38 f5 d9 af cd  |>..........8....|
; 00008c50  ae c9 3e 88 cd ae c9 d9  cd 03 de fe 20 ca 3a d4  |..>......... .:.|
; 00008c60  d9 18 d8 06 43 cd 7f d3  28 49 06 4c cd 86 d3 0e  |....C...(I.L....|
; 00008c70  ff 28 0a 06 55 cd 86 d3  c2 56 ca 0e bf 79 32 02  |.(..U....V...y2.|
; 00008c80  cb cd 48 ca 78 b1 c8 23  cd e9 ad cb ff cd 29 ae  |..H.x..#......).|
; 00008c90  23 0b 18 f0 06 79 cd 7f  d3 28 09 06 66 cd 86 d3  |#....y...(..f...|
; 00008ca0  ca 1c d4 c9 2a 27 e2 22  79 d8 cd 61 c7 22 7c d8  |....*'."y..a."|.|
; 00008cb0  cd 2d c9 cd f3 e1 cd 67  cb 2a 27 e2 cd 43 cc 30  |.-.....g.*'..C.0|
; 00008cc0  22 e5 f5 cd e9 ad 6f f1  e6 7f 67 29 ed 5b a6 df  |".....o...g).[..|
; 00008cd0  19 23 f5 cd e9 ad cb f7  cd 29 ae f1 e1 23 cd 54  |.#.......)...#.T|
; 00008ce0  cc 18 dc cd 48 ca e5 09  09 22 85 cb e1 78 b1 20  |....H...."...x. |
; 00008cf0  05 0e b7 c3 f3 ca 0b 22  28 cc cd e9 ad 5f 23 cd  |......."(...._#.|
; 00008d00  e9 ad 57 e6 c0 7a 23 20  e4 e6 3f 57 c5 e5 21 00  |..W..z# ..?W..!.|
; 00008d10  00 19 ed 53 d8 cb 54 5d  13 13 eb cd e9 ad 23 07  |...S..T]......#.|
; 00008d20  30 f9 eb cd 14 e3 cd 66  bd 21 37 e0 cd a4 e1 e1  |0......f.!7.....|
; 00008d30  c5 54 5d 2b 2b cd 14 e3  01 02 00 21 85 cb cd a4  |.T]++......!....|
; 00008d40  e1 21 37 e0 cd a4 e1 c1  c5 03 03 cd ce e1 2a a6  |.!7...........*.|
; 00008d50  df e5 03 cd 37 e1 dd e1  c1 7a b3 28 16 d5 cd 2e  |....7....z.(....|
; 00008d60  cc 11 00 00 a7 ed 52 38  06 dd e5 e1 cd 37 e1 d1  |......R8.....7..|
; 00008d70  1b 18 e6 2a 28 cc ed 5b  a6 df ed 52 eb cb 3a cb  |...*(..[...R..:.|
; 00008d80  1b 2a 27 e2 cd 43 cc 30  28 e5 f5 cd e9 ad 6f f1  |.*'..C.0(.....o.|
; 00008d90  67 e5 cb bc b7 ed 52 e1  30 07 e1 23 cd 54 cc 18  |g.....R.0..#.T..|
; 00008da0  e6 2b 44 4d e1 79 cd 29  ae 2b 78 cd 29 ae 23 18  |.+DM.y.).+x.).#.|
; 00008db0  ea 21 00 00 c1 c3 63 cb  dd 23 dd 23 dd e5 e1 cd  |.!....c..#.#....|
; 00008dc0  e9 ad f5 23 cd e9 ad e6  3f 67 f1 6f c9 cd 2e e2  |...#....?g.o....|
; 00008dd0  d0 23 cd e9 ad e6 0f 23  28 f3 e6 08 20 0d cd e9  |.#.....#(... ...|
; 00008de0  ad 23 fe c0 30 e7 fe 80  38 f4 2b cd e9 ad 23 37  |.#..0...8.+...#7|
; 00008df0  c9 3e 61 ee 03 32 68 cc  32 f5 f3 c3 4f f4 21 a7  |.>a..2h.2...O.!.|
; 00008e00  ce 71 f1 c9 dd 21 82 ac  dd 36 00 03 cd 7d d3 f5  |.q...!...6...}..|
; 00008e10  06 41 cd 86 d3 28 da 0e  01 06 44 cd 86 d3 28 de  |.A...(....D...(.|
; 00008e20  0d 06 54 cd 86 d3 28 d6  0d 06 3a b8 28 03 cd 82  |..T...(...:.(...|
; 00008e30  d3 20 03 cd 5c cd 21 7b  cd 11 83 ac 01 0a 00 ed  |. ..\.!{........|
; 00008e40  b0 f1 28 0d 2a a6 df 11  f4 ff 19 ed 5b 27 e2 18  |..(.*.......['..|
; 00008e50  07 cd 78 d8 eb cd ee d9  d5 ed 53 91 cd b7 ed 52  |..x.......S....R|
; 00008e60  e5 22 94 cd 22 91 ac 2a  37 e0 ed 5b a6 df a7 1b  |.".."..*7..[....|
; 00008e70  ed 52 22 cd af d5 dd e1  e5 dd e5 cd 50 ae 22 c5  |.R".........P.".|
; 00008e80  af 7a 32 c8 af dd e1 dd  23 cd 50 ae 22 d9 ae 7a  |.z2.....#.P."..z|
; 00008e90  32 dc ae e1 2b d1 d5 19  23 23 22 8d ac cd a6 ce  |2...+...##".....|
; 00008ea0  c2 52 f5 3e 0c cd f5 e1  dd 21 82 ac cd 3a cd d1  |.R.>.....!...:..|
; 00008eb0  dd e1 dd 2b d9 cd 50 ae  d9 3e ff cd 76 af cd c3  |...+..P..>..v...|
; 00008ec0  af c3 a2 b0 26 01 23 24  25 20 fb af db fe 2f e6  |....&.#$% ..../.|
; 00008ed0  1f 28 f8 11 11 00 af cd  c6 04 1b 15 14 20 fb c9  |.(........... ..|
; 00008ee0  06 3a cd 7f d3 c0 11 7b  cd 01 ff 0a cd 78 dd 23  |.:.....{.....x.#|
; 00008ef0  b7 28 0b fe 40 38 01 a1  12 13 05 20 ef c9 3e 20  |.(..@8..... ..> |
; 00008f00  12 13 10 fc c9 70 72 6f  6d 65 74 68 65 75 73 cd  |.....prometheus.|
; 00008f10  2f d3 cd 6d d3 20 f8 af  3d dd 21 00 00 11 00 00  |/..m. ..=.!.....|
; 00008f20  cd a1 cd cd d7 ae cd a2  b0 18 03 cd 8f b0 d8 3e  |...............>|
; 00008f30  0d cd f5 e1 c3 1e d8 cd  e9 e1 cd 48 ca 78 b1 28  |...........H.x.(|
; 00008f40  62 21 fe cd 22 ae d5 21  00 00 e5 e5 dd e1 cd ee  |b!.."..!........|
; 00008f50  d9 22 be cd e1 11 00 00  a7 ed 52 30 3f 3e 21 21  |."........R0?>!!|
; 00008f60  00 00 cd 9f ce cd cf d8  3e 2a 21 a6 df cd 9f ce  |........>*!.....|
; 00008f70  3a 73 d4 fe 10 28 ba 21  e4 ab 11 3e ac 01 20 00  |:s...(.!...>.. .|
; 00008f80  ed b0 cd a5 da c3 52 d5  cd 0c da ed 5b be cd 2a  |......R.....[..*|
; 00008f90  37 e0 a7 ed 52 38 b0 3e  07 c3 13 d8 21 40 d4 22  |7...R8.>....!@."|
; 00008fa0  ae d5 e9 ed 5b be cd 2a  d6 cd 2b 2b cd 66 bd eb  |....[..*..++.f..|
; 00008fb0  ed 5b 27 e2 eb cd 34 c7  eb cd 7c ad eb 06 06 cd  |.['...4...|.....|
; 00008fc0  44 c7 22 a6 df e5 13 13  2a 95 ce cd 66 bd eb d1  |D.".....*...f...|
; 00008fd0  cd 7c ad ed 53 37 e0 c3  40 d4 cd e9 e1 21 8e ce  |.|..S7..@....!..|
; 00008fe0  22 ae d5 06 01 11 3e ac  2a be cd 23 23 7e 23 fe  |".....>.*..##~#.|
; 00008ff0  0d 28 11 cb 68 20 f6 fe  20 30 02 3e 20 e6 7f 12  |.(..h .. 0.> ...|
; 00009000  13 04 18 e9 22 be cd 3e  01 12 13 af 12 04 cb 68  |...."..>.......h|
; 00009010  28 f8 cd a5 da c3 52 d5  cd 0c da 2a be cd 11 ff  |(.....R....*....|
; 00009020  ff a7 ed 52 38 bd c3 12  ce 32 a5 d8 22 a6 d8 c9  |...R8....2.."...|
; 00009030  3e 01 b7 c9 cd a6 ce c2  61 f4 cd 2f d3 cd 60 d3  |>.......a../..`.|
; 00009040  20 f2 dd 21 82 ac cd c7  ce cd a1 cd 3e 07 d3 fe  | ..!........>...|
; 00009050  c9 dd 6e 0b dd 66 0c 44  4d cd dd d7 eb 2a 95 ce  |..n..f.DM....*..|
; 00009060  a7 ed 52 e5 22 be cd dd  4e 0f dd 46 10 09 22 cc  |..R."...N..F..".|
; 00009070  cd 23 23 22 d6 cd dd e1  37 9f c9 cd f3 e1 cd 7d  |.##"....7......}|
; 00009080  d3 3e 00 28 01 3c 32 35  cf cd 67 cb 3e 01 32 45  |.>.(.<25..g.>.2E|
; 00009090  cf 3e 10 32 63 af 21 f9  d0 22 3f cf 2a 98 d0 23  |.>.2c.!.."?.*..#|
; 000090a0  22 3b af 22 47 af 2a 27  e2 cd 2e e2 30 20 22 15  |";."G.*'....0 ".|
; 000090b0  d1 cd 54 1f d2 5f d4 e5  cd db e2 dd e1 e5 3e 00  |..T.._........>.|
; 000090c0  b7 20 05 cd 84 d8 38 03  cd f9 d0 e1 18 db 3e 00  |. ....8.......>.|
; 000090d0  3d 32 45 cf 21 ee cf 22  3f cf 28 c0 c9 cd f1 ce  |=2E.!.."?.(.....|
; 000090e0  3e 0b c3 4b d4 dd 7e 00  cd 5d d1 d6 02 d8 20 11  |>..K..~..].... .|
; 000090f0  cd f8 d1 22 71 af 3a 63  af 32 6a af 21 2a d4 35  |..."q.:c.2j.!*.5|
; 00009100  c9 3d c8 3d ca 85 d1 3d  20 1f cd f8 d1 78 b7 20  |.=.=...= ....x. |
; 00009110  15 79 fe 08 30 10 fe 02  ca fa d7 fe 05 ca fa d7  |.y..0...........|
; 00009120  c6 10 32 63 af c9 c3 8c  d1 3d 20 0d cd f8 d1 da  |..2c.....= .....|
; 00009130  3b d0 cd 3b d0 dd 23 18  f3 3d 20 2b cd c7 cf 20  |;..;..#..= +... |
; 00009140  05 cd 43 d0 18 f6 7b fe  27 20 02 cb fa 7a c3 43  |..C...{.' ...z.C|
; 00009150  d0 cd 99 d8 dd cb 04 7e  c0 7a fe 22 20 04 bb cc  |.......~.z." ...|
; 00009160  99 d8 dd cb 04 7e c9 3d  ca ac d1 cd f8 d1 da ae  |.....~.=........|
; 00009170  d0 cd ae d0 dd 23 18 f3  dd 21 82 ac dd 46 01 78  |.....#...!...F.x|
; 00009180  e6 30 fe 30 ca 5b cf 78  e6 b0 fe 90 38 06 cd 0a  |.0.0.[.x....8...|
; 00009190  d0 c3 43 af 3e dd cb 68  c4 43 d0 3e fd cb 60 c4  |..C.>..h.C.>..`.|
; 000091a0  43 d0 3e cb cb 78 c4 43  d0 3e ed cb 70 c4 43 d0  |C.>..x.C.>..p.C.|
; 000091b0  dd 7e 00 cd 43 d0 cd 5d  d1 78 e6 07 c8 3d f5 cd  |.~..C..].x...=..|
; 000091c0  f8 d1 f1 20 70 78 3c e6  fe c2 d4 d0 79 f5 3a 48  |... px<.....y.:H|
; 000091d0  af fe c0 38 3f 3a 63 af  e6 07 28 38 fe 07 28 2c  |...8?:c...(8..(,|
; 000091e0  2a 47 af 16 c0 3d 28 0d  d6 02 16 80 28 07 3d 16  |*G...=(.....(.=.|
; 000091f0  40 28 02 16 00 1e 00 b7  ed 52 ed 5b 12 c7 cd 77  |@(.......R.[...w|
; 00009200  ad 38 09 ed 5b 37 e0 cd  77 ad 38 25 f1 ed 5b 47  |.8..[7..w.8%..[G|
; 00009210  af c3 31 af f1 11 e0 ab  2a 47 af cd 77 ad eb 38  |..1.....*G..w..8|
; 00009220  07 21 98 f6 ed 52 30 09  21 ff ff a7 ed 52 d2 31  |.!...R0.!....R.1|
; 00009230  af 3e 08 18 69 3d 20 07  79 cd 43 d0 78 18 8e 3d  |.>..i= .y.C.x..=|
; 00009240  20 20 2a 3b af 23 c5 e3  c1 a7 ed 42 7d 24 28 0a  |  *;.#.....B}$(.|
; 00009250  25 20 0b fe 80 30 07 c3  43 d0 fe 80 30 f9 3e 03  |% ...0..C...0.>.|
; 00009260  18 3c 3d 20 04 60 69 18  e3 3d 20 0b cd db d0 dd  |.<= .`i..= .....|
; 00009270  23 cd f8 d1 c3 3b d0 79  e6 c7 b0 3e 06 20 1f 79  |#....;.y...>. .y|
; 00009280  c3 52 af dd 21 82 ac dd  cb 01 5e 28 2e cd a2 d8  |.R..!.....^(....|
; 00009290  ed 53 76 d1 cd e9 ad 4f  e6 c0 28 0b 3e 12 21 00  |.Sv....O..(.>.!.|
; 000092a0  00 22 17 da c3 13 d8 79  cb f7 cd 29 ae 2a 3b af  |.".....y...).*;.|
; 000092b0  eb 2b 7a cd 29 ae 2b 7b  cd 29 ae dd 7e 01 e6 30  |.+z.).+{.)..~..0|
; 000092c0  fe 30 28 2d dd 7e 01 e6  07 4f 06 00 21 55 d1 09  |.0(-.~...O..!U..|
; 000092d0  7e 3c 01 00 04 dd 56 01  cb 12 89 10 fb 18 72 00  |~<....V.......r.|
; 000092e0  01 02 01 01 02 00 00 dd  cb 01 5e c8 dd 23 dd 23  |..........^..#.#|
; 000092f0  c9 dd 7e 00 cd 5d d1 d6  03 d8 20 10 cd f8 d1 21  |..~..].... ....!|
; 00009300  00 00 2b 78 cd 29 ae 2b  79 c3 29 ae 3d 20 0c cd  |..+x.).+y.).= ..|
; 00009310  f8 d1 ed 43 3b af ed 43  47 af c9 3d c8 3d 20 06  |...C;..CG..=.= .|
; 00009320  cd d0 d1 79 18 2b 3d 20  0a 4f 0c cd c7 cf 28 fa  |...y.+= .O....(.|
; 00009330  79 18 1e 3d 20 16 cd f8  d1 f5 21 3b af cd c4 e1  |y..= .....!;....|
; 00009340  21 47 af cd c4 e1 f1 dd  23 30 eb c9 cd d0 d1 79  |!G......#0.....y|
; 00009350  81 06 00 4f 21 3b af c3  c4 e1 0e 01 dd 7e 02 fe  |...O!;.......~..|
; 00009360  2c 20 03 0c 18 0d fe 22  20 0d dd 23 dd 7e 02 fe  |, ....." ..#.~..|
; 00009370  22 20 f7 dd 23 18 e5 fe  c0 d0 fe 80 38 f5 dd 23  |" ..#.......8..#|
; 00009380  18 f1 21 00 00 3e 2b e5  f5 dd 7e 02 f5 fe 2d 20  |..!..>+...~...- |
; 00009390  02 dd 23 dd 7e 02 fe 24  ed 5b 3b af 28 29 fe 80  |..#.~..$.[;.()..|
; 000093a0  da c3 d2 57 dd 5e 03 dd  23 cd a5 d8 cd e9 ad e6  |...W.^..#.......|
; 000093b0  c0 20 09 ed 53 3c d8 3e  09 c3 14 d1 1b eb cd e9  |. ..S<.>........|
; 000093c0  ad 57 2b cd e9 ad 5f dd  23 18 2c dd 7e 02 ee 2c  |.W+..._.#.,.~..,|
; 000093d0  44 4d c8 ee 33 c8 fe c0  3f d8 ee 1f dd 23 c3 fd  |DM..3...?....#..|
; 000093e0  d1 11 00 00 dd 23 cd 05  d3 38 0a 5f cd 05 d3 38  |.....#...8._...8|
; 000093f0  04 53 5f dd 23 eb eb f1  cd b8 d2 f1 e1 01 41 d2  |.S_.#.........A.|
; 00009400  c5 fe 2b 28 38 fe 2d 28  36 fe 2a 28 1f fe 2f 28  |..+(8.-(6.*(../(|
; 00009410  15 7c 4d 21 00 00 06 10  cb 31 17 ed 6a ed 52 30  |.|M!.....1..j.R0|
; 00009420  02 19 0d 10 f3 c9 cd 87  d2 67 69 c9 06 10 7c 4d  |.........gi...|M|
; 00009430  21 00 00 29 cb 11 17 30  01 19 10 f7 c9 19 c9 b7  |!..)...0........|
; 00009440  ed 52 fe 2d c0 7a 2f 57  7b 2f 5f 13 c9 dd 7e 02  |.R.-.z/W{/_...~.|
; 00009450  fe 22 28 8d 0e 0a fe 25  20 04 dd 23 0e 02 fe 23  |."(....% ..#...#|
; 00009460  20 04 dd 23 0e 10 21 00  00 dd 7e 02 d6 30 fe 0a  | ..#..!...~..0..|
; 00009470  38 07 d6 07 fe 0a da 6c  d2 b9 d2 6c d2 f5 79 3d  |8......l...l..y=|
; 00009480  54 5d 19 3d 20 fc f1 16  00 5f 19 dd 23 18 da dd  |T].= ...._..#...|
; 00009490  7e 02 fe 22 20 09 dd be  03 dd 23 28 02 37 c9 dd  |~.." .....#(.7..|
; 000094a0  23 b7 c9 06 61 cd 7f d3  cc f1 ce cd 0d d4 c3 12  |#...a...........|
; 000094b0  b4 06 79 cd 7f d3 c0 c7  c7 dd 21 82 ac 11 11 00  |..y.......!.....|
; 000094c0  af 37 cd 94 b0 30 f2 3e  11 cd 30 d8 21 83 ac 06  |.7...0.>..0.!...|
; 000094d0  0a 7e fe 20 38 04 fe 80  38 02 3e 3f cd 0f df 23  |.~. 8...8.>?...#|
; 000094e0  10 ef 3a 82 ac fe 03 20  d0 c9 06 0a 21 7b cd 7e  |..:.... ....!{.~|
; 000094f0  fe 20 20 03 10 f9 c9 06  0a 21 7b cd 11 83 ac 1a  |.  ......!{.....|
; 00009500  be 23 13 c0 10 f9 c9 06  42 21 3f ac cd 78 dd 23  |.#......B!?..x.#|
; 00009510  b8 c8 cb e8 b8 c9 21 cd  e0 18 03 21 94 d5 7e ee  |......!....!..~.|
; 00009520  01 77 c9 fd 21 3a 5c cd  25 af ed 56 fb ed 7b 3d  |.w..!:\.%..V..{=|
; 00009530  5c c3 76 1b f5 0e 00 cd  b0 22 e5 cd da d3 d1 f1  |\.v......"......|
; 00009540  c9 e5 dd e1 cd 39 da 3e  ef db fe c9 cd d6 d9 cd  |.....9.>........|
; 00009550  25 e2 3f 18 06 cd eb d9  cd 2e e2 d1 d2 5f d4 d5  |%.?.........._..|
; 00009560  22 17 da c9 e5 d5 06 08  e5 d5 0e 20 7e 12 2c 1c  |".......... ~.,.|
; 00009570  0d 20 f9 d1 e1 24 14 10  ef d1 e1 c9 12 13 0d c0  |. ...$..........|
; 00009580  18 48 21 c0 50 22 57 df  01 01 20 1e 7e cd 12 d4  |.H!.P"W... .~...|
; 00009590  01 01 20 1e 20 18 05 1e  20 01 03 00 7b cd 38 df  |.. . ... ...{.8.|
; 000095a0  10 fa 0d 20 f7 c9 cd 11  c7 18 19 3e 01 32 2a d4  |... .......>.2*.|
; 000095b0  cd f1 ce 3e 00 b7 3e 13  c2 13 d8 cd 0d d4 cd 69  |...>..>........i|
; 000095c0  af cd 03 de f3 1e 7e cd  0f d4 21 e0 59 01 30 20  |......~...!.Y.0 |
; 000095d0  cd ab da 3e 0f cd f5 e1  21 e4 ab 01 00 9e cd ab  |...>....!.......|
; 000095e0  da 21 3e ac 36 01 2b 36  80 31 04 ad cd 16 da cd  |.!>.6.+6.1......|
; 000095f0  88 dd cd c2 ce cd 03 de  f5 cd 25 af 3e 0f cd f5  |..........%.>...|
; 00009600  e1 3e 0f 32 73 d4 f1 fe  15 28 bf fe 04 20 19 dd  |.>.2s....(... ..|
; 00009610  2a 17 da 21 3e ac e5 01  00 20 cd ab da e1 cd d2  |*..!>.... ......|
; 00009620  d8 3e 01 32 94 d5 18 07  fe 14 20 0a cd 91 d3 3e  |.>.2...... ....>|
; 00009630  0f cd f5 e1 18 b3 06 14  fe 06 20 07 cd cb d3 10  |.......... .....|
; 00009640  fb 18 a6 fe 09 20 2b cd  cb d3 11 40 40 3e 18 cd  |..... +....@@>..|
; 00009650  aa d3 c6 08 fe a9 38 f7  21 a0 50 cd bf dd 06 06  |......8.!.P.....|
; 00009660  2a 17 da cd ee d9 10 fb  cd b7 d3 cb 67 28 d8 c3  |*...........g(..|
; 00009670  65 d4 fe 07 20 07 cd c2  d3 10 fb 18 c4 fe 0a 20  |e... .......... |
; 00009680  2a cd c2 d3 11 a0 50 3e  a0 cd aa d3 d6 08 fe 10  |*.....P>........|
; 00009690  30 f7 21 40 40 cd bf dd  06 0d 2a 17 da cd d9 d9  |0.!@@.....*.....|
; 000096a0  10 fb cd b7 d3 cb 5f 28  d8 18 c4 fe 0c 20 16 01  |......_(..... ..|
; 000096b0  01 00 2a 17 da cd f5 c7  cd 25 e2 28 be d4 d9 d9  |..*......%.(....|
; 000096c0  22 17 da 18 b6 fe 0e 20  0e 2a 7c d8 22 79 d8 2a  |"...... .*|."y.*|
; 000096d0  17 da 22 7c d8 18 ec cd  b0 d5 20 cd 21 e0 5a 01  |.."|...... .!.Z.|
; 000096e0  3f 20 cd ab da 21 3e ac  cd 78 dd 16 00 0e 09 fe  |? ...!>..x......|
; 000096f0  80 38 13 21 40 d4 22 ae  d5 e5 62 6f 11 c4 c4 29  |.8.!@."...bo...)|
; 00009700  19 7e 23 66 6f e9 cd 5c  d6 cd eb d9 e5 22 b3 e1  |.~#fo..\....."..|
; 00009710  11 60 ac 1a 4f 13 cd 8d  e2 e1 22 17 da 3e 00 b7  |.`..O....."..>..|
; 00009720  28 0c cd d6 d9 22 17 da  01 01 00 cd 60 e1 3e 0f  |(...."......`.>.|
; 00009730  32 73 d4 af 32 94 d5 c3  40 d4 21 00 00 fe 0d c8  |2s..2...@.!.....|
; 00009740  fe 08 20 0c 46 2b 7e 07  38 27 4e 70 23 71 18 21  |.. .F+~.8'Np#q.!|
; 00009750  fe 0b 20 0a 46 23 7e a7  28 17 70 2b 77 c9 fe 03  |.. .F#~.(.p+w...|
; 00009760  20 11 54 5d 2b 7e fe 80  28 07 1a 77 23 13 b7 20  | .T]+~..(..w#.. |
; 00009770  f9 3c c9 fe 05 20 09 21  39 de 3e f7 96 77 18 f1  |.<... .!9.>..w..|
; 00009780  fe 20 d8 47 20 25 11 3e  ac 1a fe 3b 28 1d 07 38  |. .G %.>...;(..8|
; 00009790  1a e5 ed 52 3e 0d 95 e1  38 11 fe 05 38 02 d6 05  |...R>...8...8...|
; 000097a0  47 04 0e 20 cd ab da 36  01 18 c6 3e 00 b7 28 c1  |G.. ...6...>..(.|
; 000097b0  78 08 7e 08 77 fe c5 c8  fe c8 c8 fe cb c8 fe d7  |x.~.w...........|
; 000097c0  c8 23 08 b7 20 eb 18 a9  dd 21 63 ac dd 36 fe 01  |.#.. ....!c..6..|
; 000097d0  dd 36 ff 37 06 ff 18 03  cd 77 dd cd 30 e1 b7 20  |.6.7.....w..0.. |
; 000097e0  f7 dd 2b c3 64 d7 fe 3b  28 de fe 20 c4 39 dd cd  |..+.d..;(.. .9..|
; 000097f0  7f dd 11 38 ac 0e 05 cd  39 dd cd 7f dd 11 24 ac  |...8....9.....$.|
; 00009800  0e 12 cd 3d dd 20 04 23  32 37 ac 11 10 ac 0e 12  |...=. .#27......|
; 00009810  cd 41 dd cd 55 db 21 38  ac 7e b7 28 11 e5 cd e9  |.A..U.!8.~.(....|
; 00009820  dc 21 0f dd cd 23 dd e1  cd f1 dc da f6 d7 32 0e  |.!...#........2.|
; 00009830  d7 fe 3a 38 05 fe 3e da  76 d7 21 24 ac e5 cd e9  |..:8..>.v.!$....|
; 00009840  dc e1 78 3d 20 28 3a 0e  d7 fe 06 20 0e 7e d6 2f  |..x= (:.... .~./|
; 00009850  fe 04 d2 fa d7 b7 ca fa  d7 18 16 fe 11 28 08 fe  |.............(..|
; 00009860  26 28 04 fe 31 20 07 7e  d6 2f fe 09 18 e4 cd aa  |&(..1 .~./......|
; 00009870  dc 32 00 d7 21 10 ac cd  aa dc 32 f8 d6 af 32 36  |.2..!.....2...26|
; 00009880  d7 3e 00 cd 8d dc 87 87  5f 3e 00 cd 8d dc 57 06  |.>......_>....W.|
; 00009890  03 cb 23 cb 12 10 fa 3e  00 17 21 6a e6 01 af 02  |..#....>..!j....|
; 000098a0  23 08 23 08 23 23 ed a1  e2 11 d8 20 f3 08 7e 23  |#.#.##..... ..~#|
; 000098b0  ba 20 ef 7e e6 e0 bb 20  e9 2b 2b 2b 56 2b 5e 3e  |. .~... .+++V+^>|
; 000098c0  00 b7 28 04 cb aa cb e2  cd b0 da 3a 00 d7 fe 2c  |..(........:...,|
; 000098d0  11 24 ac d4 6a db 3a f8  d6 38 0b fe 2c 38 0f dd  |.$..j.:..8..,8..|
; 000098e0  36 00 1f dd 23 04 11 10  ac fe 2c d4 6a db 78 b7  |6...#.....,.j.x.|
; 000098f0  28 08 cb f8 cb f0 dd 70  00 3c c6 02 32 60 ac c9  |(......p.<..2`..|
; 00009900  f5 d6 34 5f 16 37 cd b0  da c5 21 23 ac af 4f 23  |..4_.7....!#..O#|
; 00009910  0c be 20 fb 11 10 ac 1a  b7 28 04 36 2c 23 af eb  |.. ......(.6,#..|
; 00009920  be 28 06 ed a0 0c 0c 18  f7 3e 12 b9 38 5e c1 f1  |.(.......>..8^..|
; 00009930  fe 3b 28 15 11 24 ac 3e  2c cd 6a db 1a b7 28 ae  |.;(..$.>,.j...(.|
; 00009940  dd 36 00 2c dd 23 04 18  ee 21 24 ac cd 06 d8 cd  |.6.,.#...!$.....|
; 00009950  30 e1 23 7e cd 30 e1 23  7e cd 30 e1 23 7e b7 20  |0.#~.0.#~.0.#~. |
; 00009960  f8 2b cd 06 d8 18 d7 e5  d5 2a 37 e0 09 38 09 ed  |.+.......*7..8..|
; 00009970  5b 95 ce ed 52 d1 e1 d8  af 32 c3 e2 3e 07 18 1d  |[...R....2..>...|
; 00009980  3e 01 18 19 3e 02 18 15  3e 03 18 11 3e 04 18 0d  |>...>...>...>...|
; 00009990  7e fe 27 c8 fe 22 c8 3e  05 18 02 3e 06 08 cd df  |~.'..".>...>....|
; 000099a0  f4 cd de de 08 cd f5 e1  cd a5 da 2a 17 da cd 2e  |...........*....|
; 000099b0  e2 cc d9 d9 22 17 da c3  5f d4 21 00 40 cd bf dd  |...."..._.!.@...|
; 000099c0  fe 09 20 23 f5 21 72 d8  11 72 d8 cd 77 ad 28 0d  |.. #.!r..r..w.(.|
; 000099d0  cd e9 ad f5 cd 36 df f1  cb 7f 23 28 f3 cc 68 d8  |.....6....#(..h.|
; 000099e0  21 72 d8 22 3c d8 f1 21  20 e3 cb 7e 23 28 fb 3d  |!r."<..! ..~#(.=|
; 000099f0  20 f8 7e cd 36 df cb 7e  23 28 f7 c9 53 79 6d 62  | .~.6..~#(..Symb|
; 00009a00  6f ec 21 00 00 11 00 00  cd 77 ad d8 eb c9 d9 dd  |o.!......w......|
; 00009a10  e5 cd 78 d8 44 4d e1 e5  af ed 42 e1 38 03 eb ed  |..x.DM....B.8...|
; 00009a20  52 d9 c9 dd 23 dd 56 02  dd 5e 03 c9 cd 9b d8 2a  |R...#.V..^.....*|
; 00009a30  a6 df e5 cb ba 19 19 cd  e9 ad 5f 23 cd e9 ad e6  |.........._#....|
; 00009a40  3f 57 e3 e5 eb e3 cd e9  ad 5f 23 cd e9 ad 57 23  |?W......._#...W#|
; 00009a50  eb 23 29 19 d1 19 eb e1  c9 21 e4 ab e5 01 00 20  |.#)......!..... |
; 00009a60  cd ab da dd e5 e1 cd db  e2 dd 21 82 ac e1 dd 7e  |..........!....~|
; 00009a70  00 3d 20 15 dd 7e 01 fe  37 20 0e dd 7e 02 fe c0  |.= ..~..7 ..~...|
; 00009a80  36 01 d0 dd 23 77 23 18  f2 06 09 dd cb 01 5e cc  |6...#w#.......^.|
; 00009a90  a1 da 28 0a e5 cd a2 d8  e1 06 09 cd 99 da e5 dd  |..(.............|
; 00009aa0  46 00 dd 7e 01 e6 f0 4f  cd e6 da e1 28 06 3e 10  |F..~...O....(.>.|
; 00009ab0  32 73 d4 c9 36 01 b7 c8  fe 3a 38 06 fe 3e 30 02  |2s..6....:8..>0.|
; 00009ac0  16 2c d5 11 b2 e4 cd 73  da 06 05 cd 9e da d1 36  |.,.....s.......6|
; 00009ad0  01 23 dd cb 01 5e 28 04  dd 23 dd 23 d5 7a cd 5e  |.#...^(..#.#.z.^|
; 00009ae0  d9 d1 7b b7 c8 36 2c 23  b7 c8 fe 2c 30 1e 11 f0  |..{..6,#...,0...|
; 00009af0  e5 cd 73 da 06 09 1a e6  7f 77 05 20 07 3e 10 32  |..s......w. .>.2|
; 00009b00  73 d4 f1 c9 1a e6 80 23  13 28 eb c9 f5 fe 2d 38  |s......#.(....-8|
; 00009b10  1e 36 28 23 fe 2e 38 17  36 69 23 06 78 fe 2f 38  |.6(#..8.6i#.x./8|
; 00009b20  02 06 79 70 23 dd 7e 02  fe 2d 28 03 36 2b 23 dd  |..yp#.~..-(.6+#.|
; 00009b30  7e 02 fe 1f 28 20 fe c0  30 1c fe 80 30 06 77 23  |~...( ..0...0.w#|
; 00009b40  dd 23 18 eb 57 dd 5e 03  dd 23 dd 23 e5 cd a5 d8  |.#..W.^..#.#....|
; 00009b50  e1 cd 7e da 18 d9 f1 dd  23 fe 2d d8 36 29 23 c9  |..~.....#.-.6)#.|
; 00009b60  2a 17 da 2b cd e9 ad fe  c0 38 08 e6 3f 5f 16 00  |*..+.....8..?_..|
; 00009b70  ed 52 2b 2b c9 2a 17 da  23 cd e9 ad 23 cb 5f 28  |.R++.*..#...#._(|
; 00009b80  04 23 23 18 03 e6 07 c8  cd e9 ad 23 fe c0 d0 fe  |.##........#....|
; 00009b90  80 38 f5 23 18 f2 af db  fe 2f e6 1f c8 cd a2 b0  |.8.#...../......|
; 00009ba0  21 00 00 06 0d cd d9 d9  10 fb 3e 10 f5 e5 e5 cd  |!.........>.....|
; 00009bb0  ba dd dd e1 cd 39 da e1  cd ee d9 f1 c6 08 fe a9  |.....9..........|
; 00009bc0  38 ea c9 dd e5 cd cf d8  dd e1 cd 84 d8 38 05 21  |8............8.!|
; 00009bd0  ec ab 36 a0 21 0f df 22  6f da 21 e4 ab 0e 00 7e  |..6.!.."o.!....~|
; 00009be0  23 3d 28 fb 3c c8 fe 22  20 03 0c 3e 22 cb 41 20  |#=(.<.." ..>".A |
; 00009bf0  07 cd f9 de 20 02 e6 ff  cd 0f df 18 e2 e5 eb 16  |.... ...........|
; 00009c00  00 5f 19 5e 19 eb e1 c9  06 09 eb cd e9 ad eb 77  |._.^...........w|
; 00009c10  05 20 07 3e 10 32 73 d4  f1 c9 cb be e6 80 23 13  |. .>.2s.......#.|
; 00009c20  28 e8 c9 cd 80 da 18 03  cd 6c d9 0e 20 18 06 01  |(........l.. ...|
; 00009c30  00 37 21 06 ac 71 23 10  fc c9 06 00 21 3e ac cd  |.7!..q#.....!>..|
; 00009c40  78 dd fe 41 38 02 cb da  ed 53 61 ac f5 7b fe 03  |x..A8....Sa..{..|
; 00009c50  20 06 7a fe 37 ca 11 d8  f1 dd 21 63 ac d8 cd 32  | .z.7.....!c...2|
; 00009c60  e0 dd 21 65 ac cb fc dd  74 fe dd 75 ff 06 02 c9  |..!e....t..u....|
; 00009c70  11 52 03 3e 01 cb 69 20  09 cb 61 28 05 3d cb a1  |.R.>..i ..a(.=..|
; 00009c80  cb e9 32 3e db 21 1f ed  d9 06 0b d9 7e b8 20 08  |..2>.!......~. .|
; 00009c90  23 7e 2b e6 f0 b9 28 16  38 04 ed 52 18 01 19 cb  |#~+...(.8..R....|
; 00009ca0  3a cb 1b 30 03 13 13 13  d9 10 e0 04 d9 c9 23 23  |:..0..........##|
; 00009cb0  7e 23 56 23 5e cb 3f 06  03 cb 1a 18 02 cb 3a cb  |~#V#^.?.......:.|
; 00009cc0  1b 10 fa cb 3b cb 3b 06  01 05 c8 f5 7b 3c cd 8d  |....;.;.....{<..|
; 00009cd0  dc 20 01 1c 7a 3c cd 8d  dc 20 01 14 f1 bf c9 21  |. ..z<... .....!|
; 00009ce0  10 ac 06 28 0e 01 af be  23 28 01 0c 10 f9 3e 12  |...(....#(....>.|
; 00009cf0  b9 38 0f c9 fe 2c 28 07  13 fe 2d 28 02 13 13 cd  |.8...,(...-(....|
; 00009d00  5c dc da 02 d8 fe 2b 28  07 fe 2d 20 08 cd 30 e1  |\.....+(..- ..0.|
; 00009d10  cd 5c dc 38 ed fe 24 20  05 cd 59 dc 18 33 4f f6  |.\.8..$ ..Y..3O.|
; 00009d20  20 cd f9 de 20 27 c5 1b  d5 dd e5 eb cd 32 e0 dd  | ... '.......2..|
; 00009d30  e1 cb fc dd 74 00 dd 23  dd 75 00 dd 23 c1 2a 06  |....t..#.u..#.*.|
; 00009d40  ac 26 00 09 eb c1 04 04  cd 5c dc 18 04 79 cd e3  |.&.......\...y..|
; 00009d50  db 3f d0 fe 2b 28 11 fe  2d 28 0d fe 2a 28 09 fe  |.?..+(..-(..*(..|
; 00009d60  2f 28 05 fe 3f c2 02 d8  cd 59 dc 18 95 fe 22 28  |/(..?....Y...."(|
; 00009d70  42 0e 0a cd f1 de 28 14  fe 25 20 04 0e 02 18 06  |B.....(..% .....|
; 00009d80  fe 23 20 e1 0e 10 cd 59  dc da 02 d8 21 00 00 cd  |.# ....Y....!...|
; 00009d90  6a dc d0 d5 f5 79 3d 54  5d 19 da fe d7 3d 20 f9  |j....y=T]....= .|
; 00009da0  f1 b9 d2 fe d7 16 00 5f  19 38 ef d1 08 cd 59 dc  |......._.8....Y.|
; 00009db0  d8 18 dc 21 00 00 cd 44  dc b7 28 10 6f cd 44 dc  |...!...D..(.o.D.|
; 00009dc0  b7 28 09 65 6f cd 44 dc  b7 c2 0d d8 18 13 cd 59  |.(.eo.D........Y|
; 00009dd0  dc b7 ca 0d d8 fe 22 28  02 a7 c9 1a fe 22 3e 00  |......"(.....">.|
; 00009de0  c0 3e 22 cd 30 e1 1a 13  fe 29 28 06 fe 2c 28 02  |.>".0....)(..,(.|
; 00009df0  b7 c0 37 c9 f5 08 f1 d6  30 fe 0a d8 d6 07 fe 0a  |..7.....0.......|
; 00009e00  38 12 fe 10 d8 d6 20 fe  0a 38 09 fe 10 30 05 08  |8..... ..8...0..|
; 00009e10  d6 20 08 d8 08 a7 c9 fe  1a 28 0f fe 1c 28 0b fe  |. .......(...(..|
; 00009e20  1e 28 07 fe 2a 28 03 fe  2f c0 3d e5 21 36 d7 36  |.(..*(../.=.!6.6|
; 00009e30  01 e1 bf c9 e5 cd e9 dc  e1 78 b7 c8 fe 05 30 0c  |.........x....0.|
; 00009e40  e5 21 19 dd cd 23 dd e1  cd f1 dc d0 7e fe 28 3e  |.!...#......~.(>|
; 00009e50  2c c0 23 7e fe 69 20 16  23 7e fe 78 06 2e 28 06  |,.#~.i .#~.x..(.|
; 00009e60  fe 79 06 2f 20 08 23 7e  fe 2b 28 05 fe 2d 3e 2d  |.y./ .#~.+(..->-|
; 00009e70  c0 78 c9 af 47 be c8 23  04 18 fa e5 1a e6 7f be  |.x..G..#........|
; 00009e80  20 0b 1a 23 13 e6 80 28  f3 e1 af 79 c9 e1 1a e6  | ..#...(...y....|
; 00009e90  80 13 28 fa 0c 10 e4 37  c9 b2 e4 01 01 0c 02 29  |..(....7.......)|
; 00009ea0  0e 17 37 f0 e5 0c 09 0f  15 02 24 06 26 78 87 4f  |..7.......$.&x.O|
; 00009eb0  af 47 e5 09 46 23 4e e1  5e 23 56 67 69 19 5e 57  |.G..F#N.^#Vgi.^W|
; 00009ec0  19 eb c9 06 20 18 06 06  2c 18 02 06 00 cd 78 dd  |.... ...,.....x.|
; 00009ed0  fe 22 28 25 fe 27 28 21  b8 c8 fe 20 23 28 ee 2b  |."(%.'(!... #(.+|
; 00009ee0  b7 20 02 3c c9 23 cb ef  12 13 0d 20 e0 18 0f cd  |. .<.#..... ....|
; 00009ef0  77 dd b7 28 e3 fe 22 28  df 12 13 0d 20 f1 c3 02  |w..(.."(.... ...|
; 00009f00  d8 23 7e fe 01 c0 23 7e  c9 cd 78 dd fe 20 c0 23  |.#~...#~..x.. .#|
; 00009f10  18 f7 21 51 e3 22 1c df  21 e0 50 cd bf dd 21 3d  |..!Q."..!.P...!=|
; 00009f20  ac 23 3a 57 df e6 1f 32  22 d6 7e 3d 28 07 3c c8  |.#:W...2".~=(.<.|
; 00009f30  cd 15 df 18 ec 22 b1 d5  e5 3a 39 de c6 cc cd 38  |....."...:9....8|
; 00009f40  df e1 18 dd 0e 00 cd b0  22 22 57 df 06 08 e5 0e  |........""W.....|
; 00009f50  20 36 00 2c 0d 20 fa e1  24 10 f3 c9 d9 cd 03 de  | 6.,. ..$.......|
; 00009f60  d9 cd f9 de c0 f6 20 c9  21 00 00 23 22 df dd 7c  |...... .!..#"..||
; 00009f70  fe 05 20 19 3e 00 18 6c  26 02 cd 79 de 20 08 2b  |.. .>..l&..y. .+|
; 00009f80  24 25 20 f6 cd 73 de 21  00 00 22 df dd f3 cd 79  |$% ..s.!.."....y|
; 00009f90  de 28 e5 06 00 4b 7b 32  50 de 21 04 02 7a fe 19  |.(...K{2P.!..z..|
; 00009fa0  28 76 09 7e fe 20 47 38  27 7a fe 28 78 cb ef 20  |(v.~. G8'z.(x.. |
; 00009fb0  10 cd f1 de 20 04 d6 2d  18 16 cd f9 de 20 02 cb  |.... ..-..... ..|
; 00009fc0  af 47 3e 00 b7 78 28 08  cd f9 de 20 03 3e 20 a8  |.G>..x(.... .> .|
; 00009fd0  47 b7 28 b9 fe 80 28 b5  47 3e 00 fe 00 32 52 de  |G.(...(.G>...2R.|
; 00009fe0  78 ca de dd f5 cd da de  f1 26 14 2b 24 25 20 fb  |x........&.+$% .|
; 00009ff0  cb 7f 32 eb dd c8 26 4e  2b 24 25 20 fb 21 52 de  |..2...&N+$% .!R.|
; 0000a000  36 00 c9 e5 cd 8e 02 e1  28 02 af c9 7b 1c c8 14  |6.......(...{...|
; 0000a010  c0 7b d6 19 c8 d6 0f c9  eb 79 fe 1b 28 17 21 3e  |.{.......y..(.!>|
; 0000a020  ac 7e 3d 20 10 23 b6 20  0c eb 09 7e cd f9 de 20  |.~= .#. ...~... |
; 0000a030  04 cb ff 18 9b 21 b1 de  09 7e 18 94 2a 5e 5b 26  |.....!...~..*^[&|
; 0000a040  25 3e 7d 2f 2c 2d 5d 27  24 3c 7b 3f 2e 2b 7f 28  |%>}/,-]'$<{?.+.(|
; 0000a050  23 00 5c 60 00 3d 3b 29  40 14 7c 3a 20 0d 22 5f  |#.\`.=;)@.|: ."_|
; 0000a060  21 15 7e 00 1e 1e 18 02  1e 00 21 2c 01 3e 17 43  |!.~.......!,.>.C|
; 0000a070  ee 10 d3 fe 10 fc 2b 24  25 20 f4 fe 30 d8 fe 39  |......+$% ..0..9|
; 0000a080  d0 bf c9 fe 41 d8 fe 7a  d0 fe 5b 38 03 fe 61 d8  |....A..z..[8..a.|
; 0000a090  bf c9 3e 20 18 03 7e e6  7f d9 cd 4e df d9 c9 fe  |..> ..~....N....|
; 0000a0a0  80 38 1d e5 d5 21 00 00  16 00 5f 19 5e 19 7e 23  |.8...!...._.^.~#|
; 0000a0b0  f5 cd 36 df f1 cb 7f 28  f5 d1 e1 fe ba c8 3e 20  |..6....(......> |
; 0000a0c0  cb bf d9 cd 4e df 7c c6  0a fe 5a 28 06 c6 07 fe  |....N.|...Z(....|
; 0000a0d0  58 38 fa 67 36 38 d9 c9  87 26 0f 6f 9f 4f 29 29  |X8.g68...&.o.O))|
; 0000a0e0  11 00 40 d5 06 08 7e 00  b6 a9 12 23 14 10 f7 e1  |..@...~....#....|
; 0000a0f0  e5 2c 20 0a 7c c6 08 fe  58 20 02 3e 40 67 22 57  |., .|...X .>@g"W|
; 0000a100  df e1 c9 11 07 ac 06 00  cd 78 dd cd f1 de 28 0b  |.........x....(.|
; 0000a110  cb af fe 5f 28 05 cd f9  de 20 0c 12 13 23 04 78  |..._(.... ...#.x|
; 0000a120  fe 09 38 e4 c3 02 d8 78  32 06 ac 1b eb cb fe 21  |..8....x2......!|
; 0000a130  00 00 cd e9 ad 5f 23 cd  e9 ad 57 23 d5 eb 23 29  |....._#...W#..#)|
; 0000a140  19 22 d1 df 2b 2b 22 40  e0 c1 18 2b c5 2b cd e9  |."..++"@...+.+..|
; 0000a150  ad e6 3f 57 2b cd e9 ad  5f e5 21 00 00 19 11 06  |..?W+..._.!.....|
; 0000a160  ac 1a 47 13 cd e9 ad eb  be eb 20 08 23 13 10 f4  |..G....... .#...|
; 0000a170  f1 e1 af c9 e1 c1 0b 78  b1 20 d1 37 c9 cd 48 ca  |.......x. .7..H.|
; 0000a180  2a d1 df 18 32 e1 c1 c9  c5 e5 23 11 07 ac 23 cd  |*...2.....#...#.|
; 0000a190  e9 ad 4f cb b9 1a e6 7f  b9 38 ea 20 0f 1a e6 80  |..O......8. ....|
; 0000a1a0  20 e3 cd e9 ad cb 7f 20  03 13 18 e2 cd e9 ad cb  | ...... ........|
; 0000a1b0  7f 23 28 f8 f1 c1 0b 78  b1 20 cd c9 cd 79 df d0  |.#(....x. ...y..|
; 0000a1c0  21 00 00 01 0c 00 cd dd  d7 11 00 00 cd 66 bd 62  |!............f.b|
; 0000a1d0  6b 13 13 cd 7c ad 21 37  e0 cd bc e1 cd f3 df e5  |k...|.!7........|
; 0000a1e0  eb 2a 37 e0 af ed 52 eb  e5 47 3a 06 ac c6 02 4f  |.*7...R..G:....O|
; 0000a1f0  c5 e5 09 42 4b eb e1 cd  7c ad c1 21 37 e0 cd c4  |...BK...|..!7...|
; 0000a200  e1 d1 21 05 ac 36 00 c5  cd cd e2 2a a6 df cd 44  |..!..6.....*...D|
; 0000a210  e1 c1 1b eb e3 ed 5b d1  df af ed 52 eb 23 23 22  |......[....R.##"|
; 0000a220  d1 df 2b 2b dd 2a a6 df  e3 18 11 cd 2e cc ed 52  |..++.*.........R|
; 0000a230  38 08 d5 dd e5 e1 cd 47  e1 d1 e3 2b 7c b5 e3 20  |8......G...+|.. |
; 0000a240  ea e1 dd e5 e1 23 23 7b  cd 29 ae 23 7a cd 29 ae  |.....##{.).#z.).|
; 0000a250  cd 48 ca 60 69 c9 3e 00  b7 c9 0e 00 dd 21 06 ac  |.H.`i.>......!..|
; 0000a260  cd cc e0 28 19 dd 36 00  23 dd 23 11 00 10 cd 0f  |...(..6.#.#.....|
; 0000a270  e1 16 01 cd 0f e1 11 10  00 cd 0f e1 18 17 11 10  |................|
; 0000a280  27 cd 0f e1 11 e8 03 cd  0f e1 11 64 00 cd 0f e1  |'..........d....|
; 0000a290  1e 0a cd 0f e1 1e 01 0e  00 3e ff 3c a7 ed 52 30  |.........>.<..R0|
; 0000a2a0  fa 19 cb 41 28 02 b7 c8  cb 81 c6 30 fe 3a 38 02  |...A(......0.:8.|
; 0000a2b0  c6 07 cd 31 e1 dd 36 00  00 c9 04 dd 77 00 dd 23  |...1..6.....w..#|
; 0000a2c0  c9 cd 55 e1 a7 ed 42 18  0c 01 02 00 18 03 01 01  |..U...B.........|
; 0000a2d0  00 cd 55 e1 09 eb 7a cd  29 ae 2b 7b c3 29 ae cd  |..U...z.).+{.)..|
; 0000a2e0  e9 ad 5f 23 cd e9 ad 57  eb c9 e5 22 e0 e1 c5 cd  |.._#...W..."....|
; 0000a2f0  ee d9 0b 78 b1 20 f8 c1  d1 e5 cd 66 bd e1 c5 d5  |...x. .....f....|
; 0000a300  e5 2a 37 e0 d1 cd 66 bd  eb d1 cd 7c ad c1 c5 cd  |.*7...f....|....|
; 0000a310  ce e1 c1 21 17 da cd db  e1 21 79 d8 cd db e1 21  |...!.....!y....!|
; 0000a320  7c d8 cd db e1 21 37 e0  cd a4 e1 21 a6 df 5e 23  ||....!7....!..^#|
; 0000a330  56 eb a7 ed 42 18 1c e5  7e 23 66 6f 11 00 00 a7  |V...B...~#fo....|
; 0000a340  ed 52 e1 d8 18 08 01 02  00 18 03 01 01 00 5e 23  |.R............^#|
; 0000a350  56 eb 09 eb 72 2b 73 c9  eb af cd 29 ae 23 0b 78  |V...r+s....).#.x|
; 0000a360  b1 20 f6 eb c9 e5 5e 23  56 21 00 00 a7 ed 52 e1  |. ....^#V!....R.|
; 0000a370  d0 18 bb af 32 94 d5 cd  56 cd cd aa ce 3e 0a cd  |....2...V....>..|
; 0000a380  30 d8 3e 13 32 57 df 3a  94 d5 b7 3e 4f 20 02 3e  |0.>.2W.:...>O .>|
; 0000a390  49 cd 0f df 2a 37 e0 cd  13 e2 2a 9f d0 cd 08 df  |I...*7....*.....|
; 0000a3a0  cd d0 e0 21 06 ac 7e b7  c8 cd 0c df 23 18 f7 d5  |...!..~.....#...|
; 0000a3b0  11 00 00 cd 77 ad d1 c9  e5 d5 11 0c 00 19 ed 5b  |....w..........[|
; 0000a3c0  a6 df a7 ed 52 d1 e1 c9  cd 78 d8 e5 d5 ed 4b 17  |....R....x....K.|
; 0000a3d0  da a7 ed 42 30 05 eb 3f  ed 42 3f e1 d1 d8 3e 01  |...B0..?.B?...>.|
; 0000a3e0  32 c3 e2 c5 cd ee d9 cd  66 bd e1 22 b3 e1 eb cd  |2.......f.."....|
; 0000a3f0  77 ad 38 01 09 eb cd 8f  e2 06 4d cd 7f d3 c0 cd  |w.8.......M.....|
; 0000a400  78 d8 e5 d5 cd 3d c9 e1  d1 cd 66 bd 2a 17 da 22  |x....=....f.*.."|
; 0000a410  79 d8 09 22 7c d8 c9 06  00 d5 e5 cd dd d7 c5 c5  |y.."|...........|
; 0000a420  eb 2a 37 e0 a7 ed 52 e3  eb e5 09 d1 eb c1 cd 7c  |.*7...R........||
; 0000a430  ad c1 21 37 e0 cd c4 e1  21 a6 df cd c4 e1 21 79  |..!7....!.....!y|
; 0000a440  d8 cd ad e1 21 7c d8 cd  ad e1 d1 e1 3e 00 b7 3e  |....!|......>..>|
; 0000a450  00 32 c3 e2 c2 7c ad 7e  eb cd 29 ae eb 23 13 0b  |.2...|.~..)..#..|
; 0000a460  78 b1 20 f3 c9 11 82 ac  cd e9 ad 12 13 23 cd e9  |x. ..........#..|
; 0000a470  ad 12 13 23 cb 5f 28 0e  cd e9 ad 12 13 23 cd e9  |...#._(......#..|
; 0000a480  ad 12 13 23 18 03 e6 07  c8 cd e9 ad 12 13 23 fe  |...#..........#.|
; 0000a490  c0 d0 fe 80 38 f3 cd e9  ad 12 13 23 18 eb e5 2a  |....8......#...*|
; 0000a4a0  37 e0 cd 66 bd eb d1 c3  7c ad 80 42 61 64 20 6d  |7..f....|..Bad m|
; 0000a4b0  6e 65 6d 6f 6e 69 e3 42  61 64 20 6f 70 65 72 61  |nemoni.Bad opera|
; 0000a4c0  6e e4 42 69 67 20 6e 75  6d 62 65 f2 53 79 6e 74  |n.Big numbe.Synt|
; 0000a4d0  61 78 20 68 6f 72 72 6f  f2 42 61 64 20 73 74 72  |ax horro.Bad str|
; 0000a4e0  69 6e e7 42 61 64 20 69  6e 73 74 72 75 63 74 69  |in.Bad instructi|
; 0000a4f0  6f ee 4d 65 6d 6f 72 79  20 66 75 6c ec 42 61 64  |o.Memory ful.Bad|
; 0000a500  20 50 55 54 20 28 4f 52  47 a9 20 75 6e 6b 6e 6f  | PUT (ORG. unkno|
; 0000a510  77 ee 57 61 69 74 20 70  6c 65 61 73 e5 41 73 73  |w.Wait pleas.Ass|
; 0000a520  65 6d 62 6c 79 20 63 6f  6d 70 6c 65 74 e5 53 74  |embly complet.St|
; 0000a530  61 72 74 20 74 61 70 e5  54 61 70 65 20 65 72 72  |art tap.Tape err|
; 0000a540  6f f2 41 6e 79 20 6b 65  f9 28 43 29 20 39 33 20  |o.Any ke.(C) 93 |
; 0000a550  55 4e 49 56 45 52 53 55  cd 53 6f 75 72 63 65 20  |UNIVERSU.Source |
; 0000a560  45 52 52 4f d2 46 6f 75  6e 64 ba 41 6c 72 65 61  |ERRO.Found.Alrea|
; 0000a570  64 79 20 64 65 66 69 6e  65 e4 45 4e 54 20 bf 4e  |dy define.ENT .N|
; 0000a580  6f 74 20 66 6f 75 6e e4  4f 76 65 72 77 72 69 74  |ot foun.Overwrit|
; 0000a590  65 bf 44 69 73 6b 20 65  72 72 6f f2 1a 21 25 28  |e.Disk erro..!%(|
; 0000a5a0  27 2c 2f 2e 6b 71 2b 2e  31 37 36 38 3c 3f 41 44  |',/.kq+.1768<?AD|
; 0000a5b0  48 4c 4b 50 67 53 41 53  53 45 4d 42 4c d9 42 41  |HLKPgSASSEMBL.BA|
; 0000a5c0  53 49 c3 43 4f 50 d9 44  45 4c 45 54 c5 46 49 4e  |SI.COP.DELET.FIN|
; 0000a5d0  c4 47 45 4e d3 4c 4f 41  c4 4d 4f 4e 49 54 4f d2  |.GEN.LOA.MONITO.|
; 0000a5e0  4e 45 d7 50 52 49 4e d4  51 55 49 d4 52 55 ce 53  |NE.PRIN.QUI.RU.S|
; 0000a5f0  41 56 c5 54 41 42 4c c5  55 2d 54 4f d0 56 45 52  |AV.TABL.U-TO.VER|
; 0000a600  49 46 d9 43 4c 45 41 d2  52 45 50 4c 41 43 c5 53  |IF.CLEA.REPLAC.S|
; 0000a610  2d 42 45 47 49 ce 53 2d  54 4f d0 43 41 4c c3 53  |-BEGI.S-TO.CAL.S|
; 0000a620  6f 75 72 63 65 20 62 65  67 69 6e ba 20 20 20 53  |ource begin.   S|
; 0000a630  2d 74 6f 70 ba 52 65 73  75 6c 74 ba 00 4d 4d 4e  |-top.Result..MMN|
; 0000a640  4f 50 51 52 53 54 55 56  57 58 59 5b 5d 5f 61 63  |OPQRSTUVWXY[]_ac|
; 0000a650  65 67 69 6b 6d 6f 71 73  75 77 79 7b 7d 7f 81 83  |egikmoqsuwy{}...|
; 0000a660  85 87 89 8b 8d 8f 91 93  95 97 99 9b 9d 9f a1 a3  |................|
; 0000a670  a5 a7 a9 ab ae b1 b4 b7  ba bd c0 c3 c6 c9 cc cf  |................|
; 0000a680  d2 d5 d8 db de e1 e4 e7  ea ed bb 63 f0 64 e9 65  |...........c.d.e|
; 0000a690  e9 65 f8 69 ed 69 ee 6a  f0 6a f2 6c e4 6f f2 72  |.e.i.i.j.j.l.o.r|
; 0000a6a0  ec 72 f2 61 64 e3 61 64  e4 61 6e e4 62 69 f4 63  |.r.ad.ad.an.bi.c|
; 0000a6b0  63 e6 63 70 e4 63 70 e9  63 70 ec 64 61 e1 64 65  |c.cp.cp.cp.da.de|
; 0000a6c0  e3 65 6e f4 65 71 f5 65  78 f8 69 6e e3 69 6e e4  |.en.eq.ex.in.in.|
; 0000a6d0  69 6e e9 6c 64 e4 6c 64  e9 6e 65 e7 6e 6f f0 6f  |in.ld.ld.ne.no.o|
; 0000a6e0  72 e7 6f 75 f4 70 6f f0  70 75 f4 72 65 f3 72 65  |r.ou.po.pu.re.re|
; 0000a6f0  f4 72 6c e1 72 6c e3 72  6c e4 72 72 e1 72 72 e3  |.rl.rl.rl.rr.rr.|
; 0000a700  72 72 e4 72 73 f4 73 62  e3 73 63 e6 73 65 f4 73  |rr.rs.sb.sc.se.s|
; 0000a710  6c e1 73 72 e1 73 72 ec  73 75 e2 78 6f f2 63 61  |l.sr.sr.su.xo.ca|
; 0000a720  6c ec 63 70 64 f2 63 70  69 f2 64 65 66 e2 64 65  |l.cpd.cpi.def.de|
; 0000a730  66 ed 64 65 66 f3 64 65  66 f7 64 6a 6e fa 68 61  |f.def.def.djn.ha|
; 0000a740  6c f4 69 6e 64 f2 69 6e  69 f2 6c 64 64 f2 6c 64  |l.ind.ini.ldd.ld|
; 0000a750  69 f2 6f 74 64 f2 6f 74  69 f2 6f 75 74 e4 6f 75  |i.otd.oti.out.ou|
; 0000a760  74 e9 70 75 73 e8 72 65  74 e9 72 65 74 ee 72 6c  |t.pus.ret.ret.rl|
; 0000a770  63 e1 72 72 63 e1 73 6c  69 e1 20 2b 2b 2b 2b 2b  |c.rrc.sli. +++++|
; 0000a780  2b 2b 2b 2b 2b 2b 2b 2b  2b 2b 2b 2b 2b 2b 2b 2b  |++++++++++++++++|
; 0000a790  2c 2d 2e 2f 30 31 32 33  34 35 36 37 38 39 3a 3c  |,-./0123456789:<|
; 0000a7a0  3e 41 44 47 4a 4d b0 b1  b2 b3 b4 b5 b6 b7 e1 e2  |>ADGJM..........|
; 0000a7b0  e3 e4 e5 e8 e9 ec ed f0  f2 fa 61 e6 62 e3 64 e5  |..........a.b.d.|
; 0000a7c0  68 ec 68 f8 68 f9 69 f8  69 f9 6c f8 6c f9 6e e3  |h.h.h.i.i.l.l.n.|
; 0000a7d0  6e fa 70 e5 70 ef 73 f0  28 63 a9 61 66 a7 28 62  |n.p.p.s.(c.af.(b|
; 0000a7e0  63 a9 28 64 65 a9 28 68  6c a9 28 69 78 a9 28 69  |c.(de.(hl.(ix.(i|
; 0000a7f0  79 a9 28 73 70 a9 00 00  42 00 04 00 30 00 00 00  |y.(sp...B...0...|
; 0000a800  00 80 52 50 08 01 02 14  b5 8a 01 37 02 00 00 01  |..RP.......7....|
; 0000a810  80 52 58 08 02 00 15 31  27 02 37 31 60 00 02 80  |.RX....1'.71`...|
; 0000a820  52 60 08 03 00 36 b0 06  03 37 33 60 00 03 80 52  |R`...6...73`...R|
; 0000a830  68 08 04 00 36 50 04 04  37 45 60 00 04 80 52 70  |h...6P..7E`...Rp|
; 0000a840  08 05 00 2e 50 04 05 37  4b 60 00 05 80 52 80 08  |....P..7K`...R..|
; 0000a850  06 01 14 55 87 06 37 74  00 00 06 80 53 40 0f 06  |...U..7t....S@..|
; 0000a860  a4 53 70 17 07 00 96 00  04 07 37 76 00 00 07 80  |.Sp.......7v....|
; 0000a870  52 48 08 08 00 0a ac a4  08 37 78 00 00 08 80 58  |RH.......7x....X|
; 0000a880  50 08 09 00 1e c2 cb 09  20 1e da cf 09 37 7a 00  |P....... ....7z.|
; 0000a890  00 09 80 58 58 08 0a 00  14 4c c7 0a 80 58 60 08  |...XX....L...X`.|
; 0000a8a0  0b 00 2e b0 06 0b 80 58  68 08 0c 00 36 58 04 0c  |.......Xh...6X..|
; 0000a8b0  80 58 70 08 0d 00 2e 58  04 0d 80 58 80 08 0e 01  |.Xp....X...X....|
; 0000a8c0  14 5d 87 0e 80 59 40 0f  0e a4 59 70 17 0f 00 98  |.]...Y@...Yp....|
; 0000a8d0  00 04 0f 80 58 48 08 10  03 7d 60 08 10 80 18 50  |....XH...}`....P|
; 0000a8e0  08 11 02 14 bd 8a 11 80  18 58 08 12 00 15 39 27  |.........X....9'|
; 0000a8f0  12 80 18 60 08 13 00 36  b8 06 13 80 18 68 08 14  |...`...6.....h..|
; 0000a900  00 36 60 04 14 80 18 70  08 15 00 2e 60 04 15 80  |.6`....p....`...|
; 0000a910  18 80 08 16 01 14 65 87  16 80 19 40 0f 16 a4 19  |......e....@....|
; 0000a920  70 17 17 00 50 00 04 17  80 18 48 08 18 03 13 60  |p...P.....H....`|
; 0000a930  07 18 80 1a 50 08 19 00  1e c2 eb 19 20 1e da ef  |....P....... ...|
; 0000a940  19 80 1a 58 08 1a 00 14  4c e7 1a 80 1a 60 08 1b  |...X....L....`..|
; 0000a950  00 2e b8 06 1b 80 1a 68  08 1c 00 36 68 04 1c 80  |.......h...6h...|
; 0000a960  1a 70 08 1d 00 2e 68 04  1d 80 1a 80 08 1e 01 14  |.p....h.........|
; 0000a970  6d 87 1e 80 1b 40 0f 1e  a4 1b 70 17 1f 00 56 00  |m....@....p...V.|
; 0000a980  04 1f 80 1a 48 08 20 03  13 05 87 20 80 64 50 08  |....H. .... .dP.|
; 0000a990  21 02 14 c5 8a 21 22 14  dd 8e 21 80 64 58 08 22  |!....!"...!.dX."|
; 0000a9a0  02 15 6b 10 22 22 15 6b  74 22 80 64 60 08 23 00  |..k."".kt".d`.#.|
; 0000a9b0  36 c0 06 23 20 36 d8 0a  23 80 64 68 08 24 00 36  |6..# 6..#.dh.$.6|
; 0000a9c0  70 04 24 20 36 c8 08 24  80 64 70 08 25 00 2e 70  |p.$ 6..$.dp.%..p|
; 0000a9d0  04 25 20 2e c8 08 25 80  64 80 08 26 01 14 75 87  |.% ...%.d..&..u.|
; 0000a9e0  26 21 14 cd 8b 26 80 65  40 0f 26 a4 65 70 17 27  |&!...&.e@.&.ep.'|
; 0000a9f0  00 2c 00 04 27 80 64 48  08 28 03 12 a5 87 28 80  |.,..'.dH.(....(.|
; 0000aa00  66 50 08 29 00 1e c3 0b  29 20 1e db 6f 29 80 66  |fP.)....) ..o).f|
; 0000aa10  58 08 2a 02 14 c5 b0 2a  22 14 dd b4 2a 80 66 60  |X.*....*"...*.f`|
; 0000aa20  08 2b 00 2e c0 06 2b 20  2e d8 0a 2b 80 66 68 08  |.+....+ ...+.fh.|
; 0000aa30  2c 00 36 80 04 2c 20 36  e8 08 2c 80 66 70 08 2d  |,.6.., 6..,.fp.-|
; 0000aa40  00 2e 80 04 2d 20 2e e8  08 2d 80 66 80 08 2e 01  |....- ...-.f....|
; 0000aa50  14 85 87 2e 21 14 ed 8b  2e 80 67 40 0f 2e a4 67  |....!.....g@...g|
; 0000aa60  70 17 2f 00 2a 00 04 2f  80 66 48 08 30 03 12 fd  |p./.*../.fH.0...|
; 0000aa70  87 30 80 9a 50 08 31 02  15 1d 8a 31 80 9a 58 08  |.0..P.1....1..X.|
; 0000aa80  32 02 15 69 2d 32 80 9a  60 08 33 00 37 18 06 33  |2..i-2..`.3.7..3|
; 0000aa90  80 9a 68 08 34 00 37 40  0b 34 24 37 70 17 34 80  |..h.4.7@.4$7p.4.|
; 0000aaa0  9a 70 08 35 00 2f 40 0b  35 24 2f 70 17 35 80 9a  |.p.5./@.5$/p.5..|
; 0000aab0  80 08 36 01 15 45 8a 36  25 15 75 93 36 80 9b 40  |..6..E.6%.u.6..@|
; 0000aac0  0f 36 a4 9b 70 17 37 00  60 00 04 37 80 9a 48 08  |.6..p.7.`..7..H.|
; 0000aad0  38 03 12 5d 87 38 80 68  50 08 39 00 1e c4 6b 39  |8..].8.hP.9...k9|
; 0000aae0  20 1e dc 6f 39 80 68 58  08 3a 02 14 4d ad 3a 80  | ..o9.hX.:..M.:.|
; 0000aaf0  68 60 08 3b 00 2f 18 06  3b 80 68 68 08 3c 00 36  |h`.;./..;.hh.<.6|
; 0000ab00  48 04 3c 80 68 70 08 3d  00 2e 48 04 3d 80 68 80  |H.<.hp.=..H.=.h.|
; 0000ab10  08 3e 01 14 4d 87 3e 80  69 40 0f 3e a4 69 70 17  |.>..M.>.i@.>.ip.|
; 0000ab20  3f 00 24 00 04 3f 80 68  48 08 40 00 14 51 44 40  |?.$..?.hH.@..QD@|
; 0000ab30  40 0e 54 8c 40 80 22 09  48 41 00 14 51 64 41 40  |@.T.@.".HA..QdA@|
; 0000ab40  47 21 4c 41 80 22 09 68  42 00 14 51 84 42 40 5e  |G!LA.".hB..Q.B@^|
; 0000ab50  c2 cf 42 80 22 09 88 43  00 14 51 a4 43 42 15 6a  |..B."..C..Q.CB.j|
; 0000ab60  d4 43 80 22 09 a8 44 00  14 51 c4 44 20 14 53 28  |.C."..D..Q.D .S(|
; 0000ab70  44 40 40 00 08 44 80 22  09 c8 45 00 14 52 04 45  |D@@..D."..E..R.E|
; 0000ab80  20 14 53 a8 45 40 94 00  0e 45 80 22 0a 08 46 00  | .S.E@...E."..F.|
; 0000ab90  14 55 07 46 24 14 55 d3  46 40 0c 08 08 46 80 22  |.U.F$.U.F@...F."|
; 0000aba0  0d 0c 46 a4 22 0d d4 47  00 14 51 24 47 40 14 79  |..F."..G..Q$G@.y|
; 0000abb0  29 47 80 22 09 28 48 00  14 59 44 48 40 0e 5c 8c  |)G.".(H..YDH@.\.|
; 0000abc0  48 80 22 11 48 49 00 14  59 64 49 40 47 21 6c 49  |H.".HI..YdI@G!lI|
; 0000abd0  80 22 11 68 4a 00 14 59  84 4a 40 1c c2 cf 4a 80  |.".hJ..Y.J@...J.|
; 0000abe0  22 11 88 4b 00 14 59 a4  4b 42 14 b5 b4 4b 80 22  |"..K..Y.KB...K."|
; 0000abf0  11 a8 4c 00 14 59 c4 4c  20 14 5b 28 4c 80 22 11  |..L..Y.L .[(L.".|
; 0000ac00  c8 4d 00 14 5a 04 4d 20  14 5b a8 4d 40 92 00 0e  |.M..Z.M .[.M@...|
; 0000ac10  4d 80 22 12 08 4e 00 14  5d 07 4e 24 14 5d d3 4e  |M."..N..].N$.].N|
; 0000ac20  80 22 15 0c 4e a4 22 15  d4 4f 00 14 59 24 4f 40  |."..N."..O..Y$O@|
; 0000ac30  14 99 29 4f 80 22 11 28  50 00 14 61 44 50 40 0e  |..)O.".(P..aDP@.|
; 0000ac40  64 8c 50 80 22 19 48 51  00 14 61 64 51 40 47 21  |d.P.".HQ..adQ@G!|
; 0000ac50  8c 51 80 22 19 68 52 00  14 61 84 52 40 5e c2 ef  |.Q.".hR..a.R@^..|
; 0000ac60  52 80 22 19 88 53 00 14  61 a4 53 42 15 6a f4 53  |R."..S..a.SB.j.S|
; 0000ac70  80 22 19 a8 54 00 14 61  c4 54 20 14 63 28 54 80  |."..T..a.T .c(T.|
; 0000ac80  22 19 c8 55 00 14 62 04  55 20 14 63 a8 55 80 22  |"..U..b.U .c.U."|
; 0000ac90  1a 08 56 00 14 65 07 56  24 14 65 d3 56 40 0c 10  |..V..e.V$.e.V@..|
; 0000aca0  08 56 80 22 1d 0c 56 a4  22 1d d4 57 00 14 61 24  |.V."..V."..W..a$|
; 0000acb0  57 40 14 49 e9 57 80 22  19 28 58 00 14 69 44 58  |W@.I.W.".(X..iDX|
; 0000acc0  40 0e 6c 8c 58 80 22 21  48 59 00 14 69 64 59 40  |@.l.X."!HY..idY@|
; 0000acd0  47 21 ac 59 80 22 21 68  5a 00 14 69 84 5a 40 1c  |G!.Y."!hZ..i.Z@.|
; 0000ace0  c2 ef 5a 80 22 21 88 5b  00 14 69 a4 5b 42 14 bd  |..Z."!.[..i.[B..|
; 0000acf0  b4 5b 80 22 21 a8 5c 00  14 69 c4 5c 20 14 6b 28  |.[."!.\..i.\ .k(|
; 0000ad00  5c 80 22 21 c8 5d 00 14  6a 04 5d 20 14 6b a8 5d  |\."!.]..j.] .k.]|
; 0000ad10  80 22 22 08 5e 00 14 6d  07 5e 24 14 6d d3 5e 40  |."".^..m.^$.m.^@|
; 0000ad20  0c 18 08 5e 80 22 25 0c  5e a4 22 25 d4 5f 00 14  |...^."%.^."%._..|
; 0000ad30  69 24 5f 40 14 4a 69 5f  80 22 21 28 60 00 14 71  |i$_@.Ji_."!(`..q|
; 0000ad40  44 60 20 14 c9 48 60 40  0e 74 8c 60 80 22 29 48  |D` ..H`@.t.`.")H|
; 0000ad50  61 00 14 71 64 61 20 14  c9 68 61 40 47 21 cc 61  |a..qda ..ha@G!.a|
; 0000ad60  80 22 29 68 62 00 14 71  84 62 20 14 c9 88 62 40  |.")hb..q.b ...b@|
; 0000ad70  5e c3 0f 62 80 22 29 88  63 00 14 71 a4 63 20 14  |^..b.").c..q.c .|
; 0000ad80  c9 a8 63 42 15 6b 14 63  80 22 29 a8 64 00 14 71  |..cB.k.c.").d..q|
; 0000ad90  c4 64 20 14 cb 28 64 80  22 29 c8 65 00 14 72 04  |.d ..(d.").e..r.|
; 0000ada0  65 20 14 cb a8 65 80 22  2a 08 66 00 14 75 07 66  |e ...e."*.f..u.f|
; 0000adb0  24 14 75 d3 66 80 22 2d  0c 66 a4 22 2d d4 67 00  |$.u.f."-.f."-.g.|
; 0000adc0  14 71 24 67 20 14 c9 28  67 40 5a 00 12 67 80 22  |.q$g ..(g@Z..g."|
; 0000add0  29 28 68 00 14 81 44 68  20 14 e9 48 68 40 0e 84  |)(h...Dh ..Hh@..|
; 0000ade0  8c 68 80 22 31 48 69 00  14 81 64 69 20 14 e9 68  |.h."1Hi...di ..h|
; 0000adf0  69 40 47 22 0c 69 80 22  31 68 6a 00 14 81 84 6a  |i@G".i."1hj....j|
; 0000ae00  20 14 e9 88 6a 40 1c c3  0f 6a 80 22 31 88 6b 00  | ...j@...j."1.k.|
; 0000ae10  14 81 a4 6b 20 14 e9 a8  6b 42 14 c5 b4 6b 80 22  |...k ...kB...k."|
; 0000ae20  31 a8 6c 00 14 81 c4 6c  20 14 eb 28 6c 80 22 31  |1.l....l ..(l."1|
; 0000ae30  c8 6d 00 14 82 04 6d 20  14 eb a8 6d 80 22 32 08  |.m....m ...m."2.|
; 0000ae40  6e 00 14 85 07 6e 24 14  85 d3 6e 80 22 35 0c 6e  |n....n$...n."5.n|
; 0000ae50  a4 22 35 d4 6f 00 14 81  24 6f 20 14 e9 28 6f 40  |."5.o...$o ..(o@|
; 0000ae60  54 00 12 6f 80 22 31 28  70 00 15 41 47 70 24 15  |T..o."1(p..AGp$.|
; 0000ae70  71 53 70 80 22 39 48 71  00 15 41 67 71 24 15 71  |qSp."9Hq..Agq$.q|
; 0000ae80  73 71 80 22 39 68 72 00  15 41 87 72 24 15 71 93  |sq."9hr..A.r$.q.|
; 0000ae90  72 40 5e c4 6f 72 80 22  39 88 73 00 15 41 a7 73  |r@^.or."9.s..A.s|
; 0000aea0  24 15 71 b3 73 42 15 6c  74 73 80 22 39 a8 74 00  |$.q.sB.lts."9.t.|
; 0000aeb0  15 41 c7 74 24 15 71 d3  74 80 22 39 c8 75 00 15  |.A.t$.q.t."9.u..|
; 0000aec0  42 07 75 24 15 72 13 75  80 22 3a 08 76 00 7e 00  |B.u$.r.u.":.v.~.|
; 0000aed0  04 76 80 22 3d 0c 76 a4  22 3d d4 77 00 15 41 27  |.v."=.v."=.w..A'|
; 0000aee0  77 24 15 71 33 77 80 22  39 28 78 00 14 49 44 78  |w$.q3w."9(x..IDx|
; 0000aef0  40 0e 4c 8c 78 80 22 41  48 79 00 14 49 64 79 40  |@.L.x."AHy..Idy@|
; 0000af00  47 21 2c 79 80 22 41 68  7a 00 14 49 84 7a 40 1c  |G!,y."Ahz..I.z@.|
; 0000af10  c4 6f 7a 80 22 41 88 7b  00 14 49 a4 7b 42 15 1d  |.oz."A.{..I.{B..|
; 0000af20  b4 7b 80 22 41 a8 7c 00  14 49 c4 7c 20 14 4b 28  |.{."A.|..I.| .K(|
; 0000af30  7c 80 22 41 c8 7d 00 14  4a 04 7d 20 14 4b a8 7d  ||."A.}..J.} .K.}|
; 0000af40  80 22 42 08 7e 00 14 4d  07 7e 24 14 4d d3 7e 80  |."B.~..M.~$.M.~.|
; 0000af50  22 45 0c 7e a4 22 45 d4  7f 00 14 49 24 7f 80 22  |"E.~."E....I$.."|
; 0000af60  41 28 80 00 1e 49 44 80  80 4c 09 48 81 00 1e 49  |A(...ID..L.H...I|
; 0000af70  64 81 80 4c 09 68 82 00  1e 49 84 82 80 4c 09 88  |d..L.h...I...L..|
; 0000af80  83 00 1e 49 a4 83 80 4c  09 a8 84 00 1e 49 c4 84  |...I...L.....I..|
; 0000af90  20 1e 4b 28 84 80 4c 09  c8 85 00 1e 4a 04 85 20  | .K(..L.....J.. |
; 0000afa0  1e 4b a8 85 80 4c 0a 08  86 00 1e 4d 07 86 24 1e  |.K...L.....M..$.|
; 0000afb0  4d d3 86 80 4c 0d 0f 86  a4 4c 0d d7 87 00 1e 49  |M...L....L.....I|
; 0000afc0  24 87 80 4c 09 28 88 00  1c 49 44 88 80 4c 11 48  |$..L.(...ID..L.H|
; 0000afd0  89 00 1c 49 64 89 80 4c  11 68 8a 00 1c 49 84 8a  |...Id..L.h...I..|
; 0000afe0  80 4c 11 88 8b 00 1c 49  a4 8b 80 4c 11 a8 8c 00  |.L.....I...L....|
; 0000aff0  1c 49 c4 8c 20 1c 4b 28  8c 80 4c 11 c8 8d 00 1c  |.I.. .K(..L.....|
; 0000b000  4a 04 8d 20 1c 4b a8 8d  80 4c 12 08 8e 00 1c 4d  |J.. .K...L.....M|
; 0000b010  07 8e 24 1c 4d d3 8e 80  4c 15 0f 8e a4 4c 15 d7  |..$.M...L....L..|
; 0000b020  8f 00 1c 49 24 8f 80 4c  11 28 90 00 6a 50 04 90  |...I$..L.(..jP..|
; 0000b030  80 4c 19 48 91 00 6a 58  04 91 80 4c 19 68 92 00  |.L.H..jX...L.h..|
; 0000b040  6a 60 04 92 80 4c 19 88  93 00 6a 68 04 93 80 4c  |j`...L....jh...L|
; 0000b050  19 a8 94 00 6a 70 04 94  20 6a c8 08 94 80 4c 19  |....jp.. j....L.|
; 0000b060  c8 95 00 6a 80 04 95 20  6a e8 08 95 80 4c 1a 08  |...j... j....L..|
; 0000b070  96 00 6b 40 07 96 24 6b  70 13 96 80 4c 1d 0f 96  |..k@..$kp...L...|
; 0000b080  a4 4c 1d d7 97 00 6a 48  04 97 80 4c 19 28 98 00  |.L....jH...L.(..|
; 0000b090  5e 49 44 98 80 4c 21 48  99 00 5e 49 64 99 80 4c  |^ID..L!H..^Id..L|
; 0000b0a0  21 68 9a 00 5e 49 84 9a  80 4c 21 88 9b 00 5e 49  |!h..^I...L!...^I|
; 0000b0b0  a4 9b 80 4c 21 a8 9c 00  5e 49 c4 9c 20 5e 4b 28  |...L!...^I.. ^K(|
; 0000b0c0  9c 80 4c 21 c8 9d 00 5e  4a 04 9d 20 5e 4b a8 9d  |..L!...^J.. ^K..|
; 0000b0d0  80 4c 22 08 9e 00 5e 4d  07 9e 24 5e 4d d3 9e 80  |.L"...^M..$^M...|
; 0000b0e0  4c 25 0f 9e a4 4c 25 d7  9f 00 5e 49 24 9f 80 4c  |L%...L%...^I$..L|
; 0000b0f0  21 28 a0 00 20 50 04 a0  40 3e 00 10 a0 80 4c 29  |!(.. P..@>....L)|
; 0000b100  48 a1 00 20 58 04 a1 40  28 00 10 a1 80 4c 29 68  |H.. X..@(....L)h|
; 0000b110  a2 00 20 60 04 a2 40 3a  00 10 a2 80 4c 29 88 a3  |.. `..@:....L)..|
; 0000b120  00 20 68 04 a3 40 8e 00  10 a3 80 4c 29 a8 a4 00  |. h..@.....L)...|
; 0000b130  20 70 04 a4 20 20 c8 08  a4 80 4c 29 c8 a5 00 20  | p..  ....L)... |
; 0000b140  80 04 a5 20 20 e8 08 a5  80 4c 2a 08 a6 00 21 40  |...  ....L*...!@|
; 0000b150  07 a6 24 21 70 13 a6 80  4c 2d 0f a6 a4 4c 2d d7  |..$!p...L-...L-.|
; 0000b160  a7 00 20 48 04 a7 80 4c  29 28 a8 00 6c 50 04 a8  |.. H...L)(..lP..|
; 0000b170  40 3c 00 10 a8 80 4c 31  48 a9 00 6c 58 04 a9 40  |@<....L1H..lX..@|
; 0000b180  26 00 10 a9 80 4c 31 68  aa 00 6c 60 04 aa 40 38  |&....L1h..l`..@8|
; 0000b190  00 10 aa 80 4c 31 88 ab  00 6c 68 04 ab 40 8c 00  |....L1...lh..@..|
; 0000b1a0  10 ab 80 4c 31 a8 ac 00  6c 70 04 ac 20 6c c8 08  |...L1...lp.. l..|
; 0000b1b0  ac 80 4c 31 c8 ad 00 6c  80 04 ad 20 6c e8 08 ad  |..L1...l... l...|
; 0000b1c0  80 4c 32 08 ae 00 6d 40  07 ae 24 6d 70 13 ae 80  |.L2...m@..$mp...|
; 0000b1d0  4c 35 0f ae a4 4c 35 d7  af 00 6c 48 04 af 80 4c  |L5...L5...lH...L|
; 0000b1e0  31 28 b0 00 16 50 04 b0  40 86 00 15 b0 80 4c 39  |1(...P..@.....L9|
; 0000b1f0  48 b1 00 16 58 04 b1 40  72 00 15 b1 80 4c 39 68  |H...X..@r....L9h|
; 0000b200  b2 00 16 60 04 b2 40 82  00 15 b2 80 4c 39 88 b3  |...`..@.....L9..|
; 0000b210  00 16 68 04 b3 40 8a 00  15 b3 80 4c 39 a8 b4 00  |..h..@.....L9...|
; 0000b220  16 70 04 b4 20 16 c8 08  b4 80 4c 39 c8 b5 00 16  |.p.. .....L9....|
; 0000b230  80 04 b5 20 16 e8 08 b5  80 4c 3a 08 b6 00 17 40  |... .....L:....@|
; 0000b240  07 b6 24 17 70 13 b6 80  4c 3d 0f b6 a4 4c 3d d7  |..$.p...L=...L=.|
; 0000b250  b7 00 16 48 04 b7 80 4c  39 28 b8 00 04 50 04 b8  |...H...L9(...P..|
; 0000b260  40 84 00 15 b8 80 4c 41  48 b9 00 04 58 04 b9 40  |@.....LAH...X..@|
; 0000b270  70 00 15 b9 80 4c 41 68  ba 00 04 60 04 ba 40 80  |p....LAh...`..@.|
; 0000b280  00 15 ba 80 4c 41 88 bb  00 04 68 04 bb 40 88 00  |....LA....h..@..|
; 0000b290  15 bb 80 4c 41 a8 bc 00  04 70 04 bc 20 04 c8 08  |...LA....p.. ...|
; 0000b2a0  bc 80 4c 41 c8 bd 00 04  80 04 bd 20 04 e8 08 bd  |..LA....... ....|
; 0000b2b0  80 4c 42 08 be 00 05 40  07 be 24 05 70 13 be 80  |.LB....@..$.p...|
; 0000b2c0  4c 45 0f be a4 4c 45 d7  bf 00 04 48 04 bf 80 4c  |LE...LE....H...L|
; 0000b2d0  41 28 c0 00 4f 00 05 c0  80 62 09 48 c1 00 48 b0  |A(..O....b.H..H.|
; 0000b2e0  0a c1 80 62 09 68 c2 02  11 05 8a c2 80 62 09 88  |...b.h.......b..|
; 0000b2f0  c3 02 11 60 0a c3 80 62  09 a8 c4 02 6f 05 89 c4  |...`...b....o...|
; 0000b300  80 62 09 c8 c5 00 90 b0  0b c5 80 62 0a 08 c6 01  |.b.........b....|
; 0000b310  1e 4d 87 c6 80 62 0d 0f  c6 a4 62 0d d7 c7 06 5d  |.M...b....b....]|
; 0000b320  60 0b c7 80 62 09 28 c8  00 4e a0 05 c8 80 62 11  |`...b.(..N....b.|
; 0000b330  48 c9 00 4e 00 05 c9 80  62 11 68 ca 02 10 a5 8a  |H..N....b.h.....|
; 0000b340  ca 80 62 11 88 cb 80 62  11 a8 cc 02 6e a5 89 cc  |..b....b....n...|
; 0000b350  80 62 11 c8 cd 02 6f 60  09 cd 80 62 12 08 ce 01  |.b....o`...b....|
; 0000b360  1c 4d 87 ce 80 62 15 0f  ce a4 62 15 d7 cf 80 62  |.M...b....b....b|
; 0000b370  11 28 d0 00 4e f8 05 d0  80 62 19 48 d1 00 48 b8  |.(..N....b.H..H.|
; 0000b380  0a d1 80 62 19 68 d2 02  10 fd 8a d2 80 62 19 88  |...b.h.......b..|
; 0000b390  d3 01 47 69 2b d3 80 62  19 a8 d4 02 6e fd 89 d4  |..Gi+..b....n...|
; 0000b3a0  80 62 19 c8 d5 00 90 b8  0b d5 80 62 1a 08 d6 01  |.b.........b....|
; 0000b3b0  6b 60 07 d6 80 62 1d 0f  d6 a4 62 1d d7 d7 80 62  |k`...b....b....b|
; 0000b3c0  19 28 d8 00 4e 58 05 d8  80 62 21 48 d9 00 34 00  |.(..NX...b!H..4.|
; 0000b3d0  04 d9 80 62 21 68 da 02  10 5d 8a da 80 62 21 88  |...b!h...]...b!.|
; 0000b3e0  db 01 0e 4d ab db 80 62  21 a8 dc 02 6e 5d 89 dc  |...M...b!...n]..|
; 0000b3f0  80 62 21 c8 dd 80 62 22  08 de 01 5e 4d 87 de 80  |.b!...b"...^M...|
; 0000b400  62 25 0f de a4 62 25 d7  df 80 62 21 28 e0 00 4f  |b%...b%...b!(..O|
; 0000b410  10 05 e0 80 62 29 48 e1  00 48 c0 0a e1 20 48 d8  |....b)H..H... H.|
; 0000b420  0e e1 80 62 29 68 e2 02  11 15 8a e2 80 62 29 88  |...b)h.......b).|
; 0000b430  e3 00 0b 5b 13 e3 20 0b  5b 77 e3 80 62 29 a8 e4  |...[.. .[w..b)..|
; 0000b440  02 6f 15 89 e4 80 62 29  c8 e5 00 90 c0 0b e5 20  |.o....b)....... |
; 0000b450  90 d8 0f e5 80 62 2a 08  e6 01 21 60 07 e6 80 62  |.....b*...!`...b|
; 0000b460  2d 0f e6 a4 62 2d d7 e7  80 62 29 28 e8 00 4f 08  |-...b-...b)(..O.|
; 0000b470  05 e8 80 62 31 48 e9 00  11 40 04 e9 20 11 48 08  |...b1H...@.. .H.|
; 0000b480  e9 80 62 31 68 ea 02 11  0d 8a ea 80 62 31 88 eb  |..b1h.......b1..|
; 0000b490  00 0a bb 04 eb 80 62 31  a8 ec 02 6f 0d 89 ec 80  |......b1...o....|
; 0000b4a0  62 31 c8 ed 80 62 32 08  ee 01 6d 60 07 ee 80 62  |b1...b2...m`...b|
; 0000b4b0  35 0f ee a4 62 35 d7 ef  80 62 31 28 f0 00 4e 90  |5...b5...b1(..N.|
; 0000b4c0  05 f0 80 62 39 48 f1 00  48 a8 0a f1 80 62 39 68  |...b9H..H....b9h|
; 0000b4d0  f2 02 10 95 8a f2 80 62  39 88 f3 00 06 00 04 f3  |.......b9.......|
; 0000b4e0  80 62 39 a8 f4 02 6e 95  89 f4 80 62 39 c8 f5 00  |.b9...n....b9...|
; 0000b4f0  90 a8 0b f5 80 62 3a 08  f6 01 17 60 07 f6 80 62  |.....b:....`...b|
; 0000b500  3d 0f f6 a4 62 3d d7 f7  80 62 39 28 f8 00 4e 88  |=...b=...b9(..N.|
; 0000b510  05 f8 80 62 41 48 f9 00  15 1b 06 f9 20 15 1b 6a  |...bAH...... ..j|
; 0000b520  f9 80 62 41 68 fa 02 10  8d 8a fa 80 62 41 88 fb  |..bAh.......bA..|
; 0000b530  00 08 00 04 fb 80 62 41  a8 fc 02 6e 8d 89 fc 80  |......bA...n....|
; 0000b540  62 41 c8 fd 80 62 42 08  fe 01 05 60 07 fe 80 62  |bA...bB....`...b|
; 0000b550  45 0f fe a4 62 45 d7 ff  80 62 41 28 ff ff ff ff  |E...bE...bA(....|
; 0000b560  ff f4 23 32 0e 00 00 f7  00 00 2c 37 0e 00 00 4f  |..#2......,7...O|
; 0000b570  00 00 3a 3f fb 3a cf 3a  f2 c3 a7 3a 3f d1 22 00  |..:?.:.:...:?.".|
; 0000b580  3a 22 3a 3f 11 d6 f3 2a  5d 5c fd 21 3a 5c e5 ed  |:":?...*]\.!:\..|
; 0000b590  73 28 f4 ed 7b 3d 5c 21  1d f4 e3 22 20 f4 ed 56  |s(..{=\!..." ..V|
; 0000b5a0  fb 3e 01 eb c3 d5 1b 3b  3b 21 00 00 e3 21 76 1b  |.>.....;;!...!v.|
; 0000b5b0  e5 31 00 00 e1 22 5d 5c  18 09 11 00 00 2a 3d 5c  |.1..."]\.....*=\|
; 0000b5c0  73 23 72 fd 36 00 ff f3  c9 2a 3d 5c d5 5e 23 56  |s#r.6....*=\.^#V|
; 0000b5d0  ed 53 31 f4 70 2b 71 d1  c9 11 f2 f3 cd fd f3 c3  |.S1.p+q.........|
; 0000b5e0  40 d4 11 e9 f3 cd fd f3  c3 e0 ab 3a 7b cd fe 21  |@..........:{..!|
; 0000b5f0  28 f0 cd f3 e1 cd 93 f4  3e 14 c2 13 d8 22 72 3e  |(.......>...."r>|
; 0000b600  dd e5 e5 dd e1 cd c7 ce  dd 22 20 f5 dd e1 cd e8  |........." .....|
; 0000b610  f4 cd e1 02 cd 30 f4 cd  f8 d3 c3 c2 ce 21 84 cd  |.....0.......!..|
; 0000b620  01 ce f4 e5 cd 3f f4 cd  fa f3 c7 cd 8f 1c e1 11  |.....?..........|
; 0000b630  94 3e 3e 42 12 1b 01 00  09 7e 2b fe 20 20 01 79  |.>>B.....~+.  .y|
; 0000b640  12 fe 20 28 05 b7 28 02  0e 20 1b 10 ec 7e 12 cd  |.. (..(.. ...~..|
; 0000b650  2b 21 e5 cd 30 f4 e1 c9  31 04 ad cd 30 f4 cd df  |+!..0...1...0...|
; 0000b660  f4 cd f8 d3 3e 16 c3 13  d8 3a 00 00 fe f3 c8 c3  |....>....:......|
; 0000b670  e1 02 d5 01 ce f4 cd 3f  f4 2a 72 3e 3e 11 cd ad  |.......?.*r>>...|
; 0000b680  0f 7e 23 66 6f e5 cd f9  1d e1 c5 cd f1 1c eb 11  |.~#fo...........|
; 0000b690  01 01 c1 e3 e5 21 00 3a  e5 cd a2 22 d1 e1 7c 01  |.....!.:..."..|.|
; 0000b6a0  00 02 b8 30 02 44 4d e5  c5 21 00 00 eb cd cd e2  |...0.DM..!......|
; 0000b6b0  eb 22 20 f5 c1 e1 ed 42  e3 20 ca cd 7b 21 e1 c9  |." ....B. ..{!..|
; 0000b6c0  e5 3e 15 ef f5 e1 ef 03  de cb ef e1 fe 70 28 07  |.>...........p(.|
; 0000b6d0  fe 72 28 03 fe 79 c0 cd  88 1f af c9 cd 93 f4 20  |.r(..y......... |
; 0000b6e0  06 cd 36 f5 c2 ec f5 01  ce f4 cd 3f f4 dd e5 ef  |..6........?....|
; 0000b6f0  f3 e1 dd e1 cd 2c 20 eb  21 8d ac 01 06 00 ed b0  |....., .!.......|
; 0000b700  eb e5 23 23 af 77 23 36  0f 23 77 ed 5b 8d ac cd  |..##.w#6.#w.[...|
; 0000b710  1e 20 b0 7a 20 0b 3e 0c  04 18 08 cd 7b 21 c3 ce  |. .z .>.....{!..|
; 0000b720  f4 f6 0e 57 cd 0a 21 28  08 21 00 00 cd f6 20 20  |...W..!(.!....  |
; 0000b730  ea eb e3 73 23 72 cd 65  1e eb d1 e5 cd db 20 04  |...s#r.e...... .|
; 0000b740  05 20 d8 cd 29 f6 e1 22  37 f6 2a 91 cd ed 4b 94  |. ..).."7.*...K.|
; 0000b750  cd cd f5 f5 7b cd 08 f6  3e ff cd 08 f6 2a a6 df  |....{...>....*..|
; 0000b760  ed 4b cd af 0b cd f5 f5  2a 12 f6 7c b5 c4 36 f6  |.K......*..|..6.|
; 0000b770  cd 7b 21 cd 30 f4 cd e1  02 cd f8 d3 c3 40 d4 1e  |.{!.0........@..|
; 0000b780  ff cd e9 ad 23 57 ab 5f  7a cd 08 f6 0b 78 b1 20  |....#W._z....x. |
; 0000b790  f0 c9 e5 21 00 00 77 23  22 0a f6 21 00 00 23 22  |...!..w#"..!..#"|
; 0000b7a0  12 f6 7c fe 02 38 0a d5  c5 cd 36 f6 cd 29 f6 c1  |..|..8....6..)..|
; 0000b7b0  d1 e1 c9 21 00 3a 22 0a  f6 21 00 00 22 12 f6 c9  |...!.:"..!.."...|
; 0000b7c0  21 00 00 e5 cd f9 1d e1  c5 cd f1 1c ed 53 37 f6  |!............S7.|
; 0000b7d0  11 00 01 c1 21 00 3a 3a  6b 3e c3 96 22 21 1a ac  |....!.::k>.."!..|
; 0000b7e0  01 80 b0 cd 99 f4 cd c7  b6 22 78 3e 22 74 3e 01  |........."x>"t>.|
; 0000b7f0  80 b0 cd 3f f4 cd 70 b0  cd 30 f4 c3 e1 02 11 11  |...?..p..0......|
; 0000b800  ac 23 cd 5f cd 21 1a ac  01 80 b0 cd 99 f4 c2 86  |.#._.!..........|
; 0000b810  b0 22 72 3e 01 80 b0 cd  3f f4 cd c7 b6 cd 78 b0  |."r>....?.....x.|
; 0000b820  18 d6                                             |..|
; 0000b822
