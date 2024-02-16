
#
# ParaView
#

SOFT:=ParaView
SHORTVERSION:=$(shell curl -s -L  'https://www.paraview.org/files/listing.txt' | grep "/v.*/ParaView.*\.msi[[:space:]]" | egrep -v -- '-(RC[[:digit:]]*|MPI)-' | cut -f 2 -d '/' | grep '^v' | sed -e 's/^v//;' | uniq | sort -V | tail -1)
VERSION:=$(shell curl -s -L 'https://www.paraview.org/files/listing.txt' | grep "/v.*/ParaView.*\.msi[[:space:]]" | awk '{print $$1}' | egrep -v -- '-(RC[[:digit:]]*|MPI)-' | xargs -r -n 1 basename | cut -f 2 -d '-' | sort -V  | tail -1)
REVISION:=1
EXE:=$(shell curl -s -L 'https://www.paraview.org/files/listing.txt' | grep "/v$(SHORTVERSION)/ParaView-$(VERSION)-Windows.*\.msi[[:space:]]" | awk '{print $$1}' | egrep -v -- '-(RC[[:digit:]]*|MPI)-' | sort | head -1 | sed -e 's#[[:space:]]#/#g;' | cut -f 3 -d '/')
URL:=https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v$(SHORTVERSION)&type=binary&os=Windows&downloadFile=$(EXE)

# https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.11&type=binary&os=Windows&downloadFile=ParaView-5.11.0-Windows-Python3.9-msvc2017-AMD64.msi


IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next ocs version wget checksum check-exe

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "SHORTVERSION: $(SHORTVERSION)"
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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Composite Document File V2 Document, Little Endian.*Subject: ParaView, Author: Kitware, Inc" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

check-exe: tmp/$(EXE)
	@cd tmp; file $(EXE) | grep -q "Composite Document File V2 Document, Little Endian.*Subject: ParaView, Author: Kitware, Inc" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 1; }

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#; s/__EXE__/$(EXE)/;' $< > $@

%.zip: Makefile pre-install.ps1 tmp/install.bat tmp/$(EXE)
	@rm -f $@
	zip -r ./$@ pre-install.ps1
	@(cd tmp; zip -r ../$@ install.bat $(EXE))
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
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
