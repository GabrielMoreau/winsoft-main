
#
# Blender
#

SOFT:=Blender
# https://download.blender.org/release/Blender4.5/blender-4.5.4-windows-x64.msi
# https://ftp.halifax.rwth-aachen.de/blender/release/Blender4.5/blender-4.5.4-windows-x64.msi
# https://ftp.nluug.nl/pub/graphics/blender/release/Blender4.5/blender-4.5.4-windows-x64.msi
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://api.github.com/repos/blender/blender/tags' | grep '"name":' | head -1 | cut -f 4 -d '"' | sed -e 's/^v//;')
VERSION_SHORT:=$(shell echo  '$(VERSION)' | cut -f 1,2 -d '.')
URL:=$(shell echo 'https://download.blender.org,https://ftp.halifax.rwth-aachen.de/blender,https://ftp.nluug.nl/pub/graphics/blender' | sed -e 's/,/\n/g;' | sort -R | head -1)/release/Blender$(VERSION_SHORT)/blender-$(VERSION)-windows-x64.msi
#URL:=$(shell curl -s -L --connect-timeout 10 'https://www.blender.org/download/' | sed -e 's/"/\n/g;' | grep -E '^https://www.blender.org/.*/.*windows-x64.msi' | head -1 | xargs -r curl -s -L | sed -e 's/"/\n/g;' | egrep '^https://.*/blender-.*windows-x64.msi' | sort -r | head -1 | sed -e 's#/$$##;')
#VERSION:=$(shell basename '$(URL)' 2> /dev/null | cut -f 2 -d '-')
REVISION:=1

EXE:=blender-$(VERSION)-windows-x64.msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

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

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/CM_FP_Blender.blender_launcher.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		which 7z >/dev/null && { 7z x -y $(EXE) 'CM_FP_Blender.blender_launcher.exe' | grep 'Extracting'; } ; \
		)

check-exe: tmp/$(EXE) tmp/CM_FP_Blender.blender_launcher.exe
	@cd tmp; file $(EXE) | grep -q 'Subject: Blender, Author: Blender Foundation' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; }
	@cd tmp; file 'CM_FP_Blender.blender_launcher.exe' | grep -Eq 'PE32\+ executable for MS Windows.*x86-64' || { echo "Error: bad format for binary CM_FP_Blender.blender_launcher.exe" 1>&2 ; exit 12; }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@
