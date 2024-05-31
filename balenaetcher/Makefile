
#
# BalenaEtcher
#

SOFT:=BalenaEtcher
USERAGENT:=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0
VERSION:=$(shell curl -s -L 'https://github.com/balena-io/etcher/releases/latest' --user-agent "$(USERAGENT)" | sed 's/</\n/g;' | grep '^meta property.*og:title' | cut -f 4 -d ' ' | sed -e 's/^v//;')
REVISION:=1
URL:=https://github.com/balena-io/etcher/releases/download/v$(VERSION)/balenaEtcher-win32-x64-$(VERSION).zip

EXE:=balenaEtcher-win32-x64-$(VERSION).zip

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized:
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

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
	@rm -rf tmp/BalenaEtcher 2>/dev/null
	@mkdir -p tmp/BalenaEtcher
	@unzip -q tmp/$(EXE) -d tmp/BalenaEtcher || echo "Warning: strange thing in $(EXE)"
	@touch "tmp/BalenaEtcher/balenaEtcher.exe"

check-exe: tmp/BalenaEtcher/balenaEtcher.exe
	@(cd tmp; \
		file $(EXE) | grep -q "Zip archive data" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; }; \
		file 'BalenaEtcher/balenaEtcher.exe' | grep -q "PE32+ executable" || { echo "Error: bad format for binary BalenaEtcher/balenaEtcher.exe" 1>&2 ; exit 1; }; \
		which peres >/dev/null && { peres -v 'BalenaEtcher/balenaEtcher.exe' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary BalenaEtcher/balenaEtcher.exe" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/winsoft-config.ini tmp/$(EXE) uninstall.bat tmp/BalenaEtcher/balenaEtcher.exe
	@rm -f $@
	@zip -r $@ uninstall.bat pre-install.ps1
	@(cd tmp; zip --quiet -r ../$@ install.bat winsoft-config.ini BalenaEtcher)
	@chmod ugo+rw $@
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
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
