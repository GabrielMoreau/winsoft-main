PKGDIR:=$(dir $(wildcard */Makefile))
KEEP:=2

.PHONY: help build-all clean-all list-pkg space
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
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; \
			make > .make.log; \
			[ $$(find . -maxdepth 1 -name '*.zip' -a -mtime -1 -not -path '*/tmp/*' -print | wc -l) -gt 0 ] && cat .make.log; \
		)
	done
	echo ''
	echo '#=====================================================================#'
	echo '#=== Summary: packages created on this last day ('$$(date '+%Y-%m-%d %H:%M')') ===#'
	find . -maxdepth 2 -name '*.zip' -a -mtime -1 -not -path '*/tmp/*' -exec ls -ltr {} \+

clean-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; make clean; rm -f .make.log)
	done

checksum-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; grep -q '^checksum:' Makefile && make checksum)
	done

list-pkg:
	@
	for d in $(PKGDIR)
	do
		(cd $$d; \
			echo ''; \
			echo "#=== $$d ===#"; \
			unzip -t *.zip; \
		)
	done

list-version:
	@
	for d in $(PKGDIR)
	do
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			continue
		fi
		printf "%25s %s\n" "$${d%/}" $$(cd $$d; make version | grep '^VERSION:' | awk '{print $$2}')
	done

list-md:
	@
	echo '## List of '$$(git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | wc -l)' packages'
	echo ''
	echo ' | Software | Detail | &#127968; |   |'
	echo ' | -------- | ------ | --------- | - |'
	for pkg in $$(git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | xargs -r dirname | grep -v '/')
	do
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md |perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |};" | sed -e 's/\[&#127968;\]()//;'
	done | sort

space:
	@
	for d in $(PKGDIR)
	do
		(cd $$d; \
			ls -t *.zip 2>/dev/null | tail -n +$$(($(KEEP) + 1)) | xargs -r rm -vf; \
		)
	done

version:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; make version) | grep -v '^make'
	done
