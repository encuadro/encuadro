# Program: makefile
# Proyect: sift - encuadro - Facultad de Ingeniería - UDELAR
# Author: Pablo Flores
#
# Description: SIFT

SRC = 	vl/generic.c vl/host.c vl/random.c vl/pgm.c vl/mathop.c vl/sift.c vl/imopv.c

HDR = 	vl/generic.h vl/host.h vl/random.h vl/pgm.h vl/mathop.h vl/sift.h vl/imopv.h

all: encuadrosift 


encuadrosift: encuadroSift.c encuadroSift.h ${SRC} ${HDR} 
	gcc -O4 -std=c99 -o encuadroSift encuadroSift.c ${SRC} -L/usr/lib/mysql -lmysqlclient -I/usr/include/mysql -lm -DVL_DISABLE_SSE2 -lpthread

clean:
	-rm -f *.o *~ encuadrosift

saludar:
	echo "hola"
