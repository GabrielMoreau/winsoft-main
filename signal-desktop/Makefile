
#
# Signal-Desktop
#

SOFT:=Signal-Desktop
VERSION:=$(shell curl -s -L 'https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest' |  grep '"tag_name":' | cut -f 4 -d '"' | sed -e 's/^v//;' | head -1)
REVISION:=1
URL:=https://updates.signal.org/desktop/signal-desktop-win-x64-$(VERSION).exe

EXE:=signal-desktop-win-x64-$(VERSION).exe

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
		curl -# -o "$(EXE)" -L "$(URL)" ; \
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

%.zip: Makefile uninstall.bat tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@zip -Xr $@ uninstall.bat
	@(cd tmp; zip -Xr ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(OCS_NAME)"
	@echo "Launch:  install.bat"
	@echo "Notify:  $(OCS_NOTIFY)"
	@echo "Delay:   $(OCS_DELAY)"
	@echo "Cancel:  $(OCS_CANCEL)"
	@echo "Report:  $(OCS_REPORT)"
	@echo "Message: $(OCS_MESSAGE)"
	@echo ""

ocs-push:
	@[ -s "./$(OCS_NAME).zip" ] || (echo 'Zip archive not exists: $(OCS_NAME).zip' > /dev/stderr ; exit 1)
	@sha=$$(shasum -a 256 "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip"); \
	! grep -q "^$(OCS_NAME).zip$$" tmp/ocs-pkgpush.txt > /dev/null 2>&1 || { echo 'Package already upload: $(OCS_NAME).zip' > /dev/stderr ; exit 1 ; } ;\
	echo ocs-pkgpush --url "$(OCS_URL)/ocsreports" \
		--name "$(OCS_NAME)" \
		--description "$(OCS_NAME)" \
		--priority "$(OCS_PRIORITY)" \
		--notif-text '"$(OCS_MESSAGE)"' \
		--notif-delay "$(OCS_DELAY)" \
		--file "./$(OCS_NAME).zip" \
		--capture-dir tmp \
		--headless && echo "$(OCS_NAME).zip" >> tmp/ocs-pkgpush.txt
