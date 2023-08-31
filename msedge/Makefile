
#
# MSEdge
#

SOFT:=MSEdge
INSTALLER:=MicrosoftEdgeEnterpriseX64.msi
PATCH:=2
URL:=$(shell curl --silent -L https://www.microsoft.com/en-us/edge/business/download | sed -e 's/[[:space:],]/\n/g;' | grep '^downloadUrl.*MicrosoftEdgeEnterpriseX64.msi' | head -1 | sed -e 's#\\u002F#/#g;' | cut -f 2 -d '"')
UUID:=$(shell dirname "$(URL)" | xargs -r basename)
VERSION:=$(shell (grep "^$(UUID):" version.txt 2> /dev/null || file tmp/MicrosoftEdgeEnterpriseX64.msi 2> /dev/null | sed -s 's/, /\n/g;' |grep '^Comments:') | awk '{print $$2}')
EXE:=MicrosoftEdgeEnterpriseX64-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all:
	@mkdir -p tmp
	@(cd tmp; \
		echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$'                        || curl -# -o $(INSTALLER) -L "$(URL)"; \
		file "$(INSTALLER)" 2> /dev/null | grep -q "MSI Installer.*Comments: $(VERSION)" || curl -# -o $(INSTALLER) -L "$(URL)"; \
		grep -q "^$(UUID):" ../version.txt 2> /dev/null                                  || curl -# -o $(INSTALLER) -L "$(URL)"; \
		)	#@rm -f "tmp/$(INSTALLER)"
	@make next

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

next: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

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
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)
	@grep "^$(UUID):" version.txt 2> /dev/null || echo "$(UUID): $(VERSION)" >> ./version.txt
	@tail -1 ./version.txt

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		find ./ -name '*.msi' -a -not -name "$(INSTALLER)" -a -not -name "$(EXE)" -delete ; \
		cmp $(INSTALLER) $(EXE) > /dev/null 2>&1 || cp -f $(INSTALLER) $(EXE) ; \
		file $(EXE) | grep -q "MSI Installer.*Comments: $(VERSION)" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)
	@grep -q "^$(UUID): $(VERSION)$$" version.txt 2> /dev/null  || echo "Error: bad UUID for version $(VERSION) in version.txt"

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

tmp/post-install.ps1: post-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' post-install.ps1 > $@

%.zip: Makefile tmp/install.bat tmp/post-install.ps1 tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 $(EXE))
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
