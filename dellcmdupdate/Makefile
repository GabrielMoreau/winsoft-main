
#
# DellCmdUpdate
#

SOFT:=DellCmdUpdate
VERSION:=$(shell grep '^[[:digit:]]' url.txt | sort --version-sort -k 1 | tail -1 | awk '{print $$1}')
REVISION:=1
URL:=$(shell grep '^$(VERSION)[[:space:]]' url.txt | awk '{print $$2}')
VERSION_LOW:=$(shell echo "$(VERSION)" | sed -e 's/\./_/g;')
USERAGENT:=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0

EXE:=$(shell basename '$(URL)' 2> /dev/null)

URL8:=$(shell curl -s -L https://dotnet.microsoft.com/$(shell curl -s -L --connect-timeout 10 'https://dotnet.microsoft.com/en-us/download/dotnet/8.0' | sed -e 's/"/\n/g;' | grep 'thank-you/runtime-desktop.*windows-x64-installer'  | head -1) | sed -e 's/"/\n/g;' | grep '^https.*windowsdesktop-runtime-.*-win-x64.exe' | head -1)
VERSION8:=8.$(shell basename '$(URL8)' 2>/dev/null | cut -f 3 -d '-' | cut -f 2- -d '.')
EXE8:=windowsdesktop-runtime-$(VERSION8)-win-x64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum check-update

all: check-update check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Dell Command | Update

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "VERSION_LOW: $(VERSION_LOW)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$"  ../checksum.txt || { shasum -a 256 "$(EXE)"  | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE8))$$" ../checksum.txt || { shasum -a 256 "$(EXE8)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi
	@(cd tmp ; \
		grep -q "^$(VERSION8)[[:space:]]" ../version.txt || { (echo -n '$(VERSION8) ' ; peres -v $(EXE8) 2> /dev/null | grep '^Product Version' | awk '{print $$3}') >> ../version.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' version.txt) )) -lt 60 ]; then tail -3 version.txt; fi


wget: tmp/$(EXE)

check-update:
	@./check4new-version || { echo "Error: there is probably a new version online" 1>&2 ; exit 13; }

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f Dell-Command-*.EXE 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" --user-agent "$(USERAGENT)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/$(EXE8):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f windowsdesktop-runtime-8.*.exe 2>/dev/null ; \
		curl -# -o "$(EXE8)" -L "$(URL8)" ; \
		grep -q "^$$(shasum -a 256 $(EXE8))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE8)" ; \
		)

check-exe: tmp/$(EXE) tmp/$(EXE8)
	@(cd tmp ; \
		file $(EXE) | grep -Eq "PE32.? executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		#which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ; \
		)
	@(cd tmp ; \
		file $(EXE8) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE8)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE8) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION8)" || { echo "Error: bad version for binary $(EXE8)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__EXE__/$(EXE)/; s/__VERSION_LOW__/$(VERSION_LOW)/; s/__VERSION8__/$(VERSION8)/;' $< > $@

tmp/pre-install.ps1: pre-install.ps1 Makefile tmp/$(EXE8)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__EXE__/$(EXE)/; s/__VERSION_LOW__/$(VERSION_LOW)/; s/__VERSION8__/$(VERSION8)/;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/pre-install.ps1 tmp/winsoft-config.ini tmp/$(EXE) tmp/$(EXE8)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat pre-install.ps1 winsoft-config.ini $(EXE) $(EXE8))
	@chmod ugo+rw $@
