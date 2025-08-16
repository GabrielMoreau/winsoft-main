
#
# Microsoft Teams
#

SOFT:=MSTeams
VERSION:=$(shell curl -s -L 'https://learn.microsoft.com/en-us/officeupdates/teams-app-versioning' | grep -A 30 '"windows-gcc-version-history"' | paste -sd '' | sed -e s'#<tr>#\n#g;' | grep -Ev '(windows-gcc-version-history|Slimcore version)' | sed -e 's/[<>]/\n/g;' | grep -E '^[[:digit:]][[:digit:]]*\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$$' | head -1)
REVISION:=1

EXE:=teams-$(VERSION)-x64.msix
XML:=AppxManifest.xml

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "EXE: $(EXE)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || { shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -3 checksum.txt; fi

tmp/$(EXE): tmp/$(XML)
	@mkdir -p tmp
	@(cd tmp ; \
		file $(EXE) | grep -q "Zip archive data" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/$(XML):
	@mkdir -p tmp
	@./get-msi "$(VERSION)"
	@(cd tmp ; \
		file $(XML) | grep -q "XML 1.0 document" || echo "Error: bad format for document $(XML)" ; \
		)

check-exe: tmp/$(EXE)
	@cd tmp; \
		file $(EXE) | grep -q "Zip archive data" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(XML) | grep -q "XML 1.0 document" || { echo "Error: bad format for document $(XML)" 1>&2 ; exit 1; } ; \
		grep -q "[[:space:]]Version=\"$(VERSION)\"[[:space:]]" $(XML) || { echo "Error: bad version for document $(XML)" 1>&2 ; exit 1; }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/pre-install.ps1: pre-install.ps1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/%ProgramData%/$${Env:ProgramData}/;' $< > $@

%.zip: Makefile post-install.ps1 tmp/install.bat tmp/pre-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r $@ post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat pre-install.ps1 $(EXE))
	@chmod ugo+rw $@
