
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


# Include your local parameter if exists
sinclude ../../winsoft-conf/_common/conf.mk
