
#
# AcrobatReader
#

SOFT:=AcrobatReader
#$(shell mkdir -p tmp; curl -s -L "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html" > tmp/release-notes-acrobat-reader.html)
#WLINE:=$(shell curl -s -L --connect-timeout 10 "https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html" | grep 'disablelinktracking="false">DC ' | head -1)
#VERSION:=$(shell echo '$(WLINE)' | cut -f 2 -d '(' | cut -f 1 -d ')' | head -1)
#URLTRANSIT:=$(shell echo '$(WLINE)' | sed -e 's/"/\n/g;' | grep '^https' | head -1)
#VERSIONCOLLAPSE:=$(shell curl -s -L --connect-timeout 10 "$(URLTRANSIT)" | grep AcroRdrDCx64Upd | sed -e 's/"/\n/g;' | grep '^https' | cut -f 9 -d '/' | head -1)
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html' | grep 'continuous/dccontinuous.*std-ref.*Planned update,' | sed -e 's/"/\n/g;' | grep '^>[[:digit:]][\.[:digit:]]*[[:space:]]' | cut -f 1 -d ' ' | sed -e 's/^>//;' | head -1)
VERSIONCOLLAPSE:=$(shell echo '$(VERSION)' | sed -e 's/\.//g;')
VERSIONSHORT:=$(shell echo $(VERSIONCOLLAPSE) | sed -e 's/[\.0[:space:]]//g;')
REVISION:=1
NBSERVER:=$(shell seq 2 3 | sort -R | head -1)
URL:=https://ardownload$(NBSERVER).adobe.com/pub/adobe/acrobat/win/AcrobatDC/$(VERSIONCOLLAPSE)/AcroRdrDCx64$(VERSIONCOLLAPSE)_MUI.exe
URL2:=https://ardownload$(NBSERVER).adobe.com/pub/adobe/acrobat/win/AcrobatDC/$(VERSIONCOLLAPSE)/AcroRdrDCx64Upd$(VERSIONCOLLAPSE).msp

EXE:=AcroRdrDCx64$(VERSIONCOLLAPSE)_MUI.exe
EXE2:=AcroRdrDCx64Upd$(VERSIONCOLLAPSE).msp

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum
.ONESHELL:

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Adobe Acrobat%64-bit
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*[[[:alnum:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)
	@if [ "$$( (echo 100000; grep -n "x64$(VERSIONCOLLAPSE)_" checksum.txt | cut -f 1 -d ':') | tail -1)" -lt "$$( (echo 100000; grep 'AcroRdrDCx64[[:digit:]]' < checksum.txt | wc -l) | tail -1)" ]; then echo 'VERSION $(VERSION) is older then last one' > /dev/stderr ; exit 16; fi

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION:         $(VERSION)"
	@echo "VERSIONCOLLAPSE: $(VERSIONCOLLAPSE)"
	@echo "VERSIONSHORT:    $(VERSIONSHORT)"
	@echo "URL:             $(URL)"
	@echo "URL2:            $(URL2)"
	@echo "EXE:             $(EXE)"
	@echo "EXE2:            $(EXE2)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || { shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.msp 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe: tmp/$(EXE) tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32. executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep '^Product Version:[[:space:]]' | sed -e 's/[\.0[:space:]]//g;' | cut -f 2 -d ':' | grep -q "^$(VERSIONSHORT)$$" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; }; } ; \
		file $(EXE2) | grep -q "Composite Document File V2 Document" || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 12; } ; \
		file $(EXE2) | grep -q "Author: Adobe.*$(VERSION);" || { echo "Error: bad version for binary $(EXE2)" 1>&2 ; exit 12; } ; \
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

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE) tmp/$(EXE2)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini $(EXE) $(EXE2))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-remove.ps1 tmp/uninstall.bat
	@rm -f $@
	@zip -r ./$@ pre-remove.ps1
	@(cd tmp; zip -r ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
