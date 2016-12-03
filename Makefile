CFLAGS = -O3 -Wall -static -Wno-unknown-pragmas
LDLIBS = -lorcon -lm -lrt
CC = gcc

ALL = inject

all: $(ALL)

clean:
	rm -f *.o $(ALL)

inject: inject.c util.o

util.c: util.h
