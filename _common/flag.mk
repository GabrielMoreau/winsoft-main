
# curl option
CURLFLAGS:=


# Include your local parameter if exists
SELF_MAKEDIR:=$(dir $(lastword $(MAKEFILE_LIST)))
sinclude $(SELF_MAKEDIR)../../winsoft-conf/_common/flag.mk
