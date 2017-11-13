-include config.mk
DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${PREFIX}/etc
BINDIR = ${PREFIX}/bin
DSHELL = $(shell which bash || which zsh || which ksh)

BIN_OBJS = bin/flac2mp3.sh bin/flac2ogg.sh bin/wav2mp3.sh bin/wav2ogg.sh
CONF_OBJS = etc/audioct.conf

all: config.mk ${CONF_OBJS} ${BIN_OBJS}
	@echo "Now type \"make install\"."

etc/audioct.conf:
	sed "s%@@SYSCONFDIR@@%${SYSCONFDIR}%" etc/audioct.conf.in > \
		etc/audioct.conf

config.mk:
	echo PREFIX ?= ${PREFIX} > config.mk
	echo SYSCONFDIR ?= ${SYSCONFDIR} >> config.mk

$(BIN_OBJS): %.sh: %.sh.in
	sed "s%@@SHELL@@%${DSHELL}%" $< > $@

install-conf: all
	install -d ${DESTDIR}${SYSCONFDIR}
	install -m 644 etc/audioct.conf ${DESTDIR}${SYSCONFDIR}/audioct.conf

install-bin: install-conf
	install -d ${DESTDIR}${BINDIR}
	for bin in ${BIN_OBJS} ; \
		do install -m 755 $${bin} ${DESTDIR}${BINDIR} ; done

install: all install-bin

uninstall-bin:
	for obj in ${BIN_OBJS} ; \
		do [ -f ${DESTDIR}${BINDIR}/$${obj} ] && \
		unlink ${DESTDIR}${BINDIR}/$${obj} || true ; done

uninstall: uninstall-bin
	[ -f ${DESTDIR}${SYSCONFDIR}/audioct.conf ] && \
		unlink ${DESTDIR}${SYSCONFDIR}/audioct.conf || true

clean:
	for obj in config.mk ${CONF_OBJS} ${BIN_OBJS} ; \
		do [ -f $${obj} ] && unlink $${obj} || true ; done

.PHONY: install-conf install-bin install uninstall-bin \
	uninstall clean
