
#
# X2GoClient
#

SOFT:=X2GoClient
VERSION:=$(shell (grep '^[[:digit:]]' url.txt | sort --version-sort -k 1 | tail -1 | awk '{print $$1}' ; curl -s -L --connect-timeout 10 'https://code.x2go.org/releases/binary-win32/x2goclient/releases/' | sed -e 's#[</>]#\n#g;' | grep 'a href="[[:digit:]]' | tail -1 | cut -f 2 -d '"') | tail -1)
VERSION_SHORT:=$(shell echo $(VERSION) | cut -f 1 -d '-')
REVISION:=1

EXE:=x2goclient-$(VERSION)-setup.exe
URL:=https://code.x2go.org/releases/binary-win32/x2goclient/releases/$(VERSION)/$(EXE)

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=X2Go Client

check-version:
	@echo $(VERSION) | grep -qE -- '^[[:digit:]][\.[:digit:]-]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION_SHORT: $(VERSION_SHORT)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		if ! grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		then \
			shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
			tail -3 ../checksum.txt ; \
		fi ; \
		if ! grep -q "^$(VERSION)[[:space:]]" ../url.txt && exit; \
		then \
			echo "$(VERSION) $(URL)" >> ../url.txt; \
			tail -3 ../url.txt ; \
		fi ; \
		)

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		#file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		#which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION_SHORT)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -Xr ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
