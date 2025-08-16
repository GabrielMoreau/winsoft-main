
#
# Firefox
#

SOFT:=FirefoxESR
VERSION:=$(shell curl -s -L 'https://www.mozilla.org/fr/firefox/organizations/notes/' | sed -e 's/[[:space:]]/\n/g;' | grep 'data-esr-versions' | cut -f 2 -d '"')
URL:=https://download.mozilla.org/?product=firefox-esr-msi-latest-ssl&os=win64&lang=fr
REVISION:=1

EXE:=Firefox-Setup-$(VERSION)-esr.msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_DELAY:=$(OCS_DELAY_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Composite Document File.*, MSI Installer" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q "Subject: Mozilla Firefox $(VERSION)esr" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		)
	@which jq >/dev/null && { if [ $$(cat policies.json | jq empty 2>&1 | wc -l) -ne 0 ]; then echo "Error: bad json file policies.json" 1>&2 ; exit 1; fi }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat tmp/winsoft-config.ini post-install.ps1 policies.json pre-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r $@ policies.json pre-install.ps1 post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@
