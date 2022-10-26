
#
# VisualCPPRedistribuable
#

SOFT:=VisualCPPRedistribuable
VERSION:=0.7
PATCH:=1

IT_TEAM:=IT Support

VCREDIST:=
VCREDIST+=tmp/2010/vcredist_x64.exe
VCREDIST+=tmp/2010/vcredist_x86.exe
VCREDIST+=tmp/2012/vcredist_x64.exe
VCREDIST+=tmp/2012/vcredist_x86.exe
VCREDIST+=tmp/2013/vcredist_x64.exe
VCREDIST+=tmp/2013/vcredist_x86.exe
VCREDIST+=tmp/2015-2019/vc_redist.x64.exe
VCREDIST+=tmp/2015-2019/vc_redist.x86.exe
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe
VCREDIST+=tmp/2015-2022/vc_redist.x86.exe

.PHONY: all ocs clean wget

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp

wget: $(VCREDIST)

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

%.zip: Makefile tmp/install.bat post-install.ps1 view.ps1 $(VCREDIST)
	@rm -f $@
	@zip -r $@ post-install.ps1 view.ps1
	@(cd tmp; zip -r ../$@ install.bat  2010 2012 2013 2015-2019 2015-2022)
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


tmp/2010/vcredist_x64.exe:
	@mkdir -p tmp/2010
	@curl -s -o $@ -L https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2010/vcredist_x86.exe:
	@mkdir -p tmp/2010
	@curl -s -o $@ -L https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"


tmp/2012/vcredist_x64.exe:
	@mkdir -p tmp/2012
	@curl -s -o $@ -L https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2012/vcredist_x86.exe:
	@mkdir -p tmp/2012
	@curl -s -o $@ -L https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"


tmp/2013/vcredist_x64.exe:
	@mkdir -p tmp/2013
	@curl -s -o $@ -L https://aka.ms/highdpimfc2013x64enu
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2013/vcredist_x86.exe:
	@mkdir -p tmp/2013
	@curl -s -o $@ -L https://aka.ms/highdpimfc2013x86enu
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"


tmp/2015-2019/vc_redist.x64.exe:
	@mkdir -p tmp/2015-2019
	@curl -s -o $@ -L https://aka.ms/vs/16/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2015-2019/vc_redist.x86.exe:
	@mkdir -p tmp/2015-2019
	@curl -s -o $@ -L https://aka.ms/vs/16/release/vc_redist.x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"


tmp/2015-2022/vc_redist.x64.exe:
	@mkdir -p tmp/2015-2022
	@curl -s -o $@ -L https://aka.ms/vs/17/release/vc_redist.x64.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"

tmp/2015-2022/vc_redist.x86.exe:
	@mkdir -p tmp/2015-2022
	@curl -s -o $@ -L https://aka.ms/vs/17/release/vc_redist.x86.exe
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
