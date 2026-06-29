
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
REG_SEARCH:=$(SOFT)

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
		CHECKLINE=$$(tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner --exclude='*ANKAphase*' -cf - 'Fiji.app-$(VERSION)/' | sha256sum | sed 's/  -$$/  Fiji.app-$(VERSION).tarball/') ; \
		grep -q "^$${CHECKLINE}$$" ../checksum.txt && exit ; \
		echo "$${CHECKLINE}" >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf Fiji Fiji.app-* "$(ZIP)" "$(EXE)" 2>/dev/null ; \
		curl -# -L --connect-timeout 10 -o "$(ZIP)" "$(URL)" ; \
		unzip -q "$(ZIP)" ; \
		[ ! -e Fiji/fiji-windows-x64.exe ] || mv Fiji/fiji-windows-x64.exe Fiji/ImageJ-win64.exe ; \
		mv Fiji "Fiji.app-$(VERSION)" ; \
		CHECKLINE=$$(tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner --exclude='*ANKAphase*' -cf - 'Fiji.app-$(VERSION)/' | sha256sum | sed 's/  -$$/  Fiji.app-$(VERSION).tarball/') ; \
		grep -q "^$${CHECKLINE}$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		rm -f "$(ZIP)" ; \
		touch "$(EXE)" \
		)

tmp/$(ZIP2): tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf ANKAphase.zip  2>/dev/null ; \
		curl -# -L --connect-timeout 10 -o "$(ZIP2)" "$(URL2)" ; \
		unzip -q "$(ZIP2)" 'ANKAphase*/ANKAphase_*.jar' || rm -f "$(ZIP2)"; \
		mv ANKAphase*/ANKAphase_*.jar "Fiji.app-$(VERSION)/plugins/" ; \
		)

check-exe: tmp/$(EXE) tmp/$(ZIP2)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32. executable for MS Windows" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		find "Fiji.app-$(VERSION)/" -name '*-$(VERSION).*' | grep -q . || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file $(ZIP2) | grep -q "Zip archive data" || { echo "Error: bad format for archive $(ZIP2)" 1>&2 ; exit 12; } ; \
		# which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		)

#tmp/winsoft-config.ini: winsoft-config.ini Makefile tmp/$(EXE)
#	@mkdir -p tmp
#	@sed -e 's/__VERSION__/$(VERSION)/; s/__REG_SEARCH__/$(REG_SEARCH)/;' $< > $@

%.zip: Makefile tmp/$(EXE) tmp/$(ZIP2) install.bat pre-install.ps1 post-install.ps1 installer.ps1 winsoft-config.ini
	@mkdir -p tmp
	IVERSION=$$(zgrep 'plugin update-site.*filename="jars/ij-[[:digit:]]' tmp/$(SUBFOLDER)/db.xml.gz  | cut -f 4 -d '"' | cut -f 2 -d '-' | sed -e 's/.jar$$//;') ; \
	NVERSION=$$(echo $${IVERSION} | sed -e 's/\w$$//;') ; \
	sed -e "s/__VERSION__/$(VERSION)/; s/__REVISION__/$(REVISION)/; s/__IVERSION__/$${IVERSION}/; s/__NVERSION__/$${NVERSION}/;" install.bat | sed -e 's#__LOGDIR__#$(LOGDIR)#; s/__QEXEADMIN__/$(QEXEADMIN)/;' > tmp/install.bat ; \
	sed -e "s/__VERSION__/$${NVERSION}.$(VERSION)/;" winsoft-config.ini | sed -e 's/__REG_SEARCH__/$(REG_SEARCH)/;' > tmp/winsoft-config.ini
	@rm -f $@
	@zip -Xr ./$@ uninstall.bat pre-install.ps1 post-install.ps1 installer.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.ini)
	@(cd tmp/$(SUBFOLDER); zip -Xr ../../$@ db.xml.gz ImageJ-win64.exe README.md WELCOME.md)
	(cd tmp/$(SUBFOLDER); zip --quiet -r ../../$@ Contents images jars java lib licenses luts macros plugins retro scripts)
	@chmod ugo+rw $@
