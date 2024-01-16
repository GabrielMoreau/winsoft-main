
#
# OBS-Studio
#

SOFT:=OBS-Studio
URL:=$(shell curl -s -L 'https://obsproject.com/fr/download' | sed -e 's/>/\n/g;' | sed -e 's/"/\n/g;' | egrep '^https://.*/OBS-Studio-.*-Full-Installer-x64.exe$$')
VERSION:=$(shell basename $(URL) | cut -f 3 -d '-')
PATCH:=1

EXE:=OBS-Studio-$(VERSION)-Full-Installer-x64.exe

VCREDIST:=
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(PATCH)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(PATCH)_x64.zip tmp resources

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

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

tmp/pre-install.ps1: pre-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile global.ini tmp/install.bat tmp/pre-install.ps1 tmp/$(EXE) $(VCREDIST)
	@rm -f $@
	@zip -r ./$@ global.ini
	@(cd tmp; zip -r ../$@ install.bat pre-install.ps1 $(EXE) 2015-2022)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(PATCH)_x64"
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
