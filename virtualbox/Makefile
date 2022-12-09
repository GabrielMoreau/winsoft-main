
#
# VirtualBox
#

SOFT:=VirtualBox
VERSION:=$(shell curl -s -L 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/>[[:space:]]/>/; s/[<>]/\n/g;' | grep 'platform packages' | cut -f 1 -d ' ')
PATCH:=1
URL1:=$(shell curl -s -L 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/[<>"]/\n/g;' | grep "/$(VERSION)/VirtualBox-.*-Win.exe")
URL2:=$(shell curl -s -L 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/[<>"]/\n/g;' | grep "/$(VERSION)/Oracle_VM_VirtualBox_Extension")

EXE1:=VirtualBox-$(VERSION)-Win.exe
EXE2:=Oracle-VM-VirtualBox-Extension-Pack-$(VERSION).vbox-extpack

VCREDIST:=
VCREDIST+=tmp/2015-2019/vc_redist.x64.exe
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe

IT_TEAM:=IT Support


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

wget: tmp/$(EXE1) tmp/$(EXE2)

tmp/$(EXE1):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(EXE1)" -L "$(URL1)" ; \
		file $(EXE1) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE1)" ; \
		which peres >/dev/null && { peres -a $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE1)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE1)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.vbox-extpack 2>/dev/null ; \
		curl -s -o "$(EXE2)" -L "$(URL2)" ; \
		file $(EXE2) | grep -q "gzip compressed data, max compression" || echo "Error: bad format for binary $(EXE2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE1) tmp/$(EXE2)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile pre-install.ps1 tmp/install.bat tmp/$(EXE1) tmp/$(EXE2) $(VCREDIST)
	@rm -f $@
	@zip -r $@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE1) $(EXE2) 2015-2019 2015-2022)
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


tmp/2015-2019/vc_redist.x64.exe:
	@mkdir -p tmp/2015-2019
	@curl -s -o $@ -L https://aka.ms/vs/16/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2015-2019/vc_redist.x86.exe:
	@mkdir -p tmp/2015-2019
	@curl -s -o $@ -L https://aka.ms/vs/16/release/vc_redist.x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"


tmp/2015-2022/vc_redist.x64.exe:
	@mkdir -p tmp/2015-2022
	@curl -s -o $@ -L https://aka.ms/vs/17/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2015-2022/vc_redist.x86.exe:
	@mkdir -p tmp/2015-2022
	@curl -s -o $@ -L https://aka.ms/vs/17/release/vc_redist.x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"