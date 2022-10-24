
#
# Chrome
#

SOFT:=Chrome
#VERSION:=$(shell curl -s -L 'https://en.wikipedia.org/wiki/Google_Chrome_version_history' | grep -A 3 'Anchor_to_the_latest_release' |grep 'background:#a0e75a;' | cut -f 2 -d '>')
VERSION:=$(shell curl -s -L 'https://chromereleases.googleblog.com/search/label/Stable%20updates' | sed -e 's/[<>]/\n/g;' | grep '^The Stable channel has been updated to .* for Windows'  | cut -f 8 -d ' ' | grep '[[:digit:]][[:digit:]\.]' | head -1)
PATCH:=1
URL:=https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi

EXE:=googlechromestandaloneenterprise64-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null
		curl -s -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Subject: Google Chrome Installer" || echo "Error: bad format for binary $(EXE)" ; \
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
