# x64 NASM registers cheat sheet

## Registers

|                         | 64 bit | 32 bit | 16 bit | 8 bit |
|-------------------------|--------|--------|--------|-------|
| A (accumulator)         | `RAX`  | `EAX`  | `AX`   | `AL`  |
| B (base, addressing)    | `RBX`  | `EBX`  | `BX`   | `BL`  |
| C (counter, iterations) | `RCX`  | `ECX`  | `CX`   | `CL`  |
| D (data)                | `RDX`  | `EDX`  | `DX`   | `DL`  |
| D (Destination)         | `RDI`  | `EDI`  | `DI`   | `DIL` |
| S (Source)              | `RSI`  | `ESI`  | `SI`   | `SIL` |
| Numbered (n=8..15)      | `Rn`   | `RnD`  | `RnW`  | `RnB` |
| Stack pointer           | `RSP`  | `ESP`  | `SP`   | `SPL` |
| Frame pointer           | `RBP`  | `EBP`  | `BP`   | `BPL` |

As well as XMM0 .. XMM15 for 128 bit floating point numbers.

Put function arguments (first to last) in the following registers (64 bit
representations): RDI, RSI, RDX, RCX, R8, R9, then push to stack (in reverse,
has to be cleaned up by the caller!) XMM0 - XMM7 for floats

Return values are stored in RAX (`int`) or XMM0 (`float`)

RBP, RBX, R12, R13, R14, R15 will not be changed by the called function, all
others may be

Align stack pointer (RSP) to 16 byte, calling pushes 8 bytes!

Keep in mind that strings (in C) are 0-terminated

Like in a normal C program, the label that is (de facto) called first is
`main`, with the args `argc` (argcount) in RDI, and the `char** argv` in RSI
(the commandline arguments as in C's main function).


## Data

| Definition size    | Definition instruction |
|--------------------|------------------------|
| 8 bit              | `db`                   |
| 16 bit             | `dw`                   |
| 32 bit             | `dd`                   |
| 64 bit             | `ddq`/`do`             |
| float              | `dd`                   |
| double             | `dq`                   |
| extended precision | `dt`                   |