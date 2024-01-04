
#
# Firefox
#

SOFT:=FirefoxESR
VERSION:=$(shell curl -s -L 'https://www.mozilla.org/fr/firefox/organizations/notes/' | sed -e 's/[[:space:]]/\n/g;' | grep 'data-esr-versions' | cut -f 2 -d '"')
URL:=https://download.mozilla.org/?product=firefox-esr-msi-latest-ssl&os=win64&lang=fr
PATCH:=1

EXE:=Firefox-Setup-$(VERSION)-esr.msi

IT_TEAM:=IT Support


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

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

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		# file $(EXE) | grep -q "Subject: Mozilla Firefox $(VERSION)esr" || echo "Error: bad format or version for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Mozilla Firefox $(VERSION)esr" || { echo "Error: bad format or version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

tmp/post-install.ps1: post-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' post-install.ps1 > $@

%.zip: Makefile tmp/install.bat tmp/post-install.ps1 policies.json pre-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r $@ policies.json pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   20"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo " --- "
	@echo "The software will be stopped during the installation,"
	@echo "make a quick save or postpone the update."
	@echo ""
