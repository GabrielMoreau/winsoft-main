
#
# FileZilla
#

URL:=$(shell wget -q 'https://filezilla-project.org/download.php?show_all=1' -O - | sed -e 's/"/\n/g;' | grep '^https://' | grep -- '_win64-setup.exe' | head -1)

SOFT:=FileZilla
VERSION:=$(shell echo "$(URL)" | cut -f 2 -d '_')
PATCH:=9

EXE:=FileZilla_$(VERSION)_win64-setup.exe

IT_TEAM:=IT Support


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip $(EXE) tmp

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@cd tmp
	@wget "$(URL)" -O $(EXE)
	@file $(EXE) | grep 'PE32 executable'
	@grep -q "^$$(sha256sum $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)"

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat fzdefaults.xml tmp/cmdow.exe tmp/$(EXE)
	@rm -f $@
	@zip -r $@ \
		fzdefaults.xml
	@(cd tmp; zip -r ../$@ install.bat cmdow.exe $(EXE))
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
