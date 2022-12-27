#
# KeepassXC
#

SOFT:=KeepassXC
VERSION:=2.7.1
PATCH:=1

EXE:=KeePassXC-$(VERSION)-Win64.msi

IT_TEAM:=IT Support


.PHONY: all check-version ocs clean wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	echo $(VERSION) | egrep '^[[:digit:]][\.[:digit:]]*$' || $(error VERSION is undefined)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(EXE)" -L 'https://github.com/keepassxreboot/keepassxc/releases/download/$(VERSION)/KeePassXC-$(VERSION)-Win64.msi' ; \
 		curl -s -o "checksum.txt" -L 'https://github.com/keepassxreboot/keepassxc/releases/download/$(VERSION)/KeePassXC-$(VERSION)-Win64.msi.DIGEST' ; \       
		grep -q "^$$(shasum -a 256 $(EXE))$$" checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
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
