
#
# Action-RebootIfPending
#

SOFT:=Action-RebootIfPending
VERSION:=0.9
REVISION:=1

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized checksum clean control next version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_PRIORITY:=$(shell expr $(OCS_PRIORITY) + 1)
OCS_DURATION:=$(OCS_DURATION_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized:
	@echo 'Ok'

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"

checksum:
	@echo -n ''

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s#__IT_TEAM__#$(IT_TEAM)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1
	@rm -f $@@
	zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat)
	@chmod ugo+rw $@
