
#
# AnyConnect
#

SOFT:=AnyConnect
VERSION:=4.10.07061
PATCH:=1
VERSIONONLINE:=$(shell curl -s 'https://www.cisco.com/c/en/us/td/docs/security/vpn_client/anyconnect/anyconnect410/release/notes/release-notes-anyconnect-4-10.html' | sed -e 's/[<>]/\n/g;' | grep '^AnyConnect [[:digit:]].* New Features' | head -1 | cut -f 2 -d ' ')

EXE:=anyconnect-win-$(VERSION)-core-vpn-webdeploy-k9.msi

CISCO_VPN_SERVER:=vpn.example.com
IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version control $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)
	@[ "$(VERSION)" = "$(VERSIONONLINE)" ] || { echo '#'; echo "# Warning: a new version $(VERSIONONLINE) exist on Cisco website!"; echo '#'; }

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: No download here"
	@echo "EXE: $(EXE)"
	@echo "VERSIONONLINE: $(VERSIONONLINE)"

checksum:
	@( \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt && exit; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ./checksum.txt; \
		tail -3 ./checksum.txt; \
		)

control:
	@file $(EXE) | grep -q "Subject: Cisco AnyConnect Secure Mobility Client" || echo "Error: bad format for binary $(EXE)"
	@grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \

tmp/install.bat: install.bat Makefile $(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

tmp/Profile_VPN_Default.xml: Profile_VPN_Default.xml Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/(__VPN_SERVER__)/$(CISCO_VPN_SERVER)/;' Profile_VPN_Default.xml > $@
	@if grep -q '__VPN_SERVER__' $@; then echo "Error: bad VPN Server replacement in $<"; fi

%.zip: Makefile tmp/install.bat $(EXE) tmp/Profile_VPN_Default.xml
	@rm -f $@
	@zip -r $@ $(EXE)
	@(cd tmp; zip -r ../$@ install.bat $(EXE) Profile_VPN_Default.xml)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
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
