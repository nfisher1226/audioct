-include config.mk
DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${PREFIX}/etc
BINDIR = ${PREFIX}/bin
DSHELL = $(shell which bash || which zsh || which ksh)

BIN_OBJS = \
bin/ape2mp3.sh \
bin/ape2ogg.sh \
bin/ape2wav.sh \
bin/flac2mp3.sh \
bin/flac2mp3-recursive.sh \
bin/flac2ogg.sh \
bin/m4a2mp3.sh \
bin/wav2mp3.sh \
bin/wav2ogg.sh \
bin/cue2mp3.sh \
bin/cue2ogg.sh \
bin/cue2flac.sh \
bin/set-flac-tags.sh \
bin/set-ogg-tags.sh \
bin/set-mp3-tags.sh

CONF_OBJS = etc/audioct.conf

all: config.mk ${CONF_OBJS} ${BIN_OBJS}
	@echo "Now type \"make install\"."

config.mk:
	echo PREFIX ?= ${PREFIX} > config.mk
	echo SYSCONFDIR ?= ${SYSCONFDIR} >> config.mk

$(CONF_OBJS): %.conf: %.conf.in
	sed "s%@@SYSCONFDIR@@%${SYSCONFDIR}%" $< > $@

$(BIN_OBJS): %.sh: %.sh.in
	sed -e "s%@@SHELL@@%${DSHELL}%" \
	    -e "s%@@SYSCONFDIR@@%${SYSCONFDIR}%" $< > $@

install-conf: all
	install -d ${DESTDIR}${SYSCONFDIR}
	install -m 644 etc/audioct.conf ${DESTDIR}${SYSCONFDIR}/audioct.conf

install-bin: all
	install -d ${DESTDIR}${BINDIR}
	for bin in ${BIN_OBJS} ; \
		do install -m 755 $${bin} ${DESTDIR}${BINDIR} ; done

install: install-bin install-conf

uninstall-bin:
	for obj in ${BIN_OBJS} ; \
		do [ -f ${DESTDIR}${PREFIX}/$${obj} ] && \
		unlink ${DESTDIR}${PREFIX}/$${obj} || true ; done

uninstall-conf:
	[ -f ${DESTDIR}${SYSCONFDIR}/audioct.conf ] && \
		unlink ${DESTDIR}${SYSCONFDIR}/audioct.conf || true

uninstall: uninstall-bin uninstall-conf

clean:
	for obj in ${CONF_OBJS} ${BIN_OBJS} ; \
		do [ -f $${obj} ] && unlink $${obj} || true ; done

distclean: clean
	unlink config.mk || true

.PHONY: install-conf install-bin install uninstall-bin \
	uninstall-conf uninstall clean
