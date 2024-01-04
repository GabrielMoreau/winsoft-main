
#
# Wireshark
#

SOFT:=Wireshark
VERSION1:=$(shell curl -s -L 'https://www.wireshark.org/download.html' | sed -e 's/[<>]/\n/g' | grep 'current stable release' | cut -f 8 -d ' ' | sed -e 's/\.$$//;')
PATCH:=1
# https://1.eu.dl.wireshark.org/win64/Wireshark-4.2.0-x64.exe
URL1:=$(shell curl -s -L 'https://www.wireshark.org/download.html' | sed -e 's/"/\n/g;' | egrep "/Wireshark-$(VERSION1)-x64.exe")
EXE1:=Wireshark-$(VERSION1)-x64.exe

#URL2:=https://npcap.com/$(shell curl -s -L 'https://npcap.com/' | sed -e 's/"/\n/g;' | egrep '^dist/npcap-.*exe')
#VERSION2:=$(shell echo $(URL2) | sed -e 's/\.exe//;' | cut -f 2 -d '-')
URL2:=http://www.win10pcap.org/download/$(shell curl -s -L 'http://www.win10pcap.org/download/' | sed -e 's/["<>]/\n/g;' | egrep '^Win10Pcap-v.*msi' | head -1)
VERSION2:=$(shell echo $(URL2) | sed -e 's/\.msi//; s/-v/-/;' | cut -f 2 -d '-')
EXE2:=Win10Pcap-v$(VERSION2).msi
#VERSION2:=$(shell ./nmap4npcap)
#EXE2:=npcap-$(VERSION2).exe

VERSION:=$(VERSION1).$(shell echo $(VERSION2) | sed -e 's/\.//g;')


IT_TEAM:=IT Support


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION1) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION1 is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION1: $(VERSION1)"
	@echo "URL1: $(URL1)"
	@echo "EXE1: $(EXE1)"
	@echo "VERSION2: $(VERSION2)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || { shasum -a 256 "$(EXE1)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE1)

tmp/$(EXE1):
	@mkdir -p tmp
	@(cd tmp ; \
		curl -# -o "$(EXE1)" -L "$(URL1)" ; \
		# file $(EXE1) | grep -q "Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE1)" ; \
		# which peres >/dev/null && { peres -a $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION1)" || echo "Error: bad version for binary $(EXE1)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE1)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		# file $(EXE2) | grep -q "MSI Installer.*Subject: Win10Pcap" || echo "Error: bad format for binary $(EXE2)" ; \
		#which peres >/dev/null && { peres -a $(EXE2) | grep -q "^Product Version:[[:space:]]*$(VERSION2)" || echo "Error: bad version for binary $(EXE2)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe: tmp/$(EXE1) tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE1) | grep -q "Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE1)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -a $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION1)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)
	@(cd tmp ; \
		file $(EXE2) | grep -q "MSI Installer.*Subject: Win10Pcap" || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 1; } ; \
		#which peres >/dev/null && { peres -a $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION1)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE1) tmp/$(EXE2)
	@mkdir -p tmp
	@sed -e 's/__VERSION1__/$(VERSION1)/; s/__VERSION2__/$(VERSION2)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE1) tmp/$(EXE2)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE1) $(EXE2))
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
	@echo "Install and update: $(SOFT) ($(VERSION))"
	@echo ""


# 7z l nmap-7.12-setup.exe  | grep winpcap | awk '{print $5}'
# 7z -y e nmap-7.12-setup.exe winpcap-nmap-4.13.exe  > /dev/null

