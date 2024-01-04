#
# RocketChat
#

SOFT:=RocketChat
VERSION:=$(shell curl -s -L 'https://github.com/RocketChat/Rocket.Chat.Electron/releases/latest' | sed -e 's/[[:space:]]/\n/g;' | grep 'href="/RocketChat/Rocket.Chat.Electron/releases/tag/' | cut -f 6 -d '/' | cut -f 1 -d '"')
PATCH:=1
URL:=https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/$(VERSION)/rocketchat-$(VERSION)-win-x64.msi

EXE:=rocketchat-$(VERSION)-win-x64.msi

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum:
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
		file $(EXE) | grep -q "Subject: Rocket.Chat" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

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
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
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
