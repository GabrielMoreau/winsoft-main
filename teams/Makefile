
#
# Microsoft Teams
#

SOFT:=Teams
VERSION:=$(shell curl -s -L 'https://learn.microsoft.com/en-us/officeupdates/teams-app-versioning' | grep -A 30 'windows-version-history-1' | paste -sd '' | sed -e s'#<tr>#\n#g;' | grep -Ev '(windows-version-history|Slimcore version)' | sed -e 's/[<>]/\n/g;' | egrep '^[[:digit:]][[:digit:]]?\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$$' | head -1)
SHORTVERSION:=$(shell echo $(VERSION) | sed -e 's/00/0/g;')
URL:=https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true
REVISION:=1

EXE:=Teams_$(VERSION)_windows_x64.msi

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
	@echo "SHORTVERSION: $(SHORTVERSION)"
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
		file $(EXE) | grep -q "Composite Document File.*Subject: Microsoft Teams" || echo "Error: bad format for binary $(EXE)" ; \
		which msiextract >/dev/null && { rm -rf 'Program File'; msiextract $(EXE) ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@cd tmp; \
		file $(EXE) | grep -q "Composite Document File.*Subject: Microsoft Teams" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v 'Program Files/Teams Installer/Teams.exe' | grep -q "^Product Version:[[:space:]]*$(SHORTVERSION)" || { echo "Error: bad version for binary Program Files/Teams Installer/Teams.exe" 1>&2 ; exit 1; } ; }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile pre-install.ps1 tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@zip -r $@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   5"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo " --- "
	@echo ""
