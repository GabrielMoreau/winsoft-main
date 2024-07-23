
#
# MiKTeX
#

SOFT:=MiKTeX
# VERSION:=$(shell curl -s -L 'https://github.com/MiKTeX/miktex/releases/latest' | sed -e 's/[[:space:]"]/\n/g;' | grep '^/MiKTeX/miktex/releases/tag/' | head -1 | xargs -r basename)
URL:=https://miktex.org/$(shell curl -s -L 'https://miktex.org/download' | sed -e "s/'/\n/g;" | grep '^/download/.*\.zip$$' | sed -e 's#^/##; s/&#x2B;/+/g;' | head -1)
VERSIONSHORT:=$(shell basename '$(URL)' 2> /dev/null | cut -f 2 -d '-' | cut -f 1 -d '+')
VERSION:=$(shell basename '$(URL)' 2> /dev/null | cut -f 2 -d '-' | sed -e 's/+/./g;')
REVISION:=1
# https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/miktexsetup-5.5.0+1763023-x64.zip
# https://ctan.tetaneutral.net/systems/win32/miktex/setup/windows-x64/miktexsetup-5.5.0+1763023-x64.zip

ZIP:=miktexsetup-$(VERSION)-x64.zip
EXE:=miktexsetup-standalone-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe check-exe2 clean control next ocs version wget checksum

all: check-version check-exe check-exe2 $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSIONSHORT: $(VERSIONSHORT)"
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

tmp/$(ZIP):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.zip 2>/dev/null ; \
		curl -# -o "$(ZIP)" -L "$(URL)" ; \
		)

check-exe2: tmp/$(ZIP)
	@(cd tmp ; \
		file $(ZIP) | grep -q 'Zip archive data' || { echo "Error: bad format for zip $(ZIP)" 1>&2 ; exit 1; } ; \
		)

tmp/$(EXE): check-exe2 tmp/$(ZIP)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe 2>/dev/null ; \
		unzip -q "$(ZIP)" ; \
		mv miktexsetup_standalone.exe miktexsetup-standalone-$(VERSION).exe ; \
		#file $(EXE) | grep -q "PE32+ executable" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32+ executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSIONSHORT)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)


tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   20"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo " --- "
	@echo "The software will be stopped during the installation,"
	@echo "make a quick save or postpone the update."
	@echo ""
