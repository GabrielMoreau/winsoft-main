SOFT:=NotepadPP
VERSION:=8.3
PATCH:=1

EXE:=npp.$(VERSION).Installer.x64.exe


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip $(EXE) tmp

wget: $(EXE)

$(EXE):
	wget "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.3/npp.8.3.Installer.x64.exe"

%.zip: Makefile tmp/install.bat tmp/cmdow.exe $(EXE)
	rm -f $@
	zip -r $@ \
			$(EXE)
	cd tmp; zip -r ../$@ install.bat cmdow.exe
	chmod ugo+rw $@

tmp/install.bat: install.bat
	mkdir -p tmp
	perl -p -e ' \
		s/^(SET\ssoftexe=)[^=]+\.exe/$${1}$(EXE)/; \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > tmp/install.bat

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
