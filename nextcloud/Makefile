
#
# Nextcloud
#

SOFT:=Nextcloud
URL:=$(shell curl -s -L 'https://nextcloud.com/install/' | sed -e 's/"/\n/g;' | grep '^https://.*/Nextcloud-.*-x64.msi' | tail -1)
VERSION:=$(shell basename "$(URL)" | cut -f 2 -d '-')
REVISION:=1
# VERSION:=$(shell curl -s -L 'https://download.nextcloud.com/desktop/releases/Windows/' | sed -e 's/>/\n/g;' | grep 'href="Nextcloud-.*-x64.msi"' | tail -1 | cut -f 2 -d '-')
# URL:=https://download.nextcloud.com/desktop/releases/Windows/Nextcloud-$(VERSION)-x64.msi

EXE:=Nextcloud-$(VERSION)-x64.msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs ocs-push version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

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
		file $(EXE) | grep -q "Composite Document File.*MSI Installer" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q "Subject: Nextcloud $(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v 'MainExecutable' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary MainExecutable" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -Xr ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
