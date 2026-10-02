
#
# Action-Windows11Force26H2
#

SOFT:=Action-Windows11Force26H2
URL:=https://catalog.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/94520a88-858f-4832-a57d-7211f6d84a4e/public/Windows11.0-KB5121794-x64_5e20a3cce48d6611b16bdec42b07167f5456586a.msu
EXE:=KB5121794.msu
VERSION:=0.7
REVISION:=1

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized checksum clean control next version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_PRIORITY:=$(shell expr $(OCS_PRIORITY) + 1)
OCS_DURATION:=$(OCS_DURATION_LONG)

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized:
	@echo 'Ok'

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"

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
		rm -f *.msu 2>/dev/null ; \
		curl -# -L --connect-timeout 10 -o "$(EXE)" "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file "$(EXE)" | grep -q "Microsoft Cabinet archive data" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		file "$(EXE)" | grep -q "Windows11.0-KB5121794-x64_PSFX" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; \
		)

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s#__IT_TEAM__#$(IT_TEAM)#;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/$(EXE)
	@rm -f $@@
	zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
