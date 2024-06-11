
#
# JavaJRE8 Uninstall
#

SOFT:=Uninstall-JavaJRE8
VERSION:=$(shell curl -s -L 'https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html' | grep 'Java SE Runtime Environment 8u' | sed -e 's/[<>]/ /g; s/[[:space:]][[:space:]]*/ /g;' | cut -f 7 -d ' ' | sed 's/^8u//;' | head -1 )
REVISION:=1

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

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
