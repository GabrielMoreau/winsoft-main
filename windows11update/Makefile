
#
# Windows11Update
#

SOFT:=Windows11Update
URL:=$(shell curl -s -L 'https://www.microsoft.com/software-download/windows11' | grep 'windows11-upgrade-now' | sed -e 's/"/\n/g;' | grep '^https://go.microsoft.com/fwlink/')
$(shell mkdir -p tmp; cd tmp; curl -s --time-cond 'Windows11InstallationAssistant.exe' -o 'Windows11InstallationAssistant.exe' -L "$(URL)")
VERSION:=$(shell peres -v tmp/Windows11InstallationAssistant.exe  | grep '^Product Version:' | awk '{print $$3}')
REVISION:=1

EXE:=Windows11InstallationAssistant-$(VERSION).exe

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
		#rm -f *.exe *.msi 2>/dev/null ; \
		#curl -# -o "$(EXE)" -L "$(URL)" ; \
		rm -f Windows11InstallationAssistant-*.exe 2>/dev/null ; \
		ln -f Windows11InstallationAssistant.exe "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 10 ))); echo ' 100% #' ; \
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
	@echo "This command installs the latest version of Windows 11."
	@echo "After the next reboot, Windows 11 will automatically reboot several times..."
	@echo ""
