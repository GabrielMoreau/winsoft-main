
#
# 7-Zip
#

SOFT:=7-Zip
VERSION:=$(shell curl -s -L 'https://www.7-zip.org/' | sed -e 's/>/\n/g;' | grep 'Download 7-Zip' | grep -v beta | cut -f 3 -d ' ' | head -1)
VERSIONSHORT:=$(shell echo $(VERSION) | sed -e 's/\.//g;')
VERSIONNUM:=$(shell echo $(VERSION) | sed -e 's/\.0/./g;')
REVISION:=1
EXE:=7z$(VERSIONSHORT)-x64.msi
EXE2:=7z$(VERSIONSHORT)-x64.exe
URL:=https://www.7-zip.org/a/$(EXE)
URL2:=https://www.7-zip.org/a/$(EXE2)

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe check-exe2 clean control next ocs version wget checksum

all: check-version check-exe check-exe2 $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized:
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt && grep -q '[[:space:]]$(EXE2)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || { shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'Composite Document File V2 Document' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q 'Little Endian.*$(VERSIONSHORT)' || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe2: tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE2) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSIONNUM)" || { echo "Error: bad version for binary $(EXE2)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE) tmp/$(EXE2)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__VERSIONSHORT__/$(VERSIONSHORT)/;' $< > $@

tmp/post-install.ps1: post-install.ps1 Makefile tmp/$(EXE) tmp/$(EXE2)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__VERSIONSHORT__/$(VERSIONSHORT)/;' $< > $@

%.zip: Makefile tmp/install.bat tmp/post-install.ps1 pre-install.ps1 tmp/$(EXE) tmp/$(EXE2)
	@rm -f $@
	@zip -r $@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 $(EXE) $(EXE2))
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
