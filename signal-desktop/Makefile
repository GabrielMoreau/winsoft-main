
#
# Signal-Desktop
#

SOFT:=Signal-Desktop
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest' |  grep '"tag_name":' | cut -f 4 -d '"' | sed -e 's/^v//;' | head -1)
REVISION:=1
URL:=https://updates.signal.org/desktop/signal-desktop-win-x64-$(VERSION).exe

EXE:=signal-desktop-win-x64-$(VERSION).exe
REG_SEARCH:=Signal\\s\\d\\.

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Signal__.

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
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

%.zip: Makefile uninstall.bat tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -Xr $@ uninstall.bat pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@
