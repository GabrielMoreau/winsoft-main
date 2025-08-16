
# List of global parameter
# You can change it via the sinclude directive
# do not change this file

# Team Name (all package)
IT_TEAM:=IT Team

# Log Folder (protect backslash)
LOGDIR:=%WINDIR%\\Logs

# OCS Inventory Agent (ocsinventory-agent package)
OCS_URL:=https://ocs-server.example.com
OCS_SERVER:=https://ocs-server.example.com/ocsinventory
OCS_SSL:=1
OCS_NAME=$(SOFT)_$(VERSION)-$(REVISION)_x64
OCS_PRIORITY:=5
OCS_LAUNCH:=install.bat
OCS_NOTIFY:=yes
OCS_DELAY:=5
OCS_MESSAGE=$(IT_TEAM) --- Install and/or Update: $(SOFT) ($(VERSION))
OCS_CANCEL:=no
OCS_REPORT:=yes
OCS_DELAY_LONG:=20
OCS_MESSAGE_LONG=$(OCS_MESSAGE) --- The software will be stopped during the installation --- Make a quick save or postpone the update.

# Cisco AnyConnect (anyconnect package)
CISCO_VPN_SERVER:=vpn.example.com

# Hurukai Server (HarfangLab)
HURUKAI_SERVER:=hurukai.example.com
HURUKAI_SIG:=blabla
HURUKAI_PASSWORD:=youragentpass

# Include your local parameter if exists
SELF_MAKEDIR:=$(dir $(lastword $(MAKEFILE_LIST)))
sinclude $(SELF_MAKEDIR)../../winsoft-conf/_common/conf.mk
#sinclude ../../winsoft-conf/_common/conf.mk


# OCS part
.PHONY: ocs ocs-push

ocs:
	@echo ""
	@echo "Name:     $(OCS_NAME)"
	@[ "$(OCS_PRIORITY)" -eq 5 ] || echo "Priority: *$(OCS_PRIORITY)*"
	@echo "Launch:   install.bat"
	@echo "Notify:   $(OCS_NOTIFY)"
	@echo "Delay:    $(OCS_DELAY)"
	@echo "Cancel:   $(OCS_CANCEL)"
	@echo "Report:   $(OCS_REPORT)"
	@[ -z "$(OCS_SEARCH)" ] || echo "Search:   $(OCS_SEARCH)"
	@echo "Message:  $(OCS_MESSAGE)"
	@echo ""

ocs-push:
	@[ -s "./$(OCS_NAME).zip" ] || (echo 'Zip archive not exists: $(OCS_NAME).zip' > /dev/stderr ; exit 1)
	@sha=$$(shasum -a 256 "$(SOFT)_$(VERSION)-$(REVISION)_x64.zip"); \
	! grep -q "^$(OCS_NAME).zip$$" tmp/ocs-pkgpush.txt > /dev/null 2>&1 || { echo 'Package already upload: $(OCS_NAME).zip' > /dev/stderr ; exit 1 ; } ;\
	echo ocs-pkgpush --url "$(OCS_URL)/ocsreports" \
		--name "$(OCS_NAME)" \
		--description "$(OCS_NAME)" \
		--priority "$(OCS_PRIORITY)" \
		--notif-text '"$(OCS_MESSAGE)"' \
		--notif-delay "$(OCS_DELAY)" \
		--file "./$(OCS_NAME).zip" \
		--capture-dir tmp \
		--headless && echo "$(OCS_NAME).zip" >> tmp/ocs-pkgpush.txt
