
#
# FlashPlayer-Uninstall
#

SOFT:=FlashPlayer-Uninstall
INSTALLER:=uninstall_flash_player.exe
VERSION:=$(shell peres -v tmp/$(INSTALLER) 2> /dev/null 2> /dev/null | grep '^Product Version' | awk '{print $$3}')
REVISION:=1
URL:=https://fpdownload.macromedia.com/get/flashplayer/current/support/uninstall_flash_player.exe

EXE:=uninstall_flash_player-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized checksum clean control next version wget checksum

all:
	@mkdir -p tmp
	@rm -f "tmp/$(INSTALLER)"
	@(cd tmp; curl -s -o $(INSTALLER) -L "$(URL)")
	@make next

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Adobe Flash Player

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized:
	@echo 'Ok'

next: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

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
		find ./ -name '*.exe' -a -not -name "$(INSTALLER)" -a -not -name "$(EXE)" -delete ; \
		cmp $(INSTALLER) $(EXE) > /dev/null 2>&1 || cp -f $(INSTALLER) $(EXE) ; \
		file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		which peres >/dev/null && { peres -v $(EXE) 2> /dev/null | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat post-install.ps1 tmp/$(EXE)
	@rm -f $@
	@zip -r $@ post-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@
