all:
	cython swapcontext.pyx
	gcc swapcontext.c -ggdb -fPIC -shared -o swapcontext.so -lpython2.5 -I/usr/include/python2.5

