
#
# ImageJ
#

SOFT:=ImageJ
URL:=$(shell curl -s -L 'https://imagej.net/ij/download.html' | sed -e 's/"/\n/g;' | grep 'https:.*/distros/win/ij')
VERSION:=$(shell basename $(URL) | sed -e 's/^ij//; s/-.*//;')
ZIP:=$(shell basename $(URL))
EXE:=$(shell basename $(URL) | sed -e 's/zip$$/ok/;')
PATCH:=2

IT_TEAM:=IT Support


.PHONY: all check-version clean version ocs
.SECONDARY:

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	@rm -rf tmp
	@rm -f $(SOFT)-$(VERSION)-$(PATCH).zip
	@rm -f SWMB-Setup-*.exe
	@find . -name '*.bak' -delete

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "ZIP: $(ZIP)"

tmp/%.ok:
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf ImageJ "$(ZIP)" "$(EXE)" 2>/dev/null ; \
		curl -s -o "$(ZIP)" -L "$(URL)" ; \
		unzip -q "$(ZIP)" ; \
		rm -f "$(ZIP)" ; \
		touch "$(EXE)" \
		)

%.zip: Makefile tmp/$(EXE) install.bat post-install.ps1
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > tmp/ImageJ/install.bat
	@perl -p -e ' \
		s/^(\$$ImageJVersion = )"\d[\.\d]+"/$${1}"$(VERSION)"/; ' post-install.ps1 > tmp/ImageJ/post-install.ps1
	@rm -f $@
	@(cd tmp/ImageJ; zip -r ../../$@ install.bat uninstall.bat post-install.ps1 ij.jar ImageJ.exe)
	(cd tmp/ImageJ; zip --quiet -r ../../$@ jre luts macros plugins)
	@chmod ugo+rw $@


ocs: $(SOFT)-$(VERSION)-$(PATCH).zip
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
	@echo "Install and update: $(SOFT)"
	@echo ""
