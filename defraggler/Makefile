
#
# Defraggler
#

SOFT:=Defraggler
USERAGENT:=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0
#URL:=$(shell curl -s -L --connect-timeout 10 'https://www.ccleaner.com/fr-fr/defraggler/download/standard' --user-agent "$(USERAGENT)" | sed -e 's/[[:space:]]/\n/g;' | grep data-download-url  | cut -f 2 -d '"')
LASTEST_VERSION:=$(shell curl -s -L --connect-timeout 10 'https://www.ccleaner.com/defraggler/version-history' --user-agent "$(USERAGENT)" | grep 'version-history__latest-version')
VERSION:=$(shell echo "$(LASTEST_VERSION)" | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1\.\2.\3/;')
PVERSION:=$(shell echo "$(LASTEST_VERSION)" | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.0*\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1.\2\.*\3/;')
URL:=https://download.ccleaner.com/dfsetup$(shell echo $(VERSION) | cut -f 1,2 -d '.' | sed -e 's/\.//;').exe
REVISION:=1

EXE:=dfsetup$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum
.ONESHELL:

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "PVERSION: $(PVERSION)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)"  -L "$(URL)" ; \
		#file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		#which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -Xr ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
