# basic Makefile to build an example using the fjcore.cc|hh files.
# If you do not wish to use this Makefile, all you need to do is
#
#   g++ -O 01-basic.cc fjcore.cc -o 01-basic
#

# if you are not using the GNU compilers the names below will likely
# need to be redefined.
CXX=g++
FC=gfortran

CXXFLAGS=-O

all: 01-basic

01-basic: 01-basic.o fjcore.o
	$(CXX) $(LDFLAGS) -o $@ $@.o fjcore.o

fjcore_fortran_example: fjcore_fortran_example.o fjcorefortran.o fjcore.o
	$(FC) -o $@ fjcore_fortran_example.o fjcore.o fjcorefortran.o -lstdc++

clean:
	rm -vf 01-basic.o 01-basic fjcore_fortran_example.o fjcore_fortran_example
 
distclean: clean
	rm -f fjcore.o fjcorefortran.o

.cc.o:         $<
	$(CXX) $(CXXFLAGS) -c $< -o $@

fjcore.o: fjcore.hh
01-basic.o: fjcore.hh
