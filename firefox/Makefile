
#
# Firefox
#

SOFT:=FirefoxESR
VERSION:=$(shell curl -s -L "https://www.mozilla.org/fr/firefox/organizations/notes/"  | sed -e 's/[[:space:]]/\n/g;' |  grep 'data-esr-versions' | cut -f 2 -d '"')
PATCH:=1

EXE:=Firefox_Setup_$(VERSION)esr.msi

IT_TEAM:=IT Support


.PHONY: all ocs clean wget
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

curl: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@cd tmp
#	@wget -q "https://download.mozilla.org/?product=firefox-esr-msi-latest-ssl&os=win64&lang=fr" -O $(EXE)
	@curl -o $(EXE) -L https://download.mozilla.org/?product=firefox-esr-msi-latest-ssl&os=win64&lang=fr
	@file $(EXE) | grep -q "Subject: Mozilla Firefox $(VERSION)esr" || echo "Error: bad format for binary $(EXE)"
	@grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)"

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
