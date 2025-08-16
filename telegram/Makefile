
#
# Telegram
#

SOFT:=Telegram
URL:=https://github.com$(shell curl -s  -L 'https://github.com/telegramdesktop/tdesktop/releases' | sed 's/"/\n/g;' | grep '^https://github.com/telegramdesktop/tdesktop/releases/expanded_assets' | xargs -r -n 1 curl -s -L | sed 's/"/\n/g;' | grep '/tportable-x64.*zip' | head -1)
VERSION:=$(shell echo $(URL) | cut -f 8 -d '/' | sed -s 's/^v//;')
REVISION:=1

EXE:=tportable-x64.$(VERSION).zip

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_DELAY:=$(OCS_DELAY_LONG)
OCS_MESSAGE:=$(OCS_MESSAGE_LONG)

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
		rm -f *.zip 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/Telegram/Telegram.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf Telegram 2>/dev/null ; \
		unzip -q $(EXE) ; \
		#which peres >/dev/null && { peres -v 'Telegram/Telegram.exe' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		)

check-exe: tmp/Telegram/Telegram.exe tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "Zip archive data" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -v 'Telegram/Telegram.exe' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 1; } ; } ;\
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile uninstall.bat tmp/install.bat tmp/$(EXE) tmp/Telegram/Telegram.exe
	@rm -f $@
	@zip -r $@ uninstall.bat
	@(cd tmp; zip -r ../$@ install.bat Telegram)
	@chmod ugo+rw $@
