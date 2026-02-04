#
# RocketChat
#

SOFT:=RocketChat
#VERSION:=$(shell curl -s -L --connect-timeout 10 'https://github.com/RocketChat/Rocket.Chat.Electron/releases/latest' | sed -e 's/[[:space:]]/\n/g;' | grep 'href="/RocketChat/Rocket.Chat.Electron/releases/tag/' | cut -f 6 -d '/' | cut -f 1 -d '"')
REVISION:=1
#URL:=https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/$(VERSION)/rocketchat-$(VERSION)-win-x64.msi
URL:=$(shell curl -s -L --connect-timeout 10 'https://api.github.com/repos/RocketChat/Rocket.Chat.Electron/releases' | sed -e 's/"/\n/g;' | grep -P -- 'https://.*download/([\d\.]+)/rocketchat-\1-win-x64.ms' | head -1)
VERSION:=$(shell dirname "$(URL)" | xargs -r basename)

EXE:=rocketchat-$(VERSION)-win-x64.msi
REG_SEARCH:=Rocket\\.Chat

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Rocket.Chat
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

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
		file $(EXE) | grep -q "Subject: Rocket.Chat" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

tmp/servers.json: servers.json Makefile tmp/$(EXE)
	@mkdir -p tmp
	@if [ -e ../../winsoft-conf/rocketchat/servers.json ]; then cp -f ../../winsoft-conf/rocketchat/servers.json tmp/; else cp -f servers.json tmp/; fi

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/servers.json tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat servers.json winsoft-config.ini $(EXE))
	@chmod ugo+rw $@
