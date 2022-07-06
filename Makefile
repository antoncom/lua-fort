PKGC ?= pkg-config

LUAPKG ?= lua
LUAPKGC := $(shell for pc in $(LUAPKG); do \
		$(PKGC) --exists $$pc && echo $$pc && break; \
	done)

LUA_VERSION := $(shell $(PKGC) --variable=V $(LUAPKGC))
LUA_LIBDIR := $(shell $(PKGC) --variable=libdir $(LUAPKGC))
LUA_CFLAGS := $(shell $(PKGC) --cflags $(LUAPKGC))
LUA_LDFLAGS := $(shell $(PKGC) --libs-only-L $(LUAPKGC))

CMOD = cfort.so
OBJS = fort.o lfort.o
LIBS = -l$(LUAPKG)
CSTD = -std=gnu99

OPT ?= -Os
WARN = -Wall -pedantic
CFLAGS += -fPIC $(CSTD) $(WARN) $(OPT) $(LUA_CFLAGS)
LDFLAGS += -shared $(CSTD) $(LIBS) $(LUA_LDFLAGS)

$(CMOD): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

install:
	mkdir -p $(DESTDIR)$(LUA_LIBDIR)/lua/$(LUA_VERSION)
	cp $(CMOD) $(DESTDIR)$(LUA_LIBDIR)/lua/$(LUA_VERSION)

clean:
	$(RM) -r $(CMOD) $(OBJS) docs
