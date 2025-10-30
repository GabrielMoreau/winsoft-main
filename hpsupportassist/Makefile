
#
# HPSupportAssist
#

SOFT:=HPSupportAssist
#VERSION:=$(shell curl -s -L --connect-timeout 10 'https://www.filehorse.com/download-hp-support-assistant/download/' | sed -s 's/</\n/g;' | grep '^title' | awk '{print $$5}')
VERSION:=$(shell grep '^[[:digit:]]' url.txt | sort --version-sort -k 1 | tail -1 | awk '{print $$1}')
REVISION:=1
#URL:=$(shell curl -s -L --connect-timeout 10 'https://www.filehorse.com/download-hp-support-assistant/download/' | sed -s 's/"/\n/g;'  | grep '^https://www.filehorse.com/download/file')
URL:=$(shell grep '^$(VERSION)[[:space:]]' url.txt | awk '{print $$2}')

EXE:=hp-support-assist-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum check-update

all:  check-update check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

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

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		echo 'Verify sha256 checksum with direct download with Firefox on https://support.hp.com/us-en/help/hp-support-assistant' ; \
		)

wget: tmp/$(EXE)

check-update:
	@./check4new-version || { echo "Error: there is probably a new version online" 1>&2 ; exit 13; }

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf *.exe setup 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/setup/InstallHPSA.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf setup 2>/dev/null ; \
		mkdir -p setup ; \
		cd setup ; \
		7z x ../$(EXE) -y >/dev/null ; \
		)

check-exe: tmp/$(EXE) tmp/setup/InstallHPSA.exe
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32+ executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		# which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)
	@(cd tmp ; \
		which peres >/dev/null && { peres -v setup/InstallHPSA.exe | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) tmp/setup/InstallHPSA.exe
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat)
	@(cd tmp/setup; zip --quiet -r ../../$@ *)
	@chmod ugo+rw $@
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l
