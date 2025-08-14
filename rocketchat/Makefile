#
# RocketChat
#

SOFT:=RocketChat
VERSION:=$(shell curl -s -L 'https://github.com/RocketChat/Rocket.Chat.Electron/releases/latest' | sed -e 's/[[:space:]]/\n/g;' | grep 'href="/RocketChat/Rocket.Chat.Electron/releases/tag/' | cut -f 6 -d '/' | cut -f 1 -d '"')
REVISION:=1
URL:=https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/$(VERSION)/rocketchat-$(VERSION)-win-x64.msi

EXE:=rocketchat-$(VERSION)-win-x64.msi

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
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

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
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Rocket.Chat" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		# which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/servers.json: servers.json Makefile tmp/$(EXE)
	@mkdir -p tmp
	@if [ -e ../../winsoft-conf/rocketchat/servers.json ]; then cp -f ../../winsoft-conf/rocketchat/servers.json tmp/; else cp -f servers.json tmp/; fi

%.zip: Makefile pre-install.ps1 tmp/install.bat tmp/servers.json tmp/$(EXE)
	@rm -f $@
	@zip -r $@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat servers.json $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   20"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo " --- "
	@echo "The software will be stopped during the installation,"
	@echo "make a quick save or postpone the update."
	@echo ""

ocs-push:
	@[ -s "./$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" ] || (echo 'Zip archive not exists: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip' > /dev/stderr ; exit 1)
	@sha=$$(shasum -a 256 "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip"); \
	! grep -q "^$(SOFT)_$(VERSION)-$(REVISION)_x64.zip$$" tmp/ocs-pkgpush.txt > /dev/null 2>&1 || { echo 'Package already upload: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip' > /dev/stderr ; exit 1 ; } ;\
	ocs-pkgpush --url "$(OCS_URL)/ocsreports" \
		--name "$(SOFT)_$(VERSION)-$(REVISION)_x64" \
		--description "$(SOFT)_$(VERSION)-$(REVISION)_x64" \
		--priority 5 \
		--notif-text "$(IT_TEAM)\r\n---\r\nInstall and/or Update: $(SOFT) ($(VERSION))\r\n---\r\nThe software will be stopped during the installation,\r\nmake a quick save or postpone the update." \
		--notif-delay 20 \
		--file "./$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" \
		--capture-dir tmp \
		--headless && echo "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip" >> tmp/ocs-pkgpush.txt
