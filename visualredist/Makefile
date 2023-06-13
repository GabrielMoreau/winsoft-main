
#
# VisualCPPRedistributable
#

SOFT:=VisualCPPRedistributable
VERSION:=1.4
PATCH:=1

IT_TEAM:=IT Support

VCREDIST:=
VCREDIST+=tmp/2008/vcredist_x64.exe
VCREDIST+=tmp/2008/vcredist_x86.exe
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

.PHONY: all check-version clean control next ocs version wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)-$(VERSION)-$(PATCH).zip tmp resources

version: tmp/version-replace.txt
	@sed -e 's#/# #g; s/__//g; s/^s/ */; s/[[:space:]]*;//;' tmp/version-replace.txt

wget: $(VCREDIST)

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+\w?/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > $@

tmp/version-replace.txt: $(VCREDIST)
	@echo "s/__2008-x64__/$$(peres -a tmp/2008/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;"  > $@
	@echo "s/__2008-x86__/$$(peres -a tmp/2008/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2010-x64__/$$(peres -a tmp/2010/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2010-x86__/$$(peres -a tmp/2010/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2012-x64__/$$(peres -a tmp/2012/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2012-x86__/$$(peres -a tmp/2012/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2013-x64__/$$(peres -a tmp/2013/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2013-x86__/$$(peres -a tmp/2013/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2015-2019-x64__/$$(peres -a tmp/2015-2019/vc_redist.x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2015-2019-x86__/$$(peres -a tmp/2015-2019/vc_redist.x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2015-2022-x64__/$$(peres -a tmp/2015-2022/vc_redist.x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2015-2022-x86__/$$(peres -a tmp/2015-2022/vc_redist.x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@

tmp/version.txt: tmp/version-replace.txt
	@sed -e 's#/# #g; s/__//g; s/^s/ */; s/[[:space:]]*;//;' tmp/version-replace.txt > $@
	@cmp version.txt tmp/version.txt || diff --side-by-side version.txt tmp/version.txt

tmp/post-install.ps1: post-install.ps1 tmp/version-replace.txt Makefile
	@perl -p -e "$$(cat tmp/version-replace.txt)" post-install.ps1 > $@

%.zip: Makefile tmp/install.bat tmp/post-install.ps1 view.ps1 $(VCREDIST) tmp/version.txt
	@rm -f $@
	@zip -r $@ view.ps1
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 2008 2010 2012 2013 2015-2019 2015-2022)
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:     $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "Launch:   install.bat"
	@echo "Priority: *6*"
	@echo "Message:  yes"
	@echo "Delay:    5"
	@echo "Cancel:   no"
	@echo "Report:   yes"
	@echo ""
	@echo "$(IT_TEAM)"
	@echo " --- "
	@echo "Install and/or Update: $(SOFT) ($(VERSION))"
	@echo ""


tmp/2008/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2008
	@curl -s -o $@ -L $$(grep '^2008-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2008/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2008
	@curl -s -o $@ -L $$(grep '^2008-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2010/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2010
	@curl -s -o $@ -L $$(grep '^2010-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2010/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2010
	@curl -s -o $@ -L $$(grep '^2010-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2012/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2012
	@curl -s -o $@ -L $$(grep '^2012-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2012/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2012
	@curl -s -o $@ -L $$(grep '^2012-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2013/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2013
	@curl -s -o $@ -L $$(grep '^2013-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2013/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2013
	@curl -s -o $@ -L $$(grep '^2013-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2015-2019/vc_redist.x64.exe: url.txt
	@mkdir -p tmp/2015-2019
	@curl -s -o $@ -L $$(grep '^2015-2019-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2015-2019/vc_redist.x86.exe: url.txt
	@mkdir -p tmp/2015-2019
	@curl -s -o $@ -L $$(grep '^2015-2019-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2015-2022/vc_redist.x64.exe: url.txt
	@mkdir -p tmp/2015-2022
	@curl -s -o $@ -L $$(grep '^2015-2022-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2015-2022/vc_redist.x86.exe: url.txt
	@mkdir -p tmp/2015-2022
	@curl -s -o $@ -L $$(grep '^2015-2022-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -a $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"
