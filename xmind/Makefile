
#
# XMind
#

SOFT:=XMind
INSTALLER:=Xmind4WindowsX64bit.exe
URL:=https://xmind.app/zen/download/win64/
# https://dl3.xmind.app/Xmind-for-Windows-x64bit-26.01.03145-202510162012.exe
$(shell mkdir -p tmp; cd tmp; curl -s --time-cond "$(INSTALLER)" -o "$(INSTALLER)" -L "$(URL)")
VERSION:=$(shell peres -v tmp/$(INSTALLER) 2> /dev/null | grep '^Product Version' | awk '{print $$3}')
REVISION:=1

EXE:=Xmind-for-Windows-x64bit-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=$(SOFT)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(EXE) tmp resources

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
		rm -f *-*.exe *-*.msi 2>/dev/null ; \
		cp "$(INSTALLER)" "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		if grep $$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ') ../checksum.txt | grep -qv "$(EXE)"; then echo "Error: another version of $(EXE) exists with the same checksum" 1>&2 ; rm -f "$(EXE)" ; exit 14; fi; \
		)

tmp/pkg/Xmind.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		../extract4exe --setup "$(EXE)" ; \
		)

check-exe: tmp/$(EXE) tmp/pkg/Xmind.exe
	@(cd tmp ; \
		file $(EXE) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/uninstall.bat: uninstall.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile pre-install.bat tmp/install.bat tmp/uninstall.bat tmp/$(EXE) tmp/pkg/Xmind.exe
	@rm -f $@
	@zip -r $@ pre-install.bat
	@(cd tmp; zip --quiet -r ../$@ install.bat uninstall.bat pkg)
	@chmod ugo+rw $@
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile pre-install.bat tmp/uninstall.bat
	@rm -f $@
	@zip -r $@ pre-install.bat
	@(cd tmp; zip -r ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@
