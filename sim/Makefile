EVA_PRO_PATH = $(PWD)/../app
EVA_PATH     = $(EVA_PRO_PATH)/shm/include
EVA_SRC      = $(EVA_PATH)/eva.c 
EVA_OBJ      = $(EVA_SRC:.c=.o) $(EVA_PRO_PATH)/shm/dpi/eva_hdl_drv.c

CC          = gcc
CXX         = g++
DEFINES     = 
CFLAGS      = -pipe -O2 -Wall -W -m32 $(DEFINES) -lpthread
CXXFLAGS    = -pipe -O2 -Wall -W -m32 $(DEFINES) -lpthread
INCPATH     = -I$(EVA_PATH) -I$(EVA_PRO_PATH)/shm/dpi -I$(VCS_HOME)/include
LINK        = gcc
LFLAGS      = -Wl -lpthread
LIBS        = 

HDL_COMPILER = ncvlog

# VCS
#USER_RUN_OPTS += -ucli -i ./wave_fsdb.do

eva:
	make -f ../app/Makefile


svtb:
	$(CC) -Wall -g -fPIC -m32 $(EVA_SRC) $(INCPATH) -share -o libdpi.so
#	vcs -f project.f libdpi.so $(DUT_CMP_OPTS)
	ncvlog -f project.f $(DUT_CMP_OPTS)

run:
	ncsim

ipcs:
	ipcs -m |grep $$USER |awk '{print $$2}' | xargs ipcrm -m

clean:
	rm *.fsdb -rf
