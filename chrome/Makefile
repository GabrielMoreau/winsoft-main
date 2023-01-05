
#
# Chrome
#

SOFT:=Chrome
#VERSION:=$(shell curl -s -L 'https://versionhistory.googleapis.com/v1/chrome/platforms/win/channels/stable/versions' | grep '"version":' | head -1 | cut -f 4 -d '"')
VERSION:=$(shell curl -s -L https://omahaproxy.appspot.com/json | sed -e 's/{/\n/g;' | grep '"os": "win64"' | grep '"channel": "stable"' | sed -e 's/,/\n/g' | grep '"current_version":' |cut -f 4 -d'"')
PATCH:=1
URL:=https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi

EXE:=googlechromestandaloneenterprise64-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all check-version ocs clean wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Subject: Google Chrome Installer.*Comments: $(VERSION) Copyright" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) chrome-manual-updates.reg master_preferences.json
	@rm -f $@
	@zip -r $@ chrome-manual-updates.reg master_preferences.json
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
