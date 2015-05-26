SLIB     = /home/apachee/eva
EVA_PATH = $(SLIB)/shm/include
EVA_SRC  = $(wildcard $(EVA_PATH)/*.c)
EVA_OBJ  = $(EVA_SRC:.c=.o)

EVA_APP_PATH = $(PWD)/../app
SOURCES      = $(wildcard $(EVA_APP_PATH)/*.c)
#SOURCES      = $(EVA_APP_PATH)/eve_demo.c
OBJECTS      = $(patsubst %.c,%.o,$(SOURCES))

CC          = gcc
CXX         = g++
DEFINES     = -m32
CFLAGS      = -pipe -O2 -Wall -fPIC $(DEFINES) -lpthread
CXXFLAGS    = -pipe -O2 -Wall -fPIC $(DEFINES) -lpthread
INCPATH     = -I$(EVA_PATH) -I.
LINK        = gcc
LFLAGS      = $(DEFINES) -lpthread
LIBS        = 

BIN         = eva_demo

%.o: %.c
	$(CC) $(CFLAGS) $(INCPATH) -c $< -o $@

$(BIN): $(OBJECTS) $(EVA_OBJ)
	$(LINK) $^ $(LFLAGS) $(INCPATH) $(LIBS) -o $@
	\rm $(OBJECTS) $(EVA_OBJ) -rf

clean:
	rm $(OBJECTS) $(EVA_OBJ) $(BIN) -rf

