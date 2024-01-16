
#
# HPSupportAssist
#

SOFT:=HPSupportAssist
#VERSION:=$(shell curl -s -L 'https://www.filehorse.com/download-hp-support-assistant/download/' | sed -s 's/</\n/g;' | grep '^title' | awk '{print $$5}')
VERSION:=$(shell grep '^[[:digit:]]' url.txt | sort --version-sort -k 1 | tail -1 | awk '{print $$1}')
REVISION:=1
#URL:=$(shell curl -s -L 'https://www.filehorse.com/download-hp-support-assistant/download/' | sed -s 's/"/\n/g;'  | grep '^https://www.filehorse.com/download/file')
URL:=$(shell grep '^$(VERSION)[[:space:]]' url.txt | awk '{print $$2}')

EXE:=hp-support-assist-$(VERSION).exe

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

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
		echo 'Verify sha256 checksum with direct download with Firefox on https://support.hp.com/us-en/help/hp-support-assistant' ; \
		)

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf *.exe setup 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "PE32+ executable" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/setup/InstallHPSA.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf setup 2>/dev/null ; \
		mkdir -p setup ; \
		cd setup ; \
		7z x ../$(EXE) -y >/dev/null ; \
		)
	@which peres >/dev/null && { peres -a $@ | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $@" ; }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) tmp/setup/InstallHPSA.exe
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat)
	@(cd tmp/setup; zip --quiet -r ../../$@ *)
	@chmod ugo+rw $@
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l

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
