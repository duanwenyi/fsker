EVA_PRO_PATH = $(PWD)/..
EVA_PATH     = $(EVA_PRO_PATH)/shm/include
EVA_SRC      = $(wildcard $(EVA_PRO_PATH)/shm/dpi/*.c) $(EVA_PATH)/eva.c
#EVA_OBJ      = $(EVA_SRC:.c=.o) $(EVA_PRO_PATH)/shm/dpi/eva_hdl_drv.c
EVA_OBJ      = $(patsubst %.c,%.o,$(EVA_SRC))

CC          = gcc
CXX         = g++
DEFINES     = 
CFLAGS      = -pipe -O2 -Wall -W -m32 $(DEFINES) -lpthread
CXXFLAGS    = -pipe -O2 -Wall -W -m32 $(DEFINES) -lpthread
INCPATH     = -I$(EVA_PATH) -I$(EVA_PRO_PATH)/shm/dpi -I$(VCS_HOME)/include -I$(CDSHOME)/tools/include
LINK        = gcc
LFLAGS      = -Wl -lpthread
LIBS        = 

## HDL compile options
TOP_MODULE    = TH
DUT_CMPL_OPTS = -sv -update
DUT_ELAB_OPTS = -delay_mode zero -notimingchecks -noneg_tchk -access +rwc -loadvpi ./libdpi.so:setup_eva_callbacks -timescale 1ns/10ps ${TOP_MODULE}
DUT_RUN_OPTS  = ${TOP_MODULE} -nontcglitch -errormax 1 -input wave.tcl

HDL_COMPILER = ncvlog


# VCS
#USER_RUN_OPTS += -ucli -i ./wave_fsdb.do

eva:
	make -f ../app/Makefile

dpi:
	$(CC) -Wall -g -fPIC -m32 $(EVA_SRC) $(INCPATH) -shared -o libdpi.so

svtb:
	$(CC) -Wall -g -fPIC -m32 $(EVA_SRC) $(INCPATH) -shared -o libdpi.so
#	vcs -f project.f libdpi.so $(DUT_CMP_OPTS)
	ncvlog -f project.f $(DUT_CMPL_OPTS)
	ncelab $(DUT_ELAB_OPTS)

run:
	ncsim $(DUT_RUN_OPTS)

ipcs:
	ipcs -m |grep $$USER |awk '{print $$2}' | xargs ipcrm -m

clean:
	rm *.fsdb INCA_libs libdpi.so *.log eva_demo *.shm *.key evaScopeGet.txt -rf
