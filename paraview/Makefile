
#
# ParaView
#

SOFT:=ParaView
VERSION:=$(shell curl -s -L  'https://www.paraview.org/files/listing.txt' | cut -f 2 -d '/' | grep '^v' | sed -e 's/^v//;' | uniq | sort -V | tail -1)
PATCH:=1
EXE:=$(shell curl -s -L 'https://www.paraview.org/files/listing.txt' | grep "/v$(VERSION)/ParaView" | grep '\.msi[[:space:]]' | egrep -v -- '-(RC[[:digit:]]*|MPI)-' | awk '{print $1}' | sort | head -1 | sed -e 's#[[:space:]]#/#g;' | cut -f 3 -d '/')
URL:=https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v$(VERSION)&type=binary&os=Windows&downloadFile=$(EXE)

# https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.11&type=binary&os=Windows&downloadFile=ParaView-5.11.0-Windows-Python3.9-msvc2017-AMD64.msi


IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -s -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Composite Document File V2 Document, Little Endian.*$(VERSION)" || echo "Error: bad format for binary $(EXE)" ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/; \
		s/^(SET\ssoftexe=).*/$${1}$(EXE)/;' install.bat > $@

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
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""
