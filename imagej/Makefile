
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
REVISION:=1

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next ocs version wget checksum
.SECONDARY:

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	@rm -rf tmp resources $(SOFT)_$(VERSION)-$(REVISION)_x64.zip

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "ZIP: $(ZIP)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

tmp/%.exe:
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf Fiji.app Fiji.app-* ANKAphase.zip "$(ZIP)" "$(EXE)" 2>/dev/null ; \
		curl -# -o "$(ZIP)" -L "$(URL)" ; \
		unzip -q "$(ZIP)" ; \
		mv Fiji.app "Fiji.app-$(VERSION)" ; \
		curl -# -o ANKAphase.zip -L 'http://rsbweb.nih.gov/ij/plugins/ankaphase/ANKAphase.zip' ; \
		unzip -q ANKAphase.zip 'ANKAphase_*.jar' ; \
		mv ANKAphase_*.jar "Fiji.app-$(VERSION)/plugins/" ; \
		file "$(EXE)" | grep -q "x86-64, for MS Windows" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		rm -f "$(ZIP)" ; \
		touch "$(EXE)" \
		)

%.zip: Makefile tmp/$(EXE) install.bat post-install.ps1
	@mkdir -p tmp
	@IVERSION=$$(zgrep 'plugin update-site.*filename="jars/ij-[[:digit:]]' tmp/$(SUBFOLDER)/db.xml.gz  | cut -f 4 -d '"' | cut -f 2 -d '-' | sed -e 's/.jar$$//;') ; \
	NVERSION=$$(echo $${IVERSION} | sed -e 's/\w$$//;') ; \
	sed -e "s/__VERSION__/$(VERSION)/; s/__REVISION__/$(REVISION)/; s/__IVERSION__/$${IVERSION}/; s/__NVERSION__/$${NVERSION}/;" install.bat | sed -e 's#__LOGDIR__#$(LOGDIR)#;' > tmp/$(SUBFOLDER)/install.bat ; \
	sed -e "s/__VERSION__/$(VERSION)/; s/__REVISION__/$(REVISION)/; s/__IVERSION__/$${IVERSION}/; s/__NVERSION__/$${NVERSION}/;" post-install.ps1 > tmp/$(SUBFOLDER)/post-install.ps1
	@rm -f $@
	@zip -r $@  uninstall.bat
	@(cd tmp/$(SUBFOLDER); zip -r ../../$@ install.bat post-install.ps1 db.xml.gz ImageJ-win64.exe README.md WELCOME.md)
	(cd tmp/$(SUBFOLDER); zip --quiet -r ../../$@ Contents images jars java lib licenses luts macros plugins retro scripts)
	@chmod ugo+rw $@


ocs: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip
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
