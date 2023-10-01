
#
# Blender
#

SOFT:=Blender
URL:=$(shell curl -s -L 'https://www.blender.org/download/' | sed -e 's/"/\n/g;' | egrep '^https://www.blender.org/.*/.*windows-x64.msi' | head -1 | xargs -r curl -s -L | sed -e 's/"/\n/g;' | egrep '^https://.*/blender-.*windows-x64.msi' | sort -r | head -1 | sed -e 's#/$$##;')
VERSION:=$(shell basename $(URL) | cut -f 2 -d '-')
PATCH:=1

EXE:=blender-$(VERSION)-windows-x64.msi

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum check-exe

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

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
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Subject: blender, Author: Blender Foundation" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@cd tmp; file $(EXE) | grep -q "Subject: blender, Author: Blender Foundation" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/__VERSION__/$(VERSION)/; \
		s/__PATCH__/$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) check-exe
	@rm -f $@
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
