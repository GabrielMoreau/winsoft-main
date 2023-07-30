
#
# CCleaner
#

SOFT:=CCleaner
VERSION:=$(shell curl -s -L 'https://www.ccleaner.com/ccleaner/version-history' | grep 'version-history__latest-version' | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1\.\2.\3/;')
PVERSION:=$(shell curl -s -L 'https://www.ccleaner.com/ccleaner/version-history' | grep 'version-history__latest-version' | sed 's/^.*>v\([[:digit:]][[:digit:]]*\)\.0*\([[:digit:]][[:digit:]]*\)\.\([[:digit:]][[:digit:]]*\).*/\1.\2\.*\3/;')
PATCH:=1
URL:=$(shell curl -s -L 'https://www.ccleaner.com/ccleaner/download/slim' | egrep 'data-download-url=' | cut -f 2 -d '"')

EXE:=ccsetup-$(VERSION).exe

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

tmp/ccleaner.ps1: ccleaner.ps1 Makefile tmp/$(EXE)
	@perl -p -e ' \
		s/__SOFTVERSION__/$(VERSION)/;' ccleaner.ps1 > $@

%.zip: Makefile tmp/install.bat ccleaner.ini tmp/ccleaner.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ ccleaner.ini ccleaner.ps1
	@(cd tmp; zip -r ../$@ install.bat ccleaner.ps1 $(EXE))
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