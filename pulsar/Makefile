
#
# Pulsar-Edit
#

sinclude ../_common/flag.mk

SOFT:=Pulsar-Edit
REVISION:=1
URL:=$(shell curl -sL 'https://api.github.com/repos/pulsar-edit/pulsar/releases' | grep 'browser_download_url.*Setup.*exe' | cut -f 4 -d '"' | grep -v 'beta' | head -1)
VERSION:=$(shell dirname '$(URL)' 2> /dev/null | xargs -r basename | sed -e 's/^v//;')

EXE:=Windows.Pulsar.Setup.$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs ocs-push version wget checksum

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
		curl $(CURLFLAGS) -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

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

ocs-push:
	@[ -s "./$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" ] || (echo 'Zip archive not exists: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip' > /dev/stderr ; exit 1)
	@sha=$$(shasum -a 256 "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip"); \
	! grep -q "^$(SOFT)_$(VERSION)-$(REVISION)_x64.zip$$" tmp/ocs-pkgpush.txt > /dev/null 2>&1 || { echo 'Package already upload: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip' > /dev/stderr ; exit 1 ; } ;\
	ocs-pkgpush --url "$(OCS_URL)/ocsreports" \
		--name "$(SOFT)_$(VERSION)-$(REVISION)_x64" \
		--description "$(SOFT)_$(VERSION)-$(REVISION)_x64" \
		--priority 5 \
		--notif-text "$(IT_TEAM)\r\n---\r\nInstall and/or Update: $(SOFT) ($(VERSION))" \
		--notif-delay 5 \
		--file "./$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" \
		--capture-dir tmp \
		--headless && echo "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" >> tmp/ocs-pkgpush.txt
