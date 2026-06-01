
#
# Picocrypt-NG
#

SOFT:=Picocrypt-NG
# https://github.com/HACKERALERT/Picocrypt/releases/latest
# https://github.com/Picocrypt-NG/Picocrypt-NG/releases/latest
#VERSION:=$(shell curl -s -L --connect-timeout 10 'https://github.com/Picocrypt-NG/Picocrypt-NG/releases/latest' | sed -e 's/>/\n/g;' | grep 'Picocrypt.*title' | cut -f 3 -d ' ' | grep '^[[:digit:]]' | head -1)
REVISION:=1
URL:=https://github.com/$(shell curl -s -L --connect-timeout 10 'https://github.com/Picocrypt-NG/Picocrypt-NG/releases' | sed -e 's/[">]/\n/g;' | grep '/Picocrypt-NG-Setup.exe' | sed 's#^/##;' | head -1)
VERSION:=$(shell echo "$(URL)" | cut -f 8 -d '/')
VERSIONSHORT:=$(shell echo "$(VERSION)" | sed 's/\.0/./g;')

EXE:=Picocrypt-NG-Setup-$(VERSION).exe
REG_SEARCH:=Picocrypt

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

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
	@echo "VERSIONSHORT: $(VERSIONSHORT)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -L --connect-timeout 10 -o "$(EXE)" "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSIONSHORT)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__QEXEADMIN__/$(QEXEADMIN)/;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@
