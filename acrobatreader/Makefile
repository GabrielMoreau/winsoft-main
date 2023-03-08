
#
# AcrobatReader
#

SOFT:=AcrobatReader
VERSIONLONG:=$(shell curl -s 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html' | grep 'disablelinktracking="false">DC ' | cut -f 2 -d '(' | cut -f 1 -d ')' | head -1)
URLTRANSIT:=$(shell curl -s 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html' | grep "$(VERSIONLONG)" | sed -e 's/"/\n/g;' | grep '^https')
VERSIONCOLLAPSE:=$(shell curl -s "$(URLTRANSIT)" |grep AcroRdrDCx64Upd | sed -e 's/"/\n/g;' | grep '^https' | cut -f 9 -d '/' | head -1)
VERSIONSHORT:=$(shell echo $(VERSIONCOLLAPSE) | sed -e 's/[\.0[:space:]]//g;')
PATCH:=1
URL:=https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/$(VERSIONCOLLAPSE)/AcroRdrDCx64$(VERSIONCOLLAPSE)_fr_FR.exe

EXE:=AcroRdrDCx64$(VERSIONCOLLAPSE)_fr_FR.exe

IT_TEAM:=IT Support


.PHONY: all check-version ocs clean version wget
.ONESHELL:

all: $(SOFT)-$(VERSIONLONG)-$(PATCH).zip ocs

sinclude ../../winsoft-conf/common/conf.mk

check-version:
	@echo $(VERSIONLONG) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSIONLONG is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSIONLONG)-$(PATCH).zip tmp resources

version:
	@echo "VERSIONLONG:     $(VERSIONLONG)"
	@echo "VERSIONCOLLAPSE: $(VERSIONCOLLAPSE)"
	@echo "VERSIONSHORT:    $(VERSIONSHORT)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		which peres >/dev/null && { peres -a $(EXE) | grep '^Product Version:[[:space:]]' | sed -e 's/[\.0[:space:]]//g;' | cut -f 2 -d ':' | grep -q "^$(VERSIONSHORT)$$" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSIONCOLLAPSE)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSIONLONG)-$(PATCH)"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   5"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and update: $(SOFT)"
	@echo ""
