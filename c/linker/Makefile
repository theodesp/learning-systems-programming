all: libextern.a

run.o:
	clang -c run.c

extern.o: 
	clang -c extern.c

libextern.a: extern.o run.o
	ar rc libextern.a extern.o
