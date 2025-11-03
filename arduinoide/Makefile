
#
# ArduinoIDE
#

# https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.6_Windows_64bit.exe
# https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.6_Windows_64bit.msi
SOFT:=ArduinoIDE
# URL:=$(shell curl -s -L --connect-timeout 10 'https://www.arduino.cc/en/software' | sed -e 's/>/\n/g;' | sed -e 's/>/\n/g;' | grep 'Windows MSI installer' | cut -f 6 -d '"')
URL:=https:/$(shell curl -s -L --connect-timeout 10 'https://github.com/arduino/arduino-ide/releases' | sed -e 's/"/\n/g;' | grep '^/arduino/arduino-ide/.*/arduino-ide_.*_Windows_64bit.msi' | head -1)
VERSION:=$(shell basename '$(URL)' 2> /dev/null | cut -f 2 -d '_')
REVISION:=1

Adafruit:=https://raw.githubusercontent.com/basictheprogram/chocolatey-cura-new/4.10/tools/Adafruit.cer
Arduino:=https://raw.githubusercontent.com/basictheprogram/chocolatey-cura-new/4.10/tools/Arduino.cer

EXE:=arduino-ide_$(VERSION)_Windows_64bit.msi

IT_TEAM:=IT Support
LOGDIR:=%WINDIR%\\Logs


.PHONY: all check-version check-unrealized check-exe clean next version wget checksum

all: check-version check-exe $(SOFT)_$(VERSION)-$(REVISION)_x64.zip ocs

sinclude ../_common/conf.mk

check-version:
	@echo $(VERSION) | grep -Eq '^[[:digit:]][\.[:digit:]]+[[:digit:]]$$' || (echo 'VERSION is undefined' > /dev/stderr ; exit 11)

check-unrealized: check-version
	@if grep -q '[[:space:]]$(EXE)$$' checksum.txt; then echo 'Ok'; else echo 'Warning: Updates not performed for $(SOFT) version $(VERSION)'; fi

clean:
	rm -rf $(SOFT)_$(VERSION)-$(REVISION)_x64.zip tmp

version:
	@echo "VERSION: $(VERSION)"
	@echo "URL: $(URL)"
	@echo "EXE: $(EXE)"

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
		rm -f *.exe *.msi 2>/dev/null ; \
		curl -# -o "$(EXE)" -L "$(URL)" ; \
		#file $(EXE) | grep -q "Subject: Arduino IDE, Author: Arduino SA" || echo "Error: bad format for binary $(EXE)" ; \
		# which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || echo "Error: bad version for binary $(EXE)" ; } ; \
		grep -q "^$$(shasum -a 256 $(EXE))$$" ../checksum.txt || echo "Error: bad checksum for binary $(EXE)" ; \
		)

tmp/Adafruit.cer:
	@(cd tmp ; \
		rm -f Adafruit.cer ; \
		curl -# -o "Adafruit.cer" -L "$(Adafruit)" ; \
		#file "Adafruit.cer" | grep -q "Certificate, Version=3" || echo "Error: bad format for certificate Adafruit.cer" ; \
		)

tmp/Arduino.cer:
	@(cd tmp ; \
		rm -f Arduino.cer ; \
		curl -# -o "Arduino.cer" -L "$(Arduino)" ; \
		#file "Arduino.cer" | grep -q "Certificate, Version=3" || echo "Error: bad format for certificate Arduino.cer" ; \
		)

check-exe: tmp/$(EXE) tmp/Adafruit.cer tmp/Arduino.cer
	@(cd tmp ; \
		file $(EXE) | grep -q "Subject: Arduino IDE, Author: Arduino SA" || { echo "Error: bad format for binary $(EXE)" 1>&2 ; exit 12; } ; \
		#which peres >/dev/null && { peres -v $(EXE) | grep -q "^Product Version:[[:space:]]*$(VERSION)" || { echo "Error: bad version for binary $(EXE)" 1>&2 ; exit 12; }; } ; \
		file "Adafruit.cer" | grep -q "Certificate, Version=3" || echo "Error: bad format for certificate Adafruit.cer" ; \
		file "Arduino.cer"  | grep -q "Certificate, Version=3" || echo "Error: bad format for certificate Arduino.cer" ; \
		)

tmp/install.bat: install.bat Makefile tmp/$(EXE)
	@mkdir -p tmp
	@sed -e 's/__VERSION__/$(VERSION)/; s#__LOGDIR__#$(LOGDIR)#;' $< > $@

%.zip: Makefile tmp/install.bat tmp/$(EXE) tmp/Adafruit.cer tmp/Arduino.cer
	@rm -f $@
	@(cd tmp; zip -r ../$@ install.bat $(EXE) Adafruit.cer Arduino.cer)
	@chmod ugo+rw $@
