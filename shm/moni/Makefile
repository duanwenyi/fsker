SLIB     = ..
EVA_PATH = $(SLIB)/include
EVA_SRC  = $(wildcard $(EVA_PATH)/*.c)
#EVA_OBJ  = $(EVA_SRC:.c=.o)
EVA_OBJ      = $(patsubst %.c,%.o,$(EVA_SRC))

EVA_APP_PATH = $(SLIB)/moni
SOURCES      = $(wildcard $(EVA_APP_PATH)/*.c)
OBJECTS      = $(patsubst %.c,%.o,$(SOURCES))

CC          = gcc
CXX         = g++
#DEFINES     = -m32
CFLAGS      = -pipe -O2 -Wall -fPIC $(DEFINES) -lpthread
CXXFLAGS    = -pipe -O2 -Wall -fPIC $(DEFINES) -lpthread
INCPATH     = -I$(EVA_PATH) -I.
LINK        = g++
LFLAGS      = $(DEFINES) -lpthread
LIBS        = 

BIN         = moni

%.o: %.c
	$(CXX) $(CFLAGS) $(INCPATH) -c $< -o $@

%.o: %.cc
	$(CXX) $(CXXFLAGS) $(INCPATH) -c $< -o $@

$(BIN): $(OBJECTS) $(EVA_OBJ)
	$(LINK) $^ $(LFLAGS) $(INCPATH) $(LIBS) -o $@
	\rm $(OBJECTS) $(EVA_OBJ) -rf

clean:
	rm $(OBJECTS) $(EVA_OBJ) $(BIN) -rf

