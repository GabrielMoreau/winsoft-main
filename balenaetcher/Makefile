
#
# BalenaEtcher
#

SOFT:=BalenaEtcher
VERSION:=$(shell curl -s -L 'https://github.com/balena-io/etcher/releases/latest' | sed 's/</\n/g;'| grep '^meta property.*og:title' | cut -f 4 -d ' ' | sed -e 's/^v//;')
PATCH:=1
URL:=https://github.com/balena-io/etcher/releases/download/v$(VERSION)/balenaEtcher-$(VERSION)-win.zip

EXE:=balenaEtcher-$(VERSION)-win.zip

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

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
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Zip archive data" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/BalenaEtcher/balenaEtcher.exe: tmp/$(EXE)
	@rm -rf   tmp/BalenaEtcher 2>/dev/null
	@mkdir -p tmp/BalenaEtcher
	@(cd tmp/BalenaEtcher ; \
		unzip -q ../$(EXE) ; \
		)
	@(cd tmp ; \
		which peres >/dev/null && { peres -a 'BalenaEtcher/balenaEtcher.exe' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

tmp/pre-install.ps1: pre-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' pre-install.ps1 > $@

%.zip: Makefile tmp/install.bat tmp/pre-install.ps1 tmp/$(EXE) tmp/BalenaEtcher/balenaEtcher.exe
	@rm -f $@
	@zip -r $@ uninstall.bat
	@(cd tmp; zip --quiet -r ../$@ install.bat pre-install.ps1 BalenaEtcher)
	@chmod ugo+rw $@
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l

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
