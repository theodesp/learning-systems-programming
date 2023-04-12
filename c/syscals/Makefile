ZIG = zig
CFLAGS = -Wall -Wextra -pedantic

.PHONY: all clean

all: copy_file_range

copy_file_range: copy_file_range.c
	$(ZIG) cc $(CFLAGS) -o $@ $<

clean:
	rm -f copy_file_range