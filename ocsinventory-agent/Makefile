
#
# OCSInventory-Agent
#

OCS_SERVER:=ocs-server.example.com
OCS_SSL:=1

SOFT:=OCSInventory-Agent
VERSION:=$(shell curl -s -L 'https://github.com/OCSInventory-NG/WindowsAgent/releases/latest' | sed 's/</\n/g;'| grep '^meta property.*Release Agent Windows' |cut -f 6 -d ' ')
PATCH:=2
URL:=https://github.com/OCSInventory-NG/WindowsAgent/releases/download/$(VERSION)/OCS-Windows-Agent-$(VERSION)_x64.zip
FOLDER:=OCS-Windows-Agent-$(VERSION)_x64
EXE:=OCS-Windows-Agent-Setup-$(VERSION)-x64.exe

IT_TEAM:=IT Support


.PHONY: all check-version ocs clean version wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(FOLDER).zip" -L "$(URL)" ; \
		unzip -q "$(FOLDER).zip" ; \
		rm -f "$(FOLDER).zip" ; \
		mv -f "$(FOLDER)/OCS-Windows-Agent-Setup-x64.exe" "$(EXE)"; \
		file $(EXE) | grep -q "Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/; \
		s#^(SET\socsserver=).*#$${1}$(OCS_SERVER)#; \
		s/^(SET\socsssl=)\d/$${1}$(OCS_SSL)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:     $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "Launch:   install.bat"
	@echo "Priority: *8*"
	@echo "Message:  yes"
	@echo "Delay:    5"
	@echo "Cancel:   no"
	@echo "Report:   yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and update: $(SOFT)"
	@echo ""