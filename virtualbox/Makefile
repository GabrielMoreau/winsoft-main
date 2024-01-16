
#
# VirtualBox
#

SOFT:=VirtualBox
VERSION:=$(shell curl -s -L 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/>[[:space:]]/>/; s/[<>]/\n/g;' | grep 'platform packages' | cut -f 1 -d ' ')
REVISION:=1
URL1:=$(shell curl -s -L 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/[<>"]/\n/g;' | grep "/$(VERSION)/VirtualBox-.*-Win.exe")
URL2:=$(shell curl -s -L 'https://www.virtualbox.org/wiki/Downloads' | sed -e 's/[<>"]/\n/g;' | grep "/$(VERSION)/Oracle_VM_VirtualBox_Extension")

EXE1:=VirtualBox-$(VERSION)-Win.exe
EXE2:=$(shell basename $(URL2))

VCREDIST:=
VCREDIST+=tmp/2015-2019/vc_redist.x64.exe
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum check-exe1 check-exe2

all: check-version check-exe1 check-exe2 $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL1: $(URL1)"
	@echo "EXE1: $(EXE1)"
	@echo "URL2: $(URL2)"
	@echo "EXE2: $(EXE2)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || { shasum -a 256 "$(EXE1)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE1) tmp/$(EXE2)

tmp/$(EXE1):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE1)" -L "$(URL1)" ; \
		#file $(EXE1) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE1)" ; \
		#which peres >/dev/null && { peres -a $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE1)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE1))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE1)" ; \
		)

check-exe1: tmp/$(EXE1)
	@(cd tmp ; \
		file $(EXE1) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE1)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -a $(EXE1) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE1)" 1>&2 ; exit 1; }; } ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.vbox-extpack 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		#file $(EXE2) | grep -q "gzip compressed data," || echo "Error: bad format for binary $(EXE2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

check-exe2: tmp/$(EXE2)
	@(cd tmp ; \
		file $(EXE2) | grep -q "gzip compressed data," || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 1; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE1) tmp/$(EXE2)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PACKEXT__/$(EXE2)/;' $< > $@

%.zip: Makefile pre-install.ps1 tmp/install.bat tmp/$(EXE1) tmp/$(EXE2) $(VCREDIST)
	@rm -f $@
	@zip -r $@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE1) $(EXE2) 2015-2019 2015-2022)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
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


tmp/2015-2019/vc_redist.x64.exe:
	@mkdir -p tmp/2015-2019
	@curl -# -o $@ -L https://aka.ms/vs/16/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2015-2019/vc_redist.x86.exe:
	@mkdir -p tmp/2015-2019
	@curl -# -o $@ -L https://aka.ms/vs/16/release/vc_redist.x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"


tmp/2015-2022/vc_redist.x64.exe:
	@mkdir -p tmp/2015-2022
	@curl -# -o $@ -L https://aka.ms/vs/17/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2015-2022/vc_redist.x86.exe:
	@mkdir -p tmp/2015-2022
	@curl -# -o $@ -L https://aka.ms/vs/17/release/vc_redist.x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
