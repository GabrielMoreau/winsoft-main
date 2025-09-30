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


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)
OCS_SEARCH:=Rocket.Chat

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
