
#
# Action-Windows11FullUpgrade
#

SOFT:=Action-Windows11FullUpgrade
URL:=$(shell curl -s -L 'https://www.microsoft.com/software-download/windows11' | sed -e 's/"/\n/g;' | grep '^https://go.microsoft.com/fwlink/' | sed -e 's/&#61;/=/;' | head -1)
$(shell mkdir -p tmp; cd tmp; curl -s --time-cond 'Windows11InstallationAssistant.exe' -o 'Windows11InstallationAssistant.exe' -L "$(URL)")
VERSION:=$(shell peres -v tmp/Windows11InstallationAssistant.exe  | grep '^Product Version:' | awk '{print $$3}' | head -1)
REVISION:=1

EXE:=Windows11InstallationAssistant-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE) --- This command installs the latest version of Windows 11. After the next reboot, Windows 11 will automatically reboot several times...

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum: check-version
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
		#rm -f *.exe *.msi 2>/dev/null ; \
		#curl -# -o "$(EXE)" -L "$(URL)" ; \
		rm -f Windows11InstallationAssistant-*.exe 2>/dev/null ; \
		ln -f Windows11InstallationAssistant.exe "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile pre-install.ps1 tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@zip -r $@ pre-install.ps1
	@zip -r $@ HardwareReadiness
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
