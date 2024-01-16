
#
# Zoom
#

SOFT:=Zoom
#INSTALLER:=ZoomInstallerFull.msi
#VERSION:=$(shell file tmp/$(INSTALLER) 2> /dev/null | sed -e 's/,[[:space:]]/\n/g;' | grep '^Comments:' | cut -f 2 -d ' ')
VERSIONLONG:=$(shell curl -s -L 'https://www.zoom.us/rest/download?os=win' | sed -e 's/[,{}]/\n/g;' | grep -A 5 '^"zoomX64"' | grep '^"version"' | cut -f 4 -d '"' | cut -f 1 -d ' ' | head -1)
VERSION:=$(shell echo $(VERSIONLONG) | cut -f 1-3 -d '.')
REVISION:=1
#URL:=https://zoom.us/client/latest/$(INSTALLER)
URL:=https://cdn.zoom.us/prod/$(VERSIONLONG)/x64/ZoomInstallerFull.msi

ZSSOHOST:=$(shell grep -h '^ZSSOHOST' conf.yml ../../winsoft-conf/zoom/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)

EXE:=ZoomInstallerFull-$(VERSION).msi

IT_TEAM:=IT Support


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs
#	@mkdir -p tmp
#	@rm -f "tmp/$(INSTALLER)"
#	@(cd tmp; curl -s -o $(INSTALLER) -L "$(URL)")
#	@make next

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

next: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

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
		#find ./ -name '*.msi' -a -not -name "$(INSTALLER)" -a -not -name "$(EXE)" -delete ; \
		#cmp $(INSTALLER) $(EXE) > /dev/null 2>&1 || cp -f $(INSTALLER) $(EXE) ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		#file $(EXE) | grep -q "Subject: Zoom Meetings.*Comments: $(VERSION)" || echo "Error: bad format or version for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'Little Endian, Os: Windows, Version 10.0, MSI Installer' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q 'Subject: Zoom Meetings.*Comments: $(VERSION)' || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		#which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__ZSSOHOST__/$(ZSSOHOST)/g;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
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
