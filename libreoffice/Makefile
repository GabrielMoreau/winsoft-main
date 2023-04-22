
#
# LibreOffice
#

SOFT:=LibreOffice
VERSION:=$(shell curl -s 'https://fr.libreoffice.org/download/telecharger-libreoffice/' \
	| sed -e 's/[[:space:]"]/\n/g;' | egrep '^https://.*LibreOffice_.*_Win_x86.msi$$' \
	| head -1 | cut -f 7 -d '/')
PATCH:=1

EXE_LO:=LibreOffice_$(VERSION)_Win_x86-64.msi
EXE_HELP:=LibreOffice_$(VERSION)_Win_x86-64_helppack_fr.msi

URL_LO:=$(shell curl -s "https://download.documentfoundation.org/libreoffice/stable/$(VERSION)/win/x86_64/$(EXE_LO)" \
	| sed -e 's/"/\n/g;' | grep "^https://.*/$(EXE_LO)$$" | head -1)

URL_HELP:=$(shell curl -s "https://download.documentfoundation.org/libreoffice/stable/$(VERSION)/win/x86_64/$(EXE_HELP)" \
	| sed -e 's/"/\n/g;' | grep "^https://.*/$(EXE_HELP)$$" | head -1)

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL_LO: $(URL_LO)"
	@echo "EXE_LO: $(EXE_LO)"
	@echo "URL_HELP: $(URL_HELP)"
	@echo "EXE_HELP: $(EXE_HELP)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE_LO))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE_LO)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		grep -q "^$$(shasum -a 256 $(EXE_HELP))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE_HELP)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -6 ../checksum.txt ; \
		)

wget: tmp/$(EXE_LO) tmp/$(EXE_HELP)

tmp/$(EXE_LO):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *_Win_x86-64.msi 2>/dev/null ; \
		curl -s -o "$(EXE_LO)" -L "$(URL_LO)" ; \
		file "$(EXE_LO)" | grep -q "Author: The Document Foundation.*$(VERSION)" || echo "Error: bad format for binary $(EXE_LO)" ; \
		grep -q "^$$(shasum -a 256 $(EXE_LO))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE_LO)" ; \
		)

tmp/$(EXE_HELP):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *_helppack_fr.msi 2>/dev/null ; \
		curl -s -o "$(EXE_HELP)" -L "$(URL_HELP)" ; \
		file "$(EXE_HELP)" | grep -q "Author: The Document Foundation.*$(VERSION)" || echo "Error: bad format for binary $(EXE_HELP)" ; \
		grep -q "^$$(shasum -a 256 $(EXE_HELP))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE_HELP)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE_LO)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE_LO) tmp/$(EXE_HELP)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE_LO) $(EXE_HELP))
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
