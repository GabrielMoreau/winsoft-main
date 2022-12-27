
#
# Firefox
#

SOFT:=FirefoxESR
VERSION:=$(shell curl -s -L 'https://www.mozilla.org/fr/firefox/organizations/notes/' | sed -e 's/[[:space:]]/\n/g;' | grep 'data-esr-versions' | cut -f 2 -d '"')
PATCH:=1

EXE:=Firefox-Setup-$(VERSION)esr.msi

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
		curl -s -o "$(EXE)" -L 'https://download.mozilla.org/?product=firefox-esr-msi-latest-ssl&os=win64&lang=fr' ; \
		file $(EXE) | grep -q "Subject: Mozilla Firefox $(VERSION)esr" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat policies.json tmp/$(EXE)
	@rm -f $@
	@zip -r $@ policies.json
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
