
#
# OCSInventory-Agent
#

OCS_SERVER:=ocs-server.example.com
OCS_SSL:=1

SOFT:=OCSInventory-Agent
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://github.com/OCSInventory-NG/WindowsAgent/releases/latest' | sed 's/</\n/g;'| grep '^meta property.*Release Agent Windows' |cut -f 6 -d ' ')
REVISION:=1
URL:=https://github.com/OCSInventory-NG/WindowsAgent/releases/download/$(VERSION)/OCS-Windows-Agent-$(VERSION)_x64.zip
FOLDER:=OCS-Windows-Agent-$(VERSION)_x64
EXE:=OCS-Windows-Agent-Setup-$(VERSION)-x64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=OCS Inventory NG Agent
OCS_PRIORITY:=$(shell expr $(OCS_PRIORITY) + 3)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

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
		curl -# -o "$(FOLDER).zip" -L "$(URL)" ; \
		unzip -q "$(FOLDER).zip" ; \
		rm -f "$(FOLDER).zip" ; \
		mv -f "$(FOLDER)/OCS-Windows-Agent-Setup-x64.exe" "$(EXE)"; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s#__OCS_SERVER__#$(OCS_SERVER)#; s/__OCS_SSL__/$(OCS_SSL)/;' $< > $@

tmp/install-outofservice.bat: install-outofservice.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s#__OCS_SERVER__#$(OCS_SERVER)#; s/__OCS_SSL__/$(OCS_SSL)/;' $< > $@

%.zip: Makefile post-install.ps1 tmp/install.bat tmp/install-outofservice.bat tmp/$(EXE)
	@rm -f $@
	@zip -r $@ post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat install-outofservice.bat $(EXE))
	@chmod ugo+rw $@
