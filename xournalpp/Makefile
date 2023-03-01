
#
# XournalPP
#

SOFT:=XournalPP
VERSION:=$(shell curl -s -L 'https://github.com/xournalpp/xournalpp/releases/latest' | sed 's/</\n/g;' | grep '^meta property.*og:title' | cut -f 5 -d ' ')
PATCH:=1
URL:=https://github.com/xournalpp/xournalpp/releases/download/v$(VERSION)/xournalpp-$(VERSION)-windows.zip

ZIP:=xournalpp-$(VERSION)-windows.zip
EXE:=xournalpp-$(VERSION)-windows.exe

IT_TEAM:=IT Support


.PHONY: all check-version ocs clean version wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(ZIP)" -L "$(URL)" ; \
		unzip -q "$(ZIP)" ; \
		rm -f "$(ZIP)" ; \
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE)" ; \
		#which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
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
	@echo "Install and update: $(SOFT)"
	@echo ""