
#
# OCSInventory-Agent
#

OCS_SERVER:=ocs-server.example.com
OCS_SSL:=1

SOFT:=OCSInventory-Agent
VERSION:=$(shell curl -s -L 'https://github.com/OCSInventory-NG/WindowsAgent/releases/latest' | sed 's/</\n/g;'| grep '^meta property.*Release Agent Windows' |cut -f 6 -d ' ')
REVISION:=1
URL:=https://github.com/OCSInventory-NG/WindowsAgent/releases/download/$(VERSION)/OCS-Windows-Agent-$(VERSION)_x64.zip
FOLDER:=OCS-Windows-Agent-$(VERSION)_x64
EXE:=OCS-Windows-Agent-Setup-$(VERSION)-x64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum:
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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(FOLDER).zip" -L "$(URL)" ; \
		unzip -q "$(FOLDER).zip" ; \
		rm -f "$(FOLDER).zip" ; \
		mv -f "$(FOLDER)/OCS-Windows-Agent-Setup-x64.exe" "$(EXE)"; \
		file $(EXE) | grep -q "Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s#__OCS_SERVER__#$(OCS_SERVER)#; s/__OCS_SSL__/$(OCS_SSL)/;' $< > $@

tmp/install-outofservice.bat: install-outofservice.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__OCS_SERVER__#$(OCS_SERVER)#; s/__OCS_SSL__/$(OCS_SSL)/;' $< > $@

%.zip: Makefile post-install.ps1 tmp/install.bat tmp/install-outofservice.bat tmp/$(EXE)
	@rm -f $@
	@zip -r $@ post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat install-outofservice.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:     $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:   install.bat"
	@echo "Priority: *8*"
	@echo "Message:  yes"
	@echo "Delay:    5"
	@echo "Cancel:   no"
	@echo "Report:   yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
