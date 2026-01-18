# Programs and CP/M 2.2 compact flash image for the RC2014

## Last updated 18th January 2026

Note: Some of these source files may have UNIX-style line endings, so may fail to run correctly if transferred directly via XMODEM etc. Simplest way to avoid this issue is to use cut and paste from the raw GitHub file into a CP/M ED session running in a terminal emulator, such as minicom.

### BASIC 4.7b

1. sunrise-sunset-minimal.bas: Sunset / sunrise calculator for a given latitude / longitude on a particular date. Minimal changes to the version published in Sky & Telescope https://skyandtelescope.org/astronomy-resources/basic-programs-from-sky-telescope/ so that it will run (' statements becomes REM, PRINT USING becomes PRINT).

2. mastermind.bas: Simple Mastermind game. Guess the correct order and colour of 4 pegs.

### Microsoft BASIC 5.21 (CP/M 2.2)

1. valley2.bas: A version of Computing Today's "The Valley" that will work on a VT100 emulator, such as minicom, or with PicoTerm.
   Run with MBASIC VALLEY2.BAS /M:55000 /F:1
   Three terminal types supported - vanilla VT100 (80x24), PicoTerm PetSCII (80x30) and PicoTerm CP437 (80x30)
   
### Turbo Pascal 3.01A (CP/M 2.2)

1. primes.pas: Prime number generator.

2. radec.pas: RADEC - Right Ascension and Declination for all the planets (plus Pluto). Converted from 'Celestial BASIC', program 11.

3. life.pas: Life - Conway's game of life. Requires a VT100 compatible display.

4. life2.pas: Conway's game of life with the introduction of random cells. Requires a VT100 compatible display.

### FTL (HiSoft) Modula-2 1.30 (CP/M 2.2)

1. primes.mod: Prime number generator.

### Aztec C 1.06D (CP/M 2.2)

1. primes.c: Prime number generator.

### Digital Research CBASIC80 2.0 (CP/M 2.2)

1. primes80.bas: Prime number generator.

### CP/M 2.2 128Mb Compact Flash image for RC2014 with SIO/2 serial board

Pre-formatted CP/M 2.2 image for the RC2014. On Linux / UNIX use:

dd if=rc2014sio2cpm.img of=/dev/\<your cf device name\> 
to create a new copy of the image onto a 128Mb compact flash card.

Includes drives A - P with the following contents:

```
A: DOWNLOAD.COM

C: LOAD     COM : PIP      COM : STAT     COM : SUBMIT   COM                    
   DDT      COM : DISPLAY  COM : DUMP     COM : ED       COM                    
   ASM      COM : COMPARE  COM : CRUNCH   COM : DDTZ     COM                    
   EX       COM : LS       COM : LSWEEP   COM : GENHEX   COM                    
   MBASIC   COM : NULU     COM : PMARC    COM : PMEXT    COM                    
   RMXSUB1  COM : SUPERSUB COM : TDLBASIC COM : UNARC    COM                    
   UNCR     COM : UNZIP    COM : XSUB1    COM : ZAP      COM                    
   ZDE      COM : ZDENST   COM : ZMRX     COM : ZMTX     COM                    
   CRUNCH28 CFG

#### Aztec C v1.06D

D: ARCV     COM : AS       COM : CC       COM : CC       MSG                    
   C        LIB : CNM      COM : CRC      COM : CZ       COM                    
   HEX80    COM : LIBC     REL : LIBUTIL  COM : LN       COM                    
   MATH     REL : M        LIB : ROM      LIB : SIDSYM   COM                    
   SQZ      COM : T        LIB

#### Microsoft FORTRAN-80 v3.44

F: CPMIO    MAC : DSKDRV   MAC : DTBF     MAC : FCHAIN   MAC                    
   INIT     MAC : IOINIT   MAC : LPTDRV   MAC : LUNTB    MAC                    
   TTYDRV   MAC : CRCKLIST CRC : CREF80   COM : F80      COM                    
   L80      COM : LIB      COM : M80      COM : FORLIB   REL

#### Sample programs

G: VALLEY2.BAS  (Microsoft BASIC 5.21 implementation of 'The Valley'
   LIFE.PAS     (Conway's Life in Turbo Pascal 3.01A)
   PRIMES80.BAS (Prime number generator, Digital Research BASIC 2.0)

#### Digital Research BASIC Compiler v2.0

O: CB80     COM : CB80     IRL : CB80     OV1 : CB80     OV2                    
   CB80     OV3 : CBAS2    COM : CRUN2    COM : LIB      COM                    
   LINK     COM : LK80     COM  

#### Borland Turbo Pascal v3.01A

P: TINST    COM : TINST    DTA : TINST    MSG : TURBO    COM                    
   TURBO    MSG : TURBO    OVR
```

Drives B,E,H,I,J,K,L,M and N are empty.
