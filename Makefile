# Do not change variable definition here
# Change in include main.mk sub-makefile.
PKGDIR:=$(dir $(wildcard */Makefile))
KEEP:=2
SHELL:=/bin/bash
PKGLEN:=$(shell echo $(PKGDIR) | sed -e 's/[[:space:]]/\n/g;' | wc --max-line-length)

sinclude ../winsoft-conf/_common/main.mk

.PHONY: help build-all clean-all checksum-all last-checksum unrealized-updates list-pkg list-version list-md space version
.ONESHELL:

help:
	@
	echo "* \`build-all\`  build all package except if \`.noauto\` file"
	echo "* \`clean-all\`  clean all package except if \`.noauto\` file"
	echo "* \`list-pkg\`   list all package"
	echo "* \`space\`      clean old package"
	echo "* \`version\`    get all package version"

build-all:
	@
	for d in $(PKGDIR)
	do
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./_common/noauto.conf ../winsoft-conf/_common/noauto.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${d%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${d%/}
		(cd $$d; \
			make > .make.log; \
			[ $$(LANG=C find . -maxdepth 1 -name '*.zip' -a -mtime -0.5 -not -path '*/tmp/*' -print | wc -l) -gt 0 ] && cat .make.log; \
		)
	done
	echo ''
	echo '#===================================================================#'
	echo '#=== Summary: packages created since 12 hours ('$$(date '+%Y-%m-%d %H:%M')') ===#'
	LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -0.5 -not -path '*/tmp/*' -exec ls -ltr {} \+

clean-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./_common/noauto.conf ../winsoft-conf/_common/noauto.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${d%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${d%/}
		(cd $$d; make clean; rm -f .make.log)
	done

checksum-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./_common/noauto.conf ../winsoft-conf/_common/noauto.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${d%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${d%/}
		(cd $$d; grep -q '^checksum:' Makefile && make checksum)
	done

last-checksum:
	@
	while read folder
	do
		printf "#=== %-$(PKGLEN)s ===#\n" $$folder
		(cd $$folder; grep -q '^checksum:' Makefile && make checksum)
	done < <(LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -1.25 -not -path '*/tmp/*' -print | xargs -r dirname | xargs -r -n 1 basename | sort -u)

unrealized-updates:
	@
	while read folder
	do
		printf "#=== %-$(PKGLEN)s ===# " $$folder
		RESULT=$$(cd $$folder; grep -q '^check-unrealized:' Makefile && make check-unrealized)
		if [ -n "$${RESULT}" ] ; then echo "$${RESULT}"; else echo ''; fi
	done < <(LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -180 -not -path '*/tmp/*' -print | xargs -r dirname | xargs -r -n 1 basename | sort -u)
	echo '#===================================================================#'
	echo '#=== Summary: this check was performed on '$$(date '+%Y-%m-%d %H:%M')'       ===#'

list-pkg:
	@
	for d in $(PKGDIR)
	do
		(cd $$d; \
			echo ''; \
			printf "#=== %-$(PKGLEN)s ===#\n" $${d%/}; \
			unzip -t *.zip; \
		)
	done

list-version:
	@
	for d in $(PKGDIR)
	do
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./_common/noauto.conf ../winsoft-conf/_common/noauto.conf 2> /dev/null
		then
			continue
		fi
		printf "%25s %s\n" "$${d%/}" $$(cd $$d; make version | grep '^VERSION:' | awk '{print $$2}')
	done

list-md:
	@
	echo '## List of '$$((git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md'; grep -l '^Uninstall-.*.zip:' */Makefile) | wc -l)' packages'
	echo ''
	echo ' |   | Software | Detail | &#127968; |   |'
	echo ' | - | -------- | ------ | --------- | - |'
	index=0
	for pkg in $$(git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | grep -v '\\$$' | xargs -I {} sh -c "(head -1 '{}' ; dirname '{}') | paste -sd '#'"  | sort | cut -f 3 -d '#' | grep -v -- '-uninstall')
	do
		index=$$(($${index} + 1))
		sindex=$$(printf '%03i' $${index})
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md | perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | $${sindex} | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |};" | sed -e 's/\[&#127968;\]()//;'
	done | sort | grep -Ev '\([[:alpha:]][[:alpha:]]*\)\]\('
	echo ''
	echo '### Uninstall packages'
	echo ''
	echo ' | Uninstall | Detail | &#127968; |   |'
	echo ' | -------- | ------ | --------- | - |'
	for pkg in $$(git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | xargs -r grep -l '^#[[:space:]].*(.*)[[:space:]]-' | xargs -r dirname | grep -v '/' | grep 'uninstall'; grep -l '^Uninstall-.*.zip:' */Makefile | xargs -r dirname)
	do
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md |perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |}; s/(\w)\]\(/\\1 (Uninstall)](/;" | sed -e 's/\[&#127968;\]()//;'
	done | sort
	echo ''
	echo '### Action packages'
	echo ''
	echo ' | Action | Detail | &#127968; |   |'
	echo ' | -------- | ------ | --------- | - |'
	for pkg in $$(git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | xargs -r grep -l '^#[[:space:]].*(.*)[[:space:]]-' | xargs -r dirname | grep -v '/' | grep -v 'uninstall')
	do
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md |perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |}; s/(\w)\]\(/\\1 (Uninstall)](/;" | sed -e 's/\[&#127968;\]()//;'
	done | sort
	echo ''
	echo '### List of '$$((dirname $$(git ls-files | grep '^_obsolete/[[:alpha:][:digit:]-]*/README.md'; grep -l '^Uninstall-.*.zip:' _obsolete/*/Makefile)) | sort -u | wc -l)' obsolete packages'
	echo ''
	echo ' |   | Software | Detail | Date |'
	echo ' | - | -------- | ------ | ---- |'
	index=0
	for pkg in $$(git ls-files | grep '^_obsolete/[[:alpha:][:digit:]-]*/README.md' | grep -v '\\$$' | xargs -I {} sh -c "(head -1 '{}' ; dirname '{}') | paste -sd '#'"  | sort | cut -f 3 -d '#' | grep -v -- '-uninstall')
	do
		index=$$(($${index} + 1))
		sindex=$$(printf '%03i' $${index})
		obsolete=$$(grep '* Obsolete : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md | perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | $${sindex} | [\\1]($${pkg}/README.md) | \\2 | $${obsolete} |};"
	done | sort | grep -Ev '\([[:alpha:]][[:alpha:]]*\)\]\('

space:
	@
	for d in $(PKGDIR)
	do
		(cd $$d; \
			ls -t *.zip 2>/dev/null | grep -v 'Uninstall' | tail -n +$$(($(KEEP) + 1)) | xargs -r rm -vf; \
			ls -t *.zip 2>/dev/null | grep    'Uninstall' | tail -n +$$(($(KEEP) + 1)) | xargs -r rm -vf; \
		)
	done

version:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./_common/noauto.conf ../winsoft-conf/_common/noauto.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${d%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${d%/}
		(cd $$d; make version) | grep -v '^make'
	done
