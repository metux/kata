
export GOPATH := $(abspath $(CURDIR))
export BINDIR ?= /usr/bin
export UPSTREAM_VERSION := master

COMPONENTS := \
    agent \
    osbuilder \
    proxy \
    runtime \
    shim \
    packaging

COMP := $(addprefix kata-containers/,$(COMPONENTS))

all:
	$(MAKE) BINDIR=$(BINDIR) -C $(GOPATH)/src/github.com/kata-containers/runtime

clean:
	$(MAKE) -C $(GOPATH)/src/github.com/kata-containers/runtime clean
	rm -f bin/yq
	find -name "*.a" -delete
	if [ -d bin ]; then rmdir bin ; fi

fetch-source:
	for i in $(COMP) ; do \
            git subtree add  --prefix "src/github.com/$$i" "https://github.com/$$i" $(UPSTREAM_VERSION) ; \
            git subtree pull --prefix "src/github.com/$$i" "https://github.com/$$i" $(UPSTREAM_VERSION) ; \
        done

install:
	$(MAKE) BINDIR=$(BINDIR) DESTDIR=$(HOME)/FOOBAR -C $(GOPATH)/src/github.com/kata-containers/runtime install

.PONY: all clean
