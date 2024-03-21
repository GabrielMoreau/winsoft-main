
#
# Check-WithSecureHotfixes
#

SOFT:=Check-WithSecureHotfixes
VERSION:=0.4
REVISION:=1


IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"

checksum:

check-exe:

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1
	@rm -f $@
	zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:     $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:   install.bat"
	@echo "Priority: 5"
	@echo "Message:  yes"
	@echo "Delay:    5"
	@echo "Cancel:   no"
	@echo "Report:   yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
