
#
# LightBulb
#

SOFT:=LightBulb
VERSION1:=$(shell curl -s -L 'https://github.com/Tyrrrz/LightBulb/releases/latest'  | sed 's/</\n/g;'| grep '^meta property.*og:title' | cut -f 4 -d ' ')
REVISION:=1
URL1:=https://github.com/Tyrrrz/LightBulb/releases/download/$(VERSION1)/LightBulb-Installer.exe

URL2:=$(shell curl -s -L https://dotnet.microsoft.com/$(shell curl -s -L 'https://dotnet.microsoft.com/en-us/download/dotnet/8.0' | sed -e 's/"/\n/g;' | grep 'thank-you/runtime-desktop.*windows-x64-installer'  | head -1) | sed -e 's/"/\n/g;' | grep '^https.*windowsdesktop-runtime-.*-win-x64.exe' | head -1)
VERSION2:=$(shell basename $(URL2) | cut -f 3 -d '-')

# https://github.com/Tyrrrz/LightBulb/releases

EXE1:=LightBulb-Installer-$(VERSION1).exe
EXE2:=windowsdesktop-runtime-$(VERSION2)-win-x64.exe

VERSION:=$(VERSION1).$(shell echo $(VERSION2) | sed 's/\.//g;')

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-exe1 check-exe2 clean control next ocs VERSION1 wget checksum

all: check-version check-exe1 check-exe2 $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION1) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION1 is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION1: $(VERSION1)"
	@echo "URL1: $(URL1)"
	@echo "EXE1: $(EXE1)"
	@echo "VERSION2: $(VERSION2)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || { shasum -a 256 "$(EXE1)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE1)

tmp/$(EXE1):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f LightBulb-Installer-*.exe 2>/dev/null ; \
		curl -# -o "$(EXE1)" -L "$(URL1)" ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE1)" ; \
		)

check-exe1: tmp/$(EXE1)
	@(cd tmp ; \
		file $(EXE1) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE1)" 1>&2 ; exit 1; } ; \
		# which peres >/dev/null && { peres -v $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION1)" || { echo "Error: bad version for binary $(EXE1)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f windowsdesktop-runtime*.exe 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		file $(EXE2) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE2)" ; \
		which peres >/dev/null && { peres -v $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSION2)" || echo "Error: bad version for binary $(EXE2)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe2: tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE2) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSION2)" || { echo "Error: bad version for binary $(EXE2)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE1)
	@mkdir -p tmp
	@sed -e 's/__VERSION1__/$(VERSION1)/; s/__VERSION2__/$(VERSION2)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE1) tmp/$(EXE2)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE1) $(EXE2))
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
	@echo ""
