
#
# WinMerge
#

SOFT:=WinMerge
VERSION:=$(shell curl -s -L 'https://winmerge.org/downloads/' | egrep -- 'dt>WinMerge-.*-x64-Setup.exe' | cut -f 2 -d '-')
PATCH:=1
URL:=$(shell curl -s -L 'https://winmerge.org/downloads/' | sed -s 's/"/\n/g;' | egrep -- 'github.com.*/WinMerge-.*-x64-Setup.exe')

EXE:=WinMerge-$(VERSION)-x64-Setup.exe

IT_TEAM:=IT Support


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: tmp/$(EXE)

tmp/$(EXE):
	@mkdir -p tmp
	@(cd tmp ; \
		curl -s -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "PE32 executable" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

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
	@echo "Install and update: $(SOFT)"
	@echo ""