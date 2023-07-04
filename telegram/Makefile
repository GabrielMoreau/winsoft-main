
#
# Telegram
#

SOFT:=Telegram
URL:=https://github.com$(shell curl -s  -L 'https://github.com/telegramdesktop/tdesktop/releases' |sed 's/"/\n/g;' | grep '^https://github.com/telegramdesktop/tdesktop/releases/expanded_assets' | xargs -r -n 1 curl -s  -L | sed 's/"/\n/g;' | grep '/tportable-x64.*zip' | head -1)
VERSION:=$(shell echo $(URL) | cut -f 8	 -d '/' | sed -s 's/^v//;')
PATCH:=1

EXE:=tportable-x64.$(VERSION).zip

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

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
		rm -f *.zip 2>/dev/null ; \
		curl -s -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Zip archive data" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/Telegram/Telegram.exe: tmp/$(EXE)
	@mkdir -p tmp
	@(cd tmp ; \
		rm -rf Telegram 2>/dev/null ; \
		unzip -q $(EXE) ; \
		which peres >/dev/null && { peres -a 'Telegram/Telegram.exe' | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile uninstall.bat tmp/install.bat tmp/$(EXE) tmp/Telegram/Telegram.exe
	@rm -f $@
	@zip -r $@ uninstall.bat
	@(cd tmp; zip -r ../$@ install.bat Telegram)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   20"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo " --- "
	@echo "The software will be stopped during the installation,"
	@echo "make a quick save or postpone the update."
	@echo ""