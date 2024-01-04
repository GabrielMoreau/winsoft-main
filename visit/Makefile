
#
# VisIt
#

SOFT:=VisIt
URL:=$(shell curl -sL 'https://api.github.com/repos/visit-dav/visit/releases/latest' | grep 'browser_download_url.*_x64.exe' | cut -f 4 -d '"' | head -1)
VERSION:=$(shell basename $(URL) | cut -f 1 -d '_' | sed -e 's/^visit//;')
PATCH:=1

# https://github.com/visit-dav/visit/releases/download/v3.3.3/visit3.3.3_x64.exe
EXE:=visit$(VERSION)_x64.exe

IT_TEAM:=IT Support


.PHONY: all check-version check-exe clean control next ocs version wget checksum

all: check-version check-exe $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32 executable.*Nullsoft Installer self-extracting archive" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s/__PATCH__/$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE)
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
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
