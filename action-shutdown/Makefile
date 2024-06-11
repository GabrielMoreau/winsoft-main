
#
# Action-Shutdown
#

SOFT:=Action-Shutdown
VERSION:=0.9
REVISION:=1

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s#__IT_TEAM__#$(IT_TEAM)#;' $< > $@

%.zip: Makefile tmp/install.bat
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:     $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Launch:   install.bat"
	@echo "Priority: 6"
	@echo "Message:  yes"
	@echo "Delay:    *20*"
	@echo "Cancel:   yes"
	@echo "Report:   yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
