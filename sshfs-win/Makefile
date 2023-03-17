
WinfspVersion:=$(shell grep '^SET WinfspVersion' install.bat | cut -f 2 -d '=')
WinfspMajorVersion:=$(shell grep '^SET WinfspVersion' install.bat | cut -f 2 -d '='| cut -f 1,2 -d '.')
SshfsVersion:=$(shell grep '^SET SshfsVersion' install.bat | cut -f 2 -d '=')
ManagerVersion:=$(shell grep '^SET ManagerVersion' install.bat | cut -f 2 -d '=')
SiriKaliVersion:=$(shell grep '^SET SiriKaliVersion' install.bat | cut -f 2 -d '=')
PkgVersion:=$(shell grep '^SET PkgVersion' install.bat | cut -f 2 -d '=')

ServerSFTP:=$(shell grep -h '^ServerSFTP' conf.yml ../../winsoft-conf/sshfs-win/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)
NetworkDrive:=$(shell grep -h '^NetworkDrive' conf.yml ../../winsoft-conf/sshfs-win/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)

SOFT:=SSHFS-Win-Manage
VERSION:=$(SshfsVersion)
PATCH:=$(PkgVersion)

IT_TEAM:=IT Support


.PHONY: all check-version clean control next ocs version wget

all: check-version $(SOFT)-$(VERSION)-$(PATCH).zip ocs

sinclude ../common/global.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

$(SOFT)-$(VERSION)-$(PATCH).zip: ../../winsoft-conf/sshfs-win/conf.yml install.bat install.ps1 tmp/sshfs-win-connect.ps1 sshfs-win.ico README.md winfsp-$(WinfspVersion).msi sshfs-win-$(SshfsVersion)-x64.msi
	@zip -r $@ install.bat install.ps1 sshfs-win.ico README.md winfsp-$(WinfspVersion).msi sshfs-win-$(SshfsVersion)-x64.msi
	@(cd tmp; zip -r ../$@ sshfs-win-connect.ps1)

clean:
	@rm -rf tmp sshfswin*.zip winfsp-*.msi sshfs-win-*-x64.msi sshfs-win-manager-setup-v*.exe SiriKali-*.setup.exe

wget: winfsp-$(WinfspVersion).msi sshfs-win-$(SshfsVersion)-x64.msi sshfs-win-manager-setup-v$(ManagerVersion).exe SiriKali-$(SiriKaliVersion).setup.exe

winfsp-$(WinfspVersion).msi:
	@curl -s -o "winfsp-$(WinfspVersion).msi" -L "https://github.com/billziss-gh/winfsp/releases/download/v$(WinfspMajorVersion)/winfsp-$(WinfspVersion).msi"

sshfs-win-$(SshfsVersion)-x64.msi:
	@curl -s -o "sshfs-win-$(SshfsVersion)-x64.msi" -L "https://github.com/billziss-gh/sshfs-win/releases/download/v$(SshfsVersion)/sshfs-win-$(SshfsVersion)-x64.msi"

sshfs-win-manager-setup-v$(ManagerVersion).exe:
	@curl -s -o "sshfs-win-manager-setup-v$(ManagerVersion).exe" -L "https://github.com/evsar3/sshfs-win-manager/releases/download/v$(ManagerVersion)/sshfs-win-manager-setup-v$(ManagerVersion).exe"

SiriKali-$(SiriKaliVersion).setup.exe:
	@curl -s -o "SiriKali-$(SiriKaliVersion).setup.exe" -L "https://github.com/mhogomchungu/sirikali/releases/download/$(SiriKaliVersion)/SiriKali-$(SiriKaliVersion).setup.exe"

tmp/sshfs-win-connect.ps1: sshfs-win-connect.ps1 ../../winsoft-conf/sshfs-win/conf.yml
	@mkdir -p tmp
	@sed -e 's/__SERVER_SFTP__/$(ServerSFTP)/g; s/__NetworkDrive__/$(NetworkDrive)/g;' sshfs-win-connect.ps1 > tmp/sshfs-win-connect.ps1

version:
	@echo $(WinfspVersion) $(WinfspMajorVersion) $(SshfsVersion) $(ManagerVersion) $(SiriKaliVersion) $(PkgVersion)

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
