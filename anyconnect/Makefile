
#
# CiscoAnyConnect
#

SOFT:=CiscoAnyConnect
#VERSION:=4.10.07061
VERSION:=5.1.5.65
REVISION:=1
VERSIONONLINE:=$(shell curl -s 'https://www.cisco.com/c/en/us/td/docs/security/vpn_client/anyconnect/Cisco-Secure-Client-5/release/notes/release-notes-cisco-secure-client-5-1.html' | sed -e 's/[<>]/\n/g;' | grep '^Cisco Secure Client [[:digit:]].* New Features' | head -1 | cut -f 4 -d ' ')

#EXE:=anyconnect-win-$(VERSION)-core-vpn-webdeploy-k9.msi
EXE:=cisco-secure-client-win-$(VERSION)-core-vpn-webdeploy-k9.msi

CISCO_VPN_SERVER:=vpn.example.com
IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)
	@if [ "$(VERSION)" != "$(VERSIONONLINE)" ]; then echo '#'; echo "# Warning: a new version $(VERSIONONLINE) exist on Cisco website!"; echo '#'; fi

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: No download here"
	@echo "EXE: $(EXE)"
	@echo "VERSIONONLINE: $(VERSIONONLINE)"

checksum: check-version
	@( \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt && exit; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ./checksum.txt; \
		tail -3 ./checksum.txt; \
		)

check-exe: $(EXE)
	@#file $(EXE) | grep -q "Subject: Cisco AnyConnect Secure Mobility Client" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; }
	@file $(EXE) | grep -q "Subject: Cisco Secure Client - AnyConnect VPN" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; }
	@grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt || echo "Error: bad checksum for binary $(EXE)"

tmp/install.bat: install.bat Makefile $(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/Profile_VPN_Default.xml: Profile_VPN_Default.xml Makefile
	@mkdir -p tmp
	@sed -e 's/__VPN_SERVER__/$(CISCO_VPN_SERVER)/;' $< > $@
	@if grep -q '__VPN_SERVER__' $@; then echo "Error: bad VPN Server substitution in $<"; fi

%.zip: Makefile tmp/install.bat $(EXE) tmp/Profile_VPN_Default.xml
	@rm -f $@
	@zip -r $@ $(EXE)
	@(cd tmp; zip -r ../$@ install.bat $(EXE) Profile_VPN_Default.xml)
	@chmod ugo+rw $@
