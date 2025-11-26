
#
# JavaJRE8 Uninstall
#

SOFT:=Uninstall-JavaJRE8
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html' | grep 'Java SE Runtime Environment 8u' | sed -e 's/[<>]/ /g; s/[[:space:]][[:space:]]*/ /g;' | cut -f 7 -d ' ' | sed 's/^8u//;' | head -1 )
REVISION:=1

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-exe clean control next version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Java 8 Update

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"

checksum: check-version

wget: tmp/$(EXE1)

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

check-exe:

%.zip: Makefile tmp/install.bat
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat)
	@chmod ugo+rw $@
