
#
# RTools
#

SOFT:=RTools

SHORTVERSION:=$(shell curl -s -L 'https://cran.r-project.org/bin/windows/Rtools/' | grep -B 1 'for R ' | sed -e 's/"/\n/g;' | grep '^rtools' | head -1 | xargs -r dirname | sed -e 's/^rtools//;')
DOTVERSION:=$(shell curl -s -L 'https://cran.r-project.org/bin/windows/Rtools/' | grep -B 1 'for R ' | sed -e 's/=/\n/g; s/</ /g;' | grep 'rtools$(SHORTVERSION)/rtools.html' | head -1 | cut -f 2 -d ' ')
LONGVERSION:=$(shell curl -s -L 'https://cran.r-project.org/bin/windows/Rtools/rtools$(SHORTVERSION)/rtools.html' | sed -e 's/"/\n/g;' | grep '^files/rtools.*exe$$' | sed -e 's#files/rtools##; s/\.exe//;')
CONCATVERSION:=$(shell echo $(LONGVERSION) | sed -e 's/[-\.]//g;')
URL:=https://cran.r-project.org/bin/windows/Rtools/rtools$(SHORTVERSION)/files/rtools$(LONGVERSION).exe
EXE:=rtools$(LONGVERSION).exe

PATCH:=1
VERSION:=$(shell echo -n $(DOTVERSION) ; echo $(LONGVERSION) | sed -e 's/^[[:digit:]]*//; s/-/./g;')


IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "SHORTVERSION: $(SHORTVERSION)"
	@echo "DOTVERSION:   $(DOTVERSION)"
	@echo "LONGVERSION: $(LONGVERSION)"
	@echo "CONCATVERSION: $(CONCATVERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || { shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@[ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ] && tail -6 checksum.txt

wget: tmp/$(RSTUDIO_EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f R-*.exe 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		which peres >/dev/null && { peres -a $(EXE) | sed -s 's/\.//g;' | grep -q "^Product Version:[[:space:]]*$(CONCATVERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/__VERSION_L__/$(LONGVERSION)/; \
		s/__VERSION_S__/$(SHORTVERSION)/; \
		s/__PATCH__/$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
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
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
