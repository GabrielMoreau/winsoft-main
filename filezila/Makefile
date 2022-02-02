SOFT:=FileZilla
VERSION:=3.57.0
PATCH:=1

MSI:=FileZilla_$(VERSION)_win64-setup.exe


.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip $(MSI) tmp

wget: $(MSI)

$(MSI):
	wget "https://dl1.cdn.filezilla-project.org/client/FileZilla_$(VERSION)_win64-setup.exe"

%.zip: Makefile tmp/install.bat tmp/cmdow.exe $(MSI)
	rm -f $@
	zip -r $@ \
			$(MSI)
	cd tmp; zip -r ../$@ install.bat cmdow.exe
	chmod ugo+rw $@

tmp/install.bat: install.bat
	mkdir -p tmp
	perl -p -e ' \
		s/^(SET\ssoftmsi=)[^=]+\.exe/$${1}$(MSI)/; \
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
