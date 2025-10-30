
#
# DockerDesktop
#

sinclude ../_common/flag.mk

SOFT:=DockerDesktop
INSTALLER:=DockerDesktopInstaller.exe
URL:=https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe
#VSUM:=$(shell curl -s -l 'https://docs.docker.com/desktop/release-notes/' | sed -e 's/[<=>]/\n/g;' | grep '^https://desktop.docker.com/win/main/amd64/.*/checksums.txt' | head -1 | cut -f 7 -d '/')
$(shell ./get-version --url '$(URL)' --shape 'DockerDesktopInstaller-%v.exe' --exe '$(INSTALLER)' > /dev/null)
#    https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe
#URL:=https://desktop.docker.com/win/main/amd64/$(VSUM)/Docker%20Desktop%20Installer.exe
#$(shell mkdir -p tmp; cd tmp; curl $(CURLFLAGS) -s --time-cond "$(INSTALLER)" -o "$(INSTALLER)" -L "$(URL)")
VERSION:=$(shell peres -v tmp/$(INSTALLER) 2> /dev/null | grep '^Product Version' | awk '{print $$3}')
REVISION:=1
# https://desktop.docker.com/win/main/amd64/181591/Docker%20Desktop%20Installer.exe

EXE:=DockerDesktopInstaller-$(VERSION).exe

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean control next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

# OCS configuration
OCS_SEARCH:=Docker

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@( grep -q '[[:space:]]$(EXE)$$' checksum.txt || { echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)' ; exit ; } ; \
		lasturl=$$(curl -s -l 'https://docs.docker.com/desktop/release-notes/' | sed -e 's/[<=>]/\n/g;' | grep '^https://desktop.docker.com/win/main/amd64/.*/checksums.txt' | head -1) ; \
		lastsum=$$(curl -s -l "$${lasturl}" | awk '{print $$1}') ; \
		grep -q "^$${lastsum}[[:space:]]" checksum.txt || { echo 'Warning: new version upstream' ; exit ; }  ; \
		echo 'Ok' ; \
		)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp resources

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"
	@echo "CURL: $(CURLFLAGS)"

checksum: check-version
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
		rm -f *-*.exe *-*.msi 2>/dev/null ; \
		cp "$(INSTALLER)" "$(EXE)" ; \
		printf '#%.0s' $$(seq 1 $$(( $$(tput cols) - 33 ))); echo ' 100.0%' ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		if grep $$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ') ../checksum.txt | grep -qv "$(EXE)"; then echo "Error: another version of DockerDesktop-XXXX.exe exists with the same checksum" 1>&2 ; rm -f "$(EXE)" ; exit 14; fi; \
		)

check-exe: tmp/$(EXE)
	@(cd tmp ; \
		file $(EXE) | grep -q "PE32. executable.*x86-64," || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; } ; } ;\
		if grep $$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ') ../checksum.txt | grep -qv "$(EXE)"; then echo "Error: two binary DockerDesktop-XXXX.exe version exists with same checksum" 1>&2 ; exit 14; fi; \
		if grep "$(EXE)" ../checksum.txt | grep -qv "$$(shasum -a 256 "$(EXE)" | cut -f 1 -d ' ')"; then echo "Error: two binary $(EXE) exists with same version and different checksum" 1>&2 ; exit 15; fi; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/winsoft-config.psd1: winsoft-config.psd1 Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/;' $< > $@

%.zip: Makefile tmp/install.bat pre-install.ps1 tmp/winsoft-config.psd1 tmp/$(EXE)
	@rm -f $@
	@zip -Xr ./$@ pre-install.ps1
	@(cd tmp; zip -Xr ../$@ install.bat winsoft-config.psd1 $(EXE))
	@chmod ugo+rw $@
