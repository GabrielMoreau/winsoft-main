
#
# CCleaner
#

SOFT:=CCleaner
URL:=https://bits.avcdn.net/productfamily_CCLEANER/insttype_SLIM/platform_WIN_PIR/installertype_ONLINE/build_RELEASE
PVERSION:=$(shell ./get-version "$(URL)")
VERSION:=$(shell echo "$(PVERSION)" | sed 's/\.0\././;')
REVISION:=1

EXE:=ccsetup-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum
.ONESHELL:

all: check-version check-exe Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "PVERSION: $(PVERSION)"

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
		#rm -f *.exe *.msi 2>/dev/null ; \
		#curl -# -o "$(EXE)"  -L "$(URL)" ; \
		rm -f ccsetup-*.exe 2>/dev/null ; \
		ln -f ccleaner.exe "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		#file $(EXE) | grep -q 'PE32 executable' || echo "Error: bad format for binary $(EXE)" ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q 'PE32 executable' || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(PVERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/post-install.ps1: post-install.ps1 Makefile tmp/$(EXE)
	@sed -e 's/__VERSION__/$(VERSION)/;'  post-install.ps1 > $@

tmp/uninstall.bat: uninstall.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat ccleaner.ini tmp/post-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ ccleaner.ini post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 $(EXE))
	@chmod ugo+rw $@

Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64.zip: Makefile tmp/uninstall.bat
	@rm -f $@
	@(cd tmp; zip -r ../$@ uninstall.bat)
	@printf "@ uninstall.bat\n@=install.bat\n" | zipnote -w ./$@
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
	@echo "Name:    Uninstall-$(SOFT)_$(VERSION)-$(REVISION)_x64"
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
