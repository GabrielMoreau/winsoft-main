SOFT:=FileZilla
VERSION:=3.14.0
PATCH:=1

MSI:=FileZilla_$(VERSION)_win64-setup.exe


.PHONY: all ocs

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

clean:
	rm -f $(SOFT)-$(VERSION)-$(PATCH).zip


%.zip: Makefile
	perl -pi.bak -e ' \
			s/^(SET\ssoftmsi=)[^=]+\.exe/$${1}$(MSI)/; \
			s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
			s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat
	rm -f $@
	zip -r $@ \
			cmdow.exe \
			install.bat \
			$(MSI)
	chmod ugo+rw $@


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
