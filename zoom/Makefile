
#
# Zoom
#

SOFT:=Zoom
INSTALLER:=ZoomInstallerFull.msi
VERSION:=$(shell file tmp/$(INSTALLER) 2> /dev/null | sed -e 's/,[[:space:]]/\n/g;' | grep '^Comments:' | cut -f 2 -d ' ')
PATCH:=1
URL:=https://zoom.us/client/latest/$(INSTALLER)

ZSSOHOST:=$(shell grep -h '^ZSSOHOST' conf.yml ../../winsoft-conf/zoom/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)

EXE:=ZoomInstallerFull-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all:
	@mkdir -p tmp
	@rm -f "tmp/$(INSTALLER)"
	@(cd tmp; curl -s -o $(INSTALLER) -L "$(URL)")
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

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		find ./ -name '*.msi' -a -not -name "$(INSTALLER)" -a -not -name "$(EXE)" -delete ; \
		cmp $(INSTALLER) $(EXE) > /dev/null 2>&1 || cp -f $(INSTALLER) $(EXE) ; \
		file $(EXE) | grep -q "Subject: Zoom Meetings.*Comments: $(VERSION)" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/; s/__ZSSOHOST__/$(ZSSOHOST)/g;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
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
