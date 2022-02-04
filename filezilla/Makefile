
SOFT:=FileZilla
VERSION:=$(shell grep '^SET softversion' install.bat | cut -f 2 -d '=')
PATCH:=$(shell grep '^SET softpatch' install.bat | cut -f 2 -d '=')

EXE:=FileZilla_$(VERSION)_win64-setup.exe


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip $(EXE) tmp

wget: $(EXE)

$(EXE):
	wget "https://dl1.cdn.filezilla-project.org/client/FileZilla_$(VERSION)_win64-setup.exe"

%.zip: Makefile install.bat fzdefaults.xml tmp/cmdow.exe $(EXE)
	rm -f $@
	zip -r $@ \
		install.bat \
		fzdefaults.xml \
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
