
#
# VOSviewer
#

SOFT:=VOSviewer
URL:=https://www.vosviewer.com/VOSviewer.jar
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://www.vosviewer.com/download' | sed -e 's/"/\n/g;' | grep -E '_exe.zip$$' | xargs -r basename | cut -f 2 -d '_' | head -1)
# https://download.java.net/java/GA/jdk25.0.1/2fbf10d8c78e40bd87641c434705079d/8/GPL/openjdk-25.0.1_windows-x64_bin.zip
URL2:=$(shell curl -s -L --connect-timeout 10 'https://jdk.java.net/25/' | sed -e 's/"/\n/g;' | grep -E '/openjdk-.*_windows-x64_bin.zip$$' | head -1)
VERSION2:=$(shell echo '$(URL2)' | cut -f 2 -d '-' | cut -f 1 -d '_')
REVISION:=1

EXE:=VOSviewer-$(VERSION).jar
EXE2:=openjdk-$(VERSION2)_windows-x64_bin.zip

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)
OCS_DURATION:=$(OCS_DURATION_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)
	@echo $(VERSION2) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION2 is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "VERSION2: $(VERSION2)"
	@echo "URL2: $(URL2)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || { shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || { shasum -a 256 "$(EXE2)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.jar 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/$(EXE2):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.zip 2>/dev/null ; \
		curl -# -o "$(EXE2)" -L "$(URL2)" ; \
		grep -q "^$$(shasum -a 256 $(EXE2))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE2)" ; \
		)

tmp/$(SOFT).ico: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf com VOSviewer.license *.ico ; \
		unzip -q $(EXE) com/vosviewer/icon_64x64x8.png ; \
		unzip -q $(EXE) VOSviewer.license ; \
		grep -q '[[:space:]]$(VERSION)[[:space:]]' 'VOSviewer.license' || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ;\
		convert com/vosviewer/icon_64x64x8.png '$(SOFT).ico' ;\
		)

tmp/jdk-$(VERSION2)/bin/javaw.exe: tmp/$(EXE2)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf jdk-* ; \
		unzip -q $(EXE2) ; \
		)

check-exe: tmp/$(SOFT).ico tmp/jdk-$(VERSION2)/bin/javaw.exe
	@(cd tmp ; \
		file '$(EXE)' | grep -q "Java archive data" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file '$(EXE2)' | grep -q "Zip archive data" || { echo "Error: bad format for binary $(EXE2)" 1>&2 ; exit 12; } ; \
		file '$(SOFT).ico' | grep -q "MS Windows icon resource" || { echo "Error: bad format for binary $(SOFT).ico" 1>&2 ; exit 12; } ; \
		file 'jdk-$(VERSION2)/bin/javaw.exe' | grep -q "PE32. executable" || { echo "Error: bad format for binary javaw.exe" 1>&2 ; exit 12; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__JDKVERSION__/$(VERSION2)/g;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile pre-install.bat tmp/install.bat tmp/uninstall.bat tmp/$(SOFT).ico tmp/VOSviewer.license tmp/jdk-$(VERSION2)/bin/javaw.exe tmp/$(EXE)
	@rm -f $@
	@zip -r $@ pre-install.bat
	@(cd tmp; zip --quiet -r ../$@ install.bat uninstall.bat $(SOFT).ico VOSviewer.license jdk-$(VERSION2) $(EXE))
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-install.bat tmp/uninstall.bat
	@rm -f $@
	@zip -r $@ pre-install.bat
	@(cd tmp; zip -r ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
