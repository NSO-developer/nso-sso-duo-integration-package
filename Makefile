MAKE ?= make
PYTHONPATH := $(PYTHONPATH):$(CURDIR)/scripts:$(CURDIR)/load-dir

.PHONY: all
all: build

.PHONY: build
build:
	$(MAKE) -C src all

duo: clean_duo duo_deps build_duo

duo_deps:
	apt-get install sudo autoconf libtool libpam-dev libssl-dev make

build_duo:
	git clone org-526376@github.com:duosecurity/duo_unix.git
	cd duo_unix; ./bootstrap
	cd duo_unix; ./configure --prefix=/usr && make && sudo make install

pyvenv:
	virtualenv $@
	$@/bin/pip $(PIP_OPTS) install -r requirements.txt

.PHONY: check
check: pyvenv
	$</bin/pip $(PIP_OPTS) install -r requirements-test.txt
	$</bin/flake8 --max-line-length=80 scripts/authenticate

.PHONY: test
test: check
	(. pyvenv/bin/activate; \
		$(MAKE) PYTHONPATH="$(PYTHONPATH)" -C $@)

.PHONY: clean
clean:
	$(MAKE) -C src clean
	$(MAKE) -C test clean
	rm -rf load-dir python scripts/__pycache__
	rm -rf pyvenv

clean_duo:
	rm -rf duo_unix