
#
# TeXnicCenter
#

sinclude ../_common/flag.mk

SOFT:=TeXnicCenter
URL:=$(shell curl $(CURLFLAGS) -s -L 'https://www.texniccenter.org/download/' | sed -e 's/"/\n/g;'  | grep '_x64.exe/download' | head -1 | xargs -r dirname)
#URL:=$(shell curl $(CURLFLAGS) -s -L "$(URL1)" | grep 'data-release-url' | sed -e 's/"/\n/g;' | grep '^https' | head -1)
REVISION:=1
VERSION:=$(shell echo "$(URL)" | cut -f 2 -d '_' | sed -e 's/Stable//;')

EXE:=TXCSetup_$(VERSION)Stable_x64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

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
	@echo "CURL: $(CURLFLAGS)"

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
		URLREDIR=$$(curl $(CURLFLAGS) -s -L "$(URL)" | grep 'data-release-url' | sed -e 's/"/\n/g;' | grep '^https' | head -1) ; \
		echo "$${URLREDIR}" ; \
		curl $(CURLFLAGS) -# -o "$(EXE)" -L "$${URLREDIR}" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.psd1: winsoft-config.psd1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
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
	@echo ""
