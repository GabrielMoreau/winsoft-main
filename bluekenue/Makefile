
#
# BlueKenue
#

SOFT:=BlueKenue
INSTALLER:=BlueKenue64Installer3.3.4.msi
VERSION:=3.3.4
PATCH:=1

EXE:=BlueKenue64Installer$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all next ocs clean

all:
	@mkdir -p tmp
	@rm -f "tmp/$(INSTALLER)"
	@(cd tmp; curl -s -o $(INSTALLER) -L "https://nrc.canada.ca/sites/default/files/apps/kenue/$(INSTALLER)")
	@make next

next: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		cmp $(INSTALLER) $(EXE) > /dev/null 2>&1 || cp -f $(INSTALLER) $(EXE) ; \
		file $(EXE) | grep -q "BlueKenue" || echo "Error: bad format for binary $(EXE)" ; \
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
