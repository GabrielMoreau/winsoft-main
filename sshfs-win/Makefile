
WinfspVersion:=$(shell grep '^SET WinfspVersion' install.bat | cut -f 2 -d '=')
WinfspMajorVersion:=$(shell grep '^SET WinfspVersion' install.bat | cut -f 2 -d '='| cut -f 1,2 -d '.')
SshfsVersion:=$(shell grep '^SET SshfsVersion' install.bat | cut -f 2 -d '=')
ManagerVersion:=$(shell grep '^SET ManagerVersion' install.bat | cut -f 2 -d '=')
SiriKaliVersion:=$(shell grep '^SET SiriKaliVersion' install.bat | cut -f 2 -d '=')
PkgVersion:=$(shell grep '^SET PkgVersion' install.bat | cut -f 2 -d '=')

ServerSFTP:=$(shell grep -h '^ServerSFTP' conf.yml ../../winsoft-conf/sshfs-win/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)
NetworkDrive:=$(shell grep -h '^NetworkDrive' conf.yml  ../../winsoft-conf/sshfs-win/conf.yml 2>/dev/null | cut -f 2 -d ':' | sed -e 's/[[:space:]]//g;' | head -1)

.PHONY: all clean wget version ocs

all: sshfswin-$(SshfsVersion)-$(PkgVersion).zip

sshfswin-$(SshfsVersion)-$(PkgVersion).zip: ../../winsoft-conf/sshfs-win/conf.yml install.bat install.ps1 tmp/sshfs-win-connect.ps1 sshfs-win.ico tmp/cmdow.exe README.md winfsp-$(WinfspVersion).msi sshfs-win-$(SshfsVersion)-x64.msi
	zip -r sshfswin-$(SshfsVersion)-$(PkgVersion).zip install.bat install.ps1 sshfs-win.ico README.md winfsp-$(WinfspVersion).msi sshfs-win-$(SshfsVersion)-x64.msi
	cd tmp; zip -r ../sshfswin-$(SshfsVersion)-$(PkgVersion).zip sshfs-win-connect.ps1 cmdow.exe

clean:
	rm -rf tmp sshfswin*.zip winfsp-*.msi sshfs-win-*-x64.msi sshfs-win-manager-setup-v*.exe SiriKali-*.setup.exe

wget: winfsp-$(WinfspVersion).msi sshfs-win-$(SshfsVersion)-x64.msi sshfs-win-manager-setup-v$(ManagerVersion).exe SiriKali-$(SiriKaliVersion).setup.exe

winfsp-$(WinfspVersion).msi:
	wget https://github.com/billziss-gh/winfsp/releases/download/v$(WinfspMajorVersion)/winfsp-$(WinfspVersion).msi

sshfs-win-$(SshfsVersion)-x64.msi:
	wget https://github.com/billziss-gh/sshfs-win/releases/download/v$(SshfsVersion)/sshfs-win-$(SshfsVersion)-x64.msi

sshfs-win-manager-setup-v$(ManagerVersion).exe:
	wget https://github.com/evsar3/sshfs-win-manager/releases/download/v$(ManagerVersion)/sshfs-win-manager-setup-v$(ManagerVersion).exe

SiriKali-$(SiriKaliVersion).setup.exe:
	wget https://github.com/mhogomchungu/sirikali/releases/download/$(SiriKaliVersion)/SiriKali-$(SiriKaliVersion).setup.exe

tmp/sshfs-win-connect.ps1: sshfs-win-connect.ps1 ../../winsoft-conf/sshfs-win/conf.yml
	mkdir -p tmp
	sed -e 's/__SERVER_SFTP__/$(ServerSFTP)/g; s/__NetworkDrive__/$(NetworkDrive)/g;' sshfs-win-connect.ps1 > tmp/sshfs-win-connect.ps1

tmp/cmdow.exe:
	mkdir -p tmp
	cp ../common/cmdow.exe tmp/

version:
	@echo $(WinfspVersion) $(WinfspMajorVersion) $(SshfsVersion) $(ManagerVersion) $(SiriKaliVersion) $(PkgVersion)

ocs:
	@echo ""
	@echo "Name:    SSHFS Win Manage $(SshfsVersion)-$(PkgVersion)"
	@echo "Launch:  install.bat"
	@echo "Message: no"
