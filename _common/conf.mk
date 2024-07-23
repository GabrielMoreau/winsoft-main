
# List of global parameter
# You can change it via the sinclude directive
# do not change this file

# Team Name (all package)
IT_TEAM:=IT Team

# Log Folder (protect backslash)
LOGDIR:=%WINDIR%\\Logs

# OCS Inventory Agent (ocsinventory-agent package)
OCS_SERVER:=https://ocs-server.example.com/ocsinventory
OCS_SSL:=1

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
