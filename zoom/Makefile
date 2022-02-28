
#
# Zoom
#

SOFT:=Zoom
VERSION:=$(shell file tmp/ZoomInstallerFull.msi 2> /dev/null | sed 's/, /\n/g;' | grep '^Comments:' | cut -f 2 -d ' ')
PATCH:=1

EXE:=ZoomInstallerFull-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all next ocs clean
.ONESHELL:

all:
	@mkdir -p tmp
	@[ -e "tmp/ZoomInstallerFull.msi" ] && rm -f "tmp/ZoomInstallerFull.msi"
	@(cd tmp; wget --timestamping 'https://zoom.us/client/latest/ZoomInstallerFull.msi')
	@make next

sinclude ../common/global.mk

next: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

tmp/$(EXE):
	@mkdir -p tmp
	@cd tmp
	@cmp ZoomInstallerFull.msi $(EXE) > /dev/null 2>&1 || cp -f ZoomInstallerFull.msi $(EXE)
	@file $(EXE) | grep -q "Subject: Zoom Meetings" || echo "Error: bad format for binary $(EXE)"
	@grep -q "^$$(sha256sum $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)"

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

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
