
#
# PrusaSlicer
#

# https://cdn.prusa3d.com/downloads/drivers/prusa3d_win_2_7_1.exe
# https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.7.1/PrusaSlicer-2.7.1+win64-202312121425_signed.zip
#
SOFT:=PrusaSlicer
REVISION:=1
#URL:=$(shell curl -s -L 'https://help.prusa3d.com/downloads'| sed -e 's/"/\n/g;' | grep '^https://.*/drivers/prusa3d_win_.*.exe' | head -1)
#VERSION:=$(shell basename '$(URL)' 2> /dev/null | cut -f 3- -d '_' | sed -e 's/\.exe//; s/_/./g;')
#EXE:=prusa3d_win_$(VERSION).exe
VERSION:=$(shell curl -s -L 'https://github.com/prusa3d/PrusaSlicer/releases/latest' | sed 's/</\n/g;' | grep '^meta property.*og:title'  | cut -f 5 -d ' ')
URL:=https://github.com$(shell curl -s -L 'https://github.com/prusa3d/PrusaSlicer/releases/expanded_assets/version_$(VERSION)' | sed 's/"/\n/g;' | grep '^/.*/PrusaSlicer-$(VERSION).*win64.*.zip')
EXE:=PrusaSlicer-$(VERSION).zip

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

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
		rm -rf *.zip 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/PrusaSlicer/prusa-slicer.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf PrusaSlicer PrusaSlicer-$(VERSION) 2>/dev/null ; \
		unzip -q $(EXE) ; \
		mv PrusaSlicer-$(VERSION) PrusaSlicer ; \
		#which peres >/dev/null && { peres -v 'Telegram/Telegram.exe' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		)

check-exe: tmp/$(EXE) tmp/PrusaSlicer/prusa-slicer.exe
	@(cd tmp ; \
		file PrusaSlicer/prusa-slicer.exe | grep -q "PE32+ executable" || { echo "Error: bad format for binary prusa-slicer.exe" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v PrusaSlicer/prusa-slicer.exe | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary prusa-slicer.exe" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@


%.zip: Makefile uninstall.bat tmp/install.bat tmp/$(EXE) tmp/PrusaSlicer/prusa-slicer.exe
	@rm -f $@
	@zip -r ./$@ uninstall.bat
	@(cd tmp; zip --quiet -r ../$@ install.bat PrusaSlicer)
	@chmod ugo+rw $@
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l

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
