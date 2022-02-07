
#
# PuTTY
#

SOFT:=Putty
VERSION:=$(shell wget -q 'https://www.chiark.greenend.org.uk/~sgtatham/putty/' -O - | grep 'The latest version is' | cut -f 5 -d ' ' | cut -f 1,2 -d '.')
PATCH:=1

EXE:=putty-64bit-$(VERSION)-installer.msi


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir tmp
	@cd tmp
	@wget -q "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-$(VERSION)-installer.msi"
	@file $(EXE) | grep 'Little Endian, Os: Windows, Version 5.0, MSI Installer'
	@grep -q "^$$(sha256sum $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)"

tmp/install.bat: install.bat Makefile
	@mkdir tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/cmdow.exe tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ cmdow.exe install.bat $(EXE))
	@chmod ugo+rw $@

tmp/cmdow.exe:
	@mkdir -p tmp
	@cp ../common/cmdow.exe tmp/

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   5"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "Service Informatique du LEGI"
	@echo " --- "
	@echo "Installation et mise jour de $(SOFT)"
	@echo ""
