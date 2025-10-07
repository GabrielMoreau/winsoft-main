
#
# Kaspersky Uninstall
#

URL:=https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/Kasperky-Uninstall-Latest.zip
SOFT:=Kaspersky-Uninstall
VERSION:=$(shell curl -s --insecure -L https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/version.txt)
REVISION:=1

ZIP:=Kasperky-Uninstall-$(VERSION).zip

KesSecureString:=$(shell cat securestring-kes.txt ../../winsoft-conf/kaspersky/securestring-kes.txt 2>/dev/null | grep . | head -1)
KesAESKey:=../../winsoft-conf/kaspersky/aes-kaspersky.key

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next version wget

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Kaspersky
OCS_PRIORITY:=2

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip $(EXE) tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

wget: tmp/$(ZIP)

tmp/$(ZIP):
	@mkdir -p tmp
	@(cd tmp ; \
		rm -f Kasperky-Uninstall-*.zip ; \
		curl -# --insecure -o "$(ZIP)" -L "$(URL)"; \
		file "$(ZIP)" | grep -q 'Zip archive data' || echo "Error: bad format for archive $(ZIP)" ; \
		grep -q "^$$(shasum -a 256 $(ZIP))$$" ../checksum.txt || echo "Error: bad checksum for archive $(ZIP)" ; \
		)
	@(cd tmp ; unzip -q $(ZIP))

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/$(ZIP)
	@rm -f $@
	@if [ -e 'aes-kaspersky.key' ]; then cp 'aes-kaspersky.key' ./tmp/; elif [ -e "$(KesAESKey)" ]; then cp "$(KesAESKey)" ./tmp/; fi
	@sed -e "s/XXXXXXXXX/$(KesSecureString)/;" Custom-VarAutodel.psm1 > ./tmp/Custom-VarAutodel.psm1
	@(cd tmp; zip -r ../$@ install.bat *.psm1 *.ps1 aes-kaspersky.key README.md LICENSE.md)
	@chmod ugo+rw $@
