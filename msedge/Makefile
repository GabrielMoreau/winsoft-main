
#
# MSEdge
#

SOFT:=MSEdge
INSTALLER:=MicrosoftEdgeEnterpriseX64.msi
PATCH:=1
URL:=$(shell curl --silent -L https://www.microsoft.com/en-us/edge/business/download | sed -e 's/[[:space:],]/\n/g;' | grep '^downloadUrl.*MicrosoftEdgeEnterpriseX64.msi' | head -1 | sed -e 's#\\u002F#/#g;' | cut -f 2 -d '"')
UUID:=$(shell dirname "$(URL)" | xargs -r basename)
VERSION:=$(shell (grep "^$(UUID):" version.txt 2> /dev/null || file tmp/MicrosoftEdgeEnterpriseX64.msi 2> /dev/null | sed -s 's/, /\n/g;' |grep '^Comments:') | awk '{print $$2}')
EXE:=MicrosoftEdgeEnterpriseX64-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all:
	@mkdir -p tmp
	@(cd tmp; \
		echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$'                        || curl -# -o $(INSTALLER) -L "$(URL)"; \
		file "$(INSTALLER)" 2> /dev/null | grep -q "MSI Installer.*Comments: $(VERSION)" || curl -# -o $(INSTALLER) -L "$(URL)"; \
		grep -q "^$(UUID):" ../version.txt 2> /dev/null                                  || curl -# -o $(INSTALLER) -L "$(URL)"; \
		)	#@rm -f "tmp/$(INSTALLER)"
	@make next

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

next: check-version check-exe $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "UUID: $(UUID)"

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
		find ./ -name '*.msi' -a -not -name "$(INSTALLER)" -a -not -name "$(EXE)" -delete ; \
		cmp $(INSTALLER) $(EXE) > /dev/null 2>&1 || cp -f $(INSTALLER) $(EXE) ; \
		# file $(EXE) | grep -q "MSI Installer.*Comments: $(VERSION)" || echo "Error: bad format or version for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)
	@grep -q "^$(UUID): $(VERSION)$$" version.txt 2> /dev/null  || echo "Error: bad UUID for version $(VERSION) in version.txt"

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "MSI Installer.*Comments: $(VERSION)" || { echo "Error: bad format or version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
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
