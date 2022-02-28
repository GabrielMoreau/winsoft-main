
#
# Notepad++
#

SOFT:=NotepadPP
VERSION:=$(shell wget -q 'https://notepad-plus-plus.org/' -O - | grep '/downloads/v' | cut -f 3 -d '/' | cut -f 2 -d 'v')
PATCH:=6

EXE:=npp.$(VERSION).Installer.x64.exe

IT_TEAM:=IT Support


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp/$(EXE) tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir tmp
	@cd tmp
	@wget -q "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$(VERSION)/npp.$(VERSION).Installer.x64.exe"
	@file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)"
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
	mkdir -p tmp
	cp ../common/cmdow.exe tmp/

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
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
