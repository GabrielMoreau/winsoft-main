
#
# WinDirStat
#

SOFT:=WinDirStat
VERSION:=$(shell wget -q 'https://windirstat.net/download.html' -O - | sed 's/"/\n/g;' | grep 'Latest version:' | cut -f 3 -d ' ' |cut -f 1 -d '<')
PATCH:=3

EXE:=windirstat$(VERSION)_setup.exe

IT_TEAM:=IT Support


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir tmp
	@cd tmp
	@wget -q "https://windirstat.mirror.wearetriple.com//wds_current_setup.exe" -O $(EXE)
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
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and update: $(SOFT)"
	@echo ""
