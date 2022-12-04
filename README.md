# aarch64-assembler-spectrum128k

I decided it might be fun to move development of Spectrum +4 to the Spectrum 128K machine.

In other words, develop Spectrum +4 OS (for the Raspberry Pi 400) on an actual Spectrum 128K compatible computer (e.g. 128K, +2, +2A, +3, etc).

To be able to do this, we'll need a cross assembler, so that we can assemble aarch64 code on an original ZX Spectrum.

The starting point I've chosen is to reverse engineer an existing assembler ([Prometheus](https://spectrumcomputing.co.uk/entry/25427/ZX-Spectrum/Prometheus)) and see if I can adapt it to assemble aarch64 assembly.

The end goal will be to develop directly on my own Spectrum +2A.

This repo is mostly concerned with reverse engineering the original Prometheus code, before I start adapting it.

I haven't yet decided how I will get code from my Spectrum +2A on to the Raspberry Pi 400, but there are some options I can think of:

* Installing a divMMC on my Spectrum, so that I can write files to an SD card, and insert that directly into the Raspberry Pi 400
* Wiring the audio of my Spectrum +2A to gpio pins on the Raspberry Pi 400, and getting it to convert the audio back to digital content
* Seeing if I can make a serial connection to the Raspberry Pi 400 from my Spectrum 128K, and have a bare metal program on the Raspberry Pi that loads the data stream and executes it
* Connecting the Spectrum +2A to my home network somehow, and writing the code to some remote filesystem that the Raspberry Pi 400 can PXE boot from

There are probably a bunch of other options too.

Note, the Spectrum 128K probably won't have enough memory for the full Spectrum +4 source code and assembled kernel image, so I will need some means to break it into parts while working on it, and to be able to load/save parts independently. I will also need to be able to stitch the parts together somehow for final deployment or transfer over the to the Raspberry Pi. But I'm not going to worry about that now, I will solve that problem later.
