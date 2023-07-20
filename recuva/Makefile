
#
# Recuva
#

SOFT:=Recuva
URL:=$(shell curl -s -L 'https://www.ccleaner.com/fr-fr/recuva/download/standard' | sed -e 's/[[:space:]]/\n/g;' | grep data-download-url  | cut -f 2 -d '"')
#VERSION:=$(shell basename "$(URL)" | sed -e 's/rcsetup//; s/\.exe//;')
VERSION:=$(shell curl -s -L 'https://www.ccleaner.com/recuva/version-history' | grep 'version-history__latest-version' | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1\.\2.\3/;')
PVERSION:=$(shell curl -s -L 'https://www.ccleaner.com/recuva/version-history' | grep 'version-history__latest-version' | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.0*\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1.\2\.*\3/;')
PATCH:=1

EXE:=rcsetup$(VERSION).exe

IT_TEAM:=IT Support


.PHONY:  all check-version clean control next ocs version wget checksum
.ONESHELL:

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../../winsoft-conf/common/conf.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "PVERSION: $(PVERSION)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(EXE)"  -L "$(URL)" ; \
		file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

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
	@echo "Install and update: $(SOFT) ($(VERSION))"
	@echo ""
