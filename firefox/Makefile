
#
# WinDirStat
#

SOFT:=Firefox
VERSION:=91.5.1
PATCH:=1

EXE:="Firefox Setup $(VERSION)esr.msi"


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir tmp
	@cd tmp
	@wget -q "https://download-installer.cdn.mozilla.net/pub/firefox/releases/91.5.1esr/win64/fr/Firefox%20Setup%2091.5.1esr.msi" -O $(EXE)
	@file $(EXE) | grep 'PE32 executable'
	@grep -q "^$$(sha256sum $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)"

tmp/install.bat: install.bat Makefile
	@mkdir tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/cmdow.exe tmp/policies.json tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ cmdow.exe policies.json install.bat $(EXE))
	@chmod ugo+rw $@

tmp/cmdow.exe:
	@mkdir -p tmp
	@cp ../common/cmdow.exe tmp/

tmp/policies.json:
	@mkdir -p tmp
	@cp policies.json tmp/

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
