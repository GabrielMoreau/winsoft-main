
#
# LibreOffice
#

SOFT:=LibreOffice
VERSION:=$(shell curl -s 'https://fr.libreoffice.org/download/telecharger-libreoffice/' \
	| sed -e 's/[[:space:]"]/\n/g;' | egrep '^https://.*LibreOffice_.*_Win_x86.msi$$' \
	| head -1 | cut -f 7 -d '/')
REVISION:=1

EXE1:=LibreOffice_$(VERSION)_Win_x86-64.msi
EXE2:=LibreOffice_$(VERSION)_Win_x86-64_helppack_fr.msi

URL1:=$(shell curl -s "https://download.documentfoundation.org/libreoffice/stable/$(VERSION)/win/x86_64/$(EXE1)" \
	| sed -e 's/"/\n/g;' | grep "^https://.*/$(EXE1)$$" | head -1)

URL2:=$(shell curl -s "https://download.documentfoundation.org/libreoffice/stable/$(VERSION)/win/x86_64/$(EXE2)" \
	| sed -e 's/"/\n/g;' | grep "^https://.*/$(EXE2)$$" | head -1)

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE1)$$' checksum.txt && grep -q '[[:space:]]$(EXE2)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL1: $(URL1)"
	@echo "EXE1: $(EXE1)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt   || { shasum -a 256 "$(EXE1)"   | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE1) tmp/$(EXE2)

tmp/$(EXE1):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *_Win_x86-64.msi 2>/dev/null ; \
		curl -# -o "$(EXE1)" -L "$(URL1)" ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE1)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *_helppack_fr.msi 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe: tmp/$(EXE1) tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE1) | grep -q "Composite Document File.*, MSI Installer" || { echo "Error: bad format for binary $(EXE1)" 1>&2 ; exit 1; } ; \
		file $(EXE1) | grep -q "Author: The Document Foundation.*$(VERSION)" || { echo "Error: bad version for binary $(EXE1)" 1>&2 ; exit 1; } ; \
		)
	@(cd tmp ; \
		file $(EXE2) | grep -q "Composite Document File.*, MSI Installer" || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 1; } ; \
		file $(EXE2) | grep -q "Author: The Document Foundation.*$(VERSION)" || { echo "Error: bad version for binary $(EXE2)" 1>&2 ; exit 1; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE1)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE1) tmp/$(EXE2)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE1) $(EXE2))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   5"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
