
#
# Gimp
#

SOFT:=Gimp
SHORTVERSION:=$(shell curl -s -L --connect-timeout 10 'https://www.gimp.org/downloads/' | egrep 'SHA256.*code.*gimp-.*setup.*exe' | cut -f 2 -d '-')
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://www.gimp.org/downloads/' | grep -E 'gimp-.*-setup.*.exe"' | sed -e 's/-setup-\([[:digit:]][[:digit:]]*\)/.0.\1/; s/\.exe/-exe/;' | cut -f 2 -d '"' | xargs -r -n 1 basename | cut -f 2 -d '-')
REVISION:=1
URL:=https:$(shell curl -s -L --connect-timeout 10 'https://www.gimp.org/downloads/' | egrep 'gimp-.*-setup.*.exe"' | cut -f 2 -d '"')

EXE:=gimp-$(VERSION)-setup.exe

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
	@echo "SHORTVERSION: $(SHORTVERSION)"
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
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(SHORTVERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.psd1: winsoft-config.psd1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/winsoft-config.psd1 tmp/$(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.psd1 $(EXE))
	@chmod ugo+rw $@
