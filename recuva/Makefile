
#
# Recuva
#

SOFT:=Recuva
#URL:=$(shell curl -s -L 'https://www.ccleaner.com/fr-fr/recuva/download/standard' | sed -e 's/[[:space:]]/\n/g;' | grep data-download-url  | cut -f 2 -d '"')
LASTEST_VERSION:=$(shell curl -s -L 'https://www.ccleaner.com/recuva/version-history' --user-agent "$(USERAGENT)" | grep 'version-history__latest-version')
VERSION:=$(shell echo "$(LASTEST_VERSION)" | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1\.\2.\3/;')
PVERSION:=$(shell echo "$(LASTEST_VERSION)" | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.0*\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1.\2\.*\3/;')
URL:=https://download.ccleaner.com/rcsetup$(shell echo $(VERSION) | cut -f 1,2 -d '.' | sed -e 's/\.//;').exe
REVISION:=1

EXE:=rcsetup$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY:  all check-version check-unrealized check-exe clean control next ocs version wget checksum
.ONESHELL:

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

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
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
