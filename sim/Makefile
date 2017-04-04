EVA_PRO_PATH = ..
EVA_PATH     = $(EVA_PRO_PATH)/shm/include
EVA_SRC      = $(wildcard $(EVA_PRO_PATH)/shm/dpi/*.c) $(EVA_PATH)/eva.c
#EVA_OBJ      = $(EVA_SRC:.c=.o) $(EVA_PRO_PATH)/shm/dpi/eva_hdl_drv.c
EVA_OBJ      = $(patsubst %.c,%.o,$(EVA_SRC))

CC          = gcc
CXX         = g++
#DEFINES     = -m32
CFLAGS      = -pipe -O2 -Wall -W $(DEFINES) -lpthread
CXXFLAGS    = -pipe -O2 -Wall -W $(DEFINES) -lpthread
INCPATH     = -I$(EVA_PATH) -I$(EVA_PRO_PATH)/shm/dpi -I$(IES_HOME)/tools/include
VCS_INCPATH = -I$(EVA_PATH) -I$(EVA_PRO_PATH)/shm/dpi -I$(VCS_HOME)/include
#-I$(VCS_HOME)/include
LINK        = gcc
LFLAGS      = -Wl -lpthread
LIBS        = 

PRO_FILE    = ../cfg/project.f
LIB_DIR     = ./pre_sim

# HDL comple options when using VCS
VCS_SIM_EXEC   = ./simv_exec
VCS_MODE       = -full64
VCS_CMPL_OPTS  = -sverilog +v2k +libext+.v+.sv +verilog2001ext+.v +vcs+lic+wait +plusarg_save +notimingcheck +nospecify -timescale=1ns/10ps -debug $(VCS_MODE)
VCS_CMPL_OPTS += +incdir+$(VCS_HOME)/etc/vmm +vpi
VCS_CMPL_OPTS += -Mdir=./output/vmm_test_scrc -o $(VCS_SIM_EXEC) -l ./output/vmm_test.cmp_log
VCS_CMPL_OPTS += -f ${PRO_FILE} ${LIB_DIR}/libdpi.so
#VCS_CMPL_OPTS += +vpdfile+simv.vpd

VCS_RUN_OPTS   = -l ${LIB_DIR}/simv.log -ucli -i ../cfg/vcs_sim.tcl



## HDL compile options
TOP_MODULE    = TH
NC_MODE       = -64BIT 
#-CDS_IMPLICIT_TMPDIR ${LIB_DIR} -CDSLIB ../cfg/cds.lib -HDLVAR ../cfg/hdl.var
DUT_CMPL_OPTS = -sv -update ${NC_MODE} -f ${PRO_FILE} -LOGFILE ${LIB_DIR}/ncvlog.log
#-loadvpi ./libdpi.so:setup_eva_callbacks  ## remove by using DPI interface replace VPI
DUT_ELAB_OPTS = -delay_mode zero ${NC_MODE} -notimingchecks -noneg_tchk -access +rwc -timescale 1ns/10ps ${TOP_MODULE} -LOGFILE ${LIB_DIR}/ncelab.log
DUT_RUN_OPTS  = ${TOP_MODULE} ${NC_MODE} -nontcglitch -errormax 1 -input ../cfg/wave.tcl

HDL_COMPILER  = ncvlog


# VCS
#USER_RUN_OPTS += -ucli -i ./wave_fsdb.do

app:
	make -f ../app/Makefile

dpi:
	$(CXX) -Wall -g -fPIC $(DEFINES) $(EVA_SRC) $(INCPATH) -shared -o libdpi.so

svtb: dpi
	ncvlog $(DUT_CMPL_OPTS)
	ncelab $(DUT_ELAB_OPTS)

ncvlog_dbg:
	nchelp $(DUT_CMPL_OPTS)

run:
	ncsim $(DUT_RUN_OPTS)


sstb:
	$(CXX) -Wall -g -fPIC $(EVA_SRC) $(VCS_INCPATH) -DUSING_VCS_COMPILER -shared -o $(LIB_DIR)/libdpi.so
	@mkdir -p output
	vcs $(VCS_CMPL_OPTS)

srun:
	$(VCS_SIM_EXEC) $(VCS_RUN_OPTS)

elog:
	./app_demo 2>&1 | tee app_run.log

ipcs:
	ipcs -m |grep $$USER |awk '{print $$2}' | xargs ipcrm -m

clean:
	rm *.fsdb INCA_libs *.log app_demo *.shm *.key output simv_exec* libdpi.so ${LIB_DIR}/* -rf
