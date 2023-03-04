
#
# ImageJ
#

SOFT:=ImageJ

# ImageJ1
#URL:=$(shell curl -s -L 'https://imagej.net/ij/download.html' | sed -e 's/"/\n/g;' | grep 'https:.*/distros/win/ij')
#VERSION:=$(shell basename $(URL) | sed -e 's/^ij//; s/-.*//;')
VERSION:=$(shell curl -s -L 'https://maven.scijava.org/content/groups/public/sc/fiji/fiji/maven-metadata.xml' | grep '<release>' | cut -f 2 -d '>' | cut -f 1 -d '<')
URL:=https://downloads.micron.ox.ac.uk/fiji_update/mirrors/fiji-latest/fiji-win64.zip
ZIP:=fiji-win64.zip
SUBFOLDER:=Fiji.app-$(VERSION)
EXE:=$(SUBFOLDER)/ImageJ-win64.exe
PATCH:=2

IT_TEAM:=IT Support


.PHONY: all check-version clean version ocs
.SECONDARY:

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	@rm -rf tmp resources $(SOFT)-$(VERSION)-$(PATCH).zip

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "ZIP: $(ZIP)"

tmp/%.exe:
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf "Fiji.app" "Fiji.app-$(VERSION)" "$(ZIP)" "$(EXE)" 2>/dev/null ; \
		curl -o "$(ZIP)" -L "$(URL)" ; \
		unzip -q "$(ZIP)" ; \
		mv Fiji.app "Fiji.app-$(VERSION)" ; \
		curl -s -L 'http://rsbweb.nih.gov/ij/plugins/ankaphase/ANKAphase.zip' -o ANKAphase.zip ; \
		unzip -q ANKAphase.zip 'ANKAphase_*.jar' ; \
		mv ANKAphase_*.jar "Fiji.app-$(VERSION)/plugins/" ; \
		file "$(EXE)" | grep -q "x86-64, for MS Windows" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		rm -f "$(ZIP)" ; \
		touch "$(EXE)" \
		)

%.zip: Makefile tmp/$(EXE) install.bat post-install.ps1
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > tmp/$(SUBFOLDER)/install.bat
	@perl -p -e ' \
		s/^(\$$ImageJVersion = )"\d[\.\d]+"/$${1}"$(VERSION)"/; ' post-install.ps1 > tmp/$(SUBFOLDER)/post-install.ps1
	@rm -f $@
	@zip -r $@  uninstall.bat
	@(cd tmp/$(SUBFOLDER); zip -r ../../$@ install.bat post-install.ps1 db.xml.gz ImageJ-win64.exe README.md WELCOME.md)
	(cd tmp/$(SUBFOLDER); zip --quiet -r ../../$@ Contents images jars java lib licenses luts macros plugins retro scripts)
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
