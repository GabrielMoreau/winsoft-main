
#
# XournalPP
#

SOFT:=XournalPP
VERSION:=$(shell curl -s -L --connect-timeout 10 'https://github.com/xournalpp/xournalpp/releases/latest' | sed 's/</\n/g;' | grep '^meta property.*og:title' | cut -f 5 -d ' ')
REVISION:=1
# https://github.com/xournalpp/xournalpp/releases/download/v1.2.5/xournalpp-1.2.5-windows-setup-x86_64.exe
# https://github.com/xournalpp/xournalpp/releases/download/v1.2.8/xournalpp-1.2.8-windows-setup-AMD64.exe
URL:=https://github.com/xournalpp/xournalpp/releases/download/v$(VERSION)/xournalpp-$(VERSION)-windows-setup-AMD64.exe

#ZIP:=xournalpp-$(VERSION)-windows.zip
EXE:=xournalpp-$(VERSION)-windows-setup-amd64.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum: check-version
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt && exit ; \
		shasum -a 256 "$(EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; \
		tail -3 ../checksum.txt ; \
		)

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f *.exe *.msi "$(ZIP)" 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		#unzip -q "$(ZIP)" ; \
		#rm -f "$(ZIP)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile uninstall.bat tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@zip -r $@ uninstall.bat
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
