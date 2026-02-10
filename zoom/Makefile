
#
# Zoom
#

SOFT:=Zoom
VERSIONLONG:=$(shell curl -s -L --connect-timeout 10 'https://www.zoom.us/rest/download?os=win' | sed -e 's/[,{}]/\n/g;' | grep -A 5 '^"zoomX64"' | grep '^"version"' | cut -f 4 -d '"' | cut -f 1 -d ' ' | head -1)
VERSIONCHECK:=$(shell echo $(VERSIONLONG) | cut -f 1-3 -d '.')
VERSION:=$(shell echo $(VERSIONLONG) | cut -f 1-2,4 -d '.')
REVISION:=1
URL:=https://cdn.zoom.us/prod/$(VERSIONLONG)/x64/ZoomInstallerFull.msi

ZSSOHOST:=$(shell grep -h '^ZSSOHOST' conf.yml ../../winsoft-conf/zoom/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)

EXE:=ZoomInstallerFull-$(VERSION).msi
REG_SEARCH:=Zoom\\sWorkplace

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control version wget checksum

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSIONLONG: $(VERSIONLONG)"
	@echo "VERSIONCHECK: $(VERSIONCHECK)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

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
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		which msiextract >/dev/null && { rm -rf Program*File* CustomAction.dll; msiextract $(EXE) >/dev/null ; rm -rf Program*File*; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'Little Endian, Os: Windows, Version 10.0, MSI Installer' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file $(EXE) | grep -q 'Subject: Zoom Meetings.*Comments: $(VERSIONCHECK)' || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v 'CustomAction.dll' 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSIONCHECK)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__ZSSOHOST__/$(ZSSOHOST)/g;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-remove.ps1 tmp/uninstall.bat
	@rm -f $@
	@zip -Xr ./$@ pre-remove.ps1
	@(cd tmp; zip -Xr ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
