
#
# RStudio
#

SOFT:=RStudio
URL:=$(shell curl -s -L 'https://posit.co/download/rstudio-desktop/' | sed -e 's/"/\n/g;' | egrep '^https://.*/RStudio-.*.exe' | head -1)
VERSION1:=$(shell basename $(URL) | cut -f 2- -d'-' | sed -e 's/\.exe$$//;')
URL2:=https://cloud.r-project.org/bin/windows/base/$(shell curl -s -L 'https://cloud.r-project.org/bin/windows/base/' | sed -e 's/"/\n/g;' | egrep '^R-.*-win.exe')
VERSION2:=$(shell basename $(URL2) | cut -f 2 -d'-')
PATCH:=1

VERSION:=$(shell echo $(VERSION1)-$(VERSION2) | sed -e 's/-/./g;')

EXE:=RStudio-$(VERSION1).exe
EXE2:=R-$(VERSION2)-win.exe

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION1: $(VERSION1)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "VERSION2: $(VERSION2)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum:
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
		file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION1)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f R-*.exe 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		file $(EXE2) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE2)" ; \
		which peres >/dev/null && { peres -a $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSION2)" || echo "Error: bad version for binary $(EXE2)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE) tmp/$(EXE2)
	@mkdir -p tmp
	@perl -p -e ' \
		s/__VERSION1__/$(VERSION1)/; \
		s/__VERSION2__/$(VERSION2)/; \
		s/__PATCH__/$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) tmp/$(EXE2)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE) $(EXE2))
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
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
