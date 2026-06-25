
#
# Hurukai-Agent
#

SOFT:=Hurukai-Agent
VERSION:=$(shell ls -1 hurukai-*-x86_64.msi 2> /dev/null | cut -f 2 -d '-' | cut -f 1 -d '_' | sort -V | tail -1)
REVISION:=1

EXE:=hurukai-$(VERSION)-x86_64.msi
REG_SEARCH:=Hurukai\\sagent

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=HarfangLab Hurukai agent

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum: check-version $(EXE)
	@grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ./checksum.txt ; \
		tail -3 ./checksum.txt

check-exe: $(EXE)
	@grep -q "^$$(shasum -a 256 $(EXE))$$" ./checksum.txt || echo "Error: bad checksum for binary $(EXE)"
	@file $(EXE) | grep -q "Composite Document File.*Subject: HarfangLab Hurukai agent" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
	# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\


tmp/install.bat: install.bat Makefile $(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__QEXEADMIN__/$(QEXEADMIN)/; s/__HURUKAI_SERVER__/$(HURUKAI_SERVER)/; s/__HURUKAI_SIG__/$(HURUKAI_SIG)/; s/__HURUKAI_TOKEN__/$(HURUKAI_TOKEN)/;' $< > $@

tmp/winsoft-config.ini: winsoft-config.ini Makefile $(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 post-install.ps1 tmp/winsoft-config.ini $(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1 post-install.ps1 $(EXE)
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini)
	@chmod ugo+rw $@
