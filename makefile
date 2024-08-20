cat: cat.s
	as cat.s -o cat.o
	ld cat.o -o cat
	rm *.o
