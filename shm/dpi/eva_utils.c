#include "eva_utils.h"

void *emem_init(uint32_t width, uint32_t depth, uint32_t mskbits){
  EMEM_UNIT_p sto = (EMEM_UNIT_t *)malloc(sizeof(EMEM_UNIT_t));

  uint32_t size = (width+7) * depth / 8;
  if( (size != 0) && (mskbits != 0) ){
    sto->Width    = width;
    sto->Depth    = depth;
    sto->MaskBits = mskbits;
    
    sto->LinePerBytes = (width+7)/8;  // The memory width may not byte align !
    sto->MaskPerBytes = sto->LinePerBytes/mskbits;

    sto->mem = malloc(size);
    
    if(sto->mem == NULL){
      fprintf(stderr," @EVA MEM initialed FAIL !  %d x %d : MASK %d",width, depth, mskbits);
      return NULL;
    }else
      return (void *)sto;
  }else{
      fprintf(stderr," @EVA MEM initialed parameters ERROR !  %d x %d : MASK %d",
	      width, depth, mskbits);

      return NULL;
  }

}

void emem_wr_acc( void                   *handle,
		  svBitVecVal            *addr,
		  svBitVecVal            *wmsk,
		  const svOpenArrayHandle data
		  ){
  EMEM_UNIT_p sto = (EMEM_UNIT_t *)handle;

  svBitVecVal byte_da;
  uint8_t    *ptr;
  uint32_t    u,cc,ofst;

  uint32_t    e_addr = *addr;
  uint32_t    e_wmsk = *wmsk;

  sto->LastAccAddr = e_addr;
  sto->LastAccMask = e_wmsk;

  if( e_addr < sto->Depth){
    ptr = (uint8_t *)&sto->mem[e_addr * sto->LinePerBytes];
    for(u=0,ofst=0; u< sto->MaskBits; u++){
      if( e_wmsk & (1<< u) ){
	for(cc=0; cc< sto->MaskPerBytes; cc++){
	  svGetBitArrElemVecVal( &byte_da, data, ofst + cc);
	  ptr[ofst + cc] = byte_da;
	}
      }
      ofst += sto->MaskPerBytes;
    }
    
  }else{
    fprintf(stderr," ERROR @EVA MEM Write Access : Address %d exceed depth %d",
	    e_addr, sto->Depth);
  }
}

void emem_rd_acc_i( void                   *handle,
		    svBitVecVal            *addr
		    ){
  EMEM_UNIT_p sto = (EMEM_UNIT_t *)handle;

  uint32_t    e_addr = *addr;

  sto->LastAccAddr = e_addr;

  if( e_addr < sto->Depth){
  }else{
    fprintf(stderr," ERROR @EVA MEM Read Access : Address %d exceed depth %d",
	    e_addr, sto->Depth);
  }
}

void emem_rd_acc_o( void                   *handle,
		    const svOpenArrayHandle data
		    ){
  EMEM_UNIT_p sto = (EMEM_UNIT_t *)handle;

  svBitVecVal byte_da;
  uint8_t    *ptr;
  uint32_t    cc;

  uint32_t    e_addr = sto->LastAccAddr;

  if( e_addr < sto->Depth){
    ptr = (uint8_t *)&sto->mem[e_addr * sto->LinePerBytes];
    for(cc=0; cc< sto->LinePerBytes; cc++){
      byte_da = ptr[cc];
      svGetBitArrElemVecVal( data, &byte_da, cc);
    }

  }else{
    fprintf(stderr," ERROR @EVA MEM Write Access : Address %d exceed depth %d",
	    e_addr, sto->Depth);
  }
}

