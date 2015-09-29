#ifndef _EVA_UTILS_H_
#define _EVA_UTILS_H_

#include <unistd.h>  
#include <stdlib.h>  
#include <stdio.h>  
#include "svdpi.h"

typedef struct EMEM_UNIT{
  // Basic Info
  uint32_t  Width;
  uint32_t  Depth;
  uint32_t  MaskBits;

  uint32_t  LinePerBytes;
  uint32_t  MaskPerBytes;
  
  // TEMP USING
  uint32_t  LastAccAddr;
  uint32_t  LastAccMask;
  
  uint32_t  AddrMask;

  // Actual Memory Store DATA .
  uint8_t  *mem;
  

}EMEM_UNIT_t, *EMEM_UNIT_p;

void *emem_init(uint32_t width, uint32_t depth, uint32_t mskbits);

void emem_wr_acc( void                   *handle,
		  svBitVecVal            *addr,
		  svBitVecVal            *wmsk,
		  const svOpenArrayHandle data
		  );

void emem_rd_acc_i( void                   *handle,
		    svBitVecVal            *addr
		    );

void emem_rd_acc_o( void                   *handle,
		    svOpenArrayHandle       data
		    );

#endif
