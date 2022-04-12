## AHB-lite Verification in SystemVerilog
#EE-599f SoC SystemVerilog Final Project
## Introduction
AHB is a protocol introduced by the second version of the standard and it is dedicated to high
performance transfers, to connect internal and external memories and high performance peripherals.
It describes bus transactions as composed of an addressing phase, followed by a data phase. Usually,
the first phase lasts one clock cycle, while the second phase can last one or more cycles (in case of wait
states, a particular scenario described later on this chapter). In order to improve performances, these
phases can be pipelined. Furthermore, it is possible to use multiple masters controlling the accesses
to the target device with a multiplexer (non-tri-state), to have only one master at a time enabled to
access the bus.
AHB-Lite represents a subset of AHB, defined by the third version of the standard, where the bus
design is simplified for single masters.
AHB, Advanced High-performance Bus, defines the interfaces for master, slave and interconnections
between them, allowing high performance and clock frequencies, thanks to the following characteristics:
- Single clock edge operations.
- Burst transfers.
- Non-tristate implementation.
- Broad data bus configurations such as 64, 128, 256, 512 and 1024 bits.
A transfer starts from the master, sending control signals and the address. The control signals include
the direction, i.e. whether the operation is to write the data (from the master to the slave) or to read
the data (from the slave to the master), the width of the transfer and whether the transfer is single
or burst (incremental or wrapping to a particular address).

## Documentation
This project consists of 
- documentation file
- RTL file
- Sim file
