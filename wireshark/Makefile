
#
# Wireshark
#

SOFT:=Wireshark
VERSION:=$(shell curl -s -L 'https://www.wireshark.org/download.html' | sed -e 's/[<>]/\n/g' | grep 'current stable release' | cut -f 8 -d ' ' | sed -e 's/\.$$//;')
PATCH:=1
URL:=$(shell curl -s -L 'https://www.wireshark.org/download.html' | sed -e 's/"/\n/g;' | egrep "/Wireshark-win64-$(VERSION).exe")

URL2:=https://npcap.com/$(shell curl -s -L 'https://npcap.com/' | sed -e 's/"/\n/g;' | egrep '^dist/npcap-.*exe')
VERSION2:=$(shell echo $(URL2) | sed -e 's/\.exe//;' | cut -f 2 -d '-')

EXE:=Wireshark-win64-$(VERSION).exe
EXE2:=npcap-$(VERSION2).exe

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "VERSION2: $(VERSION2)"
	@echo "URL2: $(URL2)"

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		file $(EXE2) | grep -q "Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE) tmp/$(EXE2)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftversion2=)\d[\.\d]+\w?/$${1}$(VERSION2)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) tmp/$(EXE2)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE) $(EXE2))
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


# 7z l nmap-7.12-setup.exe  | grep winpcap | awk '{print $5}'
# 7z -y e nmap-7.12-setup.exe winpcap-nmap-4.13.exe  > /dev/null 

