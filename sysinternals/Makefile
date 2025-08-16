
#
# SysinternalsSuite
#

sinclude ../_common/flag.mk

SOFT:=SysinternalsSuite
URL:=https://download.sysinternals.com/files/SysinternalsSuite.zip
VERSION:=$(shell ./get-version "$(URL)")
REVISION:=1

EXE:=SysinternalsSuite-$(VERSION).zip

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next ocs version wget checksum

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
		rm -f SysinternalsSuite-*.zip 2>/dev/null ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		ln -f SysinternalsSuite.zip $(EXE) ; \
		file $(EXE) | grep -q "Zip archive data" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Zip archive data" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat uninstall.bat tmp/$(EXE)
	@rm -f $@
	@zip -r ./$@ uninstall.bat
	@(cd tmp; zip --quiet -r ../$@ install.bat SysinternalsSuite)
	@echo -n '  Zip / Number of files: '; unzip -t $@ | grep 'OK' | wc -l
	@chmod ugo+rw $@
