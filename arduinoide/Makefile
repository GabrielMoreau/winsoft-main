
#
# ArduinoIDE
#

SOFT:=ArduinoIDE
URL:=$(shell curl -s -L 'https://www.arduino.cc/en/software' | sed -e 's/>/\n/g;' | sed -e 's/>/\n/g;' | grep 'Windows MSI installer' | cut -f 6 -d '"')
VERSION:=$(shell basename $(URL) | cut -f 2 -d '_')
REVISION:=1

Adafruit:=https://raw.githubusercontent.com/basictheprogram/chocolatey-cura-new/4.10/tools/Adafruit.cer
Arduino:=https://raw.githubusercontent.com/basictheprogram/chocolatey-cura-new/4.10/tools/Arduino.cer

EXE:=arduino-ide_$(VERSION)_Windows_64bit.msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version clean control next ocs version wget checksum

all: check-version $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | egrep -q '^[[:digit:]][\.[:digit:]]*$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 1)

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

checksum:
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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		file $(EXE) | grep -q "Subject: Arduino IDE, Author: Arduino SA" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -a $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

tmp/Adafruit.cer:
	@(cd tmp ; \
		rm -f Adafruit.cer ; \
		curl -# -o "Adafruit.cer" -L "$(Adafruit)" ; \
		file "Adafruit.cer" | grep -q "Certificate, Version=3" || echo "Error: bad format for certificate Adafruit.cer" ; \
		)

tmp/Arduino.cer:
	@(cd tmp ; \
		rm -f Arduino.cer ; \
		curl -# -o "Arduino.cer" -L "$(Arduino)" ; \
		file "Arduino.cer" | grep -q "Certificate, Version=3" || echo "Error: bad format for certificate Arduino.cer" ; \
		)

%.zip: Makefile tmp/install.bat tmp/$(EXE) tmp/Adafruit.cer tmp/Arduino.cer
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE) Adafruit.cer Arduino.cer)
	@chmod ugo+rw $@

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
