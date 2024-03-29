
#
# Chrome
#

SOFT:=Chrome
$(shell mkdir -p tmp; cd tmp; curl -# --time-cond 'googlechromestandaloneenterprise64.msi' -o 'googlechromestandaloneenterprise64.msi' -L 'https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi')
VERSION:=$(shell file tmp/googlechromestandaloneenterprise64.msi | sed -e 's/.*Comments:\s\([[:digit:]][[:digit:]\.]*\).*/\1/;')
# curl -s -L 'https://versionhistory.googleapis.com/v1/chrome/platforms/win64/channels/extended/versions/all/releases?filter=endtime=none'
# curl -s -L 'https://versionhistory.googleapis.com/v1/chrome/platforms/win64/channels/stable/versions/all/releases?filter=endtime=none'
# VERSION:=$(shell curl -s -L 'https://versionhistory.googleapis.com/v1/chrome/platforms/win64/channels/extended/versions/all/releases?filter=endtime=none' | grep '"version":' | cut -f 4 -d '"' | sort -V | tail -1)
# VERSION:=$(shell curl -s -L 'https://versionhistory.googleapis.com/v1/chrome/platforms/win64/channels/stable/versions/all/releases?filter=endtime=none' | grep '"version":' | cut -f 4 -d '"' | sort -V | tail -1)
# Many times, version is increment by one in the MSI...
# VERSION_NEXT:=$(shell echo $(VERSION) | cut -f 1-3 -d '.').$(shell echo $$(( $$(echo $(VERSION) | cut -f 4 -d '.') + 1 )) )
REVISION:=1
URL:=https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi
EXE:=googlechromestandaloneenterprise64-$(VERSION).msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
#	@echo "VERSION_NEXT: $(VERSION_NEXT)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "ZIP: $(SOFT)_$(VERSION)-$(REVISION)_x64.zip"

checksum:
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
		rm -f googlechromestandaloneenterprise64-*.msi 2>/dev/null ; \
		ln -f googlechromestandaloneenterprise64.msi "$(EXE)" ; \
		#curl -# -o "$(EXE)" -L "$(URL)" ; \
		#file $(EXE) | grep -q "Subject: Google Chrome Installer.*Comments: $(VERSION) Copyright" || echo "Error: bad format or version for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Google Chrome Installer" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		file $(EXE) | grep -q "Comments: $(VERSION) Copyright" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		#file $(EXE) | grep -Eq "Comments: ($(VERSION)|$(VERSION_NEXT)) Copyright" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) chrome-parameters.reg master_preferences.json
	@rm -f $@
	@zip -r $@ chrome-parameters.reg master_preferences.json
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
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
