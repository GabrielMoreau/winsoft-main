
#
# Uninstall-NordVPN
#

sinclude ../_common/flag.mk

SOFT:=Uninstall-NordVPN
VERSION:=$(shell grep '^[[:digit:]]' url.txt | sort --version-sort -k 1 | tail -1 | awk '{print $$1}')
REVISION:=1
URL:=$(shell grep '^$(VERSION)[[:space:]]' url.txt | awk '{print $$2}')

EXE:=NordVPNSetup-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_PRIORITY:=$(shell expr $(OCS_PRIORITY) + 1)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "CURL: $(CURLFLAGS)"

checksum: check-version

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat)
	@chmod ugo+rw $@
