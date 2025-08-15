
#
# Notepad++
#

SOFT:=NotepadPP
VERSION:=$(shell curl -s -L 'https://notepad-plus-plus.org/' | grep '/downloads/v' | cut -f 3 -d '/' | cut -f 2 -d 'v')
REVISION:=1
URL:=https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$(VERSION)/npp.$(VERSION).Installer.x64.exe

EXE:=npp.$(VERSION).Installer.x64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs ocs-push version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

OCS_DELAY:=$(OCS_DELAY_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp/$(EXE) tmp

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

wget: $(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		#file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -Xr ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

#ocs:
#	@echo ""
#	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
#	@echo "Launch:  install.bat"
#	@echo "Message: yes"
#	@echo "Delay:   20"
#	@echo "Cancel:  no"
#	@echo "Report:  yes"
#	@echo ""
#	@echo "$(IT_TEAM)"
#	@echo " --- "
#	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
#	@echo " --- "
#	@echo "The software will be stopped during the installation,"
#	@echo "make a quick save or postpone the update."
#	@echo ""

#ocs-push:
#	@[ -s "./$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" ] || (echo 'Zip archive not exists: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip' > /dev/stderr ; exit 1)
#	@sha=$$(shasum -a 256 "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip"); \
#	! grep -q "^$(SOFT)_$(VERSION)-$(REVISION)_x64.zip$$" tmp/ocs-pkgpush.txt > /dev/null 2>&1 || { echo 'Package already upload: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip' > /dev/stderr ; exit 1 ; } ;\
#	ocs-pkgpush --url "$(OCS_URL)/ocsreports" \
#		--name "$(SOFT)_$(VERSION)-$(REVISION)_x64" \
#		--description "$(SOFT)_$(VERSION)-$(REVISION)_x64" \
#		--priority 5 \
#		--notif-text "$(IT_TEAM)\r\n---\r\nInstall and/or Update: $(SOFT) ($(VERSION))\r\n---\r\nThe software will be stopped during the installation,\r\nmake a quick save or postpone the update." \
#		--notif-delay 20 \
#		--file "./$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" \
#		--capture-dir tmp \
#		--headless && echo "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" >> tmp/ocs-pkgpush.txt

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
