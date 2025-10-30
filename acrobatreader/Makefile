
#
# AcrobatReader
#

SOFT:=AcrobatReader
#$(shell mkdir -p tmp; curl -s -L "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html" > tmp/release-notes-acrobat-reader.html)
WLINE:=$(shell curl -s -L "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html" | grep 'disablelinktracking="false">DC ' | head -1)
VERSION:=$(shell echo '$(WLINE)' | cut -f 2 -d '(' | cut -f 1 -d ')' | head -1)
URLTRANSIT:=$(shell echo '$(WLINE)' | sed -e 's/"/\n/g;' | grep '^https' | head -1)
VERSIONCOLLAPSE:=$(shell curl -s "$(URLTRANSIT)" | grep AcroRdrDCx64Upd | sed -e 's/"/\n/g;' | grep '^https' | cut -f 9 -d '/' | head -1)
VERSIONSHORT:=$(shell echo $(VERSIONCOLLAPSE) | sed -e 's/[\.0[:space:]]//g;')
REVISION:=1
URL:=https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/$(VERSIONCOLLAPSE)/AcroRdrDCx64$(VERSIONCOLLAPSE)_fr_FR.exe

EXE:=AcroRdrDCx64$(VERSIONCOLLAPSE)_fr_FR.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum
.ONESHELL:

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Adobe Acrobat
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*[[[:alnum:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)
	@if [ "$$( (echo 100000; grep -n "x64$(VERSIONCOLLAPSE)_" checksum.txt | cut -f 1 -d ':') | tail -1)" -lt "$$( (echo 100000; wc -l < checksum.txt) | tail -1)" ]; then echo 'VERSION $(VERSION) is older then last one' > /dev/stderr ; exit 1; fi

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION:         $(VERSION)"
	@echo "VERSIONCOLLAPSE: $(VERSIONCOLLAPSE)"
	@echo "VERSIONSHORT:    $(VERSIONSHORT)"
	@echo "URLTRANSIT:      $(URLTRANSIT)"
	@echo "URL:             $(URL)"
	@echo "EXE:             $(EXE)"

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
		#file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep '^Product Version:[[:space:]]' | sed -e 's/[\.0[:space:]]//g;' | cut -f 2 -d ':' | grep -q "^$(VERSIONSHORT)$$" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep '^Product Version:[[:space:]]' | sed -e 's/[\.0[:space:]]//g;' | cut -f 2 -d ':' | grep -q "^$(VERSIONSHORT)$$" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; }; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSIONCOLLAPSE)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@
	@grep -q "softversion=$(VERSIONCOLLAPSE)" $@ || echo "Error: bad version in install.bat"

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-remove.ps1 tmp/uninstall.bat
	@rm -f $@
	@zip -r ./$@ pre-remove.ps1
	@(cd tmp; zip -r ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
