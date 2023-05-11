
#
# DellCmdUpdate
#

SOFT:=DellCmdUpdate
VERSION:=$(shell grep '^[[:digit:]]' url.txt | sort --version-sort -k 1 | tail -1 | awk '{print $$1}')
PATCH:=1
URL:=$(shell grep '^$(VERSION)[[:space:]]' url.txt | awk '{print $$2}')
VERSION_LOW:=$(shell echo "$(VERSION)" | sed -e 's/\./_/g;')

EXE:=$(shell basename "$(URL)")

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "VERSION_LOW: $(VERSION_LOW)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		#curl -# -o "$(EXE)" -L "$(URL)" ; \
		wget -q --show-progress -O "$(EXE)" "$(URL)" ; \
		file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/; \
		s/^(SET\ssoftexe=)\w.+/$${1}$(EXE)/; \
		s/^(SET\ssoftversionlow=)\d[_\d]+/$${1}$(VERSION_LOW)/;' install.bat > $@

tmp/pre-install.ps1: pre-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/__VERSION__/$(VERSION)/;' pre-install.ps1 > $@

%.zip: Makefile tmp/install.bat tmp/pre-install.ps1 tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat pre-install.ps1 $(EXE))
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