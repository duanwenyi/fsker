`ifndef __IVS_DEF__
  `define __IVS_DEF__

  `define IVS_DMAC_BUS_64

  `ifdef IVS_DMAC_BUS_64
    `define BDWD 64   // Bus Data Width
  `else
    `define BDWD 128  // Bus Data Width
  `endif

  `define IVS_CTRL 10'h000
  `define IVS_TRIG 10'h004

  `define IVS_PAR0  10'h100
  `define IVS_PAR1  10'h104
  `define IVS_PAR2  10'h108
  `define IVS_PAR3  10'h10c
  `define IVS_PAR4  10'h110
  `define IVS_PAR5  10'h114
  `define IVS_PAR6  10'h118
  `define IVS_PAR7  10'h11c
  `define IVS_PAR8  10'h120
  `define IVS_PAR9  10'h124
  `define IVS_PAR10 10'h128
  `define IVS_PAR11 10'h12c


`endif
