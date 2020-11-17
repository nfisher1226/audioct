-include config.mk
DESTDIR    ?=
PREFIX     ?= /usr/local
BINDIR      = $(DESTDIR)$(PREFIX)/bin
LIBDIR      = $(DESTDIR)$(PREFIX)/lib
SYSCONFDIR  = $(DESTDIR)$(PREFIX)/etc
INSTALLDIRS = $(BINDIR) $(LIBDIR) $(SYSCONFDIR)
DSHELL      = $(shell which bash || which zsh || which ksh)
SHELLBASE   = $(notdir $(DSHELL))
VPATH      += bin
VPATH      += etc
VPATH      += lib

SRCS        = $(wildcard bin/*.sh.in)
OBJS        = $(patsubst bin/%.sh.in,%.sh,$(SRCS))
BIN_OBJS    = $(patsubst %.sh, $(BINDIR)/%.sh, $(OBJS))
CONF_OBJS   = audioct.conf
LIB_OBJS    = audioct_functions.sh

all: config.mk $(CONF_OBJS) $(OBJS)

config.mk:
	echo PREFIX ?= $(PREFIX) > config.mk

$(CONF_OBJS): %.conf: %.conf.in
	sed "s%@@SYSCONFDIR@@%$(SYSCONFDIR)%" $< > $@

$(OBJS): %.sh: %.sh.in
	sed -e "s%@@SHELL@@%$(DSHELL)%" \
	    -e "s%@@SHELLBASE@@%$(SHELLBASE)%" \
	    -e "s%@@LIBDIR@@%$(LIBDIR)%" \
	    -e "s%@@SYSCONFDIR@@%$(SYSCONFDIR)%" $< > $@

$(BIN_OBJS): $(BINDIR)/%.sh: %.sh | $(BINDIR)
	install -m0755 $< $@

$(LIBDIR)/$(LIB_OBJS): $(LIB_OBJS) | $(LIBDIR)
	install -m0644 $< $@

install-conf: all | $(SYSCONFDIR)
	install -m 644 audioct.conf $(SYSCONFDIR)/audioct.conf

install-bin: $(BIN_OBJS)

install-lib: $(LIBDIR)/audioct_functions.sh

install: install-bin install-conf install-lib

$(INSTALLDIRS):
	install -d $@

uninstall-bin:
	for obj in ${BIN_OBJS} ; \
		do [ -f ${DESTDIR}${PREFIX}/$${obj} ] && \
		unlink ${DESTDIR}${PREFIX}/$${obj} || true ; done

uninstall-conf:
	[ -f ${DESTDIR}${SYSCONFDIR}/audioct.conf ] && \
		unlink ${DESTDIR}${SYSCONFDIR}/audioct.conf || true

uninstall-lib:
	[ -f $(DESTDIR)$(LIBDIR)/audioct_functions.sh && \
		unlink $(DESTDIR)$(LIBDIR)/audioct_functions.sh || true

uninstall: uninstall-bin uninstall-conf uninstall-lib

clean:
	for obj in ${CONF_OBJS} ${OBJS} ; \
		do [ -f $${obj} ] && unlink $${obj} || true ; done

distclean: clean
	unlink config.mk || true

.PHONY: install-conf install-bin install uninstall-bin \
	uninstall-conf uninstall clean distclean
