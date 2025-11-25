
#
# ImageJ
#

SOFT:=ImageJ

# ImageJ1
#URL:=$(shell curl -s -L --connect-timeout 10 'https://imagej.net/ij/download.html' | sed -e 's/"/\n/g;' | grep 'https:.*/distros/win/ij')
#VERSION:=$(shell basename '$(URL)' 2> /dev/null | sed -e 's/^ij//; s/-.*//;')
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://maven.scijava.org/content/groups/public/sc/fiji/fiji/maven-metadata.xml' | grep '<release>' | cut -f 2 -d '>' | cut -f 1 -d '<')
URL:=https://downloads.micron.ox.ac.uk/fiji_update/mirrors/fiji-latest/fiji-latest-win64-jdk.zip
ZIP:=fiji-win64.zip
SUBFOLDER:=Fiji.app-$(VERSION)
EXE:=$(SUBFOLDER)/ImageJ-win64.exe
REVISION:=1

#URL2:=http://rsbweb.nih.gov/ij/plugins/ankaphase/ANKAphase.zip
URL2:=https://imagej.net/ij/plugins/ankaphase/ANKAphase.zip
ZIP2:=ANKAphase.zip

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum
.SECONDARY:

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	@rm -rf tmp resources $(SOFT)_$(VERSION)-$(REVISION)_x64.zip

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "ZIP: $(ZIP)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf Fiji Fiji.app-* ANKAphase.zip "$(ZIP)" "$(EXE)" 2>/dev/null ; \
		curl -# -o "$(ZIP)" -L "$(URL)" ; \
		unzip -q "$(ZIP)" ; \
		[ ! -e Fiji/fiji-windows-x64.exe ] || mv Fiji/fiji-windows-x64.exe Fiji/ImageJ-win64.exe ; \
		mv Fiji "Fiji.app-$(VERSION)" ; \
		curl -# -o "$(ZIP2)" -L "$(URL2)" ; \
		unzip -q "$(ZIP2)" 'ANKAphase*/ANKAphase_*.jar' ; \
		mv ANKAphase*/ANKAphase_*.jar "Fiji.app-$(VERSION)/plugins/" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		rm -f "$(ZIP)" ; \
		touch "$(EXE)" \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "x86-64, for MS Windows" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file $(ZIP2) | grep -q "Zip archive data" || { echo "Error: bad format for binary $(ZIP2)" 1>&2 ; exit 12; } ; \
		# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/$(EXE) install.bat post-install.ps1 tmp/winsoft-config.ini
	@mkdir -p tmp
	@IVERSION=$$(zgrep 'plugin update-site.*filename="jars/ij-[[:digit:]]' tmp/$(SUBFOLDER)/db.xml.gz  | cut -f 4 -d '"' | cut -f 2 -d '-' | sed -e 's/.jar$$//;') ; \
	NVERSION=$$(echo $${IVERSION} | sed -e 's/\w$$//;') ; \
	sed -e "s/__VERSION__/$(VERSION)/; s/__REVISION__/$(REVISION)/; s/__IVERSION__/$${IVERSION}/; s/__NVERSION__/$${NVERSION}/;" install.bat | sed -e 's#__LOGDIR__#$(LOGDIR)#;' > tmp/install.bat
	@rm -f $@
	@zip -r ./$@ uninstall.bat post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat winsoft-config.ini)
	@(cd tmp/$(SUBFOLDER); zip -r ../../$@ db.xml.gz ImageJ-win64.exe README.md WELCOME.md)
	(cd tmp/$(SUBFOLDER); zip --quiet -r ../../$@ Contents images jars java lib licenses luts macros plugins retro scripts)
	@chmod ugo+rw $@
