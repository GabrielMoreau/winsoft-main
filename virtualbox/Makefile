
#
# VirtualBox
#

sinclude ../_common/flag.mk

SOFT:=VirtualBox
REVISION:=1
URL1:=$(shell curl -s -L --connect-timeout 10 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/"/\n/g;' | grep '/VirtualBox-.*-Win.exe' | head -1)
VERSION:=$(shell dirname '$(URL1)' | xargs -r basename)
URL2:=$(shell curl -s -L --connect-timeout 10 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/[<>"]/\n/g;' | grep "/$(VERSION)/Oracle_VirtualBox_Extension_Pack")

#https://download.virtualbox.org/virtualbox/7.1.0/VirtualBox-7.1.0-164728-Win.exe
#https://download.virtualbox.org/virtualbox/7.1.0/Oracle_VirtualBox_Extension_Pack-7.1.0.vbox-extpack

EXE1:=VirtualBox-$(VERSION)-Win.exe
EXE2:=$(shell basename '$(URL2)' 2> /dev/null)

VCREDIST:=
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe
REG_SEARCH:=$(SOFT)

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum1 check-exe2

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE1)$$' checksum.txt && grep -q '[[:space:]]$(EXE2)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL1: $(URL1)"
	@echo "EXE1: $(EXE1)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"
	@echo "VCREDIST: $(VCREDIST)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || { shasum -a 256 "$(EXE1)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE1) tmp/$(EXE2)

tmp/$(EXE1):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE1)" -L "$(URL1)" ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE1)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.vbox-extpack 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe: tmp/$(EXE1) tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE1) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE1)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE1) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE1)" 1>&2 ; exit 12; }; } ; \
		)
	@(cd tmp ; \
		file $(EXE2) | grep -q "gzip compressed data," || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 12; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE1) tmp/$(EXE2)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__PACKEXT__/$(EXE2)/;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE) ../update-visualredist/version.txt
	@mkdir -p tmp
	@sed -e "s/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/; s/__2015-2022-x64__/$$(grep ' 2015-2022-x64 ' ../update-visualredist/version.txt | cut -f 4 -d ' ')/;" $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE1) tmp/$(EXE2) $(VCREDIST)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini $(EXE1) $(EXE2) 2015-2022)
	@chmod ugo+rw $@

tmp/2015-2022/vc_redist.x64.exe: ../update-visualredist/version.txt ../update-visualredist/checksum.txt
	@mkdir -p tmp/2015-2022
	@curl $(CURLFLAGS) -# -o $@ -L https://aka.ms/vs/17/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" ../update-visualredist/checksum.txt || echo "Error: bad checksum for binary $@"
