
#
# Inkscape
#

sinclude ../_common/flag.mk

SOFT:=Inkscape
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://inkscape.org/en/release/' | sed -e 's/"/\n/g;' | grep '^http.*/release/inkscape-' | cut -f 2 -d '-' | cut -f 1 -d '/' | grep '^[[:digit:]]' | head -1)
REVISION:=1
#URL:=https://inkscape.org/$(shell curl -s -L --connect-timeout 10 'https://inkscape.org/release/inkscape-$(VERSION)/windows/64-bit/msi/dl' |  sed -e 's/\s/\n/g; s/"/=/g;' | grep '^url=' | cut -f 2 -d '=')
URL:=https://media.inkscape.org/dl/resources/file/inkscape-$(VERSION).msi

EXE:=inkscape-$(VERSION)-x64.msi

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
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "CURL: $(CURLFLAGS)"

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
		curl $(CURLFLAGS) -# -o "$(EXE)" -L "$(URL)" ; \
		# file $(EXE) | grep -q "Subject: Inkscape" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		which 7z >/dev/null && { rm -f 'CM_FP_inkscape.bin.inkscape.exe'; 7z x -y "$(EXE)" 'CM_FP_inkscape.bin.inkscape.exe' | grep 'Extracting'; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Inkscape" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v 'CM_FP_inkscape.bin.inkscape.exe' 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.psd1: winsoft-config.psd1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.psd1 tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.psd1 $(EXE))
	@chmod ugo+rw $@
