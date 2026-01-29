
#
# Thunderbird
#

SOFT:=Thunderbird
WLINES:=$(shell curl -s -L --connect-timeout 10 'https://releases.mozilla.org/pub/thunderbird/releases/' | sed -e 's/"/\n/g;' | grep '^/pub/thunderbird/releases/' | cut -f 5 -d '/' | grep -E '^[[:digit:]][[:digit:]][[:digit:]][[:digit:]\.]*(esr)?$$' | paste -sd ',' )
VERSION_ESR:=$(shell echo "$(WLINES)" | sed -e 's/,/\n/g;' | grep '^[[:digit:]][[:digit:]\.]*esr$$' | sort -V | tail -1)
VERSION:=$(shell     echo "$(WLINES)" | sed -e 's/,/\n/g;' | grep '^[[:digit:]][[:digit:]\.]*$$'    | sort -V | tail -1)
#VERSION_LONG:=$(shell curl -s -L --connect-timeout 10 'https://www.thunderbird.net/en-US/thunderbird/all/' | sed -e 's/[[:space:]]/\n/g;' | grep 'data-thunderbird-version' | cut -f 2 -d '"')
#VERSION_ESR:=$(shell curl -s -L --connect-timeout 10 'https://releases.mozilla.org/pub/thunderbird/releases/' | sed -e 's/"/\n/g;' | grep '^/pub/thunderbird/releases/' | cut -f 5 -d '/' | grep '^[[:digit:]][[:digit:]\.]*esr$$' | sort -V | tail -1)
#VERSION:=$(shell echo $(VERSION_ESR) | sed -e 's/esr//;')
#VERSION:=$(shell curl -s -L --connect-timeout 10 'https://releases.mozilla.org/pub/thunderbird/releases/' | sed -e 's/"/\n/g;' | grep '^/pub/thunderbird/releases/' | cut -f 5 -d '/' | grep '^[[:digit:]][[:digit:]\.]*$$' | sort -V | tail -1)
REVISION:=1
URL:=https://download.mozilla.org/?product=thunderbird-$(VERSION)-msi-SSL&os=win64&lang=fr
# curl -s -L --connect-timeout 10 'https://www.thunderbird.net/en-US/thunderbird/all/' | grep -E 'https://.*/.product=thunderbird.*msi-SSL.os=win64.lang=fr' | cut -f 2 -d '"' | head -1

EXE:=Thunderbird-Setup-$(VERSION).msi
REG_SEARCH:=Mozilla\\sThunderbird

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION_ESR: $(VERSION_ESR)"
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
		file $(EXE) | grep -q "Composite Document File.*, MSI Installer" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file $(EXE) | grep -q "Subject: Mozilla Thunderbird $(VERSION) x64" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; \
		)
	@which jq >/dev/null && { if [ $$(cat policies.json | jq empty 2>&1 | wc -l) -ne 0 ]; then echo "Error: bad json file policies.json" 1>&2 ; exit 12; fi }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 policies.json tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -Xr $@ policies.json pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-remove.ps1 tmp/uninstall.bat
	@rm -f $@
	@zip -Xr ./$@ pre-remove.ps1
	@(cd tmp; zip -Xr ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
