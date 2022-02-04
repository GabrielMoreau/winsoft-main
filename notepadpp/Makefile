
SOFT:=NotepadPP
VERSION:=$(shell grep '^SET softversion' install.bat | cut -f 2 -d '=')
PATCH:=$(shell grep '^SET softpatch' install.bat | cut -f 2 -d '=')

EXE:=npp.$(VERSION).Installer.x64.exe


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip $(EXE) tmp

wget: $(EXE)

$(EXE):
	wget "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$(VERSION)/npp.$(VERSION).Installer.x64.exe"

%.zip: Makefile install.bat tmp/cmdow.exe $(EXE)
	rm -f $@
	zip -r $@ \
		install.bat \
		$(EXE)
	cd tmp; zip -r ../$@ cmdow.exe
	chmod ugo+rw $@

tmp/cmdow.exe:
	mkdir -p tmp
	cp ../common/cmdow.exe tmp/

ocs:
	@echo ""
	@echo "Name:    $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "Launch:  install.bat"
	@echo "Message: yes"
	@echo "Delay:   5"
	@echo "Cancel:  no"
	@echo "Report:  yes"
	@echo ""
	@echo "Service Informatique du LEGI"
	@echo " --- "
	@echo "Installation et mise jour de $(SOFT)"
	@echo ""
