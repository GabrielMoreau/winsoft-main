
#
# Firefox
#

SOFT:=Thunderbird
VERSION:=$(shell wget -q 'https://www.thunderbird.net/en-US/thunderbird/all/' -O - | sed 's/\s/\n/g;' | grep 'data-thunderbird-version' | cut -f 2 -d '"')
PATCH:=1

EXE:=Thunderbird_Setup_$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@cd tmp
	@wget -q "https://download.mozilla.org/?product=thunderbird-$(VERSION)-msi-SSL&os=win64&lang=fr" -O $(EXE)
	@file $(EXE) | grep -q "Subject: Mozilla Thunderbird $(VERSION) x64" || echo "Error: bad format for binary $(EXE)"
	@grep -q "^$$(sha256sum $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)"

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat policies.json tmp/cmdow.exe tmp/$(EXE)
	@rm -f $@
	@zip -r $@ policies.json
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