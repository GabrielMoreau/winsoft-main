
#
# FileZilla
#

URL:=$(shell wget -q 'https://filezilla-project.org/download.php?show_all=1' -O - | sed -e 's/"/\n/g;' | grep '^https://' | grep -- '_win64-setup.exe' | head -1)

SOFT:=FileZilla
VERSION:=$(shell echo "$(URL)" | cut -f 2 -d '_')
PATCH:=9

EXE:=FileZilla_$(VERSION)_win64-setup.exe

.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip $(EXE) tmp

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@wget "$(URL)" -O tmp/$(EXE)
	@file tmp/$(EXE) | grep 'PE32 executable'

tmp/install.bat: install.bat Makefile
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
	@echo "Service Informatique du LEGI"
	@echo " --- "
	@echo "Installation et mise jour de $(SOFT)"
	@echo ""
