
WINFSP_URL:=$(shell curl -s -L 'https://github.com/winfsp/winfsp/releases/latest' | sed 's/"/\n/g;'| grep '^https://github.com/winfsp.*msi' | head -1)
WINFSP_VERSION:=$(shell basename "$(WINFSP_URL)" | cut -f 2 -d '-' | sed -e 's/\.msi//;')
WINFSP_EXE:=winfsp-$(WINFSP_VERSION).msi

SSHFS_VERSION:=$(shell curl -s -L 'https://github.com/winfsp/sshfs-win/releases/latest' | sed 's/"/\n/g;' | grep '^/winfsp/sshfs-win/releases/tag/v' | head -1 | xargs -r basename | sed -s 's/^v//;')
SSHFS_URL:=https://github.com/billziss-gh/sshfs-win/releases/download/v$(SSHFS_VERSION)/sshfs-win-$(SSHFS_VERSION)-x64.msi
SSHFS_EXE:=sshfs-win-$(SSHFS_VERSION)-x64.msi

REVISION:=1

ServerSFTP:=$(shell grep -h '^ServerSFTP' conf.yml ../../winsoft-conf/sshfs-win/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)
NetworkDrive:=$(shell grep -h '^NetworkDrive' conf.yml ../../winsoft-conf/sshfs-win/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)

SOFT:=SSHFS-Win-Manage
VERSION:=$(SSHFS_VERSION).$(WINFSP_VERSION)


IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next ocs version wget

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	@rm -rf tmp sshfswin*.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "WINFSP_VERSION: $(WINFSP_VERSION)"
	@echo "WINFSP_URL:     $(WINFSP_URL)"
	@echo "WINFSP_EXE:     $(WINFSP_EXE)"
	@echo "SSHFS_VERSION:  $(SSHFS_VERSION)"
	@echo "SSHFS_URL:      $(SSHFS_URL)"
	@echo "SSHFS_EXE:      $(SSHFS_EXE)"

checksum:
	@mkdir -p tmp
	@(cd tmp ; \
		grep -q "^$$(shasum -a 256 $(WINFSP_EXE))$$" ../checksum.txt || { shasum -a 256 "$(WINFSP_EXE)" | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		grep -q "^$$(shasum -a 256 $(SSHFS_EXE))$$" ../checksum.txt  || { shasum -a 256 "$(SSHFS_EXE)"  | sed -e 's#tmp/##;' >> ../checksum.txt ; } ; \
		)
	@if [ $$(( $$(date '+%s') - $$(stat -c '%Y' checksum.txt) )) -lt 60 ]; then tail -6 checksum.txt; fi

wget: winfsp-$(WINFSP_VERSION).msi sshfs-win-$(SSHFS_VERSION)-x64.msi sshfs-win-manager-setup-v$(ManagerVersion).exe SiriKali-$(SiriKaliVersion).setup.exe

tmp/$(WINFSP_EXE):
	@mkdir -p tmp
	@(cd tmp; \
		rm -f winfsp-*.msi ; \
		curl -# -o "$(WINFSP_EXE)" -L "$(WINFSP_URL)" ; \
		file $(WINFSP_EXE) | grep -q "MSI Installer,.*, Subject: WinFsp - Windows File System Proxy" || echo "Error: bad format for binary $(WINFSP_EXE)" ; \
		grep -q "^$$(shasum -a 256 $(WINFSP_EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(WINFSP_EXE)" ; \
		)

tmp/$(SSHFS_EXE):
	@mkdir -p tmp
	@(cd tmp; \
		rm -f sshfs-win-*.msi ; \
		curl -# -o "$(SSHFS_EXE)" -L "$(SSHFS_URL)" ; \
		file $(SSHFS_EXE) | grep -q "MSI Installer,.*, Subject: SSHFS-Win" || echo "Error: bad format for binary $(SSHFS_EXE)" ; \
		grep -q "^$$(shasum -a 256 $(SSHFS_EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(SSHFS_EXE)" ; \
		)

tmp/sshfs-win-connect.ini: sshfs-win-connect.ini ../../winsoft-conf/sshfs-win/conf.yml
	@mkdir -p tmp
	@sed -e 's/__SERVER_SFTP__/$(ServerSFTP)/g; s/__NetworkDrive__/$(NetworkDrive)/g;' $< > $@

tmp/install.bat: install.bat Makefile tmp/$(WINFSP_EXE) tmp/$(SSHFS_EXE)
	@mkdir -p tmp
	@sed -e 's/__WINFSP_VERSION__/$(WINFSP_VERSION)/; s/__SSHFS_VERSION__/$(SSHFS_VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: ../../winsoft-conf/sshfs-win/conf.yml tmp/install.bat pre-install.ps1 post-install.ps1 sshfs-win-connect.ps1 tmp/sshfs-win-connect.ini sshfs-win.ico README.md tmp/winfsp-$(WINFSP_VERSION).msi tmp/sshfs-win-$(SSHFS_VERSION)-x64.msi
	@mkdir -p tmp
	@zip -r $@ pre-install.ps1 post-install.ps1 sshfs-win.ico README.md sshfs-win-connect.ps1
	@(cd tmp; zip -r ../$@ install.bat sshfs-win-connect.ini winfsp-$(WINFSP_VERSION).msi sshfs-win-$(SSHFS_VERSION)-x64.msi)

ocs:
	@echo ""
	@echo "Name:    $(SOFT)_$(VERSION)-$(REVISION)_x64"
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
