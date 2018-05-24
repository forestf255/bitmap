CC=gcc
CFLAGS=-c -Wall
LDFLAGS= -lz -lm
AWK=awk

# Add your source files here:
LIB_SOURCES=bmp.c
LIB_OBJECTS=$(LIB_SOURCES:.c=.o)
LIB=libbmp.a

DOCS=docs/bitmap.html docs/README.html docs/freetype-fonts.html docs/built-in-fonts.html docs/LICENSE

ifeq ($(BUILD),debug)
# Debug
CFLAGS += -O0 -g
LDFLAGS +=
else
# Release mode
CFLAGS += -O2 -DNDEBUG
LDFLAGS += -s
endif

all: libbmp.a docs utils

debug:
	make BUILD=debug

libbmp.a: $(LIB_OBJECTS)
	ar rs $@ $^

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

bmp.o: bmp.c bmp.h

docs: docsdir $(DOCS)

docsdir:
	mkdir -p docs

docs/bitmap.html: bmp.h d.awk
	$(AWK) -v Title="API Documentation" -f d.awk $< > $@

docs/LICENSE: LICENSE
	cp $< $@

docs/README.html: README.md d.awk
	$(AWK) -f d.awk -v Clean=1 -v Title="README" $< > $@

docs/freetype-fonts.html: ftypefont/ftfont.h d.awk
	$(AWK) -v Title="FreeType Font Support" -f d.awk $< > $@

docs/built-in-fonts.html: fonts/instructions.md d.awk
	$(AWK) -v Title="Raster Font Support" -f d.awk -v Clean=1 $< > $@

utils: utilsdir utils/hello utils/bmfont utils/dumpfonts utils/cvrt utils/imgdup

utils/hello: hello.c libbmp.a
	$(CC) -o $@ $^ $(LDFLAGS)

utils/bmfont: fonts/bmfont.c misc/to_xbm.c libbmp.a
	$(CC) -o $@ $^ $(LDFLAGS)

utils/dumpfonts: fonts/dumpfonts.c misc/to_xbm.c libbmp.a
	$(CC) -o $@ $^ $(LDFLAGS)

utils/cvrt: misc/cvrt.c libbmp.a
	$(CC) -o $@ $^ $(LDFLAGS)

utils/imgdup: misc/imgdup.c libbmp.a
	$(CC) -o $@ $^ $(LDFLAGS)

utilsdir:
	mkdir -p utils

.PHONY : clean

clean:
	-rm -f *.o $(LIB)
	-rm -f hello *.exe test/*.exe
	-rm -rf $(DOCS)
	-rm -rf utils docs

# The .exe above is for MinGW, btw.
