
#
# RStudio
#

SOFT:=RStudio
URL:=$(shell curl -s -L --connect-timeout 10 'https://posit.co/download/rstudio-desktop/' | sed -e 's/"/\n/g;' | grep '^https://.*/RStudio-.*.exe' | head -1)
#URL:=$(shell curl -s 'https://www.rstudio.com/wp-content/downloads.json' | grep -A4 '"name".*/RStudio-.*\.exe' | grep '"url"' | cut -f 4 -d '"' | head -1)
VERSION1:=$(shell basename '$(URL)' 2> /dev/null | cut -f 2- -d'-' | sed -e 's/\.exe$$//;')
URL2:=https://cloud.r-project.org/bin/windows/base/$(shell curl -s -L --connect-timeout 10 'https://cloud.r-project.org/bin/windows/base/' | sed -e 's/"/\n/g;' | egrep '^R-.*-win.exe')
VERSION2:=$(shell basename '$(URL2)' 2> /dev/null | cut -f 2 -d'-')
REVISION:=1

VERSION:=$(shell echo $(VERSION1)-$(VERSION2) | sed -e 's/-/./g;')

EXE:=RStudio-$(VERSION1).exe
EXE2:=R-$(VERSION2)-win.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe check-exe2 clean control next version wget checksum

all: check-version check-exe check-exe2 $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION1: $(VERSION1)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "VERSION2: $(VERSION2)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$"  ../checksum.txt || { shasum -a 256 "$(EXE)"  | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f RStudio-*.exe 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		# file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION1)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ; \
		SHA256=$$(curl -s -L --connect-timeout 10 'https://posit.co/download/rstudio-desktop/' | grep -A1 'body-md-regular.*tabindex=' | grep -v 'body-md-regular' | awk '{print $$1}' | head -1) ; \
		if [ "$$(shasum -a 256 $(EXE) | cut -f 1 -d ' ')" != "$${SHA256}" ]; then echo "Error: bad checksum for binary $(EXE)" 1>&2 ; exit 12; fi ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f R-*.exe 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		#file $(EXE2) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE2)" ; \
		#which peres >/dev/null && { peres -v $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSION2)" || echo "Error: bad version for binary $(EXE2)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe2: tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE2) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSION2)" || { echo "Error: bad version for binary $(EXE2)" 1>&2 ; exit 12; } ; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE) tmp/$(EXE2)
	@mkdir -p tmp
	@sed -e 's/__VERSION1__/$(VERSION1)/; s/__VERSION2__/$(VERSION2)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION1__/$(VERSION1)/; s/__VERSION2__/$(VERSION2)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/winsoft-config.ini tmp/$(EXE) tmp/$(EXE2)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini $(EXE) $(EXE2))
	@chmod ugo+rw $@
