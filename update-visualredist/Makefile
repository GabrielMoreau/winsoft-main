
#
# Update-VisualCPPRedistributable
#

SOFT:=Update-VisualCPPRedistributable
REVISION:=1

DIR05:=2005
URL05_64:=$(shell grep '^$(DIR05)-x64' url.txt | cut -f 2 -d ' ')
EXE05_64:=$(shell grep '^$(DIR05)-x64' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR05); cd tmp/$(DIR05); curl -s --time-cond '$(EXE05_64)' -o '$(EXE05_64)' -L "$(URL05_64)")
VER05_64:=$(shell peres -v 'tmp/$(DIR05)/$(EXE05_64)' | grep 'Product Version:' | awk '{print $$3}')
URL05_86:=$(shell grep '^$(DIR05)-x86' url.txt | cut -f 2 -d ' ')
EXE05_86:=$(shell grep '^$(DIR05)-x86' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR05); cd tmp/$(DIR05); curl -s --time-cond '$(EXE05_86)' -o '$(EXE05_86)' -L "$(URL05_86)")
VER05_86:=$(shell peres -v 'tmp/$(DIR05)/$(EXE05_86)' | grep 'Product Version:' | awk '{print $$3}')

DIR08:=2008
URL08_64:=$(shell grep '^$(DIR08)-x64' url.txt | cut -f 2 -d ' ')
EXE08_64:=$(shell grep '^$(DIR08)-x64' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR08); cd tmp/$(DIR08); curl -s --time-cond '$(EXE08_64)' -o '$(EXE08_64)' -L "$(URL08_64)")
VER08_64:=$(shell peres -v 'tmp/$(DIR08)/$(EXE08_64)' | grep 'Product Version:' | awk '{print $$3}')
URL08_86:=$(shell grep '^$(DIR08)-x86' url.txt | cut -f 2 -d ' ')
EXE08_86:=$(shell grep '^$(DIR08)-x86' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR08); cd tmp/$(DIR08); curl -s --time-cond '$(EXE08_86)' -o '$(EXE08_86)' -L "$(URL08_86)")
VER08_86:=$(shell peres -v 'tmp/$(DIR08)/$(EXE08_86)' | grep 'Product Version:' | awk '{print $$3}')

DIR10:=2010
URL10_64:=$(shell grep '^$(DIR10)-x64' url.txt | cut -f 2 -d ' ')
EXE10_64:=$(shell grep '^$(DIR10)-x64' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR10); cd tmp/$(DIR10); curl -s --time-cond '$(EXE10_64)' -o '$(EXE10_64)' -L "$(URL10_64)")
VER10_64:=$(shell peres -v 'tmp/$(DIR10)/$(EXE10_64)' | grep 'Product Version:' | awk '{print $$3}')
URL10_86:=$(shell grep '^$(DIR10)-x86' url.txt | cut -f 2 -d ' ')
EXE10_86:=$(shell grep '^$(DIR10)-x86' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR10); cd tmp/$(DIR10); curl -s --time-cond '$(EXE10_86)' -o '$(EXE10_86)' -L "$(URL10_86)")
VER10_86:=$(shell peres -v 'tmp/$(DIR10)/$(EXE10_86)' | grep 'Product Version:' | awk '{print $$3}')

DIR12:=2012
URL12_64:=$(shell grep '^$(DIR12)-x64' url.txt | cut -f 2 -d ' ')
EXE12_64:=$(shell grep '^$(DIR12)-x64' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR12); cd tmp/$(DIR12); curl -s --time-cond '$(EXE12_64)' -o '$(EXE12_64)' -L "$(URL12_64)")
VER12_64:=$(shell peres -v 'tmp/$(DIR12)/$(EXE12_64)' | grep 'Product Version:' | awk '{print $$3}')
URL12_86:=$(shell grep '^$(DIR12)-x86' url.txt | cut -f 2 -d ' ')
EXE12_86:=$(shell grep '^$(DIR12)-x86' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR12); cd tmp/$(DIR12); curl -s --time-cond '$(EXE12_86)' -o '$(EXE12_86)' -L "$(URL12_86)")
VER12_86:=$(shell peres -v 'tmp/$(DIR12)/$(EXE12_86)' | grep 'Product Version:' | awk '{print $$3}')

DIR13:=2013
URL13_64:=$(shell grep '^$(DIR13)-x64' url.txt | cut -f 2 -d ' ')
EXE13_64:=$(shell grep '^$(DIR13)-x64' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR13); cd tmp/$(DIR13); curl -s --time-cond '$(EXE13_64)' -o '$(EXE13_64)' -L "$(URL13_64)")
VER13_64:=$(shell peres -v 'tmp/$(DIR13)/$(EXE13_64)' | grep 'Product Version:' | awk '{print $$3}')
URL13_86:=$(shell grep '^$(DIR13)-x86' url.txt | cut -f 2 -d ' ')
EXE13_86:=$(shell grep '^$(DIR13)-x86' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR13); cd tmp/$(DIR13); curl -s --time-cond '$(EXE13_86)' -o '$(EXE13_86)' -L "$(URL13_86)")
VER13_86:=$(shell peres -v 'tmp/$(DIR13)/$(EXE13_86)' | grep 'Product Version:' | awk '{print $$3}')

DIR15:=2015-2022
URL15_64:=$(shell grep '^$(DIR15)-x64' url.txt | cut -f 2 -d ' ')
EXE15_64:=$(shell grep '^$(DIR15)-x64' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR15); cd tmp/$(DIR15); curl -s --time-cond '$(EXE15_64)' -o '$(EXE15_64)' -L "$(URL15_64)")
VER15_64:=$(shell peres -v 'tmp/$(DIR15)/$(EXE15_64)' | grep 'Product Version:' | awk '{print $$3}')
URL15_86:=$(shell grep '^$(DIR15)-x86' url.txt | cut -f 2 -d ' ')
EXE15_86:=$(shell grep '^$(DIR15)-x86' url.txt | cut -f 2 -d ' ' | xargs -r basename)
$(shell mkdir -p tmp/$(DIR15); cd tmp/$(DIR15); curl -s --time-cond '$(EXE15_86)' -o '$(EXE15_86)' -L "$(URL15_86)")
VER15_86:=$(shell peres -v 'tmp/$(DIR15)/$(EXE15_86)' | grep 'Product Version:' | awk '{print $$3}')

VERSION:=$(shell ./sum-versions $(VER05_64) $(VER05_86) $(VER08_64) $(VER08_86) $(VER10_64) $(VER10_86) $(VER12_64) $(VER12_86) $(VER13_64) $(VER13_86) $(VER15_64) $(VER15_86))

VCREDIST:=
VCREDIST+=tmp/2005/vcredist_x64.EXE
VCREDIST+=tmp/2005/vcredist_x86.EXE
VCREDIST+=tmp/2008/vcredist_x64.exe
VCREDIST+=tmp/2008/vcredist_x86.exe
VCREDIST+=tmp/2010/vcredist_x64.exe
VCREDIST+=tmp/2010/vcredist_x86.exe
VCREDIST+=tmp/2012/vcredist_x64.exe
VCREDIST+=tmp/2012/vcredist_x86.exe
VCREDIST+=tmp/2013/vcredist_x64.exe
VCREDIST+=tmp/2013/vcredist_x86.exe
VCREDIST+=tmp/2015-2022/vc_redist.x64.exe
VCREDIST+=tmp/2015-2022/vc_redist.x86.exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all checksum check-version check-exe clean control next ocs version wget

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version: tmp/version-replace.txt
	@sed -e 's#/# #g; s/__//g; s/^s/ */; s/[[:space:]]*;//;' tmp/version-replace.txt

checksum: $(VCREDIST)
	@for exe in $(VCREDIST); \
	do \
		grep -q "^$$(shasum -a 256 $${exe})$$" ./checksum.txt || { shasum -a 256 "$(exe)"  >> ./checksum.txt ; }; \
		ver=$$(peres -v $${exe} | grep "^Product Version:[[:space:]]" | awk '{print $$3}'); \
		year=$$(dirname $${exe} | xargs -r basename); \
		arch=$$(basename $${exe} | cut -f 2 -d '.'); \
		grep -q "$${year}-.* $${ver}" ./version.txt || { echo " * $${year}-$${arch} $${ver}" >> ./version.txt; }; \
	done
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' version.txt) )) -lt 60 ]; then tail -6 version.txt; fi

check-exe: $(VCREDIST)
	@for exe in $(VCREDIST); \
	do \
		file $${exe} | grep -q "PE32 executable" || { echo "Error: bad format for binary $${exe}" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { grep -q $$(peres -v $${exe} | grep "^Product Version:[[:space:]]" | awk '{print $$3}') version.txt || { echo "Error: bad version for binary $${exe}" 1>&2 ; exit 1; } ; } ;\
	done

wget: $(VCREDIST)

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/version-replace.txt: $(VCREDIST)
	@echo "s/__2005-x64-bad__/$$(peres -v tmp/2005/vcredist_x64.EXE | egrep 'Product Version:' | awk '{print $$3}')/;"  > $@
	@echo "s/__2005-x86-bad__/$$(peres -v tmp/2005/vcredist_x86.EXE | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2008-x64-bad__/$$(peres -v tmp/2008/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2008-x86-bad__/$$(peres -v tmp/2008/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2010-x64-bad__/$$(peres -v tmp/2010/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2010-x86-bad__/$$(peres -v tmp/2010/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2005-x64__/$$(grep '* 2005-x64[[:space:]]' version.txt | awk '{print $$3}')/;" >> $@
	@echo "s/__2005-x86__/$$(grep '* 2005-x86[[:space:]]' version.txt | awk '{print $$3}')/;" >> $@
	@echo "s/__2008-x64__/$$(grep '* 2008-x64[[:space:]]' version.txt | awk '{print $$3}')/;" >> $@
	@echo "s/__2008-x86__/$$(grep '* 2008-x86[[:space:]]' version.txt | awk '{print $$3}')/;" >> $@
	@echo "s/__2010-x64__/$$(grep '* 2010-x64[[:space:]]' version.txt | awk '{print $$3}')/;" >> $@
	@echo "s/__2010-x86__/$$(grep '* 2010-x86[[:space:]]' version.txt | awk '{print $$3}')/;" >> $@
	@echo "s/__2012-x64__/$$(peres -v tmp/2012/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2012-x86__/$$(peres -v tmp/2012/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2013-x64__/$$(peres -v tmp/2013/vcredist_x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2013-x86__/$$(peres -v tmp/2013/vcredist_x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@#echo "s/__2015-2019-x64__/$$(peres -v tmp/2015-2019/vc_redist.x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@#echo "s/__2015-2019-x86__/$$(peres -v tmp/2015-2019/vc_redist.x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2015-2022-x64__/$$(peres -v tmp/2015-2022/vc_redist.x64.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@
	@echo "s/__2015-2022-x86__/$$(peres -v tmp/2015-2022/vc_redist.x86.exe | egrep 'Product Version:' | awk '{print $$3}')/;" >> $@

tmp/version.txt: tmp/version-replace.txt
	@sed -e 's#/# #g; s/__//g; s/^s/ */; s/[[:space:]]*;//;' tmp/version-replace.txt > $@
	@cmp version.txt tmp/version.txt || diff --side-by-side version.txt tmp/version.txt

tmp/post-install.ps1: post-install.ps1 tmp/version-replace.txt Makefile
	@perl -p -e "$$(cat tmp/version-replace.txt)" $< > $@

%.zip: Makefile tmp/install.bat tmp/post-install.ps1 view.ps1 $(VCREDIST) tmp/version.txt
	@rm -f $@
	@zip -r $@ view.ps1
	@(cd tmp; zip -r ../$@ install.bat post-install.ps1 2005 2008 2010 2012 2013 2015-2022) # 2015-2019
	@chmod ugo+rw $@

ocs:
	@echo ""
	@echo "Name:     $(SOFT)_$(VERSION)-$(REVISION)_x64"
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


tmp/2005/vcredist_x64.EXE: url.txt
	@mkdir -p tmp/2005
	@curl -# -o $@ -L $$(grep '^2005-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2005/vcredist_x86.EXE: url.txt
	@mkdir -p tmp/2005
	@curl -# -o $@ -L $$(grep '^2005-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2008/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2008
	@curl -# -o $@ -L $$(grep '^2008-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2008/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2008
	@curl -# -o $@ -L $$(grep '^2008-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2010/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2010
	@curl -# -o $@ -L $$(grep '^2010-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2010/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2010
	@curl -# -o $@ -L $$(grep '^2010-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2012/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2012
	@curl -# -o $@ -L $$(grep '^2012-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2012/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2012
	@curl -# -o $@ -L $$(grep '^2012-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2013/vcredist_x64.exe: url.txt
	@mkdir -p tmp/2013
	@curl -# -o $@ -L $$(grep '^2013-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2013/vcredist_x86.exe: url.txt
	@mkdir -p tmp/2013
	@curl -# -o $@ -L $$(grep '^2013-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"


tmp/2015-2022/vc_redist.x64.exe: url.txt
	@mkdir -p tmp/2015-2022
	@curl -# -o $@ -L $$(grep '^2015-2022-x64' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"

tmp/2015-2022/vc_redist.x86.exe: url.txt
	@mkdir -p tmp/2015-2022
	@curl -# -o $@ -L $$(grep '^2015-2022-x86' url.txt | cut -f 2 -d ' ')
	@file $@ | grep -q "PE32 executable" || echo "Error: bad format for binary $@"
	@grep -q "^$$(shasum -a 256 $@)$$" checksum.txt || echo "Error: bad checksum for binary $@"
	@grep -q "[[:space:]]$$(peres -v $@ | egrep 'Product Version:' | awk '{print $$3}')$$" version.txt || echo "Error: bad version for binary $@"
