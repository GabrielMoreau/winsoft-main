
#
# Firefox
#

SOFT:=Thunderbird
VERSION:=$(shell curl -s -L 'https://www.thunderbird.net/en-US/thunderbird/all/' | sed -e 's/[[:space:]]/\n/g;' | grep 'data-thunderbird-version' | cut -f 2 -d '"')
PATCH:=1

EXE:=Thunderbird-Setup-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		curl -s -o "$(EXE)" -L "https://download.mozilla.org/?product=thunderbird-$(VERSION)-msi-SSL&os=win64&lang=fr" ; \
		file $(EXE) | grep -q "Subject: Mozilla Thunderbird $(VERSION) x64" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat policies.json tmp/$(EXE) post-install.ps1
	@rm -f $@
	@zip -r $@ policies.json post-install.ps1
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
