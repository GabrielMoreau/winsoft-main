
#
# AcrobatReader
#

SOFT:=AcrobatReader
VERSIONLONG:=$(shell curl -s 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html' | grep 'disablelinktracking="false">DC ' | cut -f 2 -d '(' | cut -f 1 -d ')' | head -1)
URLTRANSIT:=$(shell curl -s 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html' | grep "$(VERSIONLONG)" | sed -e 's/"/\n/g;' | grep '^https')
VERSIONCOLLAPSE:=$(shell curl -s "$(URLTRANSIT)" |grep AcroRdrDCx64Upd | sed -e 's/"/\n/g;' | grep '^https' | cut -f 9 -d '/' | head -1)
VERSIONSHORT:=$(shell echo $(VERSIONCOLLAPSE) | sed -e 's/[\.0[:space:]]//g;')
REVISION:=1
URL:=https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/$(VERSIONCOLLAPSE)/AcroRdrDCx64$(VERSIONCOLLAPSE)_fr_FR.exe

EXE:=AcroRdrDCx64$(VERSIONCOLLAPSE)_fr_FR.exe

IT_TEAM:=IT Support


.PHONY: all check-version check-exe clean control next ocs version wget checksum
.ONESHELL:

all: check-version check-exe $(SOFT)_$(VERSIONLONG)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSIONLONG) | egrep -q '^[[:digit:]][\.[:digit:]]*[[[:alnum:]]$$' || (echo 'VERSIONLONG is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSIONLONG)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION:         $(VERSIONLONG)"
	@echo "VERSIONLONG:     $(VERSIONLONG)"
	@echo "VERSIONCOLLAPSE: $(VERSIONCOLLAPSE)"
	@echo "VERSIONSHORT:    $(VERSIONSHORT)"
	@echo "URLTRANSIT: $(URLTRANSIT)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum:
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
		#which peres >/dev/null && { peres -a $(EXE) | grep '^Product Version:[[:space:]]' | sed -e 's/[\.0[:space:]]//g;' | cut -f 2 -d ':' | grep -q "^$(VERSIONSHORT)$$" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -a $(EXE) | grep '^Product Version:[[:space:]]' | sed -e 's/[\.0[:space:]]//g;' | cut -f 2 -d ':' | grep -q "^$(VERSIONSHORT)$$" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; }; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSIONCOLLAPSE)/;' $< > $@
	@grep -q "softversion=$(VERSIONCOLLAPSE)" $@ || echo "Error: bad version in install.bat"

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSIONLONG)-$(REVISION)_x64"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   5"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSIONLONG))"
	@echo ""
