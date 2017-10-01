-include config.mk
DESTDIR ?=
PREFIX ?= /usr/local
SYSCONFDIR ?= ${PREFIX}/etc
BINDIR = ${PREFIX}/bin

BIN_OBJS = flac2mp3.sh

all: config.mk ${CONF_OBJS} ${BIN_OBJS}
	@echo "Now type \"make install\"."

config.mk:
	echo PREFIX ?= ${PREFIX} > config.mk
	echo SYSCONFDIR ?= ${SYSCONFDIR} >> config.mk

clean:
	for obj in config.mk ${CONF_OBJS} ${BIN_OBJS} ; \
		do [ -f $${obj} ] && unlink $${obj} || true ; done
