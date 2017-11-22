INCLUDE = -I/usr/local/include/libfreenect
LIBS = -L/usr/local/lib -lpthread -lm -lfreenect -lGL -lGLU -lglut

main: main.c
	gcc $(INCLUDE) $(CFLAGS) $? -o $@ $(LIBS)
