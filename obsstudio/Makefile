
#
# OBS-Studio
#

sinclude ../_common/flag.mk

SOFT:=OBS-Studio
URL:=$(shell curl $(CURLFLAGS) -s -L 'https://obsproject.com/fr/download' | sed -e 's/>/\n/g;' | sed -e 's/"/\n/g;' | egrep '^https://.*/OBS-Studio-.*-Installer.exe$$')
VERSION:=$(shell basename $(URL) 2> /dev/null | cut -f 3 -d '-')
REVISION:=1

EXE:=OBS-Studio-$(VERSION)-Installer.exe

VCREDIST:=
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=OBS Studio

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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl $(CURLFLAGS) -# -o "$(EXE)" -L "$(URL)" ; \
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

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE) ../update-visualredist/version.txt
	@mkdir -p tmp
	@sed -e "s/__VERSION__/$(VERSION)/; s/__2015-2022-x64__/$$(grep ' 2015-2022-x64 ' ../update-visualredist/version.txt | cut -f 4 -d ' ')/;" $< > $@

%.zip: Makefile global.ini tmp/install.bat pre-install.ps1 tmp/winsoft-config.ini tmp/$(EXE) $(VCREDIST)
	@rm -f $@
	@zip -r ./$@ global.ini pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini $(EXE) 2015-2022)
	@chmod ugo+rw $@


tmp/2015-2022/vc_redist.x64.exe: ../update-visualredist/version.txt ../update-visualredist/checksum.txt
	@mkdir -p tmp/2015-2022
	@curl $(CURLFLAGS) -# -o $@ -L https://aka.ms/vs/17/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" ../update-visualredist/checksum.txt || echo "Error: bad checksum for binary $@"
