CXX           = g++
CXXFLAGS      = -g -m64 -pipe -O2 -std=gnu++1z -fPIC
CXXFLAGS2     = -g -m64 -fPIC -shared -o

TARGET = wigilib.so
SRCS = cpupolllib.cpp 

BIN = cpupolllib.o

$(TARGET): $(SRCS)
	$(CXX) $(CXXFLAGS) -c $(SRCS) -o $(BIN)
	$(CXX) $(CXXFLAGS2) $(TARGET) cpu_register.o $(BIN) -lhwloc


clean: 
	-rm -f $(TARGET) $(BIN)



