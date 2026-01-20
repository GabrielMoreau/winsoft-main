
#
# Nextcloud
#

# https://github.com/nextcloud-releases/desktop/releases/download/v3.17.3/Nextcloud-3.17.3-x64.msi
# https://github.com/nextcloud-releases/desktop/releases/download/v4.0.0/Nextcloud-4.0.0-x64.msi
# curl -sL 'https://github.com/nextcloud-releases/desktop/releases' | sed -e 's/"/\n/g;' | grep '.*/nextcloud.*/Nextcloud-.*msi$'
# curl -sL 'https://github.com/nextcloud-releases/desktop/releases' | sed -e 's/"/\n/g;' | grep '/nextcloud-releases/desktop/releases/tag/'  | grep -Ev -- '-(rc|alpha|beta)' | cut -f 6 -d '/' | cut -f 2 -d 'v' | grep . | head -1

SOFT:=Nextcloud
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://github.com/nextcloud-releases/desktop/releases' | sed -e 's/"/\n/g;' | grep '/nextcloud-releases/desktop/releases/tag/'  | grep -Ev -- '-(rc|alpha|beta)' | cut -f 6 -d '/' | cut -f 2 -d 'v' | grep . | head -1)
URL:=https://github.com/$(shell curl -s -L --connect-timeout 10 'https://github.com/nextcloud-releases/desktop/releases/expanded_assets/v$(VERSION)' | sed -e 's/"/\n/g;' | grep '.*/Nextcloud-.*-x64.msi$$' | tail -1 | sed -e 's#^/##;')
REVISION:=1
# VERSION:=$(shell curl -s -L --connect-timeout 10 'https://download.nextcloud.com/desktop/releases/Windows/' | sed -e 's/>/\n/g;' | grep 'href="Nextcloud-.*-x64.msi"' | tail -1 | cut -f 2 -d '-')
# URL:=https://download.nextcloud.com/desktop/releases/Windows/Nextcloud-$(VERSION)-x64.msi

EXE:=Nextcloud-$(VERSION)-x64.msi
REG_SEARCH:=$(SOFT)

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
		which 7z >/dev/null && { rm -rf 'MainExecutable'; 7z x -y $(EXE) 'MainExecutable' | grep 'Extracting'; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Composite Document File.*MSI Installer" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file $(EXE) | grep -q "Subject: Nextcloud $(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v 'MainExecutable' 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary MainExecutable" 1>&2 ; exit 12; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@export VERSIONLONG=$$( (echo "$(VERSION)" ; (file "tmp/$(EXE)" | cut -f 2 -d '}' | cut -f 1 -d ';' | grep '^[[:digit:]][[:digit:]\.]*$$')) | tail -1); \
		echo " VERSIONLONG=$${VERSIONLONG}"; \
		sed -e "s/__VERSION__/$${VERSIONLONG}/; s/__REG_SEARCH__/$(REG_SEARCH)/;" $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini tmp/$(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1 post-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini $(EXE))
	@chmod ugo+rw $@
