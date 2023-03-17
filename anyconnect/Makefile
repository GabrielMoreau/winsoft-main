
#
# AnyConnect
#

SOFT:=AnyConnect
VERSION:=4.10.05111
PATCH:=1

EXE:=anyconnect-win-$(VERSION)-core-vpn-webdeploy-k9.msi

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget

all: check-version control $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: No download here"
	@echo "EXE: $(EXE)"

control:
	@file $(EXE) | grep -q "Subject: Cisco AnyConnect Secure Mobility Client" || echo "Error: bad format for binary $(EXE)"
	@grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \

tmp/install.bat: install.bat Makefile $(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat $(EXE) Profile_VPN_Default.xml
	@rm -f $@
	@zip -r $@ $(EXE) Profile_VPN_Default.xml
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
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
	@echo "Install and update: $(SOFT)"
	@echo ""
