
#
# Chrome
#

SOFT:=Chrome
URL:=https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi
VERSION:=$(shell ./get-version --url "$(URL)" --exe "googlechromestandaloneenterprise64.msi" --choco "https://community.chocolatey.org/packages/GoogleChrome" --shape "googlechromestandaloneenterprise64-%v.msi")
#$(shell mkdir -p tmp; cd tmp; curl -s --time-cond 'googlechromestandaloneenterprise64.msi' -o 'googlechromestandaloneenterprise64.msi' -L "$(URL)")
#VERSION:=$(shell file tmp/googlechromestandaloneenterprise64.msi | sed -e 's/.*Comments:\s\([[:digit:]][[:digit:]\.]*\).*/\1/; s/[[:space:]:].*//;')
REVISION:=1
EXE:=googlechromestandaloneenterprise64-$(VERSION).msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Google Chrome

check-version:
	@echo "$(VERSION)" | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "ZIP: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f googlechromestandaloneenterprise64-*.msi 2>/dev/null ; \
		ln -f googlechromestandaloneenterprise64.msi "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Google Chrome Installer" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q "Comments: $(VERSION) Copyright" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) chrome-parameters.reg master_preferences.json
	@rm -f $@
	@zip -r $@ chrome-parameters.reg master_preferences.json
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-remove.ps1 tmp/uninstall.bat
	@rm -f $@
	@zip -r ./$@ pre-remove.ps1
	@(cd tmp; zip -r ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
