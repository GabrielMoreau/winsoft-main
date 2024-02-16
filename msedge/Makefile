
#
# MSEdge
#

# curl -s -L 'https://edgeupdates.microsoft.com/api/products?view=enterprise' | sed -e 's/,/\n/g;' | grep -A 500 '"Product":"Stable"' | grep -A 40 '"Platform":"Windows"' | grep -A 5 '"Architecture":"x64"' | grep '"ProductVersion":"'

SOFT:=MSEdge
#VERSION:=$(shell curl -s -L 'https://edgeupdates.microsoft.com/api/products?view=enterprise' | sed -e 's/,/\n/g;' | grep -A 500 '"Product":"Stable"' | grep -B 3 '/MicrosoftEdgeEnterpriseX64.msi"' | grep '"ProductVersion":"' | cut -f 4 -d '"' | head -1)
#URL:=$(shell curl -s -L 'https://edgeupdates.microsoft.com/api/products?view=enterprise' | sed -e 's/,/\n/g;' | grep -A 500 '"Product":"Stable"' | grep      '/MicrosoftEdgeEnterpriseX64.msi"' | cut -f 4 -d '"' | head -1)
WLINES:=$(shell curl -s -L 'https://edgeupdates.microsoft.com/api/products?view=enterprise' | sed -e 's/,/\n/g;' | grep -A 500 '"Product":"Stable"' | paste -sd ',')
VERSION:=$(shell echo '$(WLINES)' | sed -e 's/,/\n/g;' | grep -B 3 '/MicrosoftEdgeEnterpriseX64.msi"' | grep '"ProductVersion":"' | cut -f 4 -d '"' | head -1)
URL:=$(shell     echo '$(WLINES)' | sed -e 's/,/\n/g;' | grep      '/MicrosoftEdgeEnterpriseX64.msi"' | cut -f 4 -d '"' | head -1)

REVISION:=1
UUID:=$(shell dirname "$(URL)" | xargs -r basename)
EXE:=MicrosoftEdgeEnterpriseX64-$(VERSION).msi

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
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "UUID: $(UUID)"
	@echo "WLINES: $(WLINES)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt  || { shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -3 checksum.txt; fi
	@grep -q "^$(UUID):" version.txt 2> /dev/null || echo "$(UUID): $(VERSION)" >> ./version.txt
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' version.txt) )) -lt 60 ]; then tail -2 version.txt; fi

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o $(EXE) -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)
	@grep -q "^$(UUID): $(VERSION)$$" version.txt 2> /dev/null  || echo "Error: bad UUID for version $(VERSION) in version.txt"

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "MSI Installer"        || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q "Comments: $(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
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
