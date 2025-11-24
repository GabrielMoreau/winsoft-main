
#
# Webex
#

SOFT:=Webex
INSTALLER:=Webex.msi
#URL:=https://binaries.webex.com/WebexTeamsDesktop-Windows-Gold/Webex.msi
#URL:=https://binaries.webex.com/WebexTeamsDesktop-Windows-Web-Installer/Webex.exe
URL:=https://binaries.webex.com/WebexOfclDesktop-Win-64-Gold/Webex.msi
$(shell mkdir -p tmp; cd tmp; curl -s --time-cond "$(INSTALLER)" -o "$(INSTALLER)" -L "$(URL)")
#VERSION:=$(shell curl -s -L --connect-timeout 10 'https://help.webex.com/article/mqkve8' | sed -e 's/[<>[:space:]]/\n/g; s/—/-/g;' | grep -m 1 -A 500 'stack-container' | grep '^Windows-[[:digit:]]' | head -1 | cut -f 2 -d '-')
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://help.webex.com/article/mqkve8' | sed -e 's/[<>[:space:]]/\n/g; s/—/-/g;' | grep '^Windows-[[:digit:]]' | head -1 | cut -f 2 -d '-')
REVISION:=1

EXE:=Webex-$(VERSION).msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

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

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *-*.exe *-*.msi 2>/dev/null ; \
		ln -f "$(INSTALLER)" "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		if grep $$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ') ../checksum.txt | grep -qv "$(EXE)"; then echo "Error: another version of Webex-XXXX.msi exists with the same checksum" 1>&2 ; rm -f "$(EXE)" ; exit 14; fi; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Webex Teams" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		if grep $$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ') ../checksum.txt | grep -qv "$(EXE)"; then echo "Error: two binary Webex-XXXX.msi version exists with same checksum" 1>&2 ; exit 14; fi; \
		if grep "$(EXE)" ../checksum.txt | grep -qv "$$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ')"; then echo "Error: two binary $(EXE) exists with same version and different checksum" 1>&2 ; exit 15; fi; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/pre-remove.ps1: pre-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/Begin Pre-Install/Begin Pre-Remove/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r $@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile tmp/pre-remove.ps1 tmp/uninstall.bat
	@rm -f $@
	@(cd tmp; zip -r ../$@ uninstall.bat pre-remove.ps1)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
