
#
# Update-WindowsDekstopRuntime
#

SOFT:=Update-WindowsDekstopRuntime
REVISION:=1

URL5:=$(shell curl -s -L https://dotnet.microsoft.com/$(shell curl -s -L 'https://dotnet.microsoft.com/en-us/download/dotnet/5.0' | sed -e 's/"/\n/g;' | grep 'thank-you/runtime-desktop.*windows-x64-installer'  | head -1) | sed -e 's/"/\n/g;' | grep '^https.*windowsdesktop-runtime-.*-win-x64.exe' | head -1)
VERSION5:=$(shell basename $(URL5) | cut -f 3 -d '-')
EXE5:=windowsdesktop-runtime-$(VERSION5)-win-x64.exe

URL6:=$(shell curl -s -L https://dotnet.microsoft.com/$(shell curl -s -L 'https://dotnet.microsoft.com/en-us/download/dotnet/6.0' | sed -e 's/"/\n/g;' | grep 'thank-you/runtime-desktop.*windows-x64-installer'  | head -1) | sed -e 's/"/\n/g;' | grep '^https.*windowsdesktop-runtime-.*-win-x64.exe' | head -1)
VERSION6:=$(shell basename $(URL6) | cut -f 3 -d '-')
EXE6:=windowsdesktop-runtime-$(VERSION6)-win-x64.exe

URL7:=$(shell curl -s -L https://dotnet.microsoft.com/$(shell curl -s -L 'https://dotnet.microsoft.com/en-us/download/dotnet/7.0' | sed -e 's/"/\n/g;' | grep 'thank-you/runtime-desktop.*windows-x64-installer'  | head -1) | sed -e 's/"/\n/g;' | grep '^https.*windowsdesktop-runtime-.*-win-x64.exe' | head -1)
VERSION7:=$(shell basename $(URL7) | cut -f 3 -d '-')
EXE7:=windowsdesktop-runtime-$(VERSION7)-win-x64.exe

URL8:=$(shell curl -s -L https://dotnet.microsoft.com/$(shell curl -s -L 'https://dotnet.microsoft.com/en-us/download/dotnet/8.0' | sed -e 's/"/\n/g;' | grep 'thank-you/runtime-desktop.*windows-x64-installer'  | head -1) | sed -e 's/"/\n/g;' | grep '^https.*windowsdesktop-runtime-.*-win-x64.exe' | head -1)
VERSION8:=$(shell basename $(URL8) | cut -f 3 -d '-')
EXE8:=windowsdesktop-runtime-$(VERSION8)-win-x64.exe

VERSION:=$(shell ./sum-versions $(VERSION5) $(VERSION6) $(VERSION7) $(VERSION8))

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "VERSION5: $(VERSION5)"
	@echo "URL5: $(URL5)"
	@echo "EXE5: $(EXE5)"
	@echo "VERSION6: $(VERSION6)"
	@echo "URL6: $(URL6)"
	@echo "EXE6: $(EXE6)"
	@echo "VERSION7: $(VERSION7)"
	@echo "URL7: $(URL7)"
	@echo "EXE7: $(EXE7)"
	@echo "VERSION8: $(VERSION8)"
	@echo "URL8: $(URL8)"
	@echo "EXE8: $(EXE8)"

checksum: tmp/$(EXE5) tmp/$(EXE6) tmp/$(EXE7) tmp/$(EXE8)
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(EXE5))$$" ../checksum.txt || { shasum -a 256 "$(EXE5)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE6))$$" ../checksum.txt || { shasum -a 256 "$(EXE6)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE7))$$" ../checksum.txt || { shasum -a 256 "$(EXE7)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE8))$$" ../checksum.txt || { shasum -a 256 "$(EXE8)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi
	@(cd tmp ; \
		grep -q "^$(VERSION5)[[:space:]]" ../version.txt || { (echo -n '$(VERSION5) ' ; peres -v $(EXE5) | grep '^Product Version' | awk '{print $$3}') >> ../version.txt ; } ; \
		grep -q "^$(VERSION6)[[:space:]]" ../version.txt || { (echo -n '$(VERSION6) ' ; peres -v $(EXE6) | grep '^Product Version' | awk '{print $$3}') >> ../version.txt ; } ; \
		grep -q "^$(VERSION7)[[:space:]]" ../version.txt || { (echo -n '$(VERSION7) ' ; peres -v $(EXE7) | grep '^Product Version' | awk '{print $$3}') >> ../version.txt ; } ; \
		grep -q "^$(VERSION8)[[:space:]]" ../version.txt || { (echo -n '$(VERSION8) ' ; peres -v $(EXE8) | grep '^Product Version' | awk '{print $$3}') >> ../version.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' version.txt) )) -lt 60 ]; then tail -6 version.txt; fi

wget: tmp/$(EXE5)

tmp/$(EXE5):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f windowsdesktop-runtime-5.*.exe 2>/dev/null ; \
		curl -# -o "$(EXE5)" -L "$(URL5)" ; \
		grep -q "^$$(shasum -a 256 $(EXE5))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE5)" ; \
		)

tmp/$(EXE6):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f windowsdesktop-runtime-6.*.exe 2>/dev/null ; \
		curl -# -o "$(EXE6)" -L "$(URL6)" ; \
		grep -q "^$$(shasum -a 256 $(EXE6))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE6)" ; \
		)

tmp/$(EXE7):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f windowsdesktop-runtime-7.*.exe 2>/dev/null ; \
		curl -# -o "$(EXE7)" -L "$(URL7)" ; \
		grep -q "^$$(shasum -a 256 $(EXE7))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE7)" ; \
		)

tmp/$(EXE8):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f windowsdesktop-runtime-8.*.exe 2>/dev/null ; \
		curl -# -o "$(EXE8)" -L "$(URL8)" ; \
		grep -q "^$$(shasum -a 256 $(EXE8))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE8)" ; \
		)

check-exe: tmp/$(EXE5) tmp/$(EXE6) tmp/$(EXE7) tmp/$(EXE8)
	@(cd tmp ; \
		file $(EXE5) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE5)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE5) | grep -q "^Product Version:[[:space:]]*$(VERSION5)" || { echo "Error: bad version for binary $(EXE6)" 1>&2 ; exit 1; } ; } ;\
		)
	@(cd tmp ; \
		file $(EXE6) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE6)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE6) | grep -q "^Product Version:[[:space:]]*$(VERSION6)" || { echo "Error: bad version for binary $(EXE6)" 1>&2 ; exit 1; } ; } ;\
		)
	@(cd tmp ; \
		file $(EXE7) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE7)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE7) | grep -q "^Product Version:[[:space:]]*$(VERSION7)" || { echo "Error: bad version for binary $(EXE7)" 1>&2 ; exit 1; } ; } ;\
		)
	@(cd tmp ; \
		file $(EXE8) | grep -q "PE32 executable" || { echo "Error: bad format for binary $(EXE8)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v $(EXE8) | grep -q "^Product Version:[[:space:]]*$(VERSION8)" || { echo "Error: bad version for binary $(EXE8)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE5) tmp/$(EXE6) tmp/$(EXE7) tmp/$(EXE8)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__VERSION5__/$(VERSION5)/; s/__VERSION6__/$(VERSION6)/; s/__VERSION7__/$(VERSION7)/; s/__VERSION8__/$(VERSION8)/;' $< > $@

tmp/post-install.ps1: post-install.ps1 Makefile tmp/$(EXE5) tmp/$(EXE6) tmp/$(EXE7) tmp/$(EXE8)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__VERSION5__/$(VERSION5)/; s/__VERSION6__/$(VERSION6)/; s/__VERSION7__/$(VERSION7)/; s/__VERSION8__/$(VERSION8)/;' $< > $@

%.zip: Makefile tmp/install.bat tmp/post-install.ps1 tmp/$(EXE5) tmp/$(EXE6) tmp/$(EXE7) tmp/$(EXE8)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 $(EXE5) $(EXE6) $(EXE7) $(EXE8))
	@chmod ugo+rw $@

ocs:
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
